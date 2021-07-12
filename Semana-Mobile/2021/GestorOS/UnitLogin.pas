unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    imgLogo: TImage;
    rectAcessar: TRectangle;
    Label1: TLabel;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Rectangle2: TRectangle;
    Edit2: TEdit;
    Image1: TImage;
    procedure rectAcessarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmLogin.rectAcessarClick(Sender: TObject);
begin
    if Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;

    FrmPrincipal.Show;
    FrmLogin.Close;
end;

end.
