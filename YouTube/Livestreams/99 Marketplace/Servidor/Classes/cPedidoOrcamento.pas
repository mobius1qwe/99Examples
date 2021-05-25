unit cPedidoOrcamento;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics;

type
    TPedidoOrcamento = class
    private
        FConn : TFDConnection;
        FOBS: string;
        FVALOR_TOTAL: Double;
        FID_ORCAMENTO: integer;
        FID_PEDIDO: integer;
        FDT_GERACAO: TDateTime;
        FSTATUS: string;
        FID_USUARIO: integer;
        FID_USUARIO_PRESTADOR: integer;
    public
        constructor Create(conn : TFDConnection);
        property ID_ORCAMENTO : integer read FID_ORCAMENTO write FID_ORCAMENTO;
        property ID_PEDIDO : integer read FID_PEDIDO write FID_PEDIDO;
        property ID_USUARIO : integer read FID_USUARIO write FID_USUARIO;
        property STATUS : string read FSTATUS write FSTATUS;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;
        property VALOR_TOTAL : Double read FVALOR_TOTAL write FVALOR_TOTAL;
        property ID_USUARIO_PRESTADOR : integer read FID_USUARIO_PRESTADOR write FID_USUARIO_PRESTADOR;
        property OBS : string read FOBS write FOBS;

        function DadosOrcamento(out erro: string): Boolean;
        function Inserir(out erro: string): Boolean;
        function Editar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ListarOrcamento(order_by: string; out erro: string): TFDQuery;
        function AprovarOrcamento(out erro: string): Boolean;
end;

implementation

uses
  System.SysUtils;

constructor TPedidoOrcamento.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TPedidoOrcamento.DadosOrcamento(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_ORCAMENTO = 0) then
    begin
        Result := false;
        erro := 'Informe o id. do orçamento';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT * FROM TAB_PEDIDO_ORCAMENTO');
            SQL.Add('WHERE ID_ORCAMENTO=:ID_ORCAMENTO');
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;

            Active := true;

            if RecordCount > 0 then
            begin
                ID_ORCAMENTO := FieldByName('ID_ORCAMENTO').AsInteger;
                ID_PEDIDO := FieldByName('ID_PEDIDO').AsInteger;
                ID_USUARIO := FieldByName('ID_USUARIO').AsInteger;
                STATUS := FieldByName('STATUS').AsString;
                DT_GERACAO := FieldByName('DT_GERACAO').AsDateTime;
                VALOR_TOTAL := FieldByName('VALOR_TOTAL').AsFloat;
                OBS := FieldByName('OBS').AsString;

                erro := '';
                Result := true;
            end
            else
            begin
                erro := 'Orçamento não encontrado';
                Result := false;
            end;

            DisposeOf;
        end;
    except on ex:exception do
        begin
            erro := 'Erro ao buscar orçamento: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TPedidoOrcamento.ListarOrcamento(order_by: string; out erro: string): TFDQuery;
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
            SQL.Add('SELECT O.*, U.FOTO, U.NOME');
            SQL.Add('FROM TAB_PEDIDO_ORCAMENTO O');
            SQL.Add('JOIN TAB_USUARIO U ON (U.ID_USUARIO = O.ID_USUARIO)');
            SQL.Add('WHERE O.ID_PEDIDO = :ID_PEDIDO');

            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;

            if order_by = '' then
                SQL.Add('ORDER BY O.ID_ORCAMENTO DESC')
            else
                SQL.Add('ORDER BY ' + order_by);

            Active := true;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar orçamentos: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

