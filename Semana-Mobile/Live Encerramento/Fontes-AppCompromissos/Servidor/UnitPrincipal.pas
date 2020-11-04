unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDWAbout, uRESTDWBase;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Switch1: TSwitch;
    RESTServicePooler1: TRESTServicePooler;
    procedure FormCreate(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
    RESTServicePooler1.ServerMethodClass := TDM;
    RESTServicePooler1.Active := Switch1.IsChecked;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    DM.conn.Connected := true;
end;

procedure TForm1.Switch1Switch(Sender: TObject);
begin
    RESTServicePooler1.Active := Switch1.IsChecked;
end;

end.
