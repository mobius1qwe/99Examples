unit cUsuario;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics;

type
    TUsuario = class
    private
        FConn : TFDConnection;
        FID_USUARIO: integer;
        FFONE: string;
        FEMAIL: string;
        FDT_GERACAO: TDateTime;
        FFOTO: TBitmap;
        FSENHA: string;
        FNOME: string;
    public
        constructor Create(conn : TFDConnection);
        property ID_USUARIO : integer read FID_USUARIO write FID_USUARIO;
        property EMAIL : string read FEMAIL write FEMAIL;
        property SENHA : string read FSENHA write FSENHA;
        property NOME : string read FNOME write FNOME;
        property FONE : string read FFONE write FFONE;
        property FOTO : TBitmap read FFOTO write FFOTO;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;

        function DadosUsuario(out erro: string): Boolean;
        function Inserir(out erro: string): Boolean;
end;

implementation

uses
  System.SysUtils;

{ TUsuario }

constructor TUsuario.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TUsuario.DadosUsuario(out erro: string): Boolean;
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
            SQL.Add('SELECT * FROM TAB_USUARIO');
            SQL.Add('WHERE EMAIL=:EMAIL AND SENHA=:SENHA');
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('SENHA').Value := SENHA;
            Active := true;

            if RecordCount > 0 then
            begin
                ID_USUARIO := FieldByName('ID_USUARIO').AsInteger;
                EMAIL := FieldByName('EMAIL').AsString;
                SENHA := FieldByName('SENHA').AsString;
                NOME := FieldByName('NOME').AsString;
                FONE := FieldByName('FONE').AsString;
                //FOTO
                DT_GERACAO := FieldByName('DT_GERACAO').AsDateTime;

                erro := '';
                Result := true;
            end
            else
            begin
                erro := 'E-mail ou senha inválida';
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

function TUsuario.Inserir(out erro: string): Boolean;
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
            SQL.Add('INSERT INTO TAB_USUARIO(EMAIL, SENHA, NOME, FONE, FOTO, DT_GERACAO)');
            SQL.Add('VALUES(:EMAIL, :SENHA, :NOME, :FONE, :FOTO, current_timestamp)');
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('SENHA').Value := SENHA;
            ParamByName('NOME').Value := NOME;
            ParamByName('FONE').Value := FONE;

            if FOTO <> nil then
                ParamByName('FOTO').Assign(FOTO)
            else
                ParamByName('FOTO').Clear;

            ExecSQL;


            // Busca o ID gerado...
            Active := false;
            sql.Clear;
            SQL.Add('SELECT MAX(ID_USUARIO) AS ID_USUARIO FROM TAB_USUARIO');
            SQL.Add('WHERE EMAIL=:EMAIL');
            ParamByName('EMAIL').Value := EMAIL;
            Active := true;

            ID_USUARIO := FieldByName('ID_USUARIO').AsInteger;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao inserir usuário: ' + ex.Message;
        end;
    end;
end;

end.
