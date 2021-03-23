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
    ListView1: TListView;
    rect_encerrar: TRectangle;
    Label4: TLabel;
    Rectangle3: TRectangle;
    Label5: TLabel;
    procedure img_fecharClick(Sender: TObject);
    procedure img_add_itemClick(Sender: TObject);
    procedure rect_encerrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmResumo: TFrmResumo;

implementation

{$R *.fmx}

uses UnitPrincipal;

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
