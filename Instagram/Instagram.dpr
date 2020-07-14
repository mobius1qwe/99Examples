program Instagram;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Inicial in 'Form_Inicial.pas' {Frm_Inicio},
  Form_Login in 'Form_Login.pas' {Frm_login},
  Form_Principal in 'Form_Principal.pas' {Frm_Principal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(TFrm_Inicio, Frm_Inicio);
  Application.Run;
end.
