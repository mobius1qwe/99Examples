program ModenaKey;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitFrame in 'UnitFrame.pas' {FrmFrame: TFrame},
  UnitInicial in 'UnitInicial.pas' {FrmInicial};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
