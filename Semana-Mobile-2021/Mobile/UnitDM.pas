unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON;

type
  Tdm = class(TDataModule)
    RESTClient: TRESTClient;
    ReqLogin: TRESTRequest;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    ReqCategoria: TRESTRequest;
    ReqEmpresa: TRESTRequest;
    ReqServico: TRESTRequest;
    ReqHorario: TRESTRequest;
    ReqAgendar: TRESTRequest;
    ReqReserva: TRESTRequest;
    ReqExcluir: TRESTRequest;
  private
    { Private declarations }
  public
    function ValidaLogin(email, senha: string; out id_usuario: integer; out erro: string): boolean;
    function ListarCategoria(cidade: string; out jsonArray: TJsonArray;
      out erro: string): boolean;
    function ListarEmpresa(cidade, busca, ind_foto, id_empresa: string;
                           id_categoria : integer;
                           out jsonArray: TJsonArray; out erro: string): boolean;
    function ListarServico(id_empresa: integer; out jsonArray: TJsonArray;
      out erro: string): boolean;
    function ListarHorario(id_servico: integer; dt: TDate;
      out jsonArray: TJsonArray; out erro: string): boolean;
    function Agendar(id_usuario, id_servico: integer; dt: TDate; hora: string;
      out id_reserva: integer; out erro: string): boolean;
    function ListarReserva(id_usuario: integer; out jsonArray: TJsonArray;
      out erro: string): boolean;
    function ExcluirReserva(id_reserva: integer; out erro: string): boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDm.ValidaLogin(email, senha: string; out id_usuario: integer; out erro: string): boolean;
var
    json : string;
    jsonObj : TJsonObject;
begin
    erro := '';

    with ReqLogin do
    begin
        Params.Clear;
        AddParameter('email', email, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('senha', senha, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if ReqLogin.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao validar login: ' + ReqLogin.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqLogin.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        if jsonObj.GetValue('retorno').Value = 'OK' then
        begin
            id_usuario := jsonObj.GetValue('id_usuario').Value.ToInteger;
            Result := true;
        end
        else
        begin
            Result := false;
            erro := jsonObj.GetValue('retorno').Value;
        end;

        jsonObj.DisposeOf;
    end;
end;

function TDm.ListarCategoria(cidade: string; out jsonArray: TJsonArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with ReqCategoria do
        begin
            Params.Clear;
            AddParameter('cidade', cidade, TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar categorias: ' + ex.Message;
            exit;
        end;
    end;

    if ReqCategoria.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar categorias: ' + ReqCategoria.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqCategoria.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function TDm.ListarEmpresa(cidade, busca, ind_foto, id_empresa: string;
                           id_categoria : integer;
                           out jsonArray: TJsonArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with ReqEmpresa do
        begin
            Params.Clear;
            AddParameter('cidade', cidade, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('id_categoria', id_categoria.ToString, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('id_empresa', id_empresa, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('busca', busca, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('ind_foto', ind_foto, TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar empresas: ' + ex.Message;
            exit;
        end;
    end;

    if ReqEmpresa.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar empresas: ' + ReqEmpresa.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqEmpresa.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function TDm.ListarServico(id_empresa: integer; out jsonArray: TJsonArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with ReqServico do
        begin
            Params.Clear;
            AddParameter('id_empresa', id_empresa.ToString, TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar serviços: ' + ex.Message;
            exit;
        end;
    end;

    if ReqServico.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar serviços: ' + ReqServico.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqServico.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function TDm.ListarHorario(id_servico: integer; dt: TDate;
                           out jsonArray: TJsonArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with ReqHorario do
        begin
            Params.Clear;
            AddParameter('id_servico', id_servico.ToString, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('dt', FormatDateTime('yyyy-mm-dd', dt), TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar horários: ' + ex.Message;
            exit;
        end;
    end;

    if ReqHorario.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar horários: ' + ReqHorario.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqHorario.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;


function TDm.Agendar(id_usuario, id_servico: integer;
                      dt: TDate;
                      hora: string;
                      out id_reserva: integer; out erro: string): boolean;
var
    json : string;
    jsonObj : TJsonObject;
begin
    erro := '';

    with ReqAgendar do
    begin
        Params.Clear;
        AddParameter('id_usuario', id_usuario.ToString, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('id_servico', id_servico.ToString, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('dt', FormatDateTime('yyyy-mm-dd', dt), TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('hora', hora, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if ReqAgendar.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao agendar: ' + ReqAgendar.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqAgendar.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        if jsonObj.GetValue('retorno').Value = 'OK' then
        begin
            id_reserva := jsonObj.GetValue('id_reserva').Value.ToInteger;
            Result := true;
        end
        else
        begin
            Result := false;
            erro := jsonObj.GetValue('retorno').Value;
        end;

        jsonObj.DisposeOf;
    end;
end;


function TDm.ListarReserva(id_usuario: integer; out jsonArray: TJsonArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with ReqReserva do
        begin
            Params.Clear;
            AddParameter('id_usuario', id_usuario.ToString, TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar agendamentos: ' + ex.Message;
            exit;
        end;
    end;

    if ReqReserva.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar agendamentos: ' + ReqReserva.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqReserva.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function TDm.ExcluirReserva(id_reserva: integer;
                            out erro: string): boolean;
var
    json : string;
    jsonObj : TJsonObject;
begin
    erro := '';

    with ReqExcluir do
    begin
        Params.Clear;
        AddParameter('id_reserva', id_reserva.ToString, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if ReqExcluir.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao excluir: ' + ReqExcluir.Response.StatusCode.ToString;
    end
    else
    begin
        json := ReqExcluir.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        if jsonObj.GetValue('retorno').Value = 'OK' then
            Result := true
        else
        begin
            Result := false;
            erro := jsonObj.GetValue('retorno').Value;
        end;

        jsonObj.DisposeOf;
    end;
end;

end.
