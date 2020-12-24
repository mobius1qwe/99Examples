program Animacao;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
