unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uDWAbout, uRESTDWServerEvents, uDWJSONObject,
  System.JSON, FireDAC.DApt, uDWConsts;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEventsUsuario: TDWServerEvents;
    DWEventsPedido: TDWServerEvents;
    procedure DWEventsEventshoraReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsusuarioReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
  private
    function ValidarLogin(email, senha: string;
                          out status: integer): string;
    function CriarUsuario(email, senha, nome, fone, foto64: string;
      out status: integer): string;
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


function TDm.ValidarLogin(email, senha: string;
                          out status: integer): string;
var
    u : TUsuario;
    json : TJSONObject;
    erro: string;
begin
    try
        u := TUsuario.Create(dm.conn);
        u.EMAIL := email;
        u.SENHA := senha;

        json := TJSONObject.Create;

        // {"retorno":"OK", "id_usuario": 123, "nome": "Heber...."}
        // {"retorno":"Erro xyz....", "id_usuario": 0, "nome": ""}
        if NOT u.ValidarLogin(erro) then
        begin
            json.AddPair('retorno', erro);
            json.AddPair('id_usuario', '0');
            json.AddPair('nome', '');
            Status := 401;
        end
        else
        begin
            json.AddPair('retorno', 'OK');
            json.AddPair('id_usuario', u.ID_USUARIO.ToString);
            json.AddPair('nome', u.NOME);
            Status := 200;
        end;

        Result := json.ToString;

    finally
        json.DisposeOf;
        u.DisposeOf;
    end;
end;

function TDm.CriarUsuario(email, senha, nome, fone, foto64 : string;
                          out status: integer): string;
var
    u : TUsuario;
    json : TJSONObject;
    erro: string;
begin
    try
        u := TUsuario.Create(dm.conn);
        u.ID_USUARIO := 0;
        u.EMAIL := email;
        u.SENHA := senha;
        u.NOME := nome;
        u.FONE := fone;
        u.FOTO := nil;  //  Revisar....

        json := TJSONObject.Create;

        // Validar se usuario existe...
        if u.DadosUsuario(erro) then
        begin
            json.AddPair('retorno', 'Já existe um usuário com esse email');
            Status := 400;
            Result := json.ToString;
            exit;
        end;

        if NOT u.Inserir(erro) then
        begin
            json.AddPair('retorno', erro);
            Status := 400;
        end
        else
        begin
            json.AddPair('retorno', 'OK');
            json.AddPair('id_usuario', u.ID_USUARIO.ToString);
            json.AddPair('nome', u.NOME);
            Status := 201;
        end;

        Result := json.ToString;

    finally
        json.DisposeOf;
        u.DisposeOf;
    end;
end;



procedure Tdm.DWEventsEventsusuarioReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
    // GET.......
    if RequestType = TRequestType.rtGet then
        Result := ValidarLogin(Params.ItemsString['email'].AsString,
                               Params.ItemsString['senha'].AsString,
                               StatusCode)
    else
    // POST.......
    if RequestType = TRequestType.rtPost then
        Result := CriarUsuario(Params.ItemsString['email'].AsString,
                               Params.ItemsString['senha'].AsString,
                               Params.ItemsString['nome'].AsString,
                               Params.ItemsString['fone'].AsString,
                               '', // foto base64...
                               StatusCode)
    else
    begin
        StatusCode := 403;
        Result := '{"retorno":"Verbo HTTP não é válido. Utilize o GET", "id_usuario": 0, "nome": ""}';
    end;

end;

end.
