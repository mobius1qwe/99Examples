program Editor;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Principal in 'Form_Principal.pas' {Frm_Principal},
  Form_Editor in 'Form_Editor.pas' {Frm_Editor};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(TFrm_Editor, Frm_Editor);
  Application.Run;
end.
