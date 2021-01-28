program Agendei;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitFrameCategoria in 'UnitFrameCategoria.pas' {FrameCategoria: TFrame},
  UnitFrameAgendamento in 'UnitFrameAgendamento.pas' {FrameAgendamento: TFrame},
  UnitDetalheEmpresa in 'UnitDetalheEmpresa.pas' {FrmDetalheEmpresa},
  UnitFrameServico in 'UnitFrameServico.pas' {FrameServico: TFrame},
  UnitAgenda in 'UnitAgenda.pas' {FrmAgenda},
  uCustomCalendar in 'Units\uCustomCalendar.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmDetalheEmpresa, FrmDetalheEmpresa);
  Application.CreateForm(TFrmAgenda, FrmAgenda);
  Application.Run;
end.
