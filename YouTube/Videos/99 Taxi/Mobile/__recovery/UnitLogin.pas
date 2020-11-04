unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Ani,
  REST.Types, REST.Client, REST.Authenticator.Basic, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON, FMX.TabControl, System.Actions,
  FMX.ActnList, FMX.MediaLibrary.Actions, FMX.StdActns, u99Permissions,
  System.NetEncoding, uMD5;

type
  TFrmLogin = class(TForm)
    Image1: TImage;
    layout_campos: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Image2: TImage;
    edt_email: TEdit;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    Image3: TImage;
    edt_senha: TEdit;
    rect_botao: TRectangle;
    Label1: TLabel;
    Layout4: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    FloatAnimation1: TFloatAnimation;
    img_loading: TImage;
    FloatAnimation2: TFloatAnimation;
    FloatAnimation3: TFloatAnimation;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    Label4: TLabel;
    Image4: TImage;
    Label5: TLabel;
    Layout1: TLayout;
    Layout5: TLayout;
    Rectangle3: TRectangle;
    Image5: TImage;
    edt_cad_email: TEdit;
    Layout6: TLayout;
    Rectangle4: TRectangle;
    Image6: TImage;
    edt_cad_senha: TEdit;
    Rectangle5: TRectangle;
    Label6: TLabel;
    Layout7: TLayout;
    Label7: TLabel;
    FloatAnimation4: TFloatAnimation;
    c_foto: TCircle;
    Label8: TLabel;
    ActionList1: TActionList;
    ActLogin: TChangeTabAction;
    ActConta: TChangeTabAction;
    TabFoto: TTabItem;
    Layout8: TLayout;
    lbl_cancelar: TLabel;
    img_foto: TImage;
    img_library: TImage;
    ActFoto: TChangeTabAction;
    ActLibrary: TTakePhotoFromLibraryAction;
    ActCamera: TTakePhotoFromCameraAction;
    RESTClient: TRESTClient;
    RequestConta: TRESTRequest;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    RequestLogin: TRESTRequest;
    procedure FormCreate(Sender: TObject);
    procedure rect_botaoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_botaoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_botaoClick(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure c_fotoClick(Sender: TObject);
    procedure lbl_cancelarClick(Sender: TObject);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_fotoClick(Sender: TObject);
    procedure img_libraryClick(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
  private
    permissao : T99Permissions;
    procedure ExibirCampos;
    procedure ErroPermissao(Sender: TObject);
    function Base64FromBitmap(Bitmap: TBitmap): string;
    procedure AbrirPrincipal(cod: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;

function TFrmLogin.Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
  Encoding: TBase64Encoding;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                    Encoding := TBase64Encoding.Create(0);
                    Encoding.Encode(Input, Output);
                    Result := Output.DataString;
                finally
                        Encoding.Free;
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;

procedure TFrmLogin.ActLibraryDidFinishTaking(Image: TBitmap);
begin
    c_foto.Fill.Bitmap.Bitmap := Image;
    ActConta.Execute;
end;

procedure TFrmLogin.c_fotoClick(Sender: TObject);
begin
    ActFoto.Execute;
end;

procedure TFrmLogin.ExibirCampos;
begin
    img_loading.Visible := false;
    TabControl.Visible := true;
    TabControl.Opacity := 1;
end;

procedure TFrmLogin.AbrirPrincipal(cod: string);
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    FrmPrincipal.cod_usuario := cod;

    Application.MainForm := FrmPrincipal;

    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure ProcessaLogin;
var
    jsonObj : TJsonObject;
    json, sucesso, erro, cod_usuario : string;
begin
    FrmLogin.FloatAnimation2.Stop;
    FrmLogin.FloatAnimation3.Stop;


    if FrmLogin.RequestLogin.Response.StatusCode <> 200 then
    begin
        FrmLogin.ExibirCampos;
        ShowMessage('Erro ao validar login: ' + FrmLogin.RequestLogin.Response.StatusText);
        exit;
    end;

    try
        json := FrmLogin.RequestLogin.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        sucesso := jsonObj.GetValue('sucesso').Value;
        erro := jsonObj.GetValue('erro').Value;
        cod_usuario := jsonObj.GetValue('codusuario').Value;
    finally
        jsonObj.DisposeOf;
    end;

    if sucesso <> 'S' then
    begin
        FrmLogin.ExibirCampos;
        ShowMessage(erro);
        exit;
    end
    else
        FrmLogin.AbrirPrincipal(cod_usuario);

end;

procedure ProcessaConta;
var
    jsonObj : TJsonObject;
    json, sucesso, erro, cod_usuario : string;
begin
    FrmLogin.FloatAnimation2.Stop;
    FrmLogin.FloatAnimation3.Stop;

    if FrmLogin.RequestConta.Response.StatusCode <> 200 then
    begin
        FrmLogin.ExibirCampos;
        ShowMessage('Erro ao criar conta: ' + FrmLogin.RequestConta.Response.StatusText);
        exit;
    end;

    try
        json := FrmLogin.RequestConta.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        sucesso := jsonObj.GetValue('sucesso').Value;
        erro := jsonObj.GetValue('erro').Value;
        cod_usuario := jsonObj.GetValue('codusuario').Value;
    finally
        jsonObj.DisposeOf;
    end;


    if sucesso <> 'S' then
    begin
        FrmLogin.ExibirCampos;
        ShowMessage(erro);
        exit;
    end
    else
        FrmLogin.AbrirPrincipal(cod_usuario);
end;

procedure ProcessaLoginErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
    begin
        FrmLogin.ExibirCampos;
        showmessage(Exception(Sender).Message);
    end;
end;

procedure TFrmLogin.FloatAnimation1Finish(Sender: TObject);
var
    foto64, json : string;
begin
    TabControl.Visible := false;
    img_loading.Visible := true;
    FloatAnimation2.Start;
    FloatAnimation3.Start;

    try
        if FloatAnimation1.TagString = 'LOGIN' then
        begin
            // Consumir WS Login...
            RequestLogin.Params.Clear;
            RequestLogin.AddParameter('email', edt_email.Text);
            RequestLogin.AddParameter('senha', MD5(edt_senha.Text));
            RequestLogin.ExecuteAsync(ProcessaLogin, true, true, ProcessaLoginErro);
        end
        else
        begin
            // Consumir WS Criacao de Conta...

            foto64 := Base64FromBitmap(c_foto.Fill.Bitmap.Bitmap);

            RequestConta.Params.Clear;
            RequestConta.AddParameter('senha', MD5(edt_cad_senha.Text));
            RequestConta.AddParameter('email', edt_cad_email.Text);
            //RequestConta.AddParameter('foto', foto64);
            RequestConta.AddParameter('foto', foto64, TRESTRequestParameterKind.pkREQUESTBODY);

            RequestConta.ExecuteAsync(ProcessaConta, true, true, ProcessaLoginErro);
        end;

    except on ex:exception do
        showmessage('Erro ao validar login: ' + ex.Message);
    end;

end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    permissao.DisposeOf;

    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    edt_email.Margins.Top := 5;
    edt_senha.Margins.Top := 5;
    edt_cad_email.Margins.Top := 5;
    edt_cad_senha.Margins.Top := 5;
    {$ENDIF}

    TabControl.ActiveTab := TabLogin;

    // Classe de permissao...
    permissao := T99Permissions.Create;
end;

procedure TFrmLogin.ErroPermissao(Sender: TObject);
begin
    showmessage('Você não possui permissão para esse recurso');
end;

procedure TFrmLogin.img_fotoClick(Sender: TObject);
begin
    permissao.Camera(ActCamera, ErroPermissao);
end;

procedure TFrmLogin.img_libraryClick(Sender: TObject);
begin
    permissao.PhotoLibrary(ActLibrary, ErroPermissao);
end;

procedure TFrmLogin.Label2Click(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TFrmLogin.Label7Click(Sender: TObject);
begin
    ActLogin.Execute;
end;

procedure TFrmLogin.lbl_cancelarClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TFrmLogin.Rectangle5Click(Sender: TObject);
begin
    FloatAnimation1.TagString := 'NOVA-CONTA';
    FloatAnimation1.Start;
end;

procedure TFrmLogin.rect_botaoClick(Sender: TObject);
begin
    FloatAnimation1.TagString := 'LOGIN';
    FloatAnimation1.Start;
end;

procedure TFrmLogin.rect_botaoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TRectangle(Sender).Opacity := 0.8;
end;

procedure TFrmLogin.rect_botaoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TRectangle(Sender).Opacity := 1;
end;

end.
