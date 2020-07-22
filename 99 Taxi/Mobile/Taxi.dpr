program Taxi;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  u99Permissions in 'Units\u99Permissions.pas',
  uMD5 in 'Units\uMD5.pas',
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitFrameCategoria in 'UnitFrameCategoria.pas' {FrameCategoria: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
