program S3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Login in 'Form_Login.pas' {Frm_Login},
  u99Permissions in 'Units\u99Permissions.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrm_Login, Frm_Login);
  Application.Run;
end.
