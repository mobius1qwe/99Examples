program SplashForm;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitSplash in 'UnitSplash.pas' {FrmSplash},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmSplash, FrmSplash);
  Application.Run;
end.
