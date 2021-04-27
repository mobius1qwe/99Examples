unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Platform,
  System.JSON, u99Permissions,

  {$IFDEF ANDROID}
  FMX.VirtualKeyboard,
  {$ENDIF}

  FMX.Edit, uFunctions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions;

type
  TFrmLogin = class(TForm)
    TabControl1: TTabControl;
    TabInicial: TTabItem;
    TabLogin: TTabItem;
    TabConta1: TTabItem;
    TabConta2: TTabItem;
    rect_fundo_aba1: TRectangle;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    rect_btn_entrar: TRectangle;
    Label5: TLabel;
    rect_btn_cadastrar: TRectangle;
    Label6: TLabel;
    rect_tb_login: TRectangle;
    rect_login_voltar: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Layout4: TLayout;
    Label9: TLabel;
    edt_login_email: TEdit;
    Label10: TLabel;
    edt_login_senha: TEdit;
    rect_login: TRectangle;
    Label11: TLabel;
    Label12: TLabel;
    Layout5: TLayout;
    Label13: TLabel;
    edt_cad_email: TEdit;
    edt_cad_senha: TEdit;
    Label14: TLabel;
    rect_prox1: TRectangle;
    Label15: TLabel;
    Rectangle3: TRectangle;
    Label16: TLabel;
    Image3: TImage;
    Label17: TLabel;
    Layout6: TLayout;
    Label18: TLabel;
    edt_cad_nome: TEdit;
    edt_cad_fone: TEdit;
    Label19: TLabel;
    rect_prox2: TRectangle;
    Label20: TLabel;
    Rectangle5: TRectangle;
    Label21: TLabel;
    Image4: TImage;
    TabConta3: TTabItem;
    Label22: TLabel;
    Layout7: TLayout;
    Label24: TLabel;
    rect_conta_finalizar: TRectangle;
    Label25: TLabel;
    Rectangle7: TRectangle;
    Label26: TLabel;
    img_voltar: TImage;
    c_foto: TCircle;
    Label23: TLabel;
    edt_cad_endereco: TEdit;
    OpenDialog: TOpenDialog;
    ActionList1: TActionList;
    ActFoto: TTakePhotoFromCameraAction;
    procedure rect_conta_finalizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TabConta1Click(Sender: TObject);
    procedure rect_btn_cadastrarClick(Sender: TObject);
    procedure rect_loginClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure c_fotoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActFotoDidFinishTaking(Image: TBitmap);
    procedure Label17Click(Sender: TObject);
    procedure Label22Click(Sender: TObject);
  private
    permissao : T99Permissions;
    procedure NavegarAbas(pag: integer);
    procedure ProcessarLogin;
    procedure ProcessarLoginErro(Sender: TObject);
    procedure ProcessarLoginCad;
    procedure TrataPermissaoFotoErro(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, REST.Types, UnitCategoria;



procedure TFrmLogin.NavegarAbas(pag: integer);
begin
    if (TabControl1.TabIndex = 0) and (pag < 0) then
        exit;
    if (TabControl1.TabIndex = 4) and (pag > 0) then
        exit;

    TabControl1.GotoVisibleTab(TabControl1.TabIndex + pag, TTabTransition.Slide);
end;

procedure TFrmLogin.TrataPermissaoFotoErro(Sender: TObject);
begin
    showmessage('O app não possui acesso a câmera');
end;

procedure TFrmLogin.ActFotoDidFinishTaking(Image: TBitmap);
begin
    c_foto.Fill.Bitmap.Bitmap := Image;
end;

procedure TFrmLogin.c_fotoClick(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    if OpenDialog.Execute then
        c_foto.Fill.Bitmap.Bitmap.LoadFromFile(OpenDialog.FileName);
    {$ELSE}
        permissao.Camera(ActFoto, TrataPermissaoFotoErro);
    {$ENDIF}
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
            if TabControl1.TabIndex > 0 then
            begin
                Key := 0;
                NavegarAbas(-1);
            end;
        end;
    end;
    {$ENDIF}
end;


procedure TFrmLogin.FormShow(Sender: TObject);
begin
    TabControl1.ActiveTab := TabInicial;
end;

procedure TFrmLogin.img_voltarClick(Sender: TObject);
begin
    NavegarAbas(-1);
end;

procedure TFrmLogin.Label17Click(Sender: TObject);
begin
    NavegarAbas(-2);
end;

procedure TFrmLogin.Label22Click(Sender: TObject);
begin
    NavegarAbas(-3);
end;

procedure TFrmLogin.rect_btn_cadastrarClick(Sender: TObject);
begin
    NavegarAbas(2);
end;

procedure TFrmLogin.ProcessarLogin;
var
    jsonObj : TJsonObject;
    json, retorno, id_usuario, nome: string;

    endereco, email, fone, foto64, grupo, categoria : string;
    avaliacao_cliente, avaliacao_prestador : double;
    qtd_avaliacao_cliente, qtd_avaliacao_prestador : Integer;
begin
    try
        json := dm.RequestLogin.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;
        id_usuario := jsonObj.GetValue('id_usuario').Value;
        nome := jsonObj.GetValue('nome').Value;

        // Se deu erro...
        if dm.RequestLogin.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

        endereco := jsonObj.GetValue('endereco').Value;
        email := jsonObj.GetValue('email').Value;
        fone := jsonObj.GetValue('fone').Value;
        avaliacao_cliente := jsonObj.GetValue('avaliacao_cliente').Value.ToDouble;
        avaliacao_prestador := jsonObj.GetValue('avaliacao_prestador').Value.ToDouble;
        foto64 := jsonObj.GetValue('foto').Value;
        qtd_avaliacao_cliente := jsonObj.GetValue('qtd_avaliacao_cliente').Value.ToInteger;
        qtd_avaliacao_prestador := jsonObj.GetValue('qtd_avaliacao_prestador').Value.ToInteger;
        grupo := jsonObj.GetValue('grupo').Value;
        categoria := jsonObj.GetValue('categoria').Value;

    finally
        jsonObj.DisposeOf;
    end;


    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;

    if foto64 <> '' then
        FrmPrincipal.c_foto.Fill.Bitmap.Bitmap := TFunctions.BitmapFromBase64(foto64);

    FrmPrincipal.lbl_avaliacoes.Text := qtd_avaliacao_prestador.ToString + ' Avaliações';
    FrmPrincipal.id_usuario_logado := id_usuario.ToInteger;
    FrmPrincipal.lbl_endereco.Text := endereco;
    FrmPrincipal.lbl_nome.Text := nome;
    FrmPrincipal.lbl_email.Text := email;
    FrmPrincipal.lbl_fone.Text := fone;
    FrmPrincipal.lbl_grupo.TagString := grupo;
    FrmPrincipal.lbl_categoria.TagString := categoria;
    FrmPrincipal.lbl_grupo.Text := categoria + ' / ' + grupo;
    FrmPrincipal.Avaliar(Round(avaliacao_prestador));
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.ProcessarLoginCad;
var
    jsonObj : TJsonObject;
    json, retorno, id_usuario, nome: string;
begin
    try
        json := dm.RequestLoginCad.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;
        id_usuario := jsonObj.GetValue('id_usuario').Value;
        nome := jsonObj.GetValue('nome').Value;

        // Se deu erro...
        if dm.RequestLoginCad.Response.StatusCode <> 201 then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;


    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;

    FrmPrincipal.id_usuario_logado := id_usuario.ToInteger;
    FrmPrincipal.lbl_endereco.Text := edt_cad_endereco.Text;
    FrmPrincipal.lbl_nome.Text := edt_cad_nome.Text;
    FrmPrincipal.lbl_email.Text := edt_cad_email.Text;
    FrmPrincipal.lbl_fone.Text := edt_cad_fone.Text;
    FrmPrincipal.Avaliar(0);
    FrmPrincipal.c_foto.Fill.Bitmap.Bitmap := FrmLogin.c_foto.Fill.Bitmap.Bitmap;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.ProcessarLoginErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmLogin.rect_conta_finalizarClick(Sender: TObject);
begin
    if NOT Assigned(FrmCategoria) then
        Application.CreateForm(TFrmCategoria, FrmCategoria);

    FrmCategoria.request_categoria := dm.RequestCategoria;
    FrmCategoria.request_grupo := dm.RequestGrupo;

    FrmCategoria.ShowModal(procedure(ModalResult: TModalResult)
    begin
        if FrmCategoria.categoria <> '' then
        begin
            // Criar a conta no server...
            dm.RequestLoginCad.Params.Clear;
            dm.RequestLoginCad.AddParameter('id', '');
            dm.RequestLoginCad.AddParameter('email', edt_cad_email.Text);
            dm.RequestLoginCad.AddParameter('senha', edt_cad_senha.Text);
            dm.RequestLoginCad.AddParameter('nome', edt_cad_nome.Text);
            dm.RequestLoginCad.AddParameter('fone', edt_cad_fone.Text);
            dm.RequestLoginCad.AddParameter('endereco', edt_cad_endereco.Text);
            dm.RequestLoginCad.AddParameter('foto', TFunctions.Base64FromBitmap(c_foto.Fill.Bitmap.Bitmap),
                                                    TRESTRequestParameterKind.pkREQUESTBODY);
            dm.RequestLoginCad.AddParameter('categoria', FrmCategoria.categoria);
            dm.RequestLoginCad.AddParameter('grupo', FrmCategoria.grupo);
            dm.RequestLoginCad.ExecuteAsync(ProcessarLoginCad, true, true, ProcessarLoginErro);
        end;
    end);
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
begin
    // Validar o login no server...
    dm.RequestLogin.Params.Clear;
    dm.RequestLogin.AddParameter('email', edt_login_email.Text);
    dm.RequestLogin.AddParameter('senha', edt_login_senha.Text);
    dm.RequestLogin.ExecuteAsync(ProcessarLogin, true, true, ProcessarLoginErro);
end;

procedure TFrmLogin.TabConta1Click(Sender: TObject);
begin
    NavegarAbas(1);
end;

end.
