unit UnitCatalogoProd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, REST.Types, REST.Client, REST.Authenticator.Basic,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON, uFunctions;

type
  TMyThread = class(TThread)
  private
    delay: Integer;
    id_produto : integer;
    img : TListItemImage;
  protected
    procedure Execute; override;
    constructor Create;
  end;

type
  TFrmCatalogoProd = class(TForm)
    rect_toolbar: TRectangle;
    img_voltar: TImage;
    lbl_titulo: TLabel;
    img_add: TImage;
    lbl_catalogo: TLabel;
    edt_busca: TEdit;
    Rectangle1: TRectangle;
    Image1: TImage;
    lv_produto: TListView;
    img_foto: TImage;
    procedure FormShow(Sender: TObject);
    procedure img_addClick(Sender: TObject);
    procedure lv_produtoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure edt_buscaExit(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure lv_produtoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    MyThread : TMyThread;
    contador : integer;
    procedure ListarProdutos(busca: string; ind_clear: Boolean);
    procedure ProcessarProdutos;
    procedure ProcessarProdutosErro(Sender: TObject);
    procedure AddProduto(id_produto: integer;
                          preco, preco_promocao : double;
                          nome, foto64: string);
    procedure OpenCadProduto(id_produto: integer);
    function BuscaDadosProduto(id_produto: integer;
                                 out nome, ind_destaque, foto, dt_geracao: string;
                                 out preco, preco_promocao : double): boolean;
    procedure CarregaFoto(id_produto: integer; img: TListItemImage);
    procedure CarregaFotoTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    id_catalogo : Integer;
  end;

var
  FrmCatalogoProd: TFrmCatalogoProd;

implementation

{$R *.fmx}

uses UnitCatalogoProdCad, UnitDM, UnitPrincipal;

procedure TFrmCatalogoProd.CarregaFotoTerminate(Sender: TObject);
begin
    //if Assigned(TThread(Sender).FatalException) then
    //    showmessage('Erro na thread: ' + Exception(TThread(Sender).FatalException).Message);
end;

procedure TFrmCatalogoProd.CarregaFoto(id_produto: integer; img: TListItemImage);
var
    json, foto64 : string;
    jsonObj : TJSONObject;
    t : TThread;
begin
    // Criar Thread para busca da foto...
    t := TThread.CreateAnonymousThread(procedure
    begin
        dm.ReqProdutoFoto.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
        dm.ReqProdutoFoto.Params.ParameterByName('id_produto').Value := id_produto.ToString;
        dm.ReqProdutoFoto.Execute;

        // Se deu erro...
        if (dm.ReqProdutoFoto.Response.StatusCode <> 200) then
            exit;

        try
            json := dm.ReqProdutoFoto.Response.JSONValue.ToString;
            jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

            foto64 := jsonObj.GetValue('foto').Value;

            if foto64 <> '' then
            begin
                TThread.Queue(TThread.CurrentThread, procedure
                begin
                    img.OwnsBitmap := true; // Quando o bitmap é criado em runtime...
                    img.Bitmap := TFunctions.BitmapFromBase64(foto64);
                end);
            end;


        finally
            jsonObj.DisposeOf;
        end;

    end);

    t.OnTerminate := CarregaFotoTerminate;
    t.Start;
end;

procedure TFrmCatalogoProd.AddProduto(id_produto: integer;
                                      preco, preco_promocao : double;
                                      nome, foto64: string);
var
    ThreadFoto : TThread;
begin
    with lv_produto.Items.Add do
    begin
        Height := 90;
        Inc(contador);
        Tag := id_produto;

        TListItemText(Objects.FindDrawable('TxtProduto')).Text := index.ToString + ' - ' + nome + ' - ' + id_produto.ToString;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', preco);

        if preco_promocao > 0 then        
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := FormatFloat('#,##0.00', preco_promocao)
        else
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := '';

        //if foto64 <> '' then
        //begin
        //    TListItemImage(Objects.FindDrawable('ImgFoto')).OwnsBitmap := true; // Quando o bitmap é criado em runtime...
        //    TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := TFunctions.BitmapFromBase64(foto64);
        //end;


        // Foto padrao...
        TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := img_foto.Bitmap;

        //CarregaFoto(id_produto, TListItemImage(Objects.FindDrawable('ImgFoto')));

        // Criar Thread para busca da foto...
        MyThread := TMyThread.Create;
        MyThread.id_produto := id_produto;
        MyThread.delay := contador * 200;
        MyThread.img := TListItemImage(Objects.FindDrawable('ImgFoto'));
        MyThread.OnTerminate := CarregaFotoTerminate;
        MyThread.FreeOnTerminate := true;
        MyThread.Start;

    end;

end;

procedure TFrmCatalogoProd.ProcessarProdutos;
var
    jsonArray : TJsonArray;
    json, retorno : string;
    i : integer;
begin
    try
        // Se deu erro...
        if dm.ReqProdutoCons.Response.StatusCode <> 200 then
        begin
            showmessage('Erro ao consultar produtos');
            exit;
        end;

        json := dm.ReqProdutoCons.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(json), 0) as TJSONArray;

    except on ex:exception do
        begin
            showmessage(ex.Message);
            exit;
        end;
    end;

    try
        // Aumenta pagina...
        lv_produto.Tag := lv_produto.Tag + 1;


        // Popular listview dos produtos...
        lv_produto.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddProduto(jsonArray.Get(i).GetValue<integer>('ID_PRODUTO', 0),
                       jsonArray.Get(i).GetValue<double>('PRECO', 0),
                       jsonArray.Get(i).GetValue<double>('PRECO_PROMOCAO', 0),
                       jsonArray.Get(i).GetValue<string>('NOME', ''),
                       jsonArray.Get(i).GetValue<string>('FOTO', ''));
        end;


        // Nao carregar mais dados...
        if jsonArray.Size = 0 then
            lv_produto.Tag := -1;

        lv_produto.TagString := ''; // Processamento terminou...


        jsonArray.DisposeOf;

    finally
        lv_produto.EndUpdate;
        lv_produto.RecalcSize;
    end;
