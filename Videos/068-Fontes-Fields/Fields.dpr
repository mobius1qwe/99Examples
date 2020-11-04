program Fields;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Principal in 'Form_Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
