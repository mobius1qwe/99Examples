unit UnitDM;

interface

uses
  uDWDataMOdule, System.SysUtils, System.Classes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, uRESTDWPoolerDB, uRestDWDriverFD, uDWAbout,
  uRESTDWServerEvents, uDWJSONObject, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, uDWConsts;

type
  Tdm = class(TServerMethodDataModule)
    FDConn: TFDConnection;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    DWEvents: TDWServerEvents;
    qry_compromisso: TFDQuery;
    procedure DWEventsEventsListarCompromissosReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsHoraReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DWEventsEventsHoraReplyEvent(var Params: TDWParams;
  var Result: string);
begin
    Result := '{"HORA":"' + FormatDateTime('HH:NN:SS', now) + '"}';
end;


procedure Tdm.DWEventsEventsListarCompromissosReplyEvent(var Params: TDWParams;
  var Result: string);
var
    JSONValue : TJSONValue;
    qry : TFDQuery;
begin

    try
        JSONValue := TJSONValue.Create;

        qry := TFDQuery.Create(nil);
        qry.Connection := FDConn;
        qry.Active := false;
        qry.SQL.Clear;
        qry.SQL.Add('SELECT * FROM COMPROMISSO');
        qry.Active := true;

        if NOT qry.IsEmpty then
        begin
            JSONValue.LoadFromDataset('', qry, false, jmPureJSON);
            result := JSONValue.ToJSON;
        end;

    finally
        JSONValue.DisposeOf;
        qry.DisposeOf;
    end;
end;

end.
