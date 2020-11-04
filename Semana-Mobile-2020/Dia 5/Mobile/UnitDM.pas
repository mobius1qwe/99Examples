unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON, System.NetEncoding;

type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    qry_config: TFDQuery;
    RESTClient: TRESTClient;
    RequestLogin: TRESTRequest;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    RequestListarComanda: TRESTRequest;
    RequestListarProduto: TRESTRequest;
    RequestListarCategoria: TRESTRequest;
    RequestAdicionarProdutoComanda: TRESTRequest;
    RequestListarProdutoComanda: TRESTRequest;
    RequestExcluirProdutoComanda: TRESTRequest;
    RequestEncerrarComanda: TRESTRequest;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ValidaLogin(usuario: string; out erro: string): boolean;
    function ListarComanda(out jsonArray: TJSONArray; out erro: string): boolean;
    function ListarProduto(id_categoria: integer; termo_busca: string; pagina: integer;
                           out jsonArray: TJSONArray; out erro: string): boolean;
    function ListarCategoria(out jsonArray: TJSONArray;
      out erro: string): boolean;
    function AdicionarProdutoComanda(id_comanda: string; id_produto,
      qtd: integer; vl_total: double; out erro: string): boolean;
    function ListarProdutoComanda(id_comanda: string;
      out jsonArray: TJSONArray; out erro: string): boolean;
    function ExcluirProdutoCOmanda(id_comanda: string; id_consumo: integer;
      out erro: string): boolean;
    function EncerrarComanda(id_comanda: string; out erro: string): boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function Tdm.ValidaLogin(usuario: string; out erro: string): boolean;
var
    json : string;
    jsonObj: TJsonObject;
begin
    erro := '';

    with RequestLogin do
    begin
        Params.Clear;
        AddParameter('usuario', usuario, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if RequestLogin.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao validar login: ' + dm.RequestLogin.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestLogin.Response.JSONValue.ToString;
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

function Tdm.ListarComanda(out jsonArray: TJSONArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with RequestListarComanda do
        begin
            Params.Clear;
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar comandas: ' + ex.Message;
            exit;
        end;
    end;

    if RequestListarComanda.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar comandas: ' + dm.RequestLogin.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestListarComanda.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function Tdm.ListarProduto(id_categoria: integer; termo_busca: string; pagina: integer;
                           out jsonArray: TJSONArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with RequestListarProduto do
        begin
            Params.Clear;
            AddParameter('id_categoria', id_categoria.ToString, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('termo_busca', termo_busca, TRESTRequestParameterKind.pkGETorPOST);
            AddParameter('pagina', pagina.ToString, TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar produto: ' + ex.Message;
            exit;
        end;
    end;

    if RequestListarProduto.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar produto: ' + RequestListarProduto.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestListarProduto.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function Tdm.ListarCategoria(out jsonArray: TJSONArray; out erro: string): boolean;
var
    json : string;
begin
    erro := '';

    try
        with RequestListarCategoria do
        begin
            Params.Clear;
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar categorias: ' + ex.Message;
            exit;
        end;
    end;

    if RequestListarCategoria.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar categorias: ' + RequestListarCategoria.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestListarCategoria.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function Tdm.AdicionarProdutoComanda(id_comanda: string; id_produto, qtd: integer; vl_total: double;
                                     out erro: string): boolean;
var
    json : string;
    jsonObj: TJsonObject;
begin
    erro := '';

    with RequestAdicionarProdutoComanda do
    begin
        Params.Clear;
        AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('id_produto', id_produto.ToString, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('qtd', qtd.ToString, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('vl_total', FormatFloat('0.00', vl_total).Replace(',', '').Replace('.', ''),
                                        TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if RequestAdicionarProdutoComanda.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao adicionar item: ' + RequestAdicionarProdutoComanda.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestAdicionarProdutoComanda.Response.JSONValue.ToString;
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

function Tdm.ListarProdutoComanda(id_comanda: string;
                                  out jsonArray: TJSONArray; out erro: string): boolean;
var
    json : string;
    jsonObj: TJsonObject;
begin
    erro := '';

    try
        with RequestListarProdutoComanda do
        begin
            Params.Clear;
            AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
            Execute;
        end;
    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao listar produtos: ' + ex.Message;
            exit;
        end;
    end;

    if RequestListarProdutoComanda.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao listar produtos: ' + RequestListarProdutoComanda.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestListarProdutoComanda.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;
        Result := true;
    end;
end;

function Tdm.ExcluirProdutoCOmanda(id_comanda: string; id_consumo: integer; out erro: string): boolean;
var
    json : string;
    jsonObj: TJsonObject;
begin
    erro := '';

    with RequestExcluirProdutoComanda do
    begin
        Params.Clear;
        AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('id_consumo', id_consumo.ToString, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if RequestExcluirProdutoComanda.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao excluir item: ' + RequestExcluirProdutoComanda.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestExcluirProdutoComanda.Response.JSONValue.ToString;
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

function Tdm.EncerrarComanda(id_comanda: string; out erro: string): boolean;
var
    json : string;
    jsonObj: TJsonObject;
begin
    erro := '';

    with RequestEncerrarComanda do
    begin
        Params.Clear;
        AddParameter('id_comanda', id_comanda, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
    end;

    if RequestEncerrarComanda.Response.StatusCode <> 200 then
    begin
        Result := false;
        erro := 'Erro ao encerrar comanda: ' + RequestEncerrarComanda.Response.StatusCode.ToString;
    end
    else
    begin
        json := RequestEncerrarComanda.Response.JSONValue.ToString;
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

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
    with conn do
    begin
        Params.Values['DriverID'] := 'SQLite';

        {$IFDEF MSWINDOWS}
        Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\banco.db';
        {$ELSE}
        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
        {$ENDIF}

        try
            Connected := true;
        except on e:exception do
            raise Exception.Create('Erro de conexão com o banco de dados: ' + e.Message);
        end;
    end;
end;

end.
