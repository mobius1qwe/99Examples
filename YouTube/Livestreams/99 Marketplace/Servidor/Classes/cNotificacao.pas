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
        FID_USUARIO_DE: integer;
        FID_NOTIFICACAO: integer;
        FID_USUARIO_PARA: integer;

    public
        constructor Create(conn : TFDConnection);
        property ID_NOTIFICACAO : integer read FID_NOTIFICACAO write FID_NOTIFICACAO;
        property ID_USUARIO_DE : integer read FID_USUARIO_DE write FID_USUARIO_DE;
        property ID_USUARIO_PARA : integer read FID_USUARIO_PARA write FID_USUARIO_PARA;
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
    if (ID_USUARIO_PARA <= 0)  then
        ID_USUARIO_PARA := 0;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT N.*, U.FOTO, U.NOME AS NOME_ORIGEM FROM TAB_NOTIFICACAO N');
            SQL.Add('JOIN TAB_USUARIO U ON (U.ID_USUARIO = N.ID_USUARIO_DE)');
            SQL.Add('WHERE N.ID_USUARIO_PARA = :ID_USUARIO_PARA');

            if order_by = '' then
                SQL.Add('ORDER BY N.ID_NOTIFICACAO DESC')
            else
                SQL.Add('ORDER BY ' + order_by);

            ParamByName('ID_USUARIO_PARA').Value := ID_USUARIO_PARA;
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
    if (ID_USUARIO_PARA <= 0)  then
    begin
        Result := false;
        erro := 'Usuário destino não informado';
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
            SQL.Add('INSERT INTO TAB_NOTIFICACAO(ID_USUARIO_PARA, ID_USUARIO_DE, DT_GERACAO, TEXTO, ');
            SQL.Add('IND_LIDO, EXTRA1, EXTRA2)');
            SQL.Add('VALUES(:ID_USUARIO_PARA, :ID_USUARIO_DE, current_timestamp, :TEXTO, ');
            SQL.Add(':IND_LIDO, :EXTRA1, :EXTRA2)');

            ParamByName('ID_USUARIO_DE').Value := ID_USUARIO_DE;
            ParamByName('ID_USUARIO_PARA').Value := ID_USUARIO_PARA;
            ParamByName('TEXTO').Value := TEXTO;
            ParamByName('IND_LIDO').Value := IND_LIDO;
            ParamByName('EXTRA1').Value := EXTRA1;
            ParamByName('EXTRA2').Value := EXTRA2;
            ExecSQL;


            // Busca o ID gerado...
            Active := false;
            sql.Clear;
            SQL.Add('SELECT MAX(ID_NOTIFICACAO) AS ID_NOTIFICACAO FROM TAB_NOTIFICACAO');
            SQL.Add('WHERE ID_USUARIO_PARA=:ID_USUARIO_PARA');
            ParamByName('ID_USUARIO_PARA').Value := ID_USUARIO_PARA;
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

    if (ID_USUARIO_PARA <= 0)  then
    begin
        Result := false;
        erro := 'Id. usuário não informado';
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
            SQL.Add('AND ID_USUARIO_PARA=:ID_USUARIO_PARA');
            ParamByName('ID_NOTIFICACAO').Value := ID_NOTIFICACAO;
            ParamByName('ID_USUARIO_PARA').Value := ID_USUARIO_PARA;
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
