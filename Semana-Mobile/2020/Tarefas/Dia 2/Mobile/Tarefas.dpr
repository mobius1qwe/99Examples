program Tarefas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  uCustomCalendar in 'uCustomCalendar.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
