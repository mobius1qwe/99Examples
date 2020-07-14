unit Form_LoginFacebook;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.VirtualKeyboard,
  FMX.Platform;

type
  TWebFormRedirectEvent = procedure(const AURL : string; var DoCloseWebView: boolean) of object;

type
  TFrm_LoginFacebook = class(TForm)
    WebBrowser: TWebBrowser;
    Rectangle1: TRectangle;
    btn_voltar: TSpeedButton;
    procedure btn_voltarClick(Sender: TObject);
    procedure WebBrowserDidFinishLoad(ASender: TObject);
  private
    { Private declarations }
    FOnBeforeRedirect : TWebFormRedirectEvent;
  public
    { Public declarations }
    property OnBeforeRedirect: TWebFormRedirectEvent read FOnBeforeRedirect write FOnBeforeRedirect;
  end;

var
  Frm_LoginFacebook: TFrm_LoginFacebook;

implementation

{$R *.fmx}

uses Form_Login;

procedure Facebook_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
var
      LATPos: integer;
      LToken: string;
begin
        try
                LATPos := Pos('access_token=', AURL);

                if (LATPos > 0) then
                begin
                        LToken := Copy(AURL, LATPos + 13, Length(AURL));

                        if (Pos('&', LToken) > 0) then
                        begin
                                LToken := Copy(LToken, 1, Pos('&', LToken) - 1);
                        end;

                        Frm_Login.FAccessToken := LToken;

                        if (LToken <> '') then
                        begin
                                DoCloseWebView := True;
                        end;
                end
                else
                begin
                        LATPos := Pos('api_key=', AURL);

                        if LATPos <= 0 then
                        begin
                                LATPos := Pos('access_denied', AURL);

                                if (LATPos > 0) then
                                begin
                                        // Acesso negado, cancelado ou usuário não permitiu o acesso...
                                        Frm_Login.FAccessToken := '';
                                        DoCloseWebView := True;
                                end;
                        end;
                end;
      except
        on E: Exception do
          ShowMessage(E.Message);
      END;
    end;

procedure TFrm_LoginFacebook.btn_voltarClick(Sender: TObject);
begin
        Frm_Login.FAccessToken := '';
        ModalResult := mrOk;
end;

procedure TFrm_LoginFacebook.WebBrowserDidFinishLoad(ASender: TObject);
var
        CloseWebView : boolean;
        url : string;
begin
        url := TWebBrowser(ASender).URL;
        CloseWebView := false;

        if url <> '' then
                Facebook_AccessTokenRedirect(url, CloseWebView);

        if CloseWebView then
        begin
                TWebBrowser(ASender).Stop;
                TWebBrowser(ASender).URL := '';
                Frm_LoginFacebook.close;
                ModalResult := mrok;
        end;

end;

end.
