unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON;

type
  TFrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    rect_abas: TRectangle;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Rectangle4: TRectangle;
    Label3: TLabel;
    Layout1: TLayout;
    Label4: TLabel;
    edt_comanda: TEdit;
    rect_add_item: TRectangle;
    Label5: TLabel;
    rect_detalhes: TRectangle;
    Label6: TLabel;
    lb_mapa: TListBox;
    Rectangle6: TRectangle;
    lv_produto: TListView;
    edt_busca_produto: TEdit;
    rect_busca_produto: TRectangle;
    Label7: TLabel;
    img_aba1: TImage;
    img_aba2: TImage;
    img_aba3: TImage;
    procedure img_aba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rect_detalhesClick(Sender: TObject);
    procedure rect_add_itemClick(Sender: TObject);
    procedure lb_mapaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormResize(Sender: TObject);
    procedure rect_busca_produtoClick(Sender: TObject);
  private
    procedure MudarAba(img: TImage);
    procedure DetalhesComanda(comanda: string);
    procedure AddMapa(comanda: string; status: string; valor_total: double);
    procedure AddProdutoLv(id_produto: integer; descricao: string;
      preco: double);
    procedure ListarProduto(ind_clear: boolean; busca: string);
    procedure CarregarComanda;
    { Private declarations }
  public
    { Public declarations }
    procedure AddItem(comanda: string);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitAddItem, UnitResumo, UnitDM;

procedure TFrmPrincipal.CarregarComanda;
var
    jsonArray: TJsonArray;
    erro: string;
    x : integer;
begin
    lb_mapa.Items.Clear;

    if dm.ListarComanda(jsonArray, erro) = false then
    begin
        showmessage(erro);
        exit;
    end;

    for x := 0 to jsonArray.Size - 1 do
    begin
        AddMapa(jsonArray.Get(x).GetValue<string>('ID_COMANDA'),
                jsonArray.Get(x).GetValue<string>('STATUS'),
                jsonArray.Get(x).GetValue<double>('VALOR_TOTAL'));
    end;

    jsonArray.DisposeOf;
end;

procedure TFrmPrincipal.MudarAba(img: TImage);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;

    img.Opacity := 1;
    TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);
end;

procedure TFrmPrincipal.AddItem(comanda: string);
begin
    if NOT Assigned(FrmAddItem) then
        Application.CreateForm(TFrmAddItem, FrmAddItem);

    FrmAddItem.comanda := comanda;
    FrmAddItem.TabControl.ActiveTab := FrmAddItem.TabCategoria;
    FrmAddItem.Show;
end;

procedure TFrmPrincipal.AddMapa(comanda: string;
                                status: string;
                                valor_total: double);
var
    item: TListBoxItem;
    rect: TRectangle;
    lbl : TLabel;
begin
    // Item da lista...
    item := TListBoxItem.Create(lb_mapa);
    item.Text := '';
    item.Height := 110;
    item.TagString := comanda;
    item.Selectable := false;

    // Retangulo de fundo...
    rect := TRectangle.Create(item);
    rect.Parent := item;
    rect.Align := TAlignLayout.Client;
    rect.Margins.Top := 10;
    rect.Margins.Bottom := 10;
    rect.Margins.Left := 10;
    rect.Margins.Right := 10;
    rect.Fill.Kind := TBrushKind.Solid;
    rect.HitTest := false;

    if status = 'F' then
        rect.Fill.Color := $FF4A70F7  // azul...
    else
        rect.Fill.Color := $FFEC6E73; // vermelho...

    rect.XRadius := 10;
    rect.YRadius := 10;
    rect.Stroke.Kind := TBrushKind.None;

    // Label status...
    lbl := TLabel.Create(rect);
    lbl.Parent := rect;
    lbl.Align := TAlignLayout.Top;

    if status = 'F' then
        lbl.Text := 'Livre'
    else
        lbl.Text := 'Ocupada';


    lbl.Margins.Left := 5;
    lbl.Margins.Top := 5;
    lbl.Height := 15;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor];
    lbl.FontColor := $FFFFFFFF;

    // Label valor...
    lbl := TLabel.Create(rect);
    lbl.Parent := rect;
    lbl.Align := TAlignLayout.Bottom;

    if status = 'F' then
        lbl.Text := ''
    else
        lbl.Text := FormatFloat('#,##0.00', valor_total);

    lbl.Margins.Right := 5;
    lbl.Margins.Bottom := 5;
    lbl.Height := 15;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor];
    lbl.FontColor := $FFFFFFFF;
    lbl.TextAlign := TTextAlign.Trailing;

    // Label comanda...
    lbl := TLabel.Create(rect);
    lbl.Parent := rect;
    lbl.Align := TAlignLayout.Client;
    lbl.Text := comanda;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor,
                                                TStyledSetting.Size];
    lbl.FontColor := $FFFFFFFF;
    lbl.Font.Size := 30;
    lbl.TextAlign := TTextAlign.Center;
    lbl.VertTextAlign := TTextAlign.Center;


    lb_mapa.AddObject(item);
end;

procedure TFrmPrincipal.DetalhesComanda(comanda: string);
begin
    if NOT Assigned(FrmResumo) then
        Application.CreateForm(TFrmResumo, FrmResumo);

    FrmResumo.lbl_comanda.Text := comanda;
    FrmResumo.Show;
end;

procedure TFrmPrincipal.AddProdutoLv(id_produto: integer;
                                     descricao: string;
                                     preco: double);
begin
    with lv_produto.Items.Add do
    begin
        Tag := id_produto;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', preco);
    end;
end;

procedure TFrmPrincipal.ListarProduto(ind_clear: boolean; busca: string);
var
    x : integer;
    jsonArray: TJSONArray;
    erro: string;
begin
    if ind_clear then
        lv_produto.Items.Clear;

    if NOT dm.ListarProduto(0, edt_busca_produto.text, 0, jsonArray, erro) then
    begin
        showmessage(erro);
        exit;
    end;

    for x := 0 to jsonArray.Size - 1 do
    begin
        AddProdutoLv(jsonArray.Get(x).GetValue<integer>('ID_PRODUTO'),
                     jsonArray.Get(x).GetValue<string>('DESCRICAO'),
                     jsonArray.Get(x).GetValue<double>('PRECO'));
    end;

    jsonArray.DisposeOf;

end;

procedure TFrmPrincipal.rect_add_itemClick(Sender: TObject);
begin
    if edt_comanda.Text <> '' then
        AddItem(edt_comanda.Text);
end;

procedure TFrmPrincipal.rect_busca_produtoClick(Sender: TObject);
begin
    ListarProduto(true, edt_busca_produto.Text);
end;

procedure TFrmPrincipal.rect_detalhesClick(Sender: TObject);
begin
    if edt_comanda.Text <> '' then
        DetalhesComanda(edt_comanda.Text);
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
    lb_mapa.Columns := Trunc(lb_mapa.Width / 110);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    MudarAba(img_aba1);

    CarregarComanda;
end;



procedure TFrmPrincipal.img_aba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.lb_mapaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    DetalhesComanda(Item.TagString);
end;

end.
