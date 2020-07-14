program Toast;

uses
  System.StartUpCopy,
  FMX.Forms,
  Frm_Principal in 'Frm_Principal.pas' {Form1},
  Notificacao in 'Notificacao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
