unit UnitResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.DialogService;

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
    Label5: TLabel;
    lv_produto: TListView;
    img_delete: TImage;
    procedure img_fecharClick(Sender: TObject);
    procedure img_add_itemClick(Sender: TObject);
    procedure rect_encerrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AddProdutoResumo(id_produto, qtd: integer; descricao: string;
      preco: double);
    procedure ListarProduto;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmResumo: TFrmResumo;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmResumo.AddProdutoResumo(id_produto, qtd: integer;
                                      descricao: string;
                                      preco: double);
begin
    with lv_produto.Items.Add do
    begin
        Tag := id_produto;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := FormatFloat('00', qtd) +
                                                                    ' x ' + descricao;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := FormatFloat('#,##0.00', qtd * preco);
        TListItemImage(Objects.FindDrawable('ImgDelete')).bitmap := img_delete.bitmap;
    end;
end;

procedure TFrmResumo.ListarProduto;
var
    x : integer;
begin
    lv_produto.Items.Clear;

    // Buscar dados no server...
    for x := 1 to 10 do
        AddProdutoResumo(x, 01, 'Produto ' + x.ToString, x);
end;

procedure TFrmResumo.FormShow(Sender: TObject);
begin
    ListarProduto;
end;

procedure TFrmResumo.img_add_itemClick(Sender: TObject);
begin
    FrmPrincipal.AddItem(lbl_comanda.Text.ToInteger);
end;

procedure TFrmResumo.img_fecharClick(Sender: TObject);
begin
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
                                 begin
                                    if AResult = mrYes then
                                        showmessage('Encerramento concluído');
                                 end);
end;

end.