end;

procedure TFrmCatalogoProd.ProcessarProdutosErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmCatalogoProd.ListarProdutos(busca: string; ind_clear: Boolean);
begin
    // Evitar processamento concorrente...
    if lv_produto.TagString = '1' then
        exit;

    // Em processamento...
    lv_produto.TagString := '1';


    contador := 0; // Usado na Thread

    {
    Tag: contem a pagina a ser exibida na proxima chamada ao WS...
    >= 1 : faz o request para buscar mais dados
    -1   : indica que não tem mais dados
    }


    if ind_clear then
    begin
        lv_produto.ScrollTo(0);
        lv_produto.Items.Clear;
        lv_produto.Tag := 1; // Pagina a ser exibida atual...
    end;


    // Buscar produtos no servidor...
    dm.ReqProdutoCons.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
    dm.ReqProdutoCons.Params.ParameterByName('pagina').Value := lv_produto.Tag.ToString;
    dm.ReqProdutoCons.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
    dm.ReqProdutoCons.Params.ParameterByName('busca').Value := busca;
    dm.ReqProdutoCons.Params.ParameterByName('id_produto').Value := '0'; // nao filtra pelo codigo...
    dm.ReqProdutoCons.ExecuteAsync(ProcessarProdutos, true, true, ProcessarProdutosErro);
end;

function TFrmCatalogoProd.BuscaDadosProduto(id_produto: integer;
                                             out nome, ind_destaque, foto, dt_geracao: string;
                                             out preco, preco_promocao : double): boolean;
var
    json : string;
    jsonArray : TJSONArray;
begin
    try
        Result := false;
        
        // Buscar produtos no servidor...
        dm.ReqProdutoDetalhe.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
        dm.ReqProdutoDetalhe.Params.ParameterByName('pagina').Value := '0';
        dm.ReqProdutoDetalhe.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
        dm.ReqProdutoDetalhe.Params.ParameterByName('busca').Value := '';
        dm.ReqProdutoDetalhe.Params.ParameterByName('id_produto').Value := id_produto.tostring; // filtra pelo codigo...
        dm.ReqProdutoDetalhe.Execute;

    
        // Se deu erro...
        if (dm.ReqProdutoDetalhe.Response.StatusCode <> 200) then
            exit;

        try
            json := dm.ReqProdutoDetalhe.Response.JSONValue.ToString;
            jsonArray := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(json), 0) as TJSONArray;

            if jsonArray.Size > 0 then
            begin
                id_catalogo := jsonArray.Get(0).GetValue<integer>('ID_CATALOGO', 0);
                nome := jsonArray.Get(0).GetValue<string>('NOME', '');
                ind_destaque := jsonArray.Get(0).GetValue<string>('IND_DESTAQUE', '');
                foto := jsonArray.Get(0).GetValue<string>('FOTO', '');
                dt_geracao := jsonArray.Get(0).GetValue<string>('DT_GERACAO', '');
                preco := jsonArray.Get(0).GetValue<double>('PRECO', 0);
                preco_promocao := jsonArray.Get(0).GetValue<double>('PRECO_PROMOCAO', 0);

                Result := true;
            end;

        finally
            jsonArray.DisposeOf;
        end;

    except on ex:exception do            
    end;    
