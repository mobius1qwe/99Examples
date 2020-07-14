program Biometria;

uses
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},

  {$IFDEF IOS}
  iOSapi.LocalAuthentication in 'Units\iOSapi.LocalAuthentication.pas',
  {$ENDIF}

  {$IFDEF ANDROID}
  Android.KeyguardManager in 'Units\Android.KeyguardManager.pas',
  DW.Androidapi.JNI.KeyguardManager in 'Units\DW.Androidapi.JNI.KeyguardManager.pas',
  {$ENDIF}

  System.StartUpCopy;

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
