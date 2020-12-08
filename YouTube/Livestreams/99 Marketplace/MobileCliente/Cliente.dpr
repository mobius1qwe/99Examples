program Cliente;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitNotificacao in 'UnitNotificacao.pas' {FrmNotificacao},
  UnitPedido in 'UnitPedido.pas' {FrmPedido},
  UnitChat in 'UnitChat.pas' {FrmChat},
  UnitDM in 'UnitDM.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
