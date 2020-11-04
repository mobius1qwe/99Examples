unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWConstsData, uRESTDWPoolerDB,
  uDWAbout, FMX.Layouts, FMX.ListBox, FMX.StdCtrls, FMX.Edit, REST.Types,
  REST.Client, REST.Authenticator.Basic, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Json, FMX.Objects, uOpenViewURL;

type
  TForm1 = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    lbl_versao: TLabel;
    rect_update: TRectangle;
    lbl_titulo: TLabel;
    Image1: TImage;
    Layout1: TLayout;
    img_seta: TImage;
    lbl_texto: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    rect_botao: TRectangle;
    btn_update: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_updateMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btn_updateClick(Sender: TObject);
    procedure btn_updateMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
    versao_app, versao_server : string;
  public
    { Public declarations }
    procedure OnFinishUpdate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
    // Versao atual do app...
    versao_app := '1.0';
    versao_server := '0.0';

    lbl_versao.Text := 'Versão ' + versao_app;
    rect_update.Margins.Top := Form1.Height + 50;
end;

procedure TForm1.OnFinishUpdate(Sender: TObject);
begin
    // Ocorreu algum erro na Thread...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(Sender).FatalException).Message);
        exit;
    end;

    if versao_app < versao_server then
    begin
        // Exibe o painel de update...
        rect_update.Visible := true;
        img_seta.Position.Y := 0;
        img_seta.Opacity := 0;
        lbl_titulo.Opacity := 0;
        lbl_texto.Opacity := 0;
        rect_botao.Opacity := 0;

        rect_update.BringToFront;
        rect_update.AnimateFloat('Margins.Top', 0, 0.8, TAnimationType.InOut, TInterpolationType.Circular);

        img_seta.AnimateFloatDelay('Position.Y', 50, 0.5, 1, TAnimationType.Out, TInterpolationType.Back);
        img_seta.AnimateFloatDelay('Opacity', 1, 0.4, 0.9);

        lbl_titulo.AnimateFloatDelay('Opacity', 1, 0.7, 1.3);
        lbl_texto.AnimateFloatDelay('Opacity', 1, 0.7, 1.6);
        rect_botao.AnimateFloatDelay('Opacity', 1, 0.7, 1.9);
    end;

end;

procedure TForm1.btn_updateClick(Sender: TObject);
var
    url : string;
begin
    {$IFDEF ANDROID}
    url := 'http://seu-servidor.com.br/app.apk';
    {$ELSE}
    url := 'https://apps.apple.com/br/app/whatsapp-messenger/id310633997';
    {$ENDIF}
    OpenURL(url, false);
end;

procedure TForm1.btn_updateMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    rect_botao.Opacity := 0.5;
end;

procedure TForm1.btn_updateMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    rect_botao.Opacity := 1;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    t : TThread;
begin

    t := TThread.CreateAnonymousThread(procedure
    var
        JsonObj : TJSONObject;
    begin
        sleep(2000);

        // Tenta consumir servico...
        try
            RESTRequest1.Execute;
        except on ex:exception do
            begin
                raise Exception.Create('Erro ao acessar o servidor: ' + ex.Message );
                exit;
            end;
        end;

        // Trata retorno em JSON...
        try
            JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(RESTRequest1.Response.JSONValue.ToString), 0) as TJSONObject;

            versao_server := TJSONObject(JsonObj).GetValue('versao').Value;
        finally
            JsonObj.DisposeOf;
        end;

    end);

    t.OnTerminate := OnFinishUpdate;
    t.Start;

end;

end.
