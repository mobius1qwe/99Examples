unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  RESTRequest4D, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  DataSet.Serialize.Config, System.Net.HttpClientComponent, FMX.ListBox,
  System.Net.HttpClient, FMX.Edit;

type
  TFrmPrincipal = class(TForm)
    TabProdutos: TFDMemTable;
    lytToolbar: TLayout;
    Label1: TLabel;
    Layout1: TLayout;
    edt_busca: TEdit;
    btn_busca: TButton;
    lbProdutos: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_buscaClick(Sender: TObject);
    procedure lbProdutosViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure lbProdutosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure RequestProdutos(pagina: integer; busca: string);
    procedure AddProdutoListbox(id_produto: integer; descricao, categoria,
      url_foto: string);
    procedure ListarProdutosListbox(pagina: integer; busca: string;
                                    ind_clear: boolean);
    procedure ThreadProdutosTerminate(Sender: TObject);
    procedure DownloadFotoListbox(lb: TListBox);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

Const
  BASE_URL = 'http://localhost:9000';
  TAM_PAGINA = 30;


implementation

{$R *.fmx}

uses Frame.Produto;

procedure LoadImageFromURL(img: TBitmap; url: string);
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    try
        try
            http := TNetHTTPClient.Create(nil);
            vStream :=  TMemoryStream.Create;

            if (Pos('https', LowerCase(url)) > 0) then
                  HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                            THTTPSecureProtocol.TLS11,
                                            THTTPSecureProtocol.TLS12];

            http.Get(url, vStream);
            vStream.Position  :=  0;


            img.LoadFromStream(vStream);
        except
        end;

    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;
end;

procedure TFrmPrincipal.DownloadFotoListbox(lb: TListBox);
var
    t: TThread;
    foto: TBitmap;
    frame: TFrameProduto;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := 0 to lb.Items.Count - 1 do
        begin
            //sleep(1000);
            frame := TFrameProduto(lb.ItemByIndex(i).Components[0]);


            if frame.imgFoto.TagString <> '' then
            begin
                foto := TBitmap.Create;
                LoadImageFromURL(foto, frame.imgFoto.TagString);

                frame.imgFoto.TagString := '';
                frame.imgFoto.bitmap := foto;

                foto.DisposeOf;
            end;
        end;

    end);

    t.Start;
end;

procedure TFrmPrincipal.AddProdutoListbox(id_produto: integer;
                                          descricao, categoria, url_foto: string);
var
    item: TListBoxItem;
    frame: TFrameProduto;
begin
    item := TListBoxItem.Create(lbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 70;
    item.Tag := id_produto;

    frame := TFrameProduto.Create(item);
    frame.hittest := false;
    frame.Align := TAlignLayout.Client;

    frame.lblDescricao.Text := descricao;
    frame.lblCategoria.Text := categoria;
    frame.imgFoto.tagstring := url_foto;

    item.AddObject(frame);

    lbProdutos.AddObject(item);
end;

procedure TFrmPrincipal.ThreadProdutosTerminate(Sender: TObject);
begin
    // Nao carregar mais dados...
    if TabProdutos.RecordCount < TAM_PAGINA then
        lbProdutos.Tag := -1;

    while NOT TabProdutos.Eof do
    begin
        AddProdutoListbox(TabProdutos.FieldByName('id_produto').AsInteger,
                          TabProdutos.FieldByName('descricao').AsString,
                          TabProdutos.FieldByName('categoria').AsString,
                          TabProdutos.FieldByName('url_foto').AsString);

        TabProdutos.Next;
    end;

    lbProdutos.EndUpdate;

    // Processamento terminou...
    lbProdutos.TagString := '';

    // Deu erro na Thread?
    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    DownloadFotoListbox(lbProdutos);
end;

procedure TFrmPrincipal.ListarProdutosListbox(pagina: integer; busca: string;
                                               ind_clear: boolean);
var
    t: TThread;
begin
    // Evitar processamento concorrente...
    if lbProdutos.TagString = 'S' then
        exit;

    // Em processamento...
    lbProdutos.TagString := 'S';


    // Inicia atualizacao da lista...
    lbProdutos.BeginUpdate;


    // Limpa a lista...
    if ind_clear then
    begin
        pagina := 1;
        lbProdutos.ScrollToItem(lbProdutos.ItemByIndex(0));
        lbProdutos.Items.Clear;
    end;


    {
    Tag: contem a pagina atual solicitada ao servidor...
    >= 1 : faz o request para buscar mais dados
    -1 : indica que não tem mais dados
    }
    // Salva pagina atual que sera exibida...
    lbProdutos.Tag := pagina;


    t := TThread.CreateAnonymousThread(procedure
    begin
        // Busca produtos no servidor via requisição HTTP...
        RequestProdutos(pagina, busca);
    end);

    t.OnTerminate := ThreadProdutosTerminate;
    t.Start;
end;

procedure TFrmPrincipal.btn_buscaClick(Sender: TObject);
begin
    ListarProdutosListbox(1, edt_busca.Text, true);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    // Configura Dataset Serialize...
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
    TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TFrmPrincipal.lbProdutosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    showmessage('Abrir detalhes do produto: ' + Item.Tag.ToString);
end;

procedure TFrmPrincipal.lbProdutosViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
var
    item : TListBoxItem;
begin
    if (lbProdutos.Items.Count >= TAM_PAGINA) and (lbProdutos.Tag >= 0) then
    begin
        // Captura o item que está "entrando" na tela...
        item := lbProdutos.ItemByPoint(30, lbProdutos.Height - 40);

        if (item <> nil) then
            if item.Index >= lbProdutos.Items.Count - 5 then // Se chegou nos ultimos x itens da lista...
                ListarProdutosListbox(lbProdutos.Tag + 1, edt_busca.Text, false);
    end;
end;

procedure TFrmPrincipal.RequestProdutos(pagina: integer; busca: string);
var
    resp: IResponse;
begin
    TabProdutos.FieldDefs.Clear;

    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('produtos')
            .AddParam('busca', busca)
            .AddParam('pagina', pagina.ToString)
            .DataSetAdapter(TabProdutos)
            .Accept('application/json')
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

end.
