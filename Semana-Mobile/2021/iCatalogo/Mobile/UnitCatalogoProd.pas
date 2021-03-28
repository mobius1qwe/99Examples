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
  private
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

procedure TFrmCatalogoProd.AddProduto(id_produto: integer;
                                      preco, preco_promocao : double;
                                      nome, foto64: string);
begin
    with lv_produto.Items.Add do
    begin
        Height := 90;
        Tag := id_produto;

        TListItemText(Objects.FindDrawable('TxtProduto')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', preco);

        if preco_promocao > 0 then        
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := FormatFloat('#,##0.00', preco_promocao)
        else
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := '';

        if foto64 <> '' then
        begin
            TListItemImage(Objects.FindDrawable('ImgFoto')).OwnsBitmap := true; // Quando o bitmap é criado em runtime...
            TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := TFunctions.BitmapFromBase64(foto64);
        end;

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
        // Popular listview dos produtos...
        lv_produto.Items.Clear;
        lv_produto.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddProduto(jsonArray.Get(i).GetValue<integer>('ID_PRODUTO', 0),
                       jsonArray.Get(i).GetValue<double>('PRECO', 0),
                       jsonArray.Get(i).GetValue<double>('PRECO_PROMOCAO', 0),
                       jsonArray.Get(i).GetValue<string>('NOME', ''),
                       jsonArray.Get(i).GetValue<string>('FOTO', ''));
        end;

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
    if ind_clear then
        lv_produto.Items.Clear;

    // Buscar produtos no servidor...
    dm.ReqProdutoCons.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
    dm.ReqProdutoCons.Params.ParameterByName('pagina').Value := '0';
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

end.
