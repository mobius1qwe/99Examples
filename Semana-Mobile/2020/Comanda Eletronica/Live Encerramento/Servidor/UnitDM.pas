unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, uDWJSONObject, uDWAbout, uRESTDWServerEvents,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, System.JSON, FireDAC.VCLUI.Wait;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TDWServerEvents;
    QryLogin: TFDQuery;
    procedure DWEventsEventsValidarLoginReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsListarComandaReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsListarProdutoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsListarCategoriaReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsAdicionarProdutoComandaReplyEvent(
      var Params: TDWParams; var Result: string);
    procedure DWEventsEventsListarProdutoComandaReplyEvent(
      var Params: TDWParams; var Result: string);
    procedure DWEventsEventsExcluirProdutoComandaReplyEvent(
      var Params: TDWParams; var Result: string);
    procedure DWEventsEventsEncerrarComandaReplyEvent(var Params: TDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

uses
  uDWConsts;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

// Parametro(s): usuario
procedure Tdm.DWEventsEventsListarComandaReplyEvent(var Params: TDWParams;
  var Result: string);
var
    qry : TFDQuery;
    json : uDWJSONObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJSONObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.SQL.Add('SELECT  C.ID_COMANDA, C.STATUS, coalesce(SUM(O.VALOR_TOTAl), 0) AS VALOR_TOTAL ');
        qry.SQL.Add('FROM    TAB_COMANDA C ');
        qry.SQL.Add('LEFT JOIN TAB_COMANDA_CONSUMO O ON (C.ID_COMANDA = O.ID_COMANDA) ');
        qry.SQL.Add('GROUP BY C.ID_COMANDA, C.STATUS ');
        qry.SQL.Add('ORDER BY C.ID_COMANDA');
        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON);

        Result := json.ToJSON;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// Parametro(s): nenhum
procedure Tdm.DWEventsEventsValidarLoginReplyEvent(var Params: TDWParams;
  var Result: string);
var
    json : TJsonObject;
begin
    try
        json := TJsonObject.Create;

        if Params.ItemsString['usuario'].AsString = '' then
        begin
            // {"retorno": "OK"}
            json.AddPair('retorno', 'Usuário não informado');
            Result := json.ToString;
            exit;
        end;

        try
            with dm do
            begin
                QryLogin.Active := false;
                QryLogin.SQL.Clear;
                QryLogin.SQL.Add('SELECT * FROM TAB_USUARIO WHERE COD_USUARIO=:USUARIO');
                QryLogin.ParamByName('USUARIO').Value := Params.ItemsString['usuario'].AsString;
                QryLogin.Active := true;

                if QryLogin.RecordCount > 0 then
                    json.AddPair('retorno', 'OK')
                else
                    json.AddPair('retorno', 'Usuário inválido');

                Result := json.ToString;
            end;
        except
            json.AddPair('retorno', 'Erro ao validar login');
            Result := json.ToString;
        end;

    finally
        json.DisposeOf;
    end;

end;

// Parametro(s): id_categoria, termo_busca, pagina
procedure Tdm.DWEventsEventsListarProdutoReplyEvent(var Params: TDWParams;
  var Result: string);
var
    qry : TFDQuery;
    json : uDWJSONObject.TJSONValue;
    pg_inicio, pg_fim: integer;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJSONObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.SQL.Add('SELECT  * ');
        qry.SQL.Add('FROM    TAB_PRODUTO P ');
        qry.SQL.Add('WHERE  P.ID_PRODUTO > 0');

        if Params.ItemsString['id_categoria'].AsString <> '0' then
        begin
            qry.SQL.Add('AND P.ID_CATEGORIA = :ID_CATEGORIA');
            qry.ParamByName('ID_CATEGORIA').Value := Params.ItemsString['id_categoria'].AsInteger;
        end;

        if Params.ItemsString['termo_busca'].AsString <> '' then
        begin
            qry.SQL.Add('AND P.DESCRICAO LIKE :TERMO_BUSCA');
            qry.ParamByName('TERMO_BUSCA').Value := '%' + Params.ItemsString['termo_busca'].AsString + '%';
        end;

        qry.SQL.Add('ORDER BY P.DESCRICAO');

        if Params.ItemsString['pagina'].AsString <> '0' then
        begin
            //inicio= (pagina - 1) * 10 + 1
            //fim= pagina * 10

            pg_inicio := (Params.ItemsString['pagina'].AsInteger - 1) * 10 + 1;
            pg_fim := Params.ItemsString['pagina'].AsInteger * 10;
            qry.SQL.Add('ROWS ' + pg_inicio.ToString + ' TO ' + pg_fim.ToString);
        end;


        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON);

        Result := json.ToJSON;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// Parametro(s): nenhum
procedure Tdm.DWEventsEventsListarCategoriaReplyEvent(var Params: TDWParams;
  var Result: string);
var
    qry : TFDQuery;
    json : uDWJSONObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJSONObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.SQL.Add('SELECT  C.* ');
        qry.SQL.Add('FROM    TAB_PRODUTO_CATEGORIA C ');
        qry.SQL.Add('ORDER BY C.DESCRICAO');

        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON);

        Result := json.ToJSON;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// Parametro(s): id_comanda, id_produto, qtd, vl_total
procedure Tdm.DWEventsEventsAdicionarProdutoComandaReplyEvent(
  var Params: TDWParams; var Result: string);
var
    json : TJsonObject;
    qry : TFDQuery;
