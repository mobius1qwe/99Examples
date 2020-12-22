unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uDWAbout, uRESTDWServerEvents, uDWJSONObject,
  System.JSON, FireDAC.DApt;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TDWServerEvents;
    procedure DWEventsEventshoraReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsloginReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
    function CarregarConfig: string;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses System.IniFiles, cUsuario;

function TDm.CarregarConfig(): string;
var
    arq_ini : string;
    ini : TIniFile;
begin
    try
        arq_ini := System.SysUtils.GetCurrentDir + '\servidor.ini';

        // Verifica se INI existe...
        if NOT FileExists(arq_ini) then
        begin
            Result := 'Arquivo INI não encontrado: ' + arq_ini;
            exit;
        end;

        // Instanciar arquivo INI...
        ini := TIniFile.Create(arq_ini);

        // Buscar dados do arquivo fisico...
        dm.conn.Params.Values['DriverID'] := ini.ReadString('Banco de Dados', 'DriverID', '');
        dm.conn.Params.Values['Database'] := ini.ReadString('Banco de Dados', 'Database', '');
        dm.conn.Params.Values['User_name'] := ini.ReadString('Banco de Dados', 'User_name', '');
        dm.conn.Params.Values['Password'] := ini.ReadString('Banco de Dados', 'Password', '');

        try
            conn.Connected := true;
            Result := 'OK';
        except on ex:exception do
            Result := 'Erro ao acessar o banco: ' + ex.Message;
        end;

    finally
        if Assigned(ini) then
            ini.DisposeOf;
    end;
end;

procedure Tdm.DWEventsEventshoraReplyEvent(var Params: TDWParams;
  var Result: string);
begin
    Result := '{"data":"' + FormatDateTime('dd/mm/yyyy hh:nn', now) +  '"}';
end;

procedure Tdm.DWEventsEventsloginReplyEvent(var Params: TDWParams;
  var Result: string);
var
    u : TUsuario;
    erro : string;
    json : TJSONObject;
begin
    try
        u := TUsuario.Create(dm.conn);
        u.EMAIL := Params.ItemsString['email'].AsString;
        u.SENHA := Params.ItemsString['senha'].AsString;

        json := TJSONObject.Create;

        // {"retorno":"OK", "id_usuario": 123, "nome": "Heber...."}
        // {"retorno":"Erro xyz....", "id_usuario": 0, "nome": ""}
        if NOT u.ValidarLogin(erro) then
        begin
            json.AddPair('retorno', erro);
            json.AddPair('id_usuario', '0');
            json.AddPair('nome', '');
        end
        else
        begin
            json.AddPair('retorno', 'OK');
            json.AddPair('id_usuario', u.ID_USUARIO.ToString);
            json.AddPair('nome', u.NOME);
        end;

        Result := json.ToString;

    finally
        json.DisposeOf;
        u.DisposeOf;
    end;
end;

end.