function TPedidoOrcamento.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_PEDIDO <= 0)  then
    begin
        Result := false;
        erro := 'Pedido não informado';
        exit;
    end;

    if (ID_USUARIO <= 0)  then
    begin
        Result := false;
        erro := 'Usuário do orçamento não informado';
        exit;
    end;

    if (STATUS = '')  then
    begin
        Result := false;
        erro := 'Status do orçamento não informado';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            FConn.StartTransaction;

            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO TAB_PEDIDO_ORCAMENTO(ID_PEDIDO, ID_USUARIO, STATUS, DT_GERACAO, VALOR_TOTAL, OBS)');
            SQL.Add('VALUES(:ID_PEDIDO, :ID_USUARIO, :STATUS, current_timestamp, :VALOR_TOTAL, :OBS)');

            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            ParamByName('STATUS').Value := 'P';
            ParamByName('VALOR_TOTAL').Value := VALOR_TOTAL;
            ParamByName('OBS').Value := OBS;
            ExecSQL;


            Active := false;
            SQL.Clear;
            SQL.Add('UPDATE TAB_PEDIDO ');
            SQL.Add('SET QTD_ORCAMENTO = QTD_ORCAMENTO(ID_PEDIDO)');
            SQL.Add('WHERE ID_PEDIDO = :ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ExecSQL;

            FConn.Commit;


            // Busca o ID gerado...
            Active := false;
            sql.Clear;
            SQL.Add('SELECT MAX(ID_ORCAMENTO) AS ID_ORCAMENTO FROM TAB_PEDIDO_ORCAMENTO');
            SQL.Add('WHERE ID_USUARIO=:ID_USUARIO');
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            Active := true;

            ID_ORCAMENTO := FieldByName('ID_ORCAMENTO').AsInteger;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            FConn.Rollback;
            Result := false;
            erro := 'Erro ao inserir orçamento: ' + ex.Message;
        end;
    end;

end;

function TPedidoOrcamento.Editar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_ORCAMENTO <= 0)  then
    begin
        Result := false;
        erro := 'Orçamento não informado';
        exit;
    end;


    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO_ORCAMENTO SET VALOR_TOTAL=:VALOR_TOTAL, OBS=:OBS');
            SQL.Add('WHERE ID_ORCAMENTO=:ID_ORCAMENTO');

            ParamByName('VALOR_TOTAL').Value := VALOR_TOTAL;
            ParamByName('OBS').Value := OBS;
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao editar orçamento: ' + ex.Message;
        end;
    end;
end;

function TPedidoOrcamento.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_ORCAMENTO <= 0)  then
    begin
        Result := false;
        erro := 'Número do orçamento não informado';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM TAB_PEDIDO_ORCAMENTO WHERE ID_ORCAMENTO=:ID_ORCAMENTO');
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao excluir orçamento: ' + ex.Message;
        end;
    end;
end;

function TPedidoOrcamento.AprovarOrcamento(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_ORCAMENTO <= 0)  then
    begin
        Result := false;
        erro := 'Número do orçamento não informado';
        exit;
    end;

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
            // Reprovar todos os orcamentos...
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO_ORCAMENTO SET STATUS = ''R'' ');
            SQL.Add('WHERE ID_PEDIDO = :ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ExecSQL;

            // Aprovar orcamento especifico...
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO_ORCAMENTO SET STATUS = ''A'' ');
            SQL.Add('WHERE ID_ORCAMENTO = :ID_ORCAMENTO');
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            ExecSQL;

            // Atualiza informacoes do orcamento vencedor...
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_PEDIDO SET STATUS=''A'', ID_USUARIO_PRESTADOR=:ID_USUARIO_PRESTADOR,');
            SQL.Add('VALOR_TOTAL=(SELECT VALOR_TOTAL FROM TAB_PEDIDO_ORCAMENTO WHERE ID_ORCAMENTO=:ID_ORCAMENTO)');
            SQL.Add('WHERE ID_PEDIDO = :ID_PEDIDO');
            ParamByName('ID_PEDIDO').Value := ID_PEDIDO;
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            ParamByName('ID_USUARIO_PRESTADOR').Value := ID_USUARIO_PRESTADOR;
            ExecSQL;


            // Notificar prestadores sobre seus orcamentos...


            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao aprovar orçamento: ' + ex.Message;
        end;
    end;
end;


end.
