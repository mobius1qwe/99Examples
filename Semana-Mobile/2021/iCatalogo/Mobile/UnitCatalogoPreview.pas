unit UnitCatalogoPreview;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON, uFunctions;

type
  TFrmCatalogoPreview = class(TForm)
    rect_toolbar: TRectangle;
    img_fechar: TImage;
    lbl_titulo: TLabel;
    Rectangle1: TRectangle;
    edt_busca: TEdit;
    Image1: TImage;
    Layout1: TLayout;
    Label2: TLabel;
    Layout2: TLayout;
    Label3: TLabel;
    lv_produto: TListView;
    rect_fundo: TRectangle;
    layout_detalhe: TLayout;
    Rectangle2: TRectangle;
    img_foto: TImage;
    lbl_nome: TLabel;
    lbl_preco: TLabel;
    img_fechar_detalhe: TImage;
    lbl_promocao: TLabel;
    lb_destaque: TListBox;
    procedure FormShow(Sender: TObject);
    procedure edt_buscaExit(Sender: TObject);
    procedure img_fecharClick(Sender: TObject);
    procedure lv_produtoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_fechar_detalheClick(Sender: TObject);
    procedure lb_destaqueItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure ListarProdutos(busca: string; ind_clear: Boolean);
    procedure ProcessarProdutos;
    procedure ProcessarProdutosErro(Sender: TObject);
    procedure AddProduto(id_produto: integer; preco, preco_promocao: double;
      nome, foto64: string);
    procedure AddDestaque(id_produto: integer; preco, preco_promocao: double;
      nome, foto64: string);
    procedure AbrirDetalheProduto(AItem: TListViewItem);

    { Private declarations }
  public
    { Public declarations }
    id_catalogo: integer;
  end;

var
  FrmCatalogoPreview: TFrmCatalogoPreview;

implementation

{$R *.fmx}

uses UnitDM, UnitPrincipal, UnitFrameProduto;

procedure TFrmCatalogoPreview.AddProduto(id_produto: integer;
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
        begin
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := FormatFloat('#,##0.00', preco_promocao);
            TListItemText(Objects.FindDrawable('TxtPreco')).Font.Style := [TFontStyle.fsStrikeOut];
        end
        else
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := '';

        if foto64 <> '' then
        begin
            TListItemImage(Objects.FindDrawable('ImgFoto')).OwnsBitmap := true; // Quando o bitmap é criado em runtime...
            TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := TFunctions.BitmapFromBase64(foto64);
        end;

    end;
end;

procedure TFrmCatalogoPreview.AddDestaque(id_produto: integer;
                    preco, preco_promocao : double;
                    nome, foto64: string);
var
    item : TListBoxItem;
    porc : double;
    f : TFrameProduto;
    foto : TBitmap;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 200;
    item.Width := 160;
    item.Align := TAlignLayout.Client;
    item.TagString := id_produto.ToString;
    item.Selectable := false;


    f := TFrameProduto.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.lbl_nome.Text := nome;
    f.lbl_preco.Text := FormatFloat('#,##0.00', preco);

    if preco_promocao > 0 then
    begin
        f.lbl_promocao.Text := FormatFloat('#,##0.00', preco_promocao);
        f.lbl_promocao.Font.Style := [TFontStyle.fsStrikeOut];
    end
    else
        f.lbl_promocao.Text := '';

    if foto64 <> '' then
    begin
        foto := TFunctions.BitmapFromBase64(foto64);
        f.img_foto.Bitmap := foto;
        foto.DisposeOf;
    end;


    lb_destaque.AddObject(item);
end;

{
procedure TFrmCatalogoPreview.AddDestaque(id_produto: integer;
                                      preco, preco_promocao : double;
                                      nome, foto64: string);
begin
    with lv_destaque.Items.Add do
    begin
        Height := 90;
        Tag := id_produto;

        TListItemText(Objects.FindDrawable('TxtProduto')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', preco);

        if preco_promocao > 0 then
        begin
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := FormatFloat('#,##0.00', preco_promocao);
            TListItemText(Objects.FindDrawable('TxtPreco')).Font.Style := [TFontStyle.fsStrikeOut];
        end
        else
            TListItemText(Objects.FindDrawable('TxtPromocao')).Text := '';

        if foto64 <> '' then
        begin
            TListItemImage(Objects.FindDrawable('ImgFoto')).OwnsBitmap := true; // Quando o bitmap é criado em runtime...
            TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := TFunctions.BitmapFromBase64(foto64);
        end;

    end;
end;
}

procedure TFrmCatalogoPreview.ProcessarProdutos;
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

        lb_destaque.Items.Clear;

        for i := 0 to jsonArray.Size - 1 do
        begin
            if jsonArray.Get(i).GetValue<string>('IND_DESTAQUE', '') = 'S' then
                AddDestaque(jsonArray.Get(i).GetValue<integer>('ID_PRODUTO', 0),
                            jsonArray.Get(i).GetValue<double>('PRECO', 0),
                            jsonArray.Get(i).GetValue<double>('PRECO_PROMOCAO', 0),
                            jsonArray.Get(i).GetValue<string>('NOME', ''),
                            jsonArray.Get(i).GetValue<string>('FOTO', ''))
            else
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

procedure TFrmCatalogoPreview.ProcessarProdutosErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmCatalogoPreview.edt_buscaExit(Sender: TObject);
begin
    ListarProdutos(edt_busca.Text, true);
end;

procedure TFrmCatalogoPreview.FormShow(Sender: TObject);
begin
    ListarProdutos(edt_busca.Text, true);
end;

procedure TFrmCatalogoPreview.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmCatalogoPreview.img_fechar_detalheClick(Sender: TObject);
begin
    layout_detalhe.Visible := false;
end;

procedure TFrmCatalogoPreview.lb_destaqueItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    showmessage('Clicou no perfume: ' + Item.TagString);
end;

procedure TFrmCatalogoPreview.ListarProdutos(busca: string; ind_clear: Boolean);
begin
    if ind_clear then
        lv_produto.Items.Clear;

    // Buscar produtos no servidor...
    dm.ReqProdutoCons.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
    dm.ReqProdutoCons.Params.ParameterByName('pagina').Value := '0';
    dm.ReqProdutoCons.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
    dm.ReqProdutoCons.Params.ParameterByName('busca').Value := busca;
    dm.ReqProdutoCons.Params.ParameterByName('id_produto').Value := '0'; // nao filtra pelo codigo...
    dm.ReqProdutoCons.Params.ParameterByName('ind_destaque').Value := ''; // Nao filtra pelo destaque...
    dm.ReqProdutoCons.ExecuteAsync(ProcessarProdutos, true, true, ProcessarProdutosErro);
end;

procedure TFrmCatalogoPreview.AbrirDetalheProduto(AItem: TListViewItem);
begin
    img_foto.Bitmap := TListItemImage(AItem.Objects.FindDrawable('ImgFoto')).Bitmap;
    lbl_nome.Text := TListItemText(AItem.Objects.FindDrawable('TxtProduto')).Text;
    lbl_preco.Text := TListItemText(AItem.Objects.FindDrawable('TxtPreco')).Text;
    lbl_promocao.Text := TListItemText(AItem.Objects.FindDrawable('TxtPromocao')).Text;
    layout_detalhe.Visible := true;
end;

procedure TFrmCatalogoPreview.lv_produtoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    AbrirDetalheProduto(AItem);
end;

end.
