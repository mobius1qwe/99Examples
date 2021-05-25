program Cliente;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitNotificacao in 'UnitNotificacao.pas' {FrmNotificacao},
  UnitPedido in 'UnitPedido.pas' {FrmPedido},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  uFunctions in '..\Units\uFunctions.pas',
  u99Permissions in '..\Units\u99Permissions.pas',
  uLoading in '..\Units\uLoading.pas',
  UnitClassificacao in 'UnitClassificacao.pas' {FrmClassificar},
  UnitCategoria in '..\FormsCompartilhados\UnitCategoria.pas' {FrmCategoria},
  UnitChat in '..\FormsCompartilhados\UnitChat.pas' {FrmChat};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmClassificar, FrmClassificar);
  Application.CreateForm(TFrmCategoria, FrmCategoria);
  Application.CreateForm(TFrmChat, FrmChat);
  Application.Run;
end.
