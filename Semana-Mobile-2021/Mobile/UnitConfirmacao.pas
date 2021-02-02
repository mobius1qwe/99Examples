unit UnitConfirmacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.Ani;

type
  TFrmConfirmacao = class(TForm)
    Layout1: TLayout;
    img_ok: TImage;
    label11: TLabel;
    lbl_id_reserva: TLabel;
    rect_ok: TRectangle;
    Label6: TLabel;
    Layout2: TLayout;
    Image2: TImage;
    procedure rect_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfirmacao: TFrmConfirmacao;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmConfirmacao.FormShow(Sender: TObject);
begin
    TAnimator.AnimateFloat(img_ok, 'Opacity', 1, 1.5);
end;

procedure TFrmConfirmacao.rect_okClick(Sender: TObject);
begin
    FrmPrincipal.ind_fechar_telas := true;
    close;
end;

end.
