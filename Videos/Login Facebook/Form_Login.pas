unit Form_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  IPPeerClient, REST.Client, REST.Authenticator.OAuth, Data.Bind.Components,
  Data.Bind.ObjectScope

  ,REST.Utils
  ,System.JSON
  ,Web.HTTPApp
  ,System.Net.HttpClient
  ,IdHTTP

  ;

type
  TFrm_Login = class(TForm)
    RoundRect1: TRoundRect;
    btn_login: TLabel;
    Layout1: TLayout;
    edt_nome: TEdit;
    edt_email: TEdit;
    circle_foto: TCircle;
    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
    RESTResponse: TRESTResponse;
    OAuth2_Facebook: TOAuth2Authenticator;
    procedure btn_loginClick(Sender: TObject);
    procedure RESTRequestAfterExecute(Sender: TCustomRESTRequest);
  private
    { Private declarations }
  public
    { Public declarations }
    FAccessToken : string;
  end;

var
  Frm_Login: TFrm_Login;

implementation

{$R *.fmx}

uses Form_LoginFacebook;

function LoadStreamFromURL(url : string): TMemoryStream;
var
        MS : TMemoryStream;
        imagem: TBitmap;
        http : THTTPClient;
begin
        MS := TMemoryStream.Create;
        http := THTTPClient.Create;

        imagem := TBitmap.Create;
        try
                try
                        http.Get(url, MS);

                except on e: EIdHTTPProtocolException do
                begin
                        if e.ErrorCode = 404 then
                        begin
                                // url nao encontada...
                                showmessage('Foto não encontrada');
                        end
                        else
                        begin
                                // outro erro...
                                showmessage('Ocorreu um erro ao buscar a foto');                        
                        end;
                end;
                end;

                MS.Position := 0;
                Result := MS;
        finally
                imagem.Free;
        end;
        
end;

procedure TFrm_Login.btn_loginClick(Sender: TObject);
var
        id_aplicativo, LURL : string;
begin
        try
                FAccessToken := '';
                id_aplicativo := '00000000000000000'; // Colocar o codigo do seu aplicativo aqui...

                LURL := 'https://www.facebook.com/dialog/oauth'
                        + '?client_id=' + URIEncode(id_aplicativo)
                        + '&response_type=token'
                        + '&scope=' + URIEncode('public_profile,email')
                        //+ '&scope=' + URIEncode('user_about_me,user_birthday')
                        + '&redirect_uri=' + URIEncode('https://www.facebook.com/connect/login_success.html');


                // Abre tela de login do facebook...
                try
                        Frm_LoginFacebook := TFrm_LoginFacebook.Create(nil);
                        Frm_LoginFacebook.WebBrowser.Navigate(LURL);
                        Frm_LoginFacebook.ShowModal(
                                        procedure(ModalResult: TModalResult)
                                        begin
                                                if FAccessToken <> '' then
                                                begin
                                                        RESTRequest.ResetToDefaults;
                                                        RESTClient.ResetToDefaults;
                                                        RESTResponse.ResetToDefaults;
                                                        
                                                        RESTClient.BaseURL := 'https://graph.facebook.com';
                                                        RESTClient.Authenticator := OAuth2_Facebook;
                                                        RESTRequest.Resource := 'me?fields=first_name,last_name,email,picture.height(150)';
                                                        OAuth2_Facebook.AccessToken := FAccessToken;

                                                        RESTRequest.Execute;
                                                end;
                                        end);
                finally

                end;


        except on e:exception do
                showmessage(e.Message);
        end;
end;

procedure TFrm_Login.RESTRequestAfterExecute(Sender: TCustomRESTRequest);
var
        LJsonObj  : TJSONObject;
        LElements: TJSONValue;
        
        msg, url_foto, nome, email, user_id : string;

        MS: TMemoryStream;
begin
        try
                msg := '';
                FAccessToken := '';

                
                // Valida JSON retornado...
                if Assigned(RESTResponse.JSONValue) then
                        msg := RESTResponse.JSONValue.ToString;


                // Extrai campos do JSON...                
                LJsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(msg), 0) as TJSONObject;

                try
                        user_id := HTMLDecode(StringReplace(TJSONObject(LJsonObj).Get('id').JsonValue.ToString, '"', '', [rfReplaceAll]));
                except
                end;

                try
                        email := StringReplace(TJSONObject(LJsonObj).Get('email').JsonValue.ToString, '"', '', [rfReplaceAll]);
                except
                end;

                try
                        // Primeiro nome...
                        nome := StringReplace(TJSONObject(LJsonObj).Get('first_name').JsonValue.ToString, '"', '', [rfReplaceAll]);
                except
                end;

                try
                        // Sobrenome...
                        nome := nome + ' ' + StringReplace(TJSONObject(LJsonObj).Get('last_name').JsonValue.ToString, '"', '', [rfReplaceAll]);
                except
                end;

                try
                        LElements := TJSONObject(TJSONObject(LJsonObj).Get('picture').JsonValue).Get('data').JsonValue;
                        url_foto := StringReplace(TJSONObject(LElements).Get('url').JsonValue.ToString, '"', '', [rfReplaceAll]);
                except
                end;

                
                              

                // Download da foto...
                try
                        MS := TMemoryStream.Create;
                        MS := LoadStreamFromURL(url_foto);

                        circle_foto.Fill.Bitmap.Bitmap.LoadFromStream(MS);

                except
                        showmessage('Erro a criar a foto');
                end;

                edt_nome.Text := nome;
                edt_email.Text := email;
                                        
        except

        end;
end;
end.
