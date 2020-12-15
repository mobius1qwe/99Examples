unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDWAbout,
  uRESTDWBase, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TFrmPrincipal = class(TForm)
    RESTServicePooler: TRESTServicePooler;
    switch: TSwitch;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure switchSwitch(Sender: TObject);
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
var
    erro : string;
begin
    RESTServicePooler.ServerMethodClass := Tdm;
    RESTServicePooler.Active := switch.IsChecked;

    // Abre conexao com o banco...
    erro := dm.CarregarConfig;

    if erro <> 'OK' then
        ShowMessage(erro);
end;

procedure TFrmPrincipal.switchSwitch(Sender: TObject);
begin
    RESTServicePooler.Active := switch.IsChecked;
end;

end.
