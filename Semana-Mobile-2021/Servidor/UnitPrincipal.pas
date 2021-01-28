unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDWAbout, uRESTDWBase;

type
  TFrmPrincipal = class(TForm)
    Label1: TLabel;
    Switch1: TSwitch;
    ServicePooler: TRESTServicePooler;
    procedure Switch1Switch(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ServicePooler.ServerMethodClass := TDm;
    ServicePooler.Active := Switch1.IsChecked;
end;

procedure TFrmPrincipal.Switch1Switch(Sender: TObject);
begin
    ServicePooler.Active := Switch1.IsChecked;
end;

end.
