unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWdataModule, uDWAbout, uRESTDWServerEvents,
  uDWConsts, uDWJSONObject, System.JSON;

type
  Tdm = class(TServerMethodDataModule)
    DWEvents: TDWServerEvents;
    procedure DWEventsEventsgetfileReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DWEventsEventsgetfileReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    body : TJSONValue;
    arq, parametro: string;
    ArqStream : TMemoryStream;
    ret : uDWJsonObject.TJSONValue;
begin
    parametro := Params.ItemsString['UNDEFINED'].AsString; // {"arquivo": "arquivo.pdf"}
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(parametro), 0) as TJSONValue;
    arq := 'c:\temp\files\' + body.GetValue<string>('arquivo'); // c:\temp\files\arquivo.pdf;
    body.DisposeOf;

    if FileExists(arq) then
    begin
        try
            StatusCode := 200;
            ArqStream := TMemoryStream.Create;
            ArqStream.LoadFromFile(arq);
            ArqStream.Position := 0;

            ret := uDWJsonObject.TJSONValue.Create;
            ret.LoadFromStream(ArqStream);

            Result := ret.ToJSON;
        finally
            ArqStream.DisposeOf;
            ret.DisposeOf;
        end;
    end
    else
    begin
        StatusCode := 401;
        Result := 'Arquivo não encontrado: ' + arq;
    end;
end;

end.
