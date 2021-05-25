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
        FAVALIACAO_PARA_PRESTADOR: Double;
        FAVALIACAO_PARA_CLIENTE: Double;
        FQTD_ORCAMENTO: integer;
        FID_USUARIO_PRESTADOR: integer;
        FOBS_ORCADO: String;
        FVALOR_ORCADO: Double;
    public
        constructor Create(conn : TFDConnection);
        property ID_PEDIDO : integer read FID_PEDIDO write FID_PEDIDO;
        property ID_USUARIO : integer read FID_USUARIO write FID_USUARIO;
        property ID_USUARIO_PRESTADOR : integer read FID_USUARIO_PRESTADOR write FID_USUARIO_PRESTADOR;
        property STATUS : string read FSTATUS write FSTATUS;
        property CATEGORIA : string read FCATEGORIA write FCATEGORIA;
        property GRUPO : string read FGRUPO write FGRUPO;
        property ENDERECO : string read FENDERECO write FENDERECO;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;
        property DT_SERVICO : TDateTime read FDT_SERVICO write FDT_SERVICO;
        property DETALHE : string read FDETALHE write FDETALHE;
        property QTD_MAX_ORC : integer read FQTD_MAX_ORC write FQTD_MAX_ORC;
        property QTD_ORCAMENTO : integer read FQTD_ORCAMENTO write FQTD_ORCAMENTO;
        property VALOR_TOTAL : Double read FVALOR_TOTAL write FVALOR_TOTAL;
        property AVALIACAO_PARA_PRESTADOR : Double read FAVALIACAO_PARA_PRESTADOR write FAVALIACAO_PARA_PRESTADOR;
        property AVALIACAO_PARA_CLIENTE : Double read FAVALIACAO_PARA_CLIENTE write FAVALIACAO_PARA_CLIENTE;

        property VALOR_ORCADO : Double read FVALOR_ORCADO write FVALOR_ORCADO;
        property OBS_ORCADO : String read FOBS_ORCADO write FOBS_ORCADO;

        function DadosPedido(out erro: string): Boolean;
        function DadosPedidoPrestador(out erro: string): Boolean;
        function Inserir(out erro: string): Boolean;
        function Editar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ListarPedidoCliente(order_by: string; out erro: string): TFDQuery;
        function ListarPedidoPrestador(order_by: string; out erro: string): TFDQuery;
        function Aprovar(out erro: string): Boolean;
        function Avaliar(tipo_avaliacao: string; avaliacao: double; out erro: string): Boolean;
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
                QTD_ORCAMENTO := FieldByName('QTD_ORCAMENTO').AsInteger;

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

