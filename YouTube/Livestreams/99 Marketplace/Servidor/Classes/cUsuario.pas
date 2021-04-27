unit cUsuario;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics, uFunctions;

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
        FENDERECO: string;
        FAVALIACAO_PRESTADOR: Double;
        FAVALIACAO_CLIENTE: Double;
        FFOTO64: string;
        FQTD_AVALIACAO_PRESTADOR: Integer;
        FQTD_AVALIACAO_CLIENTE: Integer;
        FCATEGORIA: string;
        FGRUPO: string;
    public
        constructor Create(conn : TFDConnection);
        property ID_USUARIO : integer read FID_USUARIO write FID_USUARIO;
        property EMAIL : string read FEMAIL write FEMAIL;
        property SENHA : string read FSENHA write FSENHA;
        property NOME : string read FNOME write FNOME;
        property FONE : string read FFONE write FFONE;
        property ENDERECO : string read FENDERECO write FENDERECO;
        property AVALIACAO_CLIENTE : Double read FAVALIACAO_CLIENTE write FAVALIACAO_CLIENTE;
        property AVALIACAO_PRESTADOR : Double read FAVALIACAO_PRESTADOR write FAVALIACAO_PRESTADOR;
        property QTD_AVALIACAO_CLIENTE : Integer read FQTD_AVALIACAO_CLIENTE write FQTD_AVALIACAO_CLIENTE;
        property QTD_AVALIACAO_PRESTADOR : Integer read FQTD_AVALIACAO_PRESTADOR write FQTD_AVALIACAO_PRESTADOR;
        property FOTO : TBitmap read FFOTO write FFOTO;
        property FOTO64 : string read FFOTO64 write FFOTO64;
        property DT_GERACAO : TDateTime read FDT_GERACAO write FDT_GERACAO;
        property CATEGORIA : string read FCATEGORIA write FCATEGORIA;
        property GRUPO : string read FGRUPO write FGRUPO;

        function DadosUsuario(out erro: string): Boolean;
        function ValidarLogin(out erro: string): Boolean;
        function Inserir(out erro: string): Boolean;
        function Editar(campo, valor: string; out erro: string): Boolean;
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
    if (ID_USUARIO = 0) and (EMAIL = '')  then
    begin
        Result := false;
        erro := 'Informe o id. do usuário ou o email';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('SELECT * FROM TAB_USUARIO');

            if ID_USUARIO > 0 then
            begin
                SQL.Add('WHERE ID_USUARIO=:ID_USUARIO');
                ParamByName('ID_USUARIO').Value := ID_USUARIO;
            end
            else
            if EMAIL <> '' then
            begin
                SQL.Add('WHERE EMAIL=:EMAIL');
                ParamByName('EMAIL').Value := EMAIL;
            end;

            Active := true;

            if RecordCount > 0 then
            begin
                ID_USUARIO := FieldByName('ID_USUARIO').AsInteger;
                EMAIL := FieldByName('EMAIL').AsString;
                SENHA := FieldByName('SENHA').AsString;
                NOME := FieldByName('NOME').AsString;
                FONE := FieldByName('FONE').AsString;
                ENDERECO := FieldByName('ENDERECO').AsString;
                AVALIACAO_CLIENTE := FieldByName('AVALIACAO_CLIENTE').AsFloat;
                AVALIACAO_PRESTADOR := FieldByName('AVALIACAO_PRESTADOR').AsFloat;
                CATEGORIA := FieldByName('CATEGORIA').AsString;
                GRUPO := FieldByName('GRUPO').AsString;

                //FOTO
                DT_GERACAO := FieldByName('DT_GERACAO').AsDateTime;

                erro := '';
                Result := true;
            end
            else
            begin
                erro := 'Usuário não encontrado';
                Result := false;
            end;

            DisposeOf;
        end;
    except on ex:exception do
        begin
            erro := 'Erro ao buscar dados do usuário: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TUsuario.Editar(campo, valor: string; out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    if (campo = '')  then
    begin
        Result := false;
        erro := 'Informe o campo';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TAB_USUARIO SET ' + campo + ' = :VALOR');
            SQL.Add('WHERE ID_USUARIO=:ID_USUARIO');

            if campo = 'foto' then
                ParamByName('VALOR').Assign(FOTO)
            else
                ParamByName('VALOR').Value := valor;

            ParamByName('ID_USUARIO').Value := ID_USUARIO;

            {
            if FOTO <> nil then
                ParamByName('FOTO').Assign(FOTO)
            else
                ParamByName('FOTO').Clear;
            }

            ExecSQL;

            DisposeOf;
        end;

        Result := true;
        erro := '';

    except on ex:exception do
        begin
            Result := false;
            erro := 'Erro ao alterar usuário: ' + ex.Message;
        end;
    end;
