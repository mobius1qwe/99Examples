program Listagem;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Principal in 'Form_Principal.pas' {Form1},
  uHorizontalMenu in 'uHorizontalMenu.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