end;


procedure TFrmCatalogoProd.edt_buscaExit(Sender: TObject);
begin
    ListarProdutos(edt_busca.Text, true);
end;

procedure TFrmCatalogoProd.OpenCadProduto(id_produto: integer);
var
    nome, ind_destaque, foto64, dt_geracao: string;
    preco, preco_promocao : double;
    foto : TBitmap;
begin
    if NOT Assigned(FrmCatalogoProdCad) then
        Application.CreateForm(TFrmCatalogoProdCad, FrmCatalogoProdCad);

    FrmCatalogoProdCad.id_catalogo := id_catalogo;
        
    if id_produto = 0 then
    begin
        FrmCatalogoProdCad.id_produto := 0;
        FrmCatalogoProdCad.lbl_titulo.Text := 'Novo Catálogo';
        FrmCatalogoProdCad.modo := 'I';

        FrmCatalogoProdCad.edt_nome.Text := '';
        FrmCatalogoProdCad.Switch.IsChecked := false;
        FrmCatalogoProdCad.c_foto.Fill.Bitmap.Bitmap := FrmCatalogoProd.img_foto.Bitmap;
        FrmCatalogoProdCad.edt_preco.Text := '';
        FrmCatalogoProdCad.edt_promocao.Text := '0';
    end
    else
    begin
        FrmCatalogoProdCad.id_produto := id_produto;
        FrmCatalogoProdCad.lbl_titulo.Text := 'Alterar Catálogo';
        FrmCatalogoProdCad.modo := 'A';
        
        if NOT BuscaDadosProduto(id_produto, nome, ind_destaque, 
                                 foto64, dt_geracao, preco, preco_promocao) then
        begin
            showmessage('Erro ao buscar dados do produto');
            exit;
        end;

        
        foto := TFunctions.BitmapFromBase64(foto64);
        FrmCatalogoProdCad.id_catalogo := FrmCatalogoProd.id_catalogo;
        FrmCatalogoProdCad.edt_nome.Text := nome;    
        FrmCatalogoProdCad.Switch.IsChecked := ind_destaque = 'S';
        FrmCatalogoProdCad.c_foto.Fill.Bitmap.Bitmap := foto;
        FrmCatalogoProdCad.edt_preco.Text := FormatFloat('#,##0.00', preco);
        FrmCatalogoProdCad.edt_promocao.Text := FormatFloat('#,##0.00', preco_promocao);        

        foto.DisposeOf;
    end;

    FrmCatalogoProdCad.ShowModal(
        procedure(ModalResult: TModalResult)
        begin
            ListarProdutos(edt_busca.Text, true);
        end
    );
end;

procedure TFrmCatalogoProd.lv_produtoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    OpenCadProduto(Aitem.Tag); // A tag do item contem o id_produto...
end;

procedure TFrmCatalogoProd.lv_produtoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    if (lv_produto.Items.Count >= 0) and (lv_produto.Tag >= 0) then
    begin
        if lv_produto.GetItemRect(lv_produto.Items.Count - 3).Bottom <=
                                  lv_produto.Height then
            ListarProdutos(edt_busca.Text, false);
    end;
end;

procedure TFrmCatalogoProd.FormShow(Sender: TObject);
begin
    ListarProdutos(edt_busca.Text, true);
end;

procedure TFrmCatalogoProd.img_addClick(Sender: TObject);
begin
    OpenCadProduto(0);
end;

procedure TFrmCatalogoProd.img_voltarClick(Sender: TObject);
begin
    close;
end;


{ TMyThread }

constructor TMyThread.Create;
begin
    inherited Create(True);
end;

procedure TMyThread.Execute;
var
    json, foto64 : string;
    jsonObj : TJSONObject;
begin
    Sleep(self.delay);

    dm.ReqProdutoFoto.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
    dm.ReqProdutoFoto.Params.ParameterByName('id_produto').Value := self.id_produto.ToString;
    dm.ReqProdutoFoto.Execute;

    // Se deu erro...
    if (dm.ReqProdutoFoto.Response.StatusCode <> 200) then
        exit;

    try
        json := dm.ReqProdutoFoto.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        foto64 := jsonObj.GetValue('foto').Value;

        if foto64 <> '' then
        begin
            Synchronize(procedure
            begin
                self.img.OwnsBitmap := true; // Quando o bitmap é criado em runtime...
                self.img.Bitmap := TFunctions.BitmapFromBase64(foto64);
            end);
        end;


    finally
        jsonObj.DisposeOf;
    end;



end;

end.
