unit UnitResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.DialogService, System.JSON, FMX.Ani, FMX.Edit, FMX.TextLayout;

type
  TFrmResumo = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    img_fechar: TImage;
    img_add_item: TImage;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Layout1: TLayout;
    lbl_comanda: TLabel;
    rect_encerrar: TRectangle;
    Label4: TLabel;
    Rectangle3: TRectangle;
    lbl_total: TLabel;
    lv_produto: TListView;
    img_delete: TImage;
    img_opcoes: TImage;
    layout_menu: TLayout;
    rect_fundo_opaco: TRectangle;
    rect_menu: TRectangle;
    lbl_transferir: TLabel;
    Line1: TLine;
    lbl_fechar_menu: TLabel;
    AnimationMenu: TFloatAnimation;
    layout_transferir: TLayout;
    rect_fundo_opaco_transf: TRectangle;
    rect_transf_mesa: TRectangle;
    edt_comanda_para: TEdit;
    rect_confirmar_transf: TRectangle;
    Label5: TLabel;
    lbl_descricao: TLabel;
    img_fechar_transf: TImage;
    procedure img_fecharClick(Sender: TObject);
    procedure img_add_itemClick(Sender: TObject);
    procedure rect_encerrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_produtoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure img_opcoesClick(Sender: TObject);
    procedure AnimationMenuFinish(Sender: TObject);
    procedure lbl_fechar_menuClick(Sender: TObject);
    procedure rect_fundo_opacoClick(Sender: TObject);
    procedure lbl_transferirClick(Sender: TObject);
    procedure img_fechar_transfClick(Sender: TObject);
    procedure rect_confirmar_transfClick(Sender: TObject);
    procedure lv_produtoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddProdutoResumo(id_consumo, qtd: integer;
                               descricao, obs, obs_opcional: string;
                               preco, vl_opcional: double);
    procedure ListarProduto;
    class function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer; static;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmResumo: TFrmResumo;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, UnitAddItem;

// Calcula a altura de um item TListItemText
class function TFrmResumo.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
    if Text = '' then
    begin
        Result := 0;
        exit;
    end;

  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrmResumo.AddProdutoResumo(id_consumo, qtd: integer;
                                      descricao, obs, obs_opcional: string;
                                      preco, vl_opcional: double);
begin
    with lv_produto.Items.Add do
    begin
        Tag := id_consumo; // Mudei de id_produto para id_consumo...
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := FormatFloat('00', qtd) +
                                                                    ' x ' + descricao;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', preco);
        TListItemImage(Objects.FindDrawable('ImgDelete')).bitmap := img_delete.bitmap;

        TListItemText(Objects.FindDrawable('TxtObs')).Text := obs;
        TListItemText(Objects.FindDrawable('TxtObsOpcional')).Text := obs_opcional;
    end;
end;

procedure TFrmResumo.ListarProduto;
var
    x : integer;
    jsonArray: TJSONArray;
    erro: string;
    total : double;
begin
    total := 0;
    lv_produto.Items.Clear;

    if NOT dm.ListarProdutoComanda(lbl_comanda.Text, jsonArray, erro) then
    begin
        showmessage(erro);
        exit;
    end;


    for x := 0 to jsonArray.Size - 1 do
    begin

        AddProdutoResumo(jsonArray.Get(x).GetValue<integer>('ID_CONSUMO'),
                         jsonArray.Get(x).GetValue<integer>('QTD', 0),
                         jsonArray.Get(x).GetValue<string>('DESCRICAO', ''),
                         jsonArray.Get(x).GetValue<string>('OBS', ''),
                         jsonArray.Get(x).GetValue<string>('OBS_OPCIONAL', ''),
                         jsonArray.Get(x).GetValue<double>('VALOR_TOTAL', 0),
                         jsonArray.Get(x).GetValue<double>('VALOR_OPCIONAL', 0)
                         );

        total := total + jsonArray.Get(x).GetValue<double>('VALOR_TOTAL');
    end;

    lbl_total.Text := FormatFloat('#,##0.00', total);

    // Força a chamada do evento onUpdateObjects da listview...
    lv_produto.Margins.Bottom := 1;
    lv_produto.Margins.Bottom := 0;
    //---------------------------------------------

    jsonArray.DisposeOf;
