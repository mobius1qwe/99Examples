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
    vsProdutos: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_buscaClick(Sender: TObject);
    procedure vsProdutosViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
  private
    procedure RequestProdutos(pagina: integer; busca: string);
    procedure AddProdutoVertScrollBox(id_produto: integer; descricao, categoria,
                                      url_foto: string);
    procedure ListarProdutosVertScrollBox(pagina: integer; busca: string;
                                          ind_clear: boolean);
    procedure ThreadProdutosTerminate(Sender: TObject);
    procedure DownloadFotoVertScrollBox(vs: TVertScrollBox);
    procedure ClearVertScrollBox(VSBox: TVertScrollBox; Index: integer = -1);

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

procedure TFrmPrincipal.DownloadFotoVertScrollBox(vs: TVertScrollBox);
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

        for i := 0 to vs.Content.ChildrenCount - 1 do
        begin
            //sleep(1000);
            frame := TFrameProduto(vs.Content.Children[i]);


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

procedure TFrmPrincipal.AddProdutoVertScrollBox(id_produto: integer;
                                                descricao, categoria, url_foto: string);
var
    frame: TFrameProduto;
begin
    frame := TFrameProduto.Create(nil);
    frame.hittest := false;
    frame.align := TAlignLayout.Top;
    frame.Height := 70;
    frame.position.Y := 9999999999;

    frame.lblDescricao.Text := descricao;
    frame.lblCategoria.Text := categoria;
    frame.imgFoto.tagstring := url_foto;

    vsProdutos.AddObject(frame);
end;

procedure TFrmPrincipal.ClearVertScrollBox(VSBox: TVertScrollBox; Index: integer = -1);
var
    i: integer;
    frame: TFrame;
begin
    try
        VSBox.BeginUpdate;

        if Index >= 0 then
            TFrame(VSBox.Content.Children[Index]).DisposeOf
        else
        for i := VSBox.Content.ChildrenCount - 1 downto 0 do
            if VSBox.Content.Children[i] is TFrame then
                TFrame(VSBox.Content.Children[i]).DisposeOf;

    finally
        VSBox.EndUpdate;
    end;
end;

procedure TFrmPrincipal.ThreadProdutosTerminate(Sender: TObject);
begin
    // Nao carregar mais dados...
    if TabProdutos.RecordCount < TAM_PAGINA then
        vsProdutos.Tag := -1;

    while NOT TabProdutos.Eof do
    begin
        AddProdutoVertScrollBox(TabProdutos.FieldByName('id_produto').AsInteger,
                                TabProdutos.FieldByName('descricao').AsString,
                                TabProdutos.FieldByName('categoria').AsString,
                                TabProdutos.FieldByName('url_foto').AsString);

        TabProdutos.Next;
    end;

    vsProdutos.EndUpdate;

    // Processamento terminou...
    vsProdutos.TagString := '';

    // Deu erro na Thread?
    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    DownloadFotoVertScrollBox(vsProdutos);
end;

procedure TFrmPrincipal.vsProdutosViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
var
    posicao, tamanho_total: double;
begin
    if (vsProdutos.Content.ChildrenCount >= TAM_PAGINA) and (vsProdutos.Tag >= 0) then
    begin
        // Calcula posicao atual do scroll...
        posicao := NewViewportPosition.Y + vsProdutos.Content.Height;


        // Calcula tamanho total do scroll...
        // (70 é a altura de cada frame)
        tamanho_total := vsProdutos.Content.ChildrenCount * 70;

        if posicao > tamanho_total - 150  then
                ListarProdutosVertScrollBox(vsProdutos.Tag + 1, edt_busca.Text, false);
    end;
end;


procedure TFrmPrincipal.ListarProdutosVertScrollBox(pagina: integer; busca: string;
                                               ind_clear: boolean);
var
    t: TThread;
begin
    // Evitar processamento concorrente...
    if vsProdutos.TagString = 'S' then
        exit;

    // Em processamento...
    vsProdutos.TagString := 'S';


    // Inicia atualizacao da lista...
    vsProdutos.BeginUpdate;


    // Limpa a lista...
    if ind_clear then
    begin
        pagina := 1;
        vsProdutos.ViewportPosition := PointF(0, 0);
        ClearVertScrollBox(vsProdutos);
    end;


    {
    Tag: contem a pagina atual solicitada ao servidor...
    >= 1 : faz o request para buscar mais dados
    -1 : indica que não tem mais dados
    }
    // Salva pagina atual que sera exibida...
    vsProdutos.Tag := pagina;


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
    ListarProdutosVertScrollBox(1, edt_busca.Text, true);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    // Configura Dataset Serialize...
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
    TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
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