function TPedido.DadosPedidoPrestador(out erro: string): Boolean;
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
            SQL.Add('SELECT P.*, O.VALOR_TOTAL AS VALOR_ORCADO, O.OBS AS OBS_ORCADO');
            SQL.Add('FROM TAB_PEDIDO P');
            SQL.Add('LEFT JOIN TAB_PEDIDO_ORCAMENTO O ON (O.ID_PEDIDO = P.ID_PEDIDO');
            SQL.Add('                                AND O.ID_USUARIO = :ID_USUARIO_PRESTADOR)');
            SQL.Add('WHERE P.ID_PEDIDO=:ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ParamByName('ID_USUARIO_PRESTADOR').Value := ID_USUARIO_PRESTADOR;
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
                QTD_ORCAMENTO := FieldByName('QTD_ORCAMENTO').AsInteger;

                VALOR_ORCADO := FieldByName('VALOR_ORCADO').AsFloat;
                OBS_ORCADO := FieldByName('OBS_ORCADO').AsString;

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
            erro := 'Erro ao buscar dados do pedido: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TPedido.ListarPedidoCliente(order_by: string; out erro: string): TFDQuery;
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
            SQL.Add('P.QTD_ORCAMENTO, UU.NOME AS CLIENTE,');
            SQL.Add(''''' AS IND_ORCADO ');
            SQL.Add('FROM TAB_PEDIDO P');
            SQL.Add('LEFT JOIN TAB_USUARIO U ON (U.ID_USUARIO = P.ID_USUARIO_PRESTADOR)');
            SQL.Add('LEFT JOIN TAB_USUARIO UU ON (UU.ID_USUARIO = P.ID_USUARIO)');
            SQL.Add('WHERE P.ID_PEDIDO > 0');

            if ID_USUARIO > 0 then
            begin
                SQL.Add('AND P.ID_USUARIO = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
            end;

            if STATUS <> '' then
            begin
                SQL.Add('AND P.STATUS = :STATUS');
                ParamByName('STATUS').Value := STATUS;
            end;

            if CATEGORIA <> '' then
            begin
                SQL.Add('AND P.CATEGORIA = :CATEGORIA');
                ParamByName('CATEGORIA').Value := CATEGORIA;
            end;

            if GRUPO <> '' then
            begin
                SQL.Add('AND P.GRUPO = :GRUPO');
                ParamByName('GRUPO').Value := GRUPO;
            end;

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

function TPedido.ListarPedidoPrestador(order_by: string; out erro: string): TFDQuery;
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
            SQL.Add('P.QTD_ORCAMENTO, UU.NOME AS CLIENTE,');
            SQL.Add('PEDIDO_ORCAMENTO(P.ID_PEDIDO, :ID_USUARIO_LOGADO) AS IND_ORCADO, ');
            SQL.Add('BUSCA_ORCAMENTO(P.ID_PEDIDO, :ID_USUARIO_LOGADO) AS ID_ORCAMENTO ');
            SQL.Add('FROM TAB_PEDIDO P');
            SQL.Add('LEFT JOIN TAB_USUARIO U ON (U.ID_USUARIO = P.ID_USUARIO_PRESTADOR)');
            SQL.Add('LEFT JOIN TAB_USUARIO UU ON (UU.ID_USUARIO = P.ID_USUARIO)');
            SQL.Add('WHERE P.ID_PEDIDO > 0');

            ParamByName('ID_USUARIO_LOGADO').Value := ID_USUARIO_PRESTADOR;

            {
            if ID_USUARIO_PRESTADOR > 0 then
            begin
                SQL.Add('LEFT JOIN TAB_PEDIDO_ORCAMENTO O ON (O.ID_PEDIDO = P.ID_PEDIDO)');
                SQL.Add('WHERE O.ID_USUARIO = :ID_USUARIO_PRESTADOR');
                ParamByName('ID_USUARIO_PRESTADOR').Value := ID_USUARIO_PRESTADOR;
            end
            else
            }

            if ID_USUARIO > 0 then
            begin
                SQL.Add('AND P.ID_USUARIO_PRESTADOR = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
            end;

            if STATUS <> '' then
            begin
                SQL.Add('AND P.STATUS = :STATUS');
                ParamByName('STATUS').Value := STATUS;
            end;

            if CATEGORIA <> '' then
            begin
                SQL.Add('AND P.CATEGORIA = :CATEGORIA');
                ParamByName('CATEGORIA').Value := CATEGORIA;
            end;

            if GRUPO <> '' then
            begin
                SQL.Add('AND P.GRUPO = :GRUPO');
                ParamByName('GRUPO').Value := GRUPO;
            end;

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
            SQL.Add('GRUPO, ENDERECO, DT_GERACAO, DT_SERVICO, DETALHE, QTD_MAX_ORC, VALOR_TOTAL, QTD_ORCAMENTO)');
            SQL.Add('VALUES(:ID_USUARIO, :STATUS, :CATEGORIA,');
            SQL.Add(':GRUPO, :ENDERECO, current_timestamp, :DT_SERVICO, :DETALHE, :QTD_MAX_ORC, :VALOR_TOTAL, 0)');

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
            ParamByName('DT_SERVICO').Value := FormatDateTime('yyyy-mm-dd hh:nn:ss', DT_SERVICO);
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
            SQL.Add('DELETE FROM TAB_PEDIDO WHERE ID_PEDIDO=:ID_PEDIDO AND ID_USUARIO=:ID_USUARIO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
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

function TPedido.Aprovar(out erro: string): Boolean;
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
            // Atualiza o pedido...
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO SET STATUS = ''R'' WHERE ID_PEDIDO=:ID_PEDIDO AND ID_USUARIO=:ID_USUARIO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao atualizar pedido: ' + ex.Message;
        end;
    end;
end;


// tipo_avaliacao: C=Enviada pelo cliente | P=Enviada pelo prestador
function TPedido.Avaliar(tipo_avaliacao: string;
                         avaliacao: double;
                         out erro: string): Boolean;
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
            // Atualiza o pedido...
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO ');

            if tipo_avaliacao = 'C' then
                SQL.Add('SET AVALIACAO_PARA_PRESTADOR = :AVALIACAO ')
            else
                SQL.Add('SET AVALIACAO_PARA_CLIENTE = :AVALIACAO ');

            SQL.Add('WHERE ID_PEDIDO=:ID_PEDIDO AND ID_USUARIO=:ID_USUARIO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            ParamByName('AVALIACAO').Value := avaliacao;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao avaliar pedido: ' + ex.Message;
        end;
    end;
end;

end.
