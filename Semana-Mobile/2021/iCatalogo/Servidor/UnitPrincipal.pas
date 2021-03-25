unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uDWAbout, uRESTDWBase;

type
  TFrmPrincipal = class(TForm)
    Switch: TSwitch;
    Label1: TLabel;
    ServicePooler: TRESTServicePooler;
    procedure SwitchSwitch(Sender: TObject);
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
var
    erro : string;
begin
    ServicePooler.ServerMethodClass := Tdm;
    ServicePooler.Active := Switch.IsChecked;

    // Conexao com o banco...
    erro := dm.CarregarConfig;

    if erro <> 'OK' then
        ShowMessage(erro);
end;

procedure TFrmPrincipal.SwitchSwitch(Sender: TObject);
begin
    ServicePooler.Active := Switch.IsChecked;
end;

end.