end;

function TUsuario.ValidarLogin(out erro: string): Boolean;
var
    qry : TFDQuery;
    foto_bmp : TBitmap;
begin
    if (EMAIL = '')  then
    begin
        Result := false;
        erro := 'Informe o email do usuário';
        exit;
    end;

    if (SENHA = '')  then
    begin
        Result := false;
        erro := 'Informe a senha do usuário';
        exit;
    end;

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
                ENDERECO := FieldByName('ENDERECO').AsString;
                AVALIACAO_CLIENTE := FieldByName('AVALIACAO_CLIENTE').AsFloat;
                AVALIACAO_PRESTADOR := FieldByName('AVALIACAO_PRESTADOR').AsFloat;
                DT_GERACAO := FieldByName('DT_GERACAO').AsDateTime;
                QTD_AVALIACAO_CLIENTE := FieldByName('QTD_AVALIACAO_CLIENTE').AsInteger;
                QTD_AVALIACAO_PRESTADOR := FieldByName('QTD_AVALIACAO_PRESTADOR').AsInteger;
                CATEGORIA := FieldByName('CATEGORIA').AsString;
                GRUPO := FieldByName('GRUPO').AsString;

                // Foto do usuario...
                foto_bmp := TBitmap.Create;
                TFunctions.LoadBitmapFromBlob(foto_bmp, TBlobField(FieldByName('FOTO')));
                FOTO64 := TFunctions.Base64FromBitmap(foto_bmp);
                foto_bmp.DisposeOf;
                //-------------------

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
    if (EMAIL = '')  then
    begin
        Result := false;
        erro := 'Informe o email do usuário';
        exit;
    end;

    if (SENHA = '')  then
    begin
        Result := false;
        erro := 'Informe a senha do usuário';
        exit;
    end;

    if (NOME = '')  then
    begin
        Result := false;
        erro := 'Informe o nome do usuário';
        exit;
    end;

    if (FONE = '')  then
    begin
        Result := false;
        erro := 'Informe o telefone do usuário';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := FConn;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO TAB_USUARIO(EMAIL, SENHA, NOME, FONE, FOTO,');
            SQL.Add('DT_GERACAO, ENDERECO, AVALIACAO_CLIENTE, AVALIACAO_PRESTADOR,');
            SQL.Add('QTD_AVALIACAO_CLIENTE, QTD_AVALIACAO_PRESTADOR, CATEGORIA, GRUPO)');
            SQL.Add('VALUES(:EMAIL, :SENHA, :NOME, :FONE, :FOTO, ');
            SQL.Add('current_timestamp, :ENDERECO, :AVALIACAO_CLIENTE, :AVALIACAO_PRESTADOR, 0, 0,');
            SQL.Add(':CATEGORIA, :GRUPO)');
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('SENHA').Value := SENHA;
            ParamByName('NOME').Value := NOME;
            ParamByName('FONE').Value := FONE;
            ParamByName('ENDERECO').Value := ENDERECO;
            ParamByName('AVALIACAO_CLIENTE').Value := AVALIACAO_CLIENTE;
            ParamByName('AVALIACAO_PRESTADOR').Value := AVALIACAO_PRESTADOR;
            ParamByName('CATEGORIA').Value := CATEGORIA;
            ParamByName('GRUPO').Value := GRUPO;

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
