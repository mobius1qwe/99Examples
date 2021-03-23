unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.TabControl,
  System.Actions, FMX.ActnList,

  uLoading;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Layout3: TLayout;
    edt_usuario_login: TEdit;
    Rectangle1: TRectangle;
    btn_login: TSpeedButton;
    Layout4: TLayout;
    Image2: TImage;
    Layout5: TLayout;
    lbl_criar_conta: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    ActionList1: TActionList;
    ActLogin: TChangeTabAction;
    ActConta: TChangeTabAction;
    Layout6: TLayout;
    Image3: TImage;
    Layout7: TLayout;
    Label3: TLabel;
    Label5: TLabel;
    Layout8: TLayout;
    edt_usuario_cad: TEdit;
    Rectangle2: TRectangle;
    btn_criar_conta: TSpeedButton;
    label_icone: TLabel;
    Layout9: TLayout;
    img_icone1: TImage;
    img_icone2: TImage;
    img_icone4: TImage;
    img_icone3: TImage;
    img_icone6: TImage;
    img_icone5: TImage;
    c_selecao: TCircle;
    Layout10: TLayout;
    lbl_login: TLabel;
    Layout11: TLayout;
    Image10: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lbl_criar_contaClick(Sender: TObject);
    procedure lbl_loginClick(Sender: TObject);
    procedure img_icone1Click(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);
    procedure btn_criar_contaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FinalizaLogin(Sender: TObject);
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

procedure SelecioneIcone(Sender: TObject);
begin
     with FrmLogin do
    begin
        img_icone1.Tag := 0;
        img_icone2.Tag := 0;
        img_icone3.Tag := 0;
        img_icone4.Tag := 0;
        img_icone5.Tag := 0;
        img_icone6.Tag := 0;

        TImage(Sender).Tag := 1;


        c_selecao.AnimateFloat('Position.X', TImage(Sender).Position.X + 20 - 4, 0.2);
    end;
end;

procedure TFrmLogin.btn_criar_contaClick(Sender: TObject);
var
    icone : TBitmap;
begin
    // Verificar se usuario existe...
    dm.sql_usuario.Active := false;
    dm.sql_usuario.SQL.Clear;
    dm.sql_usuario.SQL.Add('SELECT * FROM USUARIO');
    dm.sql_usuario.SQL.Add('WHERE COD_USUARIO = :COD_USUARIO');
    dm.sql_usuario.ParamByName('COD_USUARIO').Value := edt_usuario_cad.Text;
    dm.sql_usuario.Active := true;

    if dm.sql_usuario.RecordCount > 0 then
    begin
        showmessage('O código de usuário já está em uso');
        exit;
    end;

    // Icone selecionado...
    if img_icone1.Tag = 1 then icone := img_icone1.Bitmap;
    if img_icone2.Tag = 1 then icone := img_icone2.Bitmap;
    if img_icone3.Tag = 1 then icone := img_icone3.Bitmap;
    if img_icone4.Tag = 1 then icone := img_icone4.Bitmap;
    if img_icone5.Tag = 1 then icone := img_icone5.Bitmap;
    if img_icone6.Tag = 1 then icone := img_icone6.Bitmap;


    // Cadastrar usuario...
    try
        dm.sql_usuario.Active := false;
        dm.sql_usuario.SQL.Clear;
        dm.sql_usuario.SQL.Add('INSERT USUARIO(COD_USUARIO, ICONE)');
        dm.sql_usuario.SQL.Add('VALUES(:COD_USUARIO, :ICONE)');
        dm.sql_usuario.ParamByName('COD_USUARIO').Value := edt_usuario_cad.Text;
        dm.sql_usuario.ParamByName('ICONE').Assign(icone);
        dm.sql_usuario.ExecSQL;
    except
        showmessage('Erro ao criar nova conta');
        exit;
    end;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.pcod_usuario := edt_usuario_cad.Text;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.FinalizaLogin(Sender: TObject);
begin
    // Ocorreu algum erro na Thread...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(Sender).FatalException).Message);
        exit;
    end;

    // Usuario validado com sucesso...
    TLoading.Hide;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.pcod_usuario := edt_usuario_login.Text;

    FrmPrincipal.Show;
    FrmLogin.Close;

end;

procedure TFrmLogin.btn_loginClick(Sender: TObject);
var
    t : TThread;
begin

    TLoading.Show(FrmLogin, 'Validando usuário...');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(2000);

        // Verificar se usuario existe...

        dm.sql_usuario.Active := false;
        dm.sql_usuario.SQL.Clear;
        dm.sql_usuario.SQL.Add('SELECT * FROM USUARIO');
        dm.sql_usuario.SQL.Add('WHERE COD_USUARIO = :COD_USUARIO');
        dm.sql_usuario.ParamByName('COD_USUARIO').Value := edt_usuario_login.Text;
        dm.sql_usuario.Active := true;


        if dm.sql_usuario.RecordCount = 0 then
        begin
            TThread.Synchronize(nil, procedure
            begin
                    TLoading.Hide;
                    raise Exception.Create('Código de usuário não encontrado');
            end);
        end;

    end);

    t.OnTerminate := FinalizaLogin;
    t.Start;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    TabControl.TabPosition := TTabPosition.None;
    TabControl.ActiveTab := TabLogin;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    SelecioneIcone(img_icone1);
end;

procedure TFrmLogin.img_icone1Click(Sender: TObject);
begin
    SelecioneIcone(Sender);
end;

procedure TFrmLogin.lbl_criar_contaClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TFrmLogin.lbl_loginClick(Sender: TObject);
begin
    ActLogin.Execute;
end;

end.
