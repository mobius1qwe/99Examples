unit Form_Inicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TFrm_Inicio = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout6: TLayout;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Path1: TPath;
    Layout7: TLayout;
    Label2: TLabel;
    Line1: TLine;
    Line2: TLine;
    Label3: TLabel;
    Line3: TLine;
    Label4: TLabel;
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Inicio: TFrm_Inicio;

implementation

{$R *.fmx}

uses Form_Login;

procedure TFrm_Inicio.Label3Click(Sender: TObject);
begin
        if not Assigned(Frm_Login) then
                Application.CreateForm(TFrm_Login, Frm_Login);

        Frm_login.Show;
end;

end.
