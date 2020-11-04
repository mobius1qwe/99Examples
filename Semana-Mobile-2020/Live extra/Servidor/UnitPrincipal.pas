unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDWAbout,
  uRESTDWBase, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects;

type
  TFrmPrincipal = class(TForm)
    Label1: TLabel;
    Switch: TSwitch;
    RESTServicePooler: TRESTServicePooler;
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

procedure ConectarBanco;
begin
    try
        dm.conn.Params.Values['DriverID'] := 'FB';
        dm.conn.Params.Values['Database'] := 'D:\Comanda\Servidor\DB\BANCO.FDB';
        dm.conn.Params.Values['User_Name'] := 'SYSDBA';
        dm.conn.Params.Values['Password'] := 'masterkey';
        dm.conn.Connected := true;
    except
        ShowMessage('Erro ao acessar o banco');
    end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    RESTServicePooler.ServerMethodClass := TDm;
    RESTServicePooler.Active := Switch.IsChecked;

    ConectarBanco;
end;

procedure TFrmPrincipal.SwitchSwitch(Sender: TObject);
begin
    RESTServicePooler.Active := Switch.IsChecked;
end;

end.
