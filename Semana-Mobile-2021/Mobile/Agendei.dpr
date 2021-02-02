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
  uCustomCalendar in 'Units\uCustomCalendar.pas',
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  uFunctions in 'Units\uFunctions.pas',
  UnitConfirmacao in 'UnitConfirmacao.pas' {FrmConfirmacao},
  uLoading in 'Units\uLoading.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
