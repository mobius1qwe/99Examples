unit cChat;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics;

type
    TChat = class
    private
        FConn : TFDConnection;
        FID_USUARIO_PARA: integer;
        FID_ORCAMENTO: integer;
        FID_USUARIO_DE: integer;
        FDT_GERACAO: TDateTime;
        FID_CHAT: integer;
        FTEXTO: string;

    public
        constructor Create(conn : TFDConnection);
        property ID_CHAT : integer read FID_CHAT write FID_CHAT;
        property ID_USUARIO_DE : integer read FID_USUARIO_DE write FID_USUARIO_DE;
        property ID_USUARIO_PARA : integer read FID_USUARIO_PARA write FID_USUARIO_PARA;
        property ID_ORCAMENTO : integer read FID_ORCAMENTO write FID_ORCAMENTO;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;
        property TEXTO : string read FTEXTO write FTEXTO;

        function Inserir(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ListarChat(order_by: string; out erro: string): TFDQuery;
end;

implementation

uses
  System.SysUtils;


constructor TChat.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TChat.ListarChat(order_by: string; out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    if (ID_ORCAMENTO <= 0)  then
    begin
        Result := nil;
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
            SQL.Add('SELECT * FROM TAB_CHAT');
            SQL.Add('WHERE ID_ORCAMENTO = :ID_ORCAMENTO');

            if order_by = '' then
                SQL.Add('ORDER BY ID_CHAT')
            else
                SQL.Add('ORDER BY ' + order_by);

            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            Active := true;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar mensagens: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

function TChat.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_USUARIO_DE <= 0)  then
    begin
        Result := false;
        erro := 'Usuário origem não informado';
        exit;
    end;

    if (ID_USUARIO_PARA <= 0)  then
    begin
        Result := false;
        erro := 'Usuário destino não informado';
        exit;
    end;

    if (ID_ORCAMENTO <= 0)  then
    begin
        Result := false;
        erro := 'Orçamento não informado';
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
            SQL.Add('INSERT INTO TAB_CHAT(ID_USUARIO_DE, ID_USUARIO_PARA,');
            SQL.Add('ID_ORCAMENTO, DT_GERACAO, TEXTO)');
            SQL.Add('VALUES(:ID_USUARIO_DE, :ID_USUARIO_PARA, :ID_ORCAMENTO, current_timestamp, :TEXTO)');

            ParamByName('ID_USUARIO_DE').Value := ID_USUARIO_DE;
            ParamByName('ID_USUARIO_PARA').Value := ID_USUARIO_PARA;
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            ParamByName('TEXTO').Value := TEXTO;
            ExecSQL;


            // Busca o ID gerado...
            Active := false;
            sql.Clear;
            SQL.Add('SELECT MAX(ID_CHAT) AS ID_CHAT FROM TAB_CHAT');
            SQL.Add('WHERE ID_ORCAMENTO=:ID_ORCAMENTO');
            ParamByName('ID_ORCAMENTO').Value := ID_ORCAMENTO;
            Active := true;

            ID_CHAT := FieldByName('ID_CHAT').AsInteger;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao inserir mensagem: ' + ex.Message;
        end;
    end;
end;

function TChat.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (ID_CHAT <= 0)  then
    begin
        Result := false;
        erro := 'Id da mensagem não informado';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM TAB_CHAT WHERE ID_CHAT=:ID_CHAT');
            ParamByName('ID_CHAT').Value := ID_CHAT;
            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao excluir mensagem: ' + ex.Message;
        end;
    end;
end;

end.
