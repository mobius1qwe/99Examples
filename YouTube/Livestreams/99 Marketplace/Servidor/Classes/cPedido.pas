unit cPedido;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics;

type
    TPedido = class
    private
        FConn : TFDConnection;
        FID_USUARIO: integer;
        FDT_SERVICO: TDateTime;
        FID_PEDIDO: integer;
        FDT_GERACAO: TDateTime;
        FQTD_MAX_ORC: integer;
        FCATEGORIA: string;
        FSTATUS: string;
        FDETALHE: string;
        FENDERECO: string;
        FGRUPO: string;
        FVALOR_TOTAL: Double;

    public
        constructor Create(conn : TFDConnection);
        property ID_PEDIDO : integer read FID_PEDIDO write FID_PEDIDO;
        property ID_USUARIO : integer read FID_USUARIO write FID_USUARIO;
        property STATUS : string read FSTATUS write FSTATUS;
        property CATEGORIA : string read FCATEGORIA write FCATEGORIA;
        property GRUPO : string read FGRUPO write FGRUPO;
        property ENDERECO : string read FENDERECO write FENDERECO;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;
        property DT_SERVICO : TDateTime read FDT_SERVICO write FDT_SERVICO;
        property DETALHE : string read FDETALHE write FDETALHE;
        property QTD_MAX_ORC : integer read FQTD_MAX_ORC write FQTD_MAX_ORC;
        property VALOR_TOTAL : Double read FVALOR_TOTAL write FVALOR_TOTAL;

        function DadosPedido(out erro: string): Boolean;
        function Inserir(out erro: string): Boolean;
        function Editar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ListarPedido(order_by: string; out erro: string): TFDQuery;
end;

implementation

uses
  System.SysUtils;

{ TUsuario }

