unit UniLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  uLoading, uSession;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConta1: TTabItem;
    TabConta2: TTabItem;
    Image1: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    edtEmail: TEdit;
    btnLogin: TButton;
    lblCadConta: TLabel;
    Image2: TImage;
    Layout2: TLayout;
    Label3: TLabel;
    btnProximo: TButton;
    lblLogin: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    btnCriarConta: TButton;
    Label7: TLabel;
    lblLogin2: TLabel;
    Layout4: TLayout;
    StyleBook: TStyleBook;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    edtSenha: TEdit;
    Rectangle3: TRectangle;
    edtNomeCad: TEdit;
    Rectangle4: TRectangle;
    edtSenhaCad: TEdit;
    Rectangle5: TRectangle;
    EdtEmailCad: TEdit;
    Rectangle6: TRectangle;
    edtEnderecoCad: TEdit;
    Rectangle7: TRectangle;
    edtCEPCad: TEdit;
    Rectangle8: TRectangle;
    edtUFCad: TEdit;
    Rectangle9: TRectangle;
    edtCidadeCad: TEdit;
    Rectangle10: TRectangle;
    edtBairroCad: TEdit;
    btnVoltar: TImage;
    procedure btnLoginClick(Sender: TObject);
    procedure lblCadContaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ThreadLoginTerminate(Sender: TObject);
    procedure ThreadShowTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses DataModule.Usuario, UnitPrincipal;

procedure TFrmLogin.btnProximoClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(2);
end;


procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.ThreadShowTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    if DmUsuario.QryUsuario.RecordCount > 0 then
    begin
        // Abrir o form Principal...
        if NOT Assigned(FrmPrincipal) then
            Application.CreateForm(TFrmPrincipal, FrmPrincipal);

        Application.MainForm := FrmPrincipal;
        TSession.ID_USUARIO := DmUsuario.QryUsuario.FieldByName('id_usuario').AsInteger;
        FrmPrincipal.lblMenuNome.text := DmUsuario.QryUsuario.FieldByName('nome').AsString;
        FrmPrincipal.lblMenuEmail.text := DmUsuario.QryUsuario.FieldByName('email').AsString;
        FrmPrincipal.Show;
        FrmLogin.Close;
    end;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var
    t: TThread;
begin
    TLoading.Show(FrmLogin, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        DmUsuario.ListarUsuarioLocal;
    end);

    t.OnTerminate := ThreadShowTerminate;
    t.Start;
end;

procedure TFrmLogin.lblCadContaClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblLoginClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0);
end;

procedure TFrmLogin.ThreadLoginTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    // Abrir o form Principal...
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    try
        DmUsuario.ListarUsuarioLocal;
    except
    end;

    Application.MainForm := FrmPrincipal;
    TSession.ID_USUARIO := DmUsuario.QryUsuario.FieldByName('id_usuario').AsInteger;
    FrmPrincipal.lblMenuNome.text := DmUsuario.QryUsuario.FieldByName('nome').AsString;
    FrmPrincipal.lblMenuEmail.text := DmUsuario.QryUsuario.FieldByName('email').AsString;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
var
    t : TThread;
begin
    TLoading.Show(FrmLogin, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1500);
        DmUsuario.CriarConta(edtNomeCad.Text, EdtEmailCad.Text, edtSenhaCad.text,
                             edtEnderecoCad.Text, edtBairroCad.Text, edtCidadeCad.Text,
                             edtUFCad.Text, edtCEPCad.Text);


        // Salvar dados no banco do aparelho...
        with DmUsuario.TabUsuario do
        begin
            if RecordCount > 0 then
            begin
                DmUsuario.SalvarUsuarioLocal(fieldbyname('id_usuario').asinteger,
                                             edtEmailCad.text,
                                             edtNomeCad.text,
                                             edtEnderecoCad.text,
                                             edtBairroCad.text,
                                             edtCidadeCad.text,
                                             edtUFCad.text,
                                             edtCEPCad.text);
            end;
        end;

    end);

    t.OnTerminate := ThreadLoginTerminate;
    t.Start;
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
var
    t : TThread;
begin
    TLoading.Show(FrmLogin, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        //sleep(1500);
        DmUsuario.Login(edtEmail.Text, edtSenha.Text);

        // Salvar dados no banco do aparelho...
        with DmUsuario.TabUsuario do
        begin
            if RecordCount > 0 then
            begin
                DmUsuario.SalvarUsuarioLocal(fieldbyname('id_usuario').asinteger,
                                             fieldbyname('email').asstring,
                                             fieldbyname('nome').asstring,
                                             fieldbyname('endereco').asstring,
                                             fieldbyname('bairro').asstring,
                                             fieldbyname('cidade').asstring,
                                             fieldbyname('uf').asstring,
                                             fieldbyname('cep').asstring);
            end;
        end;
    end);

    t.OnTerminate := ThreadLoginTerminate;
    t.Start;
end;

end.
