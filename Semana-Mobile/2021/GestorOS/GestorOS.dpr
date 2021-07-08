program GestorOS;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitDM in 'UnitDM.pas' {dm: TDataModule},
  UnitAssinatura in 'UnitAssinatura.pas' {FrmAssinatura},
  UnitOS in 'UnitOS.pas' {FrmOS};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmAssinatura, FrmAssinatura);
  Application.CreateForm(TFrmOS, FrmOS);
  Application.Run;
end.
