unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, System.JSON,
  uFunctions;

type
  TFrmPrincipal = class(TForm)
    rect_toolbar: TRectangle;
    img_menu: TImage;
    img_add: TImage;
    Label1: TLabel;
    lv_catalogo: TListView;
    img_logo: TImage;
    img_editar: TImage;
    img_produtos: TImage;
    img_preview: TImage;
    procedure lv_catalogoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure img_addClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure OpenCadCatalogo(id_catalogo: integer);
    procedure AddCatalogoLista(id_catalogo, qtd: integer; nome, foto64: string);
    procedure ListarCatalogos(ind_clear: Boolean);
    procedure ProcessarCatalogos;
    procedure ProcessarCatalogosErro(Sender: TObject);
    function BuscaDadosCatalogo(id_catalogo: integer; out nome, foto,
      dt_geracao: string; out qtd_produto: integer): boolean;
    { Private declarations }
  public
    { Public declarations }
    id_usuario : integer;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitCatalogoCad, UnitCatalogoProd, UnitCatalogoPreview, UnitDM;

procedure TFrmPrincipal.AddCatalogoLista(id_catalogo, qtd: integer;
                                         nome, foto64: string);
begin
    with lv_catalogo.Items.Add do
    begin
        Tag := id_catalogo;
        Height := 150;

        TListItemText(Objects.FindDrawable('TxtCatalogo')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtQtd')).Text := qtd.ToString + ' produto(s)';

        TListItemImage(Objects.FindDrawable('ImgFoto')).OwnsBitmap := true; // Quando o bitmap é criado em runtime...
        TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := TFunctions.BitmapFromBase64(foto64);

        TListItemImage(Objects.FindDrawable('ImgEditar')).Bitmap := img_editar.Bitmap;

        TListItemImage(Objects.FindDrawable('ImgPreview')).Bitmap := img_preview.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgPreview')).TagString := nome;

        TListItemImage(Objects.FindDrawable('ImgProdutos')).Bitmap := img_produtos.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgProdutos')).TagString := nome;
    end;
end;

procedure TFrmPrincipal.ProcessarCatalogos;
var
    jsonArray : TJsonArray;
    json, retorno : string;
    i : integer;
begin
    try
        // Se deu erro...
        if dm.ReqCatalogoCons.Response.StatusCode <> 200 then
        begin
            showmessage('Erro ao consultar catálogos');
            exit;
        end;

        json := dm.ReqCatalogoCons.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(json), 0) as TJSONArray;

    except on ex:exception do
        begin
            showmessage(ex.Message);
            exit;
        end;
    end;

    try
        // Popular listview dos produtos...
        lv_catalogo.Items.Clear;
        lv_catalogo.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddCatalogoLista(jsonArray.Get(i).GetValue<integer>('ID_CATALOGO', 0),
                             jsonArray.Get(i).GetValue<integer>('QTD_PRODUTO', 0),
                             jsonArray.Get(i).GetValue<string>('NOME', ''),
                             jsonArray.Get(i).GetValue<string>('FOTO', ''));
        end;

        jsonArray.DisposeOf;

    finally
        lv_catalogo.EndUpdate;
        lv_catalogo.RecalcSize;
    end;
end;

procedure TFrmPrincipal.ProcessarCatalogosErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmPrincipal.ListarCatalogos(ind_clear: Boolean);
begin
    if ind_clear then
        lv_catalogo.Items.Clear;

    // Buscar produtos no servidor...
    dm.ReqCatalogoCons.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
    dm.ReqCatalogoCons.ExecuteAsync(ProcessarCatalogos, true, true, ProcessarCatalogosErro);
end;

function TFrmPrincipal.BuscaDadosCatalogo(id_catalogo: integer;
                                          out nome, foto, dt_geracao: string;
                                          out qtd_produto: integer): boolean;
var
    json : string;
    jsonArray : TJSONArray;
