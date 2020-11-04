unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDWAbout, uRESTDWBase, uRESTDWServerEvents,
  FMX.Edit, Data.DB;

type
  TFrmPrincipal = class(TForm)
    Label1: TLabel;
    Switch: TSwitch;
    RESTServicePooler: TRESTServicePooler;
    btn_categoria: TButton;
    OpenDialog: TOpenDialog;
    procedure SwitchSwitch(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_categoriaClick(Sender: TObject);
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

procedure TFrmPrincipal.btn_categoriaClick(Sender: TObject);
begin
    if OpenDialog.Execute then
    begin
        dm.QryGeral.Active := false;
        dm.QryGeral.SQL.Clear;
        dm.QryGeral.sql.Add('INSERT INTO TAB_CATEGORIA(COD_CATEGORIA, DESCRICAO, ICONE, IND_ATIVO, TAXA_BASE, ORDEM)');
        dm.QryGeral.sql.Add('VALUES(''Utilitário'', ''Ideal para transporte de cargas maiores e mais pesadas'', :ICONE, ''S'', 2.5, 4)');
        dm.QryGeral.ParamByName('ICONE').LoadFromFile(OpenDialog.FileName, ftBlob);
        //dm.QryGeral.ParamByName('ICONE').Assign(bmp);
        dm.QryGeral.ExecSQL;
    end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    RESTServicePooler.ServerMethodClass := Tdm;
    RESTServicePooler.Active := Switch.IsChecked;
end;

procedure TFrmPrincipal.SwitchSwitch(Sender: TObject);
begin
    RESTServicePooler.Active := Switch.IsChecked;
end;

end.
