program GestorOS;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  UnitAssinatura in 'UnitAssinatura.pas' {FrmAssinatura},
  UnitOS in 'UnitOS.pas' {FrmOS},
  UnitFunctions in 'Units\UnitFunctions.pas',
  u99Permissions in 'Units\u99Permissions.pas',
  UnitBuscaCliente in 'UnitBuscaCliente.pas' {FrmBuscaCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmAssinatura, FrmAssinatura);
  Application.CreateForm(TFrmOS, FrmOS);
  Application.CreateForm(TFrmBuscaCliente, FrmBuscaCliente);
  Application.Run;
end.
