unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDWAbout, uRESTDWBase, uRESTDWServerEvents;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Switch: TSwitch;
    RESTServicePooler: TRESTServicePooler;
    procedure SwitchSwitch(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses UnitDM;

procedure TForm1.FormCreate(Sender: TObject);
begin
    RESTServicePooler.ServerMethodClass := Tdm;
    RESTServicePooler.Active := Switch.IsChecked;
end;

procedure TForm1.SwitchSwitch(Sender: TObject);
begin
    RESTServicePooler.Active := Switch.IsChecked;
end;

end.
