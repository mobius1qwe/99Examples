unit cUsuario;

interface

uses Firedac.Comp.Client, System.SysUtils, Firedac.DApt, FMX.Graphics;

type
    TUsuario = class
    private
        FConn : TFDConnection;
        FCod_Usuario: Integer;
        FSenha: String;
        FEmail: String;
        FFoto: TBitmap;
    public
        constructor Create(conn: TFDConnection);
        property Cod_Usuario : Integer read FCod_Usuario write FCod_Usuario;
        property Email : String read FEmail write FEmail;
        property Senha : String read FSenha write FSenha;
        property Foto : TBitmap read FFoto write FFoto;
        function ValidaLogin(out erro : string) : Boolean;
        function CriarConta(out erro: string): Boolean;
end;

implementation

{ TUsuario }

constructor TUsuario.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TUsuario.ValidaLogin(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT * FROM TAB_USUARIO');
            SQL.Add('WHERE EMAIL=:EMAIL AND SENHA=:SENHA');
            ParamByName('EMAIL').Value := Email;
            ParamByName('SENHA').Value := Senha;
            Active := true;

            if RecordCount > 0 then
            begin
                Cod_Usuario := FieldByName('COD_USUARIO').AsInteger;
                erro := '';
                Result := true;
            end
            else
            begin
                Cod_Usuario := 0;
                erro := 'Email ou senha inválida';
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

function TUsuario.CriarConta(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('INSERT INTO TAB_USUARIO(EMAIL, SENHA, FOTO) VALUES(:EMAIL, :SENHA, :FOTO)');
            ParamByName('EMAIL').Value := Email;
            ParamByName('SENHA').Value := Senha;
            ParamByName('FOTO').Assign(Foto);
            ExecSQL;

            Active := false;
            SQL.Clear;
            SQL.Add('SELECT MAX(COD_USUARIO) AS COD_USUARIO FROM TAB_USUARIO');
            SQL.Add('WHERE EMAIL=:EMAIL');
            ParamByName('EMAIL').Value := Email;
            Active := true;

            Cod_Usuario := FieldByName('COD_USUARIO').AsInteger;
            erro := '';
            Result := true;

            DisposeOf;
        end;

    except on ex:exception do
    begin
        erro := 'Erro ao criar conta: ' + ex.Message;
        Result := false;
    end;
    end;
end;

end.
