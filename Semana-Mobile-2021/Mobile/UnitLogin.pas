unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  uLoading;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabInicial: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Rectangle1: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    layout_campos_login: TLayout;
    Image2: TImage;
    Label1: TLabel;
    Rectangle2: TRectangle;
    edt_login_email: TEdit;
    Rectangle3: TRectangle;
    edt_login_senha: TEdit;
    rect_btn_login: TRectangle;
    Label2: TLabel;
    Layout4: TLayout;
    Image3: TImage;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    edt_conta_nome: TEdit;
    Rectangle5: TRectangle;
    edt_conta_senha: TEdit;
    Rectangle6: TRectangle;
    Label3: TLabel;
    Layout6: TLayout;
    Label4: TLabel;
    Rectangle7: TRectangle;
    edt_conta_email: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rect_btn_loginClick(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    id_usuario: integer;
    procedure TerminateLogin(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitDM, UnitPrincipal;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    TabControl.ActiveTab := TabInicial;

    // Configurar endereco no meu SERVIDOR...
    {$IFDEF DEBUG}
    //dm.RESTClient.BaseURL := 'http://192.168.0.103:8082';  // Para testar no Android, coloque p IP do seu PC
    dm.RESTClient.BaseURL := 'http://localhost:8082';
    {$ELSE}
    dm.RESTClient.BaseURL := 'https://seu-site-oficial:8082';
    {$ENDIF}
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFrmLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
    layout_campos_login.Margins.Bottom := 0;
end;

procedure TFrmLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
    layout_campos_login.Margins.Bottom := layout_campos_login.Position.Y;
end;

procedure TFrmLogin.TerminateLogin(Sender: TObject);
begin
    TLoading.Hide;

    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(Sender).FatalException).Message);
        exit;
    end;


    // Abrir o form principal...
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    FrmPrincipal.id_usuario_global := id_usuario;
    FrmPrincipal.Show;
    Application.MainForm := FrmPrincipal;
    FrmLogin.Close;
end;

procedure TFrmLogin.rect_btn_loginClick(Sender: TObject);
var
    erro : string;
    t : TThread;
begin
    TLoading.Show(FrmLogin, 'Enviando...');

    t := TThread.CreateAnonymousThread(procedure
    begin
        if NOT dm.ValidaLogin(edt_login_email.Text,
                          edt_login_senha.Text,
                          id_usuario,
                          erro) then
        begin
            raise Exception.Create(erro);
            exit;
        end;
    end);

    t.OnTerminate := TerminateLogin;
    t.Start;
end;

end.