end;

procedure TFrmResumo.lv_produtoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if TListView(Sender).Selected <> nil then
    begin
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgDelete' then
            begin
                TDialogService.MessageDialog('Confirma exclusão do item?',
                                 TMsgDlgType.mtConfirmation,
                                 [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                 TMsgDlgBtn.mbNo,
                                 0,
                 procedure(const AResult: TModalResult)
                 var
                    erro: string;
                 begin
                    if AResult = mrYes then
                    begin
                        if dm.ExcluirProdutoCOmanda(lbl_comanda.Text,
                                                        lv_produto.Selected.Tag,
                                                        erro) = false then
                            showmessage(erro)
                        else
                            FrmResumo.ListarProduto;

                    end;
                 end);
            end;
        end;
    end;
end;

procedure TFrmResumo.lv_produtoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    altura: Integer;
    txt : TListItemText;
begin
    // Calcular altura do item...
    altura := 0;

    // Obs...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtObs'));
    altura := altura + GetTextHeight(txt, txt.Width, txt.Text);

    // Obs Opcional...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtObsOpcional'));

    if altura = 0 then
        txt.PlaceOffset.Y := 40;

    altura := altura + GetTextHeight(txt, txt.Width, txt.Text);

    AItem.Height := altura + 40;
end;

procedure TFrmResumo.AnimationMenuFinish(Sender: TObject);
begin
    AnimationMenu.Inverse := not AnimationMenu.Inverse;

    if rect_menu.Margins.Bottom = -130 then // Menu fechado
    begin
        layout_menu.Visible := false;

        if rect_menu.Tag = 1 then // Transferir comanda...
            layout_transferir.Visible := true;

        rect_menu.Tag := 0;
    end;
end;

procedure TFrmResumo.FormShow(Sender: TObject);
begin
    layout_menu.Visible := false;
    ListarProduto;
end;

procedure TFrmResumo.img_add_itemClick(Sender: TObject);
begin
    //FrmPrincipal.AddItem(lbl_comanda.Text);
    if NOT Assigned(FrmAddItem) then
        Application.CreateForm(TFrmAddItem, FrmAddItem);

    FrmAddItem.comanda := lbl_comanda.Text;
    FrmAddItem.TabControl.ActiveTab := FrmAddItem.TabCategoria;
    FrmAddItem.ShowModal(procedure(ModalResult: TModalResult)
    begin
        FrmResumo.ListarProduto;
    end);
end;

procedure TFrmResumo.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmResumo.img_fechar_transfClick(Sender: TObject);
begin
    layout_transferir.Visible := false;
end;

procedure TFrmResumo.img_opcoesClick(Sender: TObject);
begin
    rect_menu.Margins.Bottom := -130;
    layout_menu.Visible := true;

    AnimationMenu.Start;
end;

procedure TFrmResumo.lbl_fechar_menuClick(Sender: TObject);
begin
    AnimationMenu.Start;
end;

procedure TFrmResumo.lbl_transferirClick(Sender: TObject);
begin
    rect_menu.Tag := 1;
    edt_comanda_para.Text := '';
    AnimationMenu.Start;
end;

procedure TFrmResumo.rect_confirmar_transfClick(Sender: TObject);
var
    erro: string;
begin
    if dm.TransferirComanda(lbl_comanda.Text, edt_comanda_para.Text, erro) = false then
    begin
        showmessage(erro);
        exit;
    end;

    layout_transferir.Visible := false;
    close;
end;

procedure TFrmResumo.rect_encerrarClick(Sender: TObject);
begin
    TDialogService.MessageDialog('Confirma encerramento?',
                                 TMsgDlgType.mtConfirmation,
                                 [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                 TMsgDlgBtn.mbNo,
                                 0,
     procedure(const AResult: TModalResult)
     var
        erro: string;
     begin
        if AResult = mrYes then
        begin

            if dm.EncerrarComanda(lbl_comanda.Text, erro) then
                close
            else
                showmessage(erro);

        end;
     end);
end;

procedure TFrmResumo.rect_fundo_opacoClick(Sender: TObject);
begin
    AnimationMenu.Start;
end;

end.
