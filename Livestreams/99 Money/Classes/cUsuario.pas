unit cUsuario;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, System.SysUtils, FMX.Graphics;

type
    TUsuario = class
    private
        Fconn: TFDConnection;
        FIND_LOGIN: string;
        FEMAIL: string;
        FSENHA: string;
        FNOME: string;
        FID_USUARIO: Integer;
        FFOTO: TBitmap;
    public
        constructor Create(conn: TFDConnection);
        property ID_USUARIO: Integer read FID_USUARIO write FID_USUARIO;
        property NOME: string read FNOME write FNOME;
        property EMAIL: string read FEMAIL write FEMAIL;
        property SENHA: string read FSENHA write FSENHA;
        property IND_LOGIN: string read FIND_LOGIN write FIND_LOGIN;
        property FOTO: TBitmap read FFOTO write FFOTO;

        function ListarUsuario(out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Alterar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function ValidarLogin(out erro: string): boolean;
        function Logout(out erro: string): boolean;
end;

implementation

{ TCategoria }

constructor TUsuario.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;

function TUsuario.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if NOME = '' then
    begin
        erro := 'Informe o nome do usuário';
        Result := false;
        exit;
    end;

    if EMAIL = '' then
    begin
        erro := 'Informe o email do usuário';
        Result := false;
        exit;
    end;

    if SENHA = '' then
    begin
        erro := 'Informe a senha do usuário';
        Result := false;
        exit;
    end;


    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('INSERT INTO TAB_USUARIO(NOME, EMAIL, SENHA, IND_LOGIN, FOTO)');
                SQL.Add('VALUES(:NOME, :EMAIL, :SENHA, :IND_LOGIN, :FOTO)');
                ParamByName('NOME').Value := NOME;
                ParamByName('EMAIL').Value := EMAIL;
                ParamByName('SENHA').Value := SENHA;
                ParamByName('IND_LOGIN').Value := IND_LOGIN;
                ParamByName('FOTO').Assign(FOTO);
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao inserir usuário: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TUsuario.Alterar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if NOME = '' then
    begin
        erro := 'Informe o nome do usuário';
        Result := false;
        exit;
    end;

    if EMAIL = '' then
    begin
        erro := 'Informe o email do usuário';
        Result := false;
        exit;
    end;

    if SENHA = '' then
    begin
        erro := 'Informe a senha do usuário';
        Result := false;
        exit;
    end;


    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('UPDATE TAB_USUARIO SET NOME=:NOME, EMAIL=:EMAIL,');
                SQL.Add('SENHA=:SENHA, IND_LOGIN=:IND_LOGIN, FOTO=:FOTO');
                SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
                ParamByName('NOME').Value := NOME;
                ParamByName('EMAIL').Value := EMAIL;
                ParamByName('SENHA').Value := SENHA;
                ParamByName('IND_LOGIN').Value := IND_LOGIN;
                ParamByName('FOTO').Assign(FOTO);
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao alterar usuário: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TUsuario.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin

    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                Active := false;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_USUARIO');

                if ID_USUARIO > 0 then
                begin
                    SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
                    ParamByName('ID_USUARIO').Value := ID_USUARIO;
                end;

                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao excluir usuário: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TUsuario.ListarUsuario(out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            sql.Add('SELECT * FROM TAB_USUARIO');
            SQL.Add('WHERE 1 = 1');

            if ID_USUARIO > 0 then
            begin
                SQL.Add('AND ID_USUARIO = :ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
            end;

            if EMAIL <> '' then
            begin
                SQL.Add('AND EMAIL = :EMAIL');
                ParamByName('EMAIL').Value := EMAIL;
            end;

            if SENHA <> '' then
            begin
                SQL.Add('AND SENHA = :SENHA');
                ParamByName('SENHA').Value := SENHA;
            end;

            Active := true;
        end;

        Result := qry;
        erro := '';

    except on ex:exception do
    begin
        Result := nil;
        erro := 'Erro ao consultar usuários: ' + ex.Message;
    end;
    end;
end;

function TUsuario.ValidarLogin(out erro: string): boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if EMAIL = '' then
    begin
        erro := 'Informe o email do usuário';
        Result := false;
        exit;
    end;

    if SENHA = '' then
    begin
        erro := 'Informe a senha do usuário';
        Result := false;
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        try
            with qry do
            begin
                Active := false;
                sql.Clear;
                sql.Add('SELECT * FROM TAB_USUARIO');
                SQL.Add('WHERE EMAIL = :EMAIL');
                SQL.Add('AND SENHA = :SENHA');
                ParamByName('EMAIL').Value := EMAIL;
                ParamByName('SENHA').Value := SENHA;
                Active := true;


                if RecordCount = 0 then
                begin
                    Result := false;
                    erro := 'Email ou senha inválida';
                    exit;
                end;

                Active := false;
                sql.Clear;
                sql.Add('UPDATE TAB_USUARIO');
                SQL.Add('SET IND_LOGIN = ''S''');
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao validar login: ' + ex.Message;
        end;
        end;
    finally
        qry.DisposeOf;
    end;
end;

function TUsuario.Logout(out erro: string): boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Fconn;

        try
            with qry do
            begin
                Active := false;
                sql.Clear;
                sql.Add('UPDATE TAB_USUARIO');
                SQL.Add('SET IND_LOGIN = ''N''');
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao fazer logout: ' + ex.Message;
        end;
        end;
    finally
        qry.DisposeOf;
    end;
end;

end.
