unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.TabControl,
  System.Actions, FMX.ActnList, u99Permissions, FMX.MediaLibrary.Actions,
  FireDAC.Comp.Client, FireDAC.DApt,

  {$IFDEF ANDROID}
  FMX.VirtualKeyboard, FMX.Platform,
  {$ENDIF}

  FMX.StdActns;

type
  TFrmLogin = class(TForm)
    Layout2: TLayout;
    img_login_logo: TImage;
    Layout1: TLayout;
    RoundRect1: TRoundRect;
    edt_login_email: TEdit;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    RoundRect2: TRoundRect;
    edt_login_senha: TEdit;
    Layout4: TLayout;
    rect_login: TRoundRect;
    Label1: TLabel;
    TabControl1: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    Layout5: TLayout;
    Image1: TImage;
    Layout6: TLayout;
    RoundRect4: TRoundRect;
    edt_cad_nome: TEdit;
    Layout7: TLayout;
    RoundRect5: TRoundRect;
    edt_cad_senha: TEdit;
    Layout8: TLayout;
    rect_conta_proximo: TRoundRect;
    Label2: TLabel;
    Layout9: TLayout;
    RoundRect7: TRoundRect;
    edt_cad_email: TEdit;
    TabFoto: TTabItem;
    Layout10: TLayout;
    c_foto_editar: TCircle;
    Layout11: TLayout;
    rect_conta: TRoundRect;
    Label3: TLabel;
    TabEscolher: TTabItem;
    Layout12: TLayout;
    Label4: TLabel;
    img_foto: TImage;
    img_library: TImage;
    Layout13: TLayout;
    img_foto_voltar: TImage;
    Layout14: TLayout;
    img_escolher_voltar: TImage;
    Layout15: TLayout;
    Layout16: TLayout;
    lbl_login_tab: TLabel;
    lbl_login_conta: TLabel;
    Rectangle1: TRectangle;
    ActionList1: TActionList;
    ActConta: TChangeTabAction;
    ActEscolher: TChangeTabAction;
    ActFoto: TChangeTabAction;
    ActLogin: TChangeTabAction;
    Layout17: TLayout;
    lbl_conta_login: TLabel;
    Label6: TLabel;
    Rectangle2: TRectangle;
    Layout18: TLayout;
    ActLibrary: TTakePhotoFromLibraryAction;
    ActCamera: TTakePhotoFromCameraAction;
    Timer1: TTimer;
    procedure lbl_login_contaClick(Sender: TObject);
    procedure lbl_conta_loginClick(Sender: TObject);
    procedure rect_conta_proximoClick(Sender: TObject);
    procedure img_foto_voltarClick(Sender: TObject);
    procedure c_foto_editarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img_fotoClick(Sender: TObject);
    procedure img_libraryClick(Sender: TObject);
    procedure img_escolher_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rect_contaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, cUsuario, UnitDM;

procedure TFrmLogin.ActCameraDidFinishTaking(Image: TBitmap);
begin
    c_foto_editar.Fill.Bitmap.Bitmap := Image;
    ActFoto.Execute;
end;

procedure TFrmLogin.ActLibraryDidFinishTaking(Image: TBitmap);
begin
    c_foto_editar.Fill.Bitmap.Bitmap := Image;
    ActFoto.Execute;
end;

procedure TFrmLogin.c_foto_editarClick(Sender: TObject);
begin
    ActEscolher.Execute;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    permissao := T99Permissions.Create;
end;

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
    permissao.DisposeOf;
end;

procedure TFrmLogin.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}

begin
    {$IFDEF ANDROID}
    if (Key = vkHardwareBack) then
    begin
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                          IInterface(FService));

        if (FService <> nil) and
           (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
        begin
            // Botao back pressionado e teclado visivel...
            // (apenas fecha o teclado)
        end
        else
        begin
            // Botao back pressionado e teclado NAO visivel...

            if TabControl1.ActiveTab = TabConta then
            begin
                Key := 0;
                ActLogin.Execute
            end
            else if TabControl1.ActiveTab = TabFoto then
            begin
                Key := 0;
                ActConta.Execute
            end
            else if TabControl1.ActiveTab = TabEscolher then
            begin
                Key := 0;
                ActFoto.Execute;
            end;
        end;
    end;
    {$ENDIF}
end;
procedure TFrmLogin.FormShow(Sender: TObject);
begin
    TabControl1.ActiveTab := TabLogin;
    Timer1.Enabled := true;
end;

procedure TFrmLogin.Timer1Timer(Sender: TObject);
var
    u : TUsuario;
    erro: string;
    qry: TFDQuery;
begin
    Timer1.Enabled := false;

    // Valida se usuario ja está logado...
    try
        u := TUsuario.Create(dm.conn);
        qry := TFDQuery.Create(nil);

        qry := u.ListarUsuario(erro);

        if qry.FieldByName('IND_LOGIN').AsString <> 'S' then
            exit;

    finally
        qry.DisposeOf;
        u.DisposeOf;
    end;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.TrataErroPermissao(Sender: TObject);
begin
    showmessage('Você não possui permissão de acesso para esse recurso');
end;

procedure TFrmLogin.img_escolher_voltarClick(Sender: TObject);
begin
    ActFoto.Execute;
end;

procedure TFrmLogin.img_fotoClick(Sender: TObject);
begin
    permissao.Camera(ActCamera, TrataErroPermissao);
end;

procedure TFrmLogin.img_foto_voltarClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TFrmLogin.img_libraryClick(Sender: TObject);
begin
    permissao.PhotoLibrary(ActLibrary, TrataErroPermissao);
end;

procedure TFrmLogin.lbl_conta_loginClick(Sender: TObject);
begin
    ActLogin.Execute;
end;

procedure TFrmLogin.lbl_login_contaClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TFrmLogin.rect_contaClick(Sender: TObject);
var
    u : TUsuario;
    erro : string;
begin
    try
        u := TUsuario.Create(dm.conn);
        u.NOME := edt_cad_nome.Text;
        u.EMAIL := edt_cad_email.Text;
        u.SENHA := edt_cad_senha.Text;
        u.IND_LOGIN := 'S';
        u.FOTO := c_foto_editar.Fill.Bitmap.Bitmap;

        // Excluir conta existente...
        if NOT u.Excluir(erro) then
        begin
            showmessage(erro);
            exit;
        end;

        // Cadastrar novo usuario...
        if NOT u.Inserir(erro) then
        begin
            showmessage(erro);
            exit;
        end;

    finally
        u.DisposeOf;
    end;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.rect_conta_proximoClick(Sender: TObject);
begin
    ActFoto.Execute;
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
var
    u : TUsuario;
    erro : string;
begin
    try
        u := TUsuario.Create(dm.conn);
        u.EMAIL := edt_login_email.Text;
        u.SENHA := edt_login_senha.Text;

        if NOT u.ValidarLogin(erro) then
        begin
            showmessage(erro);
            exit;
        end;

    finally
        u.DisposeOf;
    end;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

end.