begin
    try
        json := TJsonObject.Create;
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        // Validar parametros...
        if (Params.ItemsString['id_comanda'].AsString = '') or
           (Params.ItemsString['id_produto'].AsString = '') or
           (Params.ItemsString['qtd'].AsString = '') or
           (Params.ItemsString['vl_total'].AsString = '') then
        begin
            json.AddPair('retorno', 'Parametros não informados');
            Result := json.ToString;
            exit;
        end;

        try
            // Marca a comanda como aberta...
            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('UPDATE TAB_COMANDA SET STATUS = ''A'', ');
            qry.SQL.Add('DT_ABERTURA = COALESCE(DT_ABERTURA, current_timestamp) ');
            qry.SQL.Add('WHERE ID_COMANDA = :ID_COMANDA');
            qry.ParamByName('ID_COMANDA').Value := Params.ItemsString['id_comanda'].AsString;
            qry.ExecSQL;


            // Insere o item no consumo...
            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('INSERT INTO TAB_COMANDA_CONSUMO(ID_COMANDA, ID_PRODUTO, QTD, VALOR_TOTAL)');
            qry.SQL.Add('VALUES(:ID_COMANDA, :ID_PRODUTO, :QTD, :VALOR_TOTAL)');
            qry.ParamByName('ID_COMANDA').Value := Params.ItemsString['id_comanda'].AsString;
            qry.ParamByName('ID_PRODUTO').Value := Params.ItemsString['id_produto'].AsInteger;
            qry.ParamByName('QTD').Value := Params.ItemsString['qtd'].AsInteger;
            qry.ParamByName('VALOR_TOTAL').Value := Params.ItemsString['vl_total'].AsFloat / 100;
            qry.ExecSQL;

            json.AddPair('retorno', 'OK');

        except on ex:exception do
            json.AddPair('retorno', ex.Message);
        end;

        Result := json.ToString;

    finally
        qry.DisposeOf;
        json.DisposeOf;
    end;

end;

// Parametro(s): id_comanda
procedure Tdm.DWEventsEventsListarProdutoComandaReplyEvent(
  var Params: TDWParams; var Result: string);
var
    qry : TFDQuery;
    json : uDWJSONObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJSONObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.SQL.Add('SELECT C.ID_CONSUMO, P.ID_PRODUTO, P.DESCRICAO, C.QTD, C.VALOR_TOTAL ');
        qry.SQL.Add('FROM   TAB_COMANDA_CONSUMO C ');
        qry.SQL.Add('JOIN   TAB_PRODUTO P ON (P.ID_PRODUTO = C.ID_PRODUTO)');
        qry.SQL.Add('WHERE  C.ID_COMANDA = :ID_COMANDA');
        qry.SQL.Add('ORDER BY P.DESCRICAO');
        qry.ParamByName('ID_COMANDA').Value := Params.ItemsString['id_comanda'].AsString;
        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON);

        Result := json.ToJSON;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// Parametro(s): id_comanda, id_consumo
procedure Tdm.DWEventsEventsExcluirProdutoComandaReplyEvent(
  var Params: TDWParams; var Result: string);
var
    json : TJsonObject;
    qry : TFDQuery;
begin
    try
        json := TJsonObject.Create;
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        // Validar parametros...
        if (Params.ItemsString['id_comanda'].AsString = '') or
           (Params.ItemsString['id_consumo'].AsString = '') then
        begin
            json.AddPair('retorno', 'Parametros não informados');
            Result := json.ToString;
            exit;
        end;

        try
            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('DELETE FROM TAB_COMANDA_CONSUMO ');
            qry.SQL.Add('WHERE ID_CONSUMO=:ID_CONSUMO AND ID_COMANDA=:ID_COMANDA');
            qry.ParamByName('ID_COMANDA').Value := Params.ItemsString['id_comanda'].AsString;
            qry.ParamByName('ID_CONSUMO').Value := Params.ItemsString['id_consumo'].AsInteger;
            qry.ExecSQL;

            json.AddPair('retorno', 'OK');

        except on ex:exception do
            json.AddPair('retorno', ex.Message);
        end;

        Result := json.ToString;

    finally
        qry.DisposeOf;
        json.DisposeOf;
    end;

end;

// Parametro(s): id_comanda
procedure Tdm.DWEventsEventsEncerrarComandaReplyEvent(var Params: TDWParams;
  var Result: string);
var
    json : TJsonObject;
    qry : TFDQuery;
begin
    try
        json := TJsonObject.Create;
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        // Validar parametros...
        if (Params.ItemsString['id_comanda'].AsString = '') then
        begin
            json.AddPair('retorno', 'Parametro id_comanda não informado');
            Result := json.ToString;
            exit;
        end;

        try
            // Aqui voce cadastraria os dados dessa comanda na tabela de vendas
            // do ERP do restaurante...

            //      :)

            //-----------------------------------------------------------------


            // Fecha a comanda...
            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('UPDATE TAB_COMANDA SET STATUS = ''F'', DT_ABERTURA = NULL ');
            qry.SQL.Add('WHERE ID_COMANDA=:ID_COMANDA');
            qry.ParamByName('ID_COMANDA').Value := Params.ItemsString['id_comanda'].AsString;
            qry.ExecSQL;

            // Limpa o consumo...
            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('DELETE FROM TAB_COMANDA_CONSUMO');
            qry.SQL.Add('WHERE ID_COMANDA=:ID_COMANDA');
            qry.ParamByName('ID_COMANDA').Value := Params.ItemsString['id_comanda'].AsString;
            qry.ExecSQL;

            json.AddPair('retorno', 'OK');

        except on ex:exception do
            json.AddPair('retorno', ex.Message);
        end;

        Result := json.ToString;

    finally
        qry.DisposeOf;
        json.DisposeOf;
    end;

end;

end.
