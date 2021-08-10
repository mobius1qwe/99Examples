unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uDWAbout, uRESTDWBase;

type
  TFrmPrincipal = class(TForm)
    Switch: TSwitch;
    RESTServicePooler: TRESTServicePooler;
    procedure FormCreate(Sender: TObject);
    procedure SwitchSwitch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitDM;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    RESTServicePooler.ServerMethodClass := TDm;
    RESTServicePooler.Active := Switch.IsChecked;
end;

procedure TFrmPrincipal.SwitchSwitch(Sender: TObject);
begin
    RESTServicePooler.Active := Switch.IsChecked;
end;

end.
