unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON, uDWJSONObject, System.IOUtils;

type
  TFrmPrincipal = class(TForm)
    btnRDW: TButton;
    RESTClient: TRESTClient;
    ReqRDW: TRESTRequest;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    procedure btnRDWClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.btnRDWClick(Sender: TObject);
var
    jsonParam : TJSONObject;
    retJson : uDWJsonObject.TJSONValue;
    arqLocal : string;
    arqStream : TStringStream;
begin
    try
        jsonParam := TJSONObject.Create;
        jsonParam.AddPair('arquivo', 'arquivo.pdf');

        ReqRDW.Params.Clear;
        ReqRDW.Body.ClearBody;
        ReqRDW.Body.Add(jsonParam.ToString, ContentTypeFromString('application/json'));
        ReqRDW.Execute;

        if ReqRDW.Response.StatusCode <> 200 then
            ShowMessage('Erro ao baixar arquivo: ' + ReqRDW.Response.Content)
        else
        begin
            try
                retJson := uDWJsonObject.TJSONValue.Create;
                retJson.LoadFromJSON(ReqRDW.Response.Content);

                {$IFDEF MSWINDOWS}
                arqLocal := GetCurrentDir + '\arquivo-baixado-windows.pdf';
                {$ELSE}
                arqLocal := TPath.Combine(TPath.GetDocumentsPath, 'arquivo-baixado-mobile.pdf');
                {$ENDIF}

                arqStream := TStringStream.Create('');
                retJson.SaveToStream(arqStream);
                arqStream.SaveToFile(arqLocal);
            finally
                retJson.DisposeOf;
                arqStream.DisposeOf;
            end;
        end;
    finally
        jsonParam.DisposeOf;
    end;
end;

end.
