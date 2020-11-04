unit UnitSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects;

type
  TFrmSplash = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSplash: TFrmSplash;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmSplash := nil;
end;

procedure TFrmSplash.FormCreate(Sender: TObject);
begin
    Image1.Align := TAlignLayout.Center;
end;

procedure TFrmSplash.FormShow(Sender: TObject);
begin
    Timer1.Interval := 3000;
    Timer1.Enabled := true;
    image1.Opacity := 0;

    Image1.Align := TAlignLayout.None;
    Image1.AnimateFloat('Opacity', 1, 0.4);
    Image1.AnimateFloatDelay('Position.Y', 0, 0.3, 2.5, TAnimationType.&In, TInterpolationType.Back);
end;

procedure TFrmSplash.Timer1Timer(Sender: TObject);
begin
    Timer1.Enabled := false;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmSplash.Close;
end;

end.
