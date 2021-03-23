unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.TabControl,
  Rest.Types;

type
  TFrmLogin = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    edt_usuario: TEdit;
    rect_login: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConfig: TTabItem;
    Layout2: TLayout;
    Label4: TLabel;
    edt_servidor: TEdit;
    rect_save_config: TRectangle;
    Label5: TLabel;
    lbl_config: TLabel;
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbl_configClick(Sender: TObject);
    procedure rect_save_configClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    dm.qry_config.Active := false;
    dm.qry_config.SQL.Clear;
    dm.qry_config.SQL.Add('SELECT * FROM TAB_USUARIO');
    dm.qry_config.Active := true;

    if dm.qry_config.FieldByName('SERVIDOR').AsString <> '' then
    begin
        TabControl.ActiveTab := TabLogin;
        edt_servidor.Text := dm.qry_config.FieldByName('SERVIDOR').AsString;
    end
    else
    begin
        lbl_titulo.Text := 'Configurações';
        TabControl.ActiveTab := TabConfig;
    end;
end;

procedure TFrmLogin.lbl_configClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1, TTabTransition.Slide);
    lbl_titulo.Text := 'Configurações';
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
var
    erro: string;
begin
    // Configurar endereco IP do server...
    dm.RESTClient.BaseURL := edt_servidor.Text;
    //------------------------------------

    if dm.ValidaLogin(edt_usuario.Text, erro) = false then
    begin
        showmessage(erro);
        exit;
    end;


    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    FrmPrincipal.Show;
    Application.MainForm := FrmPrincipal;
    FrmLogin.Close;
end;

procedure TFrmLogin.rect_save_configClick(Sender: TObject);
begin
    if edt_servidor.Text = '' then
    begin
        showmessage('Informe o servidor');
        exit;
    end;

    with dm.qry_config do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('DELETE FROM TAB_USUARIO');
        ExecSQL;

        Active := false;
        SQL.Clear;
        SQL.Add('INSERT INTO TAB_USUARIO(SERVIDOR)');
        SQL.Add('VALUES(:SERVIDOR)');
        ParamByName('SERVIDOR').Value := edt_servidor.Text;
        ExecSQL;
    end;

    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
    lbl_titulo.Text := 'Acesso';
end;

end.
