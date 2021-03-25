unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, uDWAbout, uRESTDWServerEvents,
  uDWConsts, uDWJSONObject, FireDAC.DApt, FMX.Graphics, System.JSON,
  uFunctions;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    ServerEvents: TDWServerEvents;
    procedure ServerEventsEventscatalogosReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
  private
    function ListarCatalogo(id_usuario: integer; out status: integer): string;
    function CriarCatalogo(id_usuario: integer; nome, foto64: string;
      out status: integer): string;
    function EditarCatalogo(id_catalogo, id_usuario: integer; nome,
      foto64: string; out status: integer): string;
    function ExcluirCatalogo(id_catalogo, id_usuario: integer;
      out status: integer): string;
    { Private declarations }
  public
    { Public declarations }
    function CarregarConfig: string;
  end;

var
  dm: Tdm;

implementation

uses
  System.IniFiles;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

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
        dm.conn.Params.Clear;
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

function TDm.ListarCatalogo(id_usuario: integer;
                            out status : integer) : string;
var
    json : uDWJSONObject.TJSONValue;
    erro : string;
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;
        qry.SQL.Add('SELECT * FROM TAB_CATALOGO WHERE ID_USUARIO=:ID_USUARIO');
        qry.ParamByName('ID_USUARIO').Value := id_usuario;
        qry.Active := true;

        json := uDWJSONObject.TJSONValue.Create;
        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
        status := 200;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

function TDm.CriarCatalogo(id_usuario: integer;
                           nome, foto64: string;
                           out status : integer) : string;
var
    json : TJsonObject;
    qry : TFDQuery;
    foto_bmp : TBitmap;
begin
    try
        json := TJsonObject.Create;

        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        // Validacoes...
        if (nome = '') then
        begin
            json.AddPair('retorno', 'Informe todos os parâmetros');
            status := 400;
            Result := json.ToString;
            exit;
        end;

        // Foto bitmap...
        try
            foto_bmp := TFunctions.BitmapFromBase64(foto64)
        except on ex:exception do
            begin
                json.AddPair('retorno', 'Erro ao criar foto: ' + ex.Message);
                status := 400;
                Result := json.ToString;
                exit;
            end;
        end;

        try
            qry.SQL.Add('INSERT INTO TAB_CATALOGO(ID_USUARIO, NOME, FOTO, QTD_PRODUTO, DT_GERACAO)');
            qry.SQL.Add('VALUES(:ID_USUARIO, :NOME, :FOTO, 0, current_timestamp)');
            qry.ParamByName('ID_USUARIO').Value := id_usuario;
            qry.ParamByName('NOME').Value := nome;
            qry.ParamByName('FOTO').Assign(foto_bmp);
            qry.ExecSQL;

            qry.SQL.Clear;
            qry.SQL.Add('SELECT MAX(ID_CATALOGO) AS ID_CATALOGO FROM TAB_CATALOGO');
            qry.SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
            qry.ParamByName('ID_USUARIO').Value := id_usuario;
            qry.Active := true;

            json.AddPair('retorno', 'OK');
            json.AddPair('id_catalogo', qry.FieldByName('ID_CATALOGO').AsString);
            Status := 201;
            foto_bmp.DisposeOf;

            Result := json.ToString;

        except on ex:exception do
            begin
                json.AddPair('retorno', ex.Message);
                Status := 500;
            end;
        end;



    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

function TDm.EditarCatalogo(id_catalogo, id_usuario : integer;
                           nome, foto64: string;
                           out status: integer): string;
var
    json : TJSONObject;
    qry : TFDQuery;
    foto_bmp : TBitmap;
