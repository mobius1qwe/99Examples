program Servidor;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  cUsuario in 'Classes\cUsuario.pas',
  cPedido in 'Classes\cPedido.pas',
  cNotificacao in 'Classes\cNotificacao.pas',
  cChat in 'Classes\cChat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
