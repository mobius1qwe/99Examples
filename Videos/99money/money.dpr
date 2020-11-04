program money;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Principal in 'Form_Principal.pas' {Frm_Principal},
  DataModule in 'DataModule.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
