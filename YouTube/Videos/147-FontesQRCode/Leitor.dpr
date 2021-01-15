program Leitor;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {Form1},
  u99Permissions in 'u99Permissions.pas',
  UnitCamera in 'UnitCamera.pas' {FrmCamera};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmCamera, FrmCamera);
  Application.Run;
end.
