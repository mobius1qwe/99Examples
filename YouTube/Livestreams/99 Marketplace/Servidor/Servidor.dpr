program Servidor;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  cUsuario in 'Classes\cUsuario.pas',
  cPedido in 'Classes\cPedido.pas',
  cNotificacao in 'Classes\cNotificacao.pas',
  cChat in 'Classes\cChat.pas',
  uFunctions in '..\Units\uFunctions.pas',
  cPedidoOrcamento in 'Classes\cPedidoOrcamento.pas',
  cCategoria in 'Classes\cCategoria.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
