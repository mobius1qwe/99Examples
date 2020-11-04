unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, uDWAbout, uRESTDWServerEvents,
  uDWJSONObject;

type
  Tdm = class(TServerMethodDataModule)
    DWEvents: TDWServerEvents;
    procedure DWEventsEventshoraReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsValidaLoginReplyEvent(var Params: TDWParams;
      var Result: string);
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

procedure Tdm.DWEventsEventshoraReplyEvent(var Params: TDWParams;
  var Result: string);
begin
    Result := '{"hora": "' + FormatDateTime('hh:nn:ss', now) + '"}';
end;

procedure Tdm.DWEventsEventsValidaLoginReplyEvent(var Params: TDWParams;
  var Result: string);
var
    codusuario, senha : string;
begin
    codusuario := Params.ItemsString['usuario'].AsString;
    senha := Params.ItemsString['senha'].AsString;

    if codusuario = '' then
        Result := '{"sucesso": "N", "erro":"Usuário não informado", "codusuario":"0"}'
    else
        Result := '{"sucesso": "S", "erro":"", "codusuario":"10"}';
end;

end.
