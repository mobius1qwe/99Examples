program TabControl;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
