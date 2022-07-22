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
    lvProdutos: TListView;
    Layout1: TLayout;
    edt_busca: TEdit;
    btn_busca: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lvProdutosPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure btn_buscaClick(Sender: TObject);
  private
    procedure RequestProdutos(pagina: integer; busca: string);
    procedure AddProdutoListview(id_produto: integer; descricao, categoria,
      url_foto: string);
    procedure ListarProdutosListview(pagina: integer; busca: string;
                                               ind_clear: boolean);
    procedure DownloadFotoListview(lv: TListview; obj_foto: string);
    procedure ThreadProdutosTerminate(Sender: TObject);

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

procedure TFrmPrincipal.DownloadFotoListview(lv: TListview; obj_foto: string);
var
    t: TThread;
    foto: TBitmap;
    img: TListItemImage;
    url: string;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := 0 to lv.Items.Count - 1 do
        begin
            //sleep(2000);
            img := TListItemImage(lv.Items[i].Objects.FindDrawable(obj_foto));
            url := img.TagString;

            if (url <> '') then
            begin
                img.TagString := '';

                foto := TBitmap.Create;
                LoadImageFromURL(foto, url);

                TThread.Synchronize(TThread.CurrentThread, procedure
                begin
                    img.Bitmap := foto;
                    img.OwnsBitmap := true;
                end);
            end;
        end;

    end);

    t.Start;
end;


procedure TFrmPrincipal.AddProdutoListview(id_produto: integer;
                                            descricao, categoria, url_foto: string);
var
    item: TListViewItem;
begin
    item := lvProdutos.Items.Add;

    with item do
    begin
        Height := 70;

        Tag := id_produto;

        TListItemImage(Objects.FindDrawable('imgFoto')).TagString := url_foto;
        TListItemText(Objects.FindDrawable('txtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('txtCategoria')).Text := categoria;
    end;
end;

procedure TFrmPrincipal.ThreadProdutosTerminate(Sender: TObject);
begin
    // Nao carregar mais dados...
    if TabProdutos.RecordCount < TAM_PAGINA then
        lvProdutos.Tag := -1;

    while NOT TabProdutos.Eof do
    begin
        AddProdutoListview(TabProdutos.FieldByName('id_produto').AsInteger,
                           TabProdutos.FieldByName('descricao').AsString,
                           TabProdutos.FieldByName('categoria').AsString,
                           TabProdutos.FieldByName('url_foto').AsString);

        TabProdutos.Next;
    end;

    lvProdutos.EndUpdate;

    // Processamento terminou...
    lvProdutos.TagString := '';

    // Deu erro na Thread?
    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    DownloadFotoListview(lvProdutos, 'imgFoto');
end;

procedure TFrmPrincipal.ListarProdutosListview(pagina: integer; busca: string;
                                               ind_clear: boolean);
var
    t: TThread;
begin
    // Evitar processamento concorrente...
    if lvProdutos.TagString = 'S' then
        exit;

    // Em processamento...
    lvProdutos.TagString := 'S';


    // Inicia atualizacao da lista...
    lvProdutos.BeginUpdate;


    // Limpa a lista...
    if ind_clear then
    begin
        pagina := 1;
        lvProdutos.ScrollTo(0);
        lvProdutos.Items.Clear;
    end;


    {
    Tag: contem a pagina atual solicitada ao servidor...
    >= 1 : faz o request para buscar mais dados
    -1 : indica que não tem mais dados
    }
    // Salva pagina atual que sera exibida...
    lvProdutos.Tag := pagina;


    t := TThread.CreateAnonymousThread(procedure
    begin
        // Busca produtos no servidor via requisição HTTP...
        RequestProdutos(pagina, busca);
    end);

    t.OnTerminate := ThreadProdutosTerminate;
    t.Start;
end;

procedure TFrmPrincipal.lvProdutosPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    // Verifica se a rolagem atingiu o limite para uma nova carga...
    if (lvProdutos.Items.Count >= TAM_PAGINA) and (lvProdutos.Tag >= 0) then
        if lvProdutos.GetItemRect(lvProdutos.Items.Count - 5).Bottom <= lvProdutos.Height then
            ListarProdutosListview(lvProdutos.Tag + 1, edt_busca.Text, false);
end;

procedure TFrmPrincipal.btn_buscaClick(Sender: TObject);
begin
    ListarProdutosListview(1, edt_busca.Text, true);
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
            .AddParam('tamanho_pagina', TAM_PAGINA.ToString)
            .DataSetAdapter(TabProdutos)
            .Accept('application/json')
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

end.