begin
    try
        Result := false;

        // Buscar catalogo no servidor...
        dm.ReqCatalogoDetalhe.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
        dm.ReqCatalogoDetalhe.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
        dm.ReqCatalogoDetalhe.Execute;


        // Se deu erro...
        if (dm.ReqCatalogoDetalhe.Response.StatusCode <> 200) then
            exit;

        try
            json := dm.ReqCatalogoDetalhe.Response.JSONValue.ToString;
            jsonArray := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(json), 0) as TJSONArray;

            if jsonArray.Size > 0 then
            begin
                nome := jsonArray.Get(0).GetValue<string>('NOME', '');
                foto := jsonArray.Get(0).GetValue<string>('FOTO', '');
                dt_geracao := jsonArray.Get(0).GetValue<string>('DT_GERACAO', '');
                qtd_produto := jsonArray.Get(0).GetValue<integer>('QTD_PRODUTO', 0);

                Result := true;
            end;

        finally
            jsonArray.DisposeOf;
        end;

    except on ex:exception do
    end;
end;

procedure TFrmPrincipal.OpenCadCatalogo(id_catalogo: integer);
var
    nome, foto64, dt_geracao: string;
    qtd: integer;
    foto_bmp: TBitmap;
begin
    if NOT Assigned(FrmCatalogoCad) then
        Application.CreateForm(TFrmCatalogoCad, FrmCatalogoCad);

    if id_catalogo = 0 then
    begin
        FrmCatalogoCad.lbl_titulo.Text := 'Novo Catálogo';
        FrmCatalogoCad.modo := 'I';
        FrmCatalogoCad.edt_nome.Text := '';
    end
    else
    begin
        FrmCatalogoCad.lbl_titulo.Text := 'Alterar Catálogo';
        FrmCatalogoCad.modo := 'A';
        if NOT BuscaDadosCatalogo(id_catalogo, nome, foto64, dt_geracao, qtd) then
        begin
            showmessage('Erro ao buscar dados do catálogo');
            exit;
        end;

        FrmCatalogoCad.id_catalogo := id_catalogo;
        FrmCatalogoCad.edt_nome.Text := nome;

        foto_bmp := TFunctions.BitmapFromBase64(foto64);
        FrmCatalogoCad.c_foto.Fill.Bitmap.Bitmap := foto_bmp;
        foto_bmp.DisposeOf;
    end;

    FrmCatalogoCad.ShowModal(
        procedure (ModalResult: TModalResult)
        begin
            ListarCatalogos(true);
        end
    );
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    // Forcar um usuario logado...
    id_usuario := 1;

    ListarCatalogos(true);
end;

procedure TFrmPrincipal.img_addClick(Sender: TObject);
begin
    OpenCadCatalogo(0);
end;

procedure TFrmPrincipal.lv_catalogoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if TListView(Sender).Selected <> nil then
    begin
        // Imagem...
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgEditar' then
            begin
                OpenCadCatalogo(TListView(Sender).Items[ItemIndex].Tag);
                exit;
            end;

        end;

        // Produto...
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgProdutos' then
            begin
                if NOT Assigned(FrmCatalogoProd) then
                    Application.CreateForm(TFrmCatalogoProd, FrmCatalogoProd);

                FrmCatalogoProd.lbl_catalogo.Text := TListItemImage(ItemObject).TagString;
                FrmCatalogoProd.id_catalogo := TListView(Sender).Items[ItemIndex].Tag;
                FrmCatalogoProd.ShowModal(procedure(ModalResult: TModalResult)
                                        begin
                                            ListarCatalogos(true);
                                        end);
                exit;
            end;
        end;

        // Preview...
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgPreview' then
            begin
                if NOT Assigned(FrmCatalogoPreview) then
                    Application.CreateForm(TFrmCatalogoPreview, FrmCatalogoPreview);

                FrmCatalogoPreview.lbl_titulo.Text := TListItemImage(ItemObject).TagString;
                FrmCatalogoPreview.id_catalogo := TListView(Sender).Items[ItemIndex].Tag;
                FrmCatalogoPreview.Show;
                exit;
            end;
        end;

        // Senao...
        OpenCadCatalogo(TListView(Sender).Items[ItemIndex].Tag);


    end;
end;

end.