constructor TPedido.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TPedido.DadosPedido(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_PEDIDO = 0) then
    begin
        Result := false;
        erro := 'Informe o id. do pedido';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT * FROM TAB_PEDIDO');
            SQL.Add('WHERE ID_PEDIDO=:ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;

            Active := true;

            if RecordCount > 0 then
            begin
                ID_PEDIDO := FieldByName('ID_PEDIDO').AsInteger;
                ID_USUARIO := FieldByName('ID_USUARIO').AsInteger;
                STATUS := FieldByName('STATUS').AsString;
                CATEGORIA := FieldByName('CATEGORIA').AsString;
                GRUPO := FieldByName('GRUPO').AsString;
                ENDERECO := FieldByName('ENDERECO').AsString;
                DT_GERACAO := FieldByName('DT_GERACAO').AsDateTime;
                DT_SERVICO := FieldByName('DT_SERVICO').AsDateTime;
                DETALHE := FieldByName('DETALHE').AsString;
                QTD_MAX_ORC := FieldByName('QTD_MAX_ORC').AsInteger;
                VALOR_TOTAL := FieldByName('VALOR_TOTAL').AsFloat;

                erro := '';
                Result := true;
            end
            else
            begin
                erro := 'Pedido não encontrado';
                Result := false;
            end;

            DisposeOf;
        end;
    except on ex:exception do
        begin
            erro := 'Erro ao validar login: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TPedido.ListarPedido(order_by: string; out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT P.ID_PEDIDO, P.ID_USUARIO, P.STATUS, P.CATEGORIA, P.GRUPO,');
            SQL.Add('P.ENDERECO, P.DT_GERACAO, P.DT_SERVICO, P.DETALHE, P.QTD_MAX_ORC,');
            SQL.Add('P.ID_USUARIO_PRESTADOR, P.VALOR_TOTAL, U.NOME, U.FONE,');
            SQL.Add('COUNT(O.ID_ORCAMENTO) AS QTD_ORCAMENTO');
            SQL.Add('FROM TAB_PEDIDO P');
            SQL.Add('LEFT JOIN TAB_PEDIDO_ORCAMENTO O ON (O.ID_PEDIDO = P.ID_PEDIDO)');
            SQL.Add('LEFT JOIN TAB_USUARIO U ON (U.ID_USUARIO = P.ID_USUARIO_PRESTADOR)');
            SQL.Add('WHERE P.ID_PEDIDO > 0');

            if STATUS <> '' then
            begin
                SQL.Add('AND P.STATUS = :STATUS');
                ParamByName('STATUS').Value := STATUS;
            end;

            if ID_USUARIO > 0 then
            begin
                SQL.Add('AND P.ID_USUARIO = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
            end;

            SQL.Add('GROUP BY P.ID_PEDIDO, P.ID_USUARIO, P.STATUS, P.CATEGORIA, P.GRUPO,');
            SQL.Add('P.ENDERECO, P.DT_GERACAO, P.DT_SERVICO, P.DETALHE, P.QTD_MAX_ORC,');
            SQL.Add('P.ID_USUARIO_PRESTADOR, P.VALOR_TOTAL, U.NOME, U.FONE');

            if order_by = '' then
                SQL.Add('ORDER BY P.ID_PEDIDO DESC')
            else
                SQL.Add('ORDER BY ' + order_by);

            Active := true;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar pedidos: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

function TPedido.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_USUARIO <= 0)  then
    begin
        Result := false;
        erro := 'Usuário do pedido não informado';
        exit;
    end;

    if (STATUS = '')  then
    begin
        Result := false;
        erro := 'Status do pedido não informado';
        exit;
    end;

    if (CATEGORIA = '')  then
    begin
        Result := false;
        erro := 'Categoria do pedido não informada';
        exit;
    end;

    if (GRUPO = '')  then
    begin
        Result := false;
        erro := 'Grupo do pedido não informado';
        exit;
    end;

    if (ENDERECO = '')  then
    begin
        Result := false;
        erro := 'Endereço do pedido não informado';
        exit;
    end;

    if (DETALHE = '')  then
    begin
        Result := false;
        erro := 'Detalhes do pedido não informado';
        exit;
    end;

    if (QTD_MAX_ORC <= 0)  then
        QTD_MAX_ORC := 3;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO TAB_PEDIDO(ID_USUARIO, STATUS, CATEGORIA,');
            SQL.Add('GRUPO, ENDERECO, DT_GERACAO, DT_SERVICO, DETALHE, QTD_MAX_ORC, VALOR_TOTAL)');
            SQL.Add('VALUES(:ID_USUARIO, :STATUS, :CATEGORIA,');
            SQL.Add(':GRUPO, :ENDERECO, current_timestamp, :DT_SERVICO, :DETALHE, :QTD_MAX_ORC, :VALOR_TOTAL)');

            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            ParamByName('STATUS').Value := STATUS;
            ParamByName('CATEGORIA').Value := CATEGORIA;
            ParamByName('GRUPO').Value := GRUPO;
            ParamByName('ENDERECO').Value := ENDERECO;
            ParamByName('DT_SERVICO').Value := DT_SERVICO;
            ParamByName('DETALHE').Value := DETALHE;
            ParamByName('QTD_MAX_ORC').Value := QTD_MAX_ORC;
            ParamByName('VALOR_TOTAL').Value := VALOR_TOTAL;
            ExecSQL;


            // Busca o ID gerado...
            Active := false;
            sql.Clear;
            SQL.Add('SELECT MAX(ID_PEDIDO) AS ID_PEDIDO FROM TAB_PEDIDO');
            SQL.Add('WHERE ID_USUARIO=:ID_USUARIO');
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            Active := true;

            ID_PEDIDO := FieldByName('ID_PEDIDO').AsInteger;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao inserir pedido: ' + ex.Message;
        end;
    end;
end;

function TPedido.Editar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_PEDIDO <= 0)  then
    begin
        Result := false;
        erro := 'Pedido não informado';
        exit;
    end;

    if (CATEGORIA = '')  then
    begin
        Result := false;
        erro := 'Categoria do pedido não informada';
        exit;
    end;

    if (GRUPO = '')  then
    begin
        Result := false;
        erro := 'Grupo do pedido não informado';
        exit;
    end;

    if (ENDERECO = '')  then
    begin
        Result := false;
        erro := 'Endereço do pedido não informado';
        exit;
    end;

    if (DETALHE = '')  then
    begin
        Result := false;
        erro := 'Detalhes do pedido não informado';
        exit;
    end;


    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO SET CATEGORIA=:CATEGORIA, GRUPO=:GRUPO,');
            SQL.Add('ENDERECO=:ENDERECO, DT_SERVICO=:DT_SERVICO, DETALHE=:DETALHE');
            SQL.Add('WHERE ID_PEDIDO=:ID_PEDIDO');

            ParamByName('CATEGORIA').Value := CATEGORIA;
            ParamByName('GRUPO').Value := GRUPO;
            ParamByName('ENDERECO').Value := ENDERECO;
            ParamByName('DT_SERVICO').Value := DT_SERVICO;
            ParamByName('DETALHE').Value := DETALHE;
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao editar pedido: ' + ex.Message;
        end;
    end;
end;

function TPedido.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_PEDIDO <= 0)  then
    begin
        Result := false;
        erro := 'Número do pedido não informado';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            // Apaga mensagens de chat do pedido...
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM TAB_CHAT WHERE ID_PEDIDO=:ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ExecSQL;


            // Apaga o pedido...
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM TAB_PEDIDO WHERE ID_PEDIDO=:ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao excluir pedido: ' + ex.Message;
        end;
    end;
end;

end.
