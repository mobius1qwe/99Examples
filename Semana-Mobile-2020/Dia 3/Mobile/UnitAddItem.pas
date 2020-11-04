unit UnitAddItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Edit, FMX.Layouts;

type
  TFrmAddItem = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    img_fechar: TImage;
    lv_categoria: TListView;
    TabControl: TTabControl;
    TabCategoria: TTabItem;
    TabProduto: TTabItem;
    Rectangle2: TRectangle;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    Rectangle6: TRectangle;
    edt_busca_produto: TEdit;
    rect_busca_produto: TRectangle;
    Label7: TLabel;
    Rectangle3: TRectangle;
    lbl_comanda: TLabel;
    img_icone: TImage;
    lv_produto: TListView;
    img_add: TImage;
    layout_qtd: TLayout;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    lbl_descricao: TLabel;
    rect_encerrar: TRectangle;
    Label4: TLabel;
    lbl_qtd: TLabel;
    img_menos: TImage;
    img_mais: TImage;
    img_fechar_qtd: TImage;
    procedure img_fecharClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_produtoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_menosClick(Sender: TObject);
    procedure img_fechar_qtdClick(Sender: TObject);
  private
    procedure AddCategoriaLv(id_categoria: integer; descricao: string;
      icone: TStream);
    procedure ListarCategoria;
    procedure AddProdutoLv(id_produto: integer; descricao: string;
      preco: double);
    procedure ListarProduto(id_categoria: integer; busca: string);
    { Private declarations }
  public
    { Public declarations }
    comanda: integer;
  end;

var
  FrmAddItem: TFrmAddItem;

implementation

{$R *.fmx}

procedure TFrmAddItem.AddCategoriaLv(id_categoria: integer;
                                     descricao: string;
                                     icone: TStream);
var
    bmp : TBitmap;
begin
    with lv_categoria.Items.Add do
    begin
        Tag := id_categoria;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;

        // Icone...
        if icone <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(icone);

            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := true;
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := bmp;
        end;
    end;
end;

procedure TFrmAddItem.ListarCategoria;
var
    x : integer;
    icone : TStream;
begin
    lv_categoria.Items.Clear;

    icone := TMemoryStream.Create;
    img_icone.Bitmap.SaveToStream(icone);
    icone.Position := 0;

    // Buscar dados no server...
    for x := 1 to 10 do
        AddCategoriaLv(x, 'Categoria ' + x.ToString, icone);

    icone.DisposeOf;
end;

procedure TFrmAddItem.AddProdutoLv(id_produto: integer;
                                   descricao: string;
                                   preco: double);
begin
    with lv_produto.Items.Add do
    begin
        Tag := id_produto;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', preco);
        TListItemImage(Objects.FindDrawable('ImgAdd')).bitmap := img_add.bitmap;
    end;
end;

procedure TFrmAddItem.ListarProduto(id_categoria: integer; busca: string);
var
    x : integer;
begin
    lv_produto.Items.Clear;

    // Buscar dados no server...
    for x := 1 to 10 do
        AddProdutoLv(x, 'Produto ' + x.ToString, x);
end;

procedure TFrmAddItem.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    lbl_titulo.Text := TListItemText(AItem.Objects.FindDrawable('TxtDescricao')).Text;
    lbl_comanda.Text := 'Comanda / Mesa: ' + comanda.ToString;

    ListarProduto(AItem.Tag, '');

    TabControl.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFrmAddItem.lv_produtoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    // Exibir a confirmacao + Qtd...
    lbl_qtd.Text := '01';
    lbl_descricao.Text := TListItemText(AItem.Objects.FindDrawable('TxtDescricao')).Text;
    layout_qtd.Visible := true;
end;

procedure TFrmAddItem.FormShow(Sender: TObject);
begin
    layout_qtd.Visible := false;
    ListarCategoria;
end;

procedure TFrmAddItem.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmAddItem.img_fechar_qtdClick(Sender: TObject);
begin
    layout_qtd.Visible := false;
end;

procedure TFrmAddItem.img_menosClick(Sender: TObject);
begin
    try
        lbl_qtd.Text := FormatFloat('00', lbl_qtd.Text.ToInteger + TImage(Sender).Tag);

        if lbl_qtd.Text.ToInteger < 1 then
            lbl_qtd.Text := '01';
    except
        lbl_qtd.Text := '01';
    end;
end;

procedure TFrmAddItem.img_voltarClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

end.
