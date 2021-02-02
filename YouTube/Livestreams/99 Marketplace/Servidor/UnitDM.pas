unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uDWAbout, uRESTDWServerEvents, uDWJSONObject,
  System.JSON, FireDAC.DApt, uDWConsts, FMX.Graphics, uFunctions;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEventsUsuario: TDWServerEvents;
    DWEventsPedido: TDWServerEvents;
    DWEventsNotificacao: TDWServerEvents;
    procedure DWEventsEventshoraReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsusuarioReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWEventsPedidoEventspedidoReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWEventsNotificacaoEventsnotificacaoReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
  private
    function ValidarLogin(email, senha: string;
                          out status: integer): string;
    function CriarUsuario(email, senha, nome, fone, foto64: string;
      out status: integer): string;
    function ListaPedidos(sts, id_usuario: string;
      out status_code: integer): string;
    function ListaNotificacoes(id_usuario: string;
      out status_code: integer): string;
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

uses System.IniFiles, cUsuario, cPedido, cNotificacao;

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
    foto_bmp : TBitmap;
begin
    try
        json := TJSONObject.Create;
        u := TUsuario.Create(dm.conn);


        if foto64 = '' then
        begin
            json.AddPair('retorno', 'Foto do usuário não enviada');
            json.AddPair('id_usuario', '0');
            json.AddPair('nome', '');
            Status := 400;
            Result := json.ToString;
            exit;
        end;

        // Criar foto bitmap...
        try
            foto_bmp := TFunctions.BitmapFromBase64(foto64);
        except on ex:exception do
            begin
                json.AddPair('retorno', 'Erro ao criar imagem no servidor: ' + ex.Message);
                json.AddPair('id_usuario', '0');
                json.AddPair('nome', '');
                Status := 400;
                Result := json.ToString;
                exit;
            end;
        end;


        u.ID_USUARIO := 0;
        u.EMAIL := email;
        u.SENHA := senha;
        u.NOME := nome;
        u.FONE := fone;
        u.FOTO := foto_bmp;

        // Validar se usuario existe...
        if u.DadosUsuario(erro) then
        begin
            json.AddPair('retorno', 'Já existe um usuário com esse email');
            json.AddPair('id_usuario', '0');
            json.AddPair('nome', '');
            Status := 400;
            Result := json.ToString;
            exit;
        end;

        if NOT u.Inserir(erro) then
        begin
            json.AddPair('retorno', erro);
            json.AddPair('id_usuario', '0');
            json.AddPair('nome', '');
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
        foto_bmp.DisposeOf;
        json.DisposeOf;
        u.DisposeOf;
    end;
end;


function TDm.ListaPedidos(sts, id_usuario: string;
                          out status_code: integer): string;
var
    p : TPedido;
    json : uDWJSONObject.TJSONValue;
    qry : TFDQuery;
    erro: string;
begin
    try
        p := TPedido.Create(dm.conn);
        p.STATUS := sts;
        p.ID_USUARIO := id_usuario.ToInteger;

        qry := p.ListarPedido('', erro);

        json := uDWJSONObject.TJSONValue.Create;
        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
        status_code := 200;

    finally
        json.DisposeOf;
        p.DisposeOf;
    end;
end;

function TDm.ListaNotificacoes(id_usuario: string;
                          out status_code: integer): string;
var
    n : TNotificacao;
    json : uDWJSONObject.TJSONValue;
    qry : TFDQuery;
    erro: string;
begin
    try
        try
            n := TNotificacao.Create(dm.conn);
            n.ID_USUARIO := id_usuario.ToInteger;

            qry := n.ListarNotificacao('', erro);

            json := uDWJSONObject.TJSONValue.Create;
            json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

            Result := json.ToJSON;
            status_code := 200;
        except on ex:exception do
            begin
                status_code := 400;
                Result := '[{"retorno": "' + ex.Message + '"}]';
            end;
        end;

    finally
        json.DisposeOf;
        n.DisposeOf;
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
                               Params.ItemsString['foto'].AsString,
                               StatusCode)
    else
    begin
        StatusCode := 403;
        Result := '{"retorno":"Verbo HTTP não é válido. Utilize o GET", "id_usuario": 0, "nome": ""}';
    end;

end;

procedure Tdm.DWEventsNotificacaoEventsnotificacaoReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
begin
    // GET.......
    if RequestType = TRequestType.rtGet then
        Result := ListaNotificacoes(Params.ItemsString['id_usuario'].AsString,
                               StatusCode)
    {
    else
    // POST.......
    if RequestType = TRequestType.rtPost then
        Result := CriarUsuario(Params.ItemsString['email'].AsString,
                               Params.ItemsString['senha'].AsString,
                               Params.ItemsString['nome'].AsString,
                               Params.ItemsString['fone'].AsString,
                               Params.ItemsString['foto'].AsString,
                               StatusCode)
    }
    else
    begin
        StatusCode := 403;
        Result := '{"retorno":"Verbo HTTP não é válido. Utilize o GET", "id_usuario": 0, "nome": ""}';
    end;
end;

procedure Tdm.DWEventsPedidoEventspedidoReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
    // GET.......
    if RequestType = TRequestType.rtGet then
        Result := ListaPedidos(Params.ItemsString['status'].AsString,
                               Params.ItemsString['id_usuario'].AsString,
                               StatusCode)
    {
    else
    // POST.......
    if RequestType = TRequestType.rtPost then
        Result := CriarUsuario(Params.ItemsString['email'].AsString,
                               Params.ItemsString['senha'].AsString,
                               Params.ItemsString['nome'].AsString,
                               Params.ItemsString['fone'].AsString,
                               Params.ItemsString['foto'].AsString,
                               StatusCode)
    }
    else
    begin
        StatusCode := 403;
        Result := '{"retorno":"Verbo HTTP não é válido. Utilize o GET", "id_usuario": 0, "nome": ""}';
    end;
end;

end.
