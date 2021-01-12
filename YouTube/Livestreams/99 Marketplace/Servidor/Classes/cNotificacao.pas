unit cNotificacao;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics;

type
    TNotificacao = class
    private
        FConn : TFDConnection;
        FDT_GERACAO: TDateTime;
        FEXTRA2: string;
        FEXTRA1: string;
        FTEXTO: string;
        FIND_LIDO: string;
        FID_USUARIO: integer;
        FID_NOTIFICACAO: integer;

    public
        constructor Create(conn : TFDConnection);
        property ID_NOTIFICACAO : integer read FID_NOTIFICACAO write FID_NOTIFICACAO;
        property ID_USUARIO : integer read FID_USUARIO write FID_USUARIO;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;
        property TEXTO : string read FTEXTO write FTEXTO;
        property IND_LIDO : string read FIND_LIDO write FIND_LIDO;
        property EXTRA1 : string read FEXTRA1 write FEXTRA1;
        property EXTRA2 : string read FEXTRA2 write FEXTRA2;

        function Inserir(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ListarNotificacao(order_by: string; out erro: string): TFDQuery;
end;

implementation

uses
  System.SysUtils;


constructor TNotificacao.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TNotificacao.ListarNotificacao(order_by: string; out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    if (ID_USUARIO <= 0)  then
    begin
        Result := nil;
        erro := 'Usuário não informado';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT * FROM TAB_NOTIFICACAO');
            SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');

            if order_by = '' then
                SQL.Add('ORDER BY ID_NOTIFICACAO DESC')
            else
                SQL.Add('ORDER BY ' + order_by);

            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            Active := true;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar notificações: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

function TNotificacao.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_USUARIO <= 0)  then
    begin
        Result := false;
        erro := 'Usuário não informado';
        exit;
    end;

    if (TEXTO = '')  then
    begin
        Result := false;
        erro := 'Texto não informado';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO TAB_NOTIFICACAO(ID_USUARIO, DT_GERACAO, TEXTO, ');
            SQL.Add('IND_LIDO, EXTRA1, EXTRA2)');
            SQL.Add('VALUES(:ID_USUARIO, current_timestamp, :TEXTO, ');
            SQL.Add(':IND_LIDO, :EXTRA1, :EXTRA2)');

            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            ParamByName('TEXTO').Value := TEXTO;
            ParamByName('IND_LIDO').Value := IND_LIDO;
            ParamByName('EXTRA1').Value := EXTRA1;
            ParamByName('EXTRA2').Value := EXTRA2;
            ExecSQL;


            // Busca o ID gerado...
            Active := false;
            sql.Clear;
            SQL.Add('SELECT MAX(ID_NOTIFICACAO) AS ID_NOTIFICACAO FROM TAB_NOTIFICACAO');
            SQL.Add('WHERE ID_USUARIO=:ID_USUARIO');
            ParamByName('ID_USUARIO').Value := ID_USUARIO;
            Active := true;

            ID_NOTIFICACAO := FieldByName('ID_NOTIFICACAO').AsInteger;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao inserir notificacao: ' + ex.Message;
        end;
    end;
end;

function TNotificacao.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_NOTIFICACAO <= 0)  then
    begin
        Result := false;
        erro := 'Notificação não informada';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM TAB_NOTIFICACAO WHERE ID_NOTIFICACAO=:ID_NOTIFICACAO');
            ParamByName('ID_NOTIFICACAO').Value := ID_NOTIFICACAO;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao excluir notificação: ' + ex.Message;
        end;
    end;
end;

end.
