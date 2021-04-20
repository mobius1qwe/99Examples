program Prestador;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  u99Permissions in '..\Units\u99Permissions.pas',
  uFunctions in '..\Units\uFunctions.pas',
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitCategoria in '..\FormsCompartilhados\UnitCategoria.pas' {FrmCategoria};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmCategoria, FrmCategoria);
  Application.Run;
end.
