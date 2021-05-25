program Prestador;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  u99Permissions in '..\Units\u99Permissions.pas',
  uFunctions in '..\Units\uFunctions.pas',
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitCategoria in '..\FormsCompartilhados\UnitCategoria.pas' {FrmCategoria},
  UnitPedido in 'UnitPedido.pas' {FrmPedido},
  uLoading in '..\Units\uLoading.pas',
  UnitChat in '..\FormsCompartilhados\UnitChat.pas' {FrmChat};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmCategoria, FrmCategoria);
  Application.CreateForm(TFrmPedido, FrmPedido);
  Application.CreateForm(TFrmChat, FrmChat);
  Application.Run;
end.
