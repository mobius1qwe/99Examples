program Tarefas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  uCustomCalendar in 'uCustomCalendar.pas',
  UnitNotificacao in 'UnitNotificacao.pas' {FrmNotificacao},
  UnitCompromisso in 'UnitCompromisso.pas' {FrmCompromisso},
  UnitNotificacaoDados in 'UnitNotificacaoDados.pas',
  UnitCompromissoDados in 'UnitCompromissoDados.pas',
  UnitNotificacaoFame in 'UnitNotificacaoFame.pas' {FrameNotificacao: TFrame},
  UnitCompromissoFrame in 'UnitCompromissoFrame.pas' {FrameCompromisso: TFrame},
  UnitCompromissoUsuarioDados in 'UnitCompromissoUsuarioDados.pas',
  UnitCompromissoUsuarioFrame in 'UnitCompromissoUsuarioFrame.pas' {FrameCompromissoUsuario: TFrame},
  UnitDM in 'UnitDM.pas' {DM: TDataModule},
  uLoading in 'uLoading.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
