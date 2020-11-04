program Login;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Login in 'Form_Login.pas' {Frm_Login},
  Form_LoginFacebook in 'Form_LoginFacebook.pas' {Frm_LoginFacebook};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrm_Login, Frm_Login);
  Application.CreateForm(TFrm_LoginFacebook, Frm_LoginFacebook);
  Application.Run;
end.