begin
    try
        json := TJSONObject.Create;

        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;


        // Validações dos parametros...
        if (nome = '') then
        begin
            json.AddPair('retorno', 'Informe todos os parâmetros');
            Status := 400;
            Result := json.ToString;
            exit;
        end;

        // Criar foto bitmap...
        try
            foto_bmp := TFunctions.BitmapFromBase64(foto64);
        except on ex:exception do
            begin
                json.AddPair('retorno', 'Erro ao criar foto no servidor: ' + ex.Message);
                Status := 400;
                Result := json.ToString;
                exit;
            end;
        end;


        try
            qry.SQL.Add('UPDATE TAB_CATALOGO SET NOME=:NOME, FOTO=:FOTO');
            qry.SQL.Add('WHERE ID_CATALOGO=:ID_CATALOGO AND ID_USUARIO=:ID_USUARIO');
            qry.ParamByName('ID_CATALOGO').Value := id_catalogo;
            qry.ParamByName('ID_USUARIO').Value := id_usuario;
            qry.ParamByName('NOME').Value := nome;
            qry.ParamByName('FOTO').Assign(foto_bmp);
            qry.ExecSQL;

            json.AddPair('retorno', 'OK');
            json.AddPair('id_catalogo', id_catalogo.ToString);
            Status := 200;

        except on ex:exception do
            begin
                json.AddPair('retorno', ex.Message);
                Status := 500;
            end;
        end;


        Result := json.ToString;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

function TDm.ExcluirCatalogo(id_catalogo, id_usuario : integer;
                             out status: integer): string;
var
    json : TJSONObject;
    qry : TFDQuery;
begin
    try
        json := TJSONObject.Create;

        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;


        // Validações dos parametros...
        if (id_catalogo <= 0) then
        begin
            json.AddPair('retorno', 'Informe todos os parâmetros');
            Status := 400;
            Result := json.ToString;
            exit;
        end;


        try
            dm.conn.StartTransaction;

            qry.SQL.Add('DELETE FROM TAB_CATALOGO_PRODUTO');
            qry.SQL.Add('WHERE ID_CATALOGO=:ID_CATALOGO');
            qry.ParamByName('ID_CATALOGO').Value := id_catalogo;
            qry.ExecSQL;

            qry.SQL.Clear;
            qry.SQL.Add('DELETE FROM TAB_CATALOGO');
            qry.SQL.Add('WHERE ID_CATALOGO=:ID_CATALOGO AND ID_USUARIO=:ID_USUARIO');
            qry.ParamByName('ID_CATALOGO').Value := id_catalogo;
            qry.ParamByName('ID_USUARIO').Value := id_usuario;
            qry.ExecSQL;

            json.AddPair('retorno', 'OK');
            json.AddPair('id_catalogo', id_catalogo.ToString);
            Status := 200;

            dm.conn.Commit;

        except on ex:exception do
            begin
                dm.conn.Rollback;
                json.AddPair('retorno', ex.Message);
                Status := 500;
            end;
        end;

        Result := json.ToString;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

procedure Tdm.ServerEventsEventscatalogosReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
begin
    if RequestType = TRequestType.rtGet then
        Result := ListarCatalogo(Params.ItemsString['id_usuario'].AsInteger, StatusCode)
    else
    if RequestType = TRequestType.rtPost then
        Result := CriarCatalogo(Params.ItemsString['id_usuario'].AsInteger,
                                Params.ItemsString['nome'].AsString,
                                Params.ItemsString['foto'].AsString,
                                StatusCode)
    else
    if RequestType = TRequestType.rtPatch then
        Result := EditarCatalogo(Params.ItemsString['id_catalogo'].AsInteger,
                                 Params.ItemsString['id_usuario'].AsInteger,
                                 Params.ItemsString['nome'].AsString,
                                 Params.ItemsString['foto'].AsString,
                                 StatusCode)
    else
    if RequestType = TRequestType.rtDelete then
        Result := ExcluirCatalogo(Params.ItemsString['id_catalogo'].AsInteger,
                                  Params.ItemsString['id_usuario'].AsInteger,
                                  StatusCode);
end;

end.
