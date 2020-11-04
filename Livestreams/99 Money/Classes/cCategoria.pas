unit cCategoria;

interface

uses FireDAC.Comp.Client, FireDAC.DApt, System.SysUtils, FMX.Graphics;

type
    TCategoria = class
    private
        Fconn: TFDConnection;
        FID_CATEGORIA: Integer;
        FDESCRICAO: string;
        FICONE: TBitmap;
        FINDICE_ICONE: Integer;
    public
        constructor Create(conn: TFDConnection);
        property ID_CATEGORIA: Integer read FID_CATEGORIA write FID_CATEGORIA;
        property DESCRICAO: string read FDESCRICAO write FDESCRICAO;
        property ICONE: TBitmap read FICONE write FICONE;
        property INDICE_ICONE: Integer read FINDICE_ICONE write FINDICE_ICONE;

        function ListarCategoria(out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Alterar(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
end;

implementation

{ TCategoria }

constructor TCategoria.Create(conn: TFDConnection);
begin
    Fconn := conn;
end;

function TCategoria.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if DESCRICAO = '' then
    begin
        erro := 'Informe a descrição da categoria';
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
                SQL.Add('INSERT INTO TAB_CATEGORIA(DESCRICAO, ICONE, INDICE_ICONE)');
                SQL.Add('VALUES(:DESCRICAO, :ICONE, :INDICE_ICONE)');
                ParamByName('DESCRICAO').Value := DESCRICAO;
                ParamByName('ICONE').Assign(ICONE);
                ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao inserir categorias: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TCategoria.Alterar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_CATEGORIA <= 0 then
    begin
        erro := 'Informe o ID da categoria';
        Result := false;
        exit;
    end;

    if DESCRICAO = '' then
    begin
        erro := 'Informe a descrição da categoria';
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
                SQL.Add('UPDATE TAB_CATEGORIA SET DESCRICAO=:DESCRICAO, ICONE=:ICONE,');
                SQL.Add('INDICE_ICONE=:INDICE_ICONE');
                SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('DESCRICAO').Value := DESCRICAO;
                ParamByName('ICONE').Assign(ICONE);
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ParamByName('INDICE_ICONE').Value := INDICE_ICONE;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao alterar categorias: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TCategoria.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_CATEGORIA <= 0 then
    begin
        erro := 'Informe o ID da categoria';
        Result := false;
        exit;
    end;

    try
        try
            qry := TFDQuery.Create(nil);
            qry.Connection := Fconn;

            with qry do
            begin
                // Validar se categoria possui lancamentos....
                Active := false;
                SQL.Clear;
                SQL.Add('SELECT * FROM TAB_LANCAMENTO');
                SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                Active := true;

                if RecordCount > 0 then
                begin
                    Result := False;
                    erro := 'A categoria possui lançamentos e não pode ser excluída';
                    exit;
                end;


                Active := false;
                SQL.Clear;
                SQL.Add('DELETE FROM TAB_CATEGORIA');
                SQL.Add('WHERE ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
                ExecSQL;
            end;

            Result := true;
            erro := '';

        except on ex:exception do
        begin
            Result := False;
            erro := 'Erro ao excluir categorias: ' + ex.Message;
        end;
        end;

    finally
        qry.DisposeOf;
    end;
end;

function TCategoria.ListarCategoria(out erro: string): TFDQuery;
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
            sql.Add('SELECT * FROM TAB_CATEGORIA');
            sql.Add('WHERE 1 = 1');

            if ID_CATEGORIA > 0 then
            begin
                SQL.Add('AND ID_CATEGORIA = :ID_CATEGORIA');
                ParamByName('ID_CATEGORIA').Value := ID_CATEGORIA;
            end;

            sql.Add('ORDER BY DESCRICAO');

            Active := true;
        end;

        Result := qry;
        erro := '';

    except on ex:exception do
    begin
        Result := nil;
        erro := 'Erro ao consultar categorias: ' + ex.Message;
    end;
    end;
end;

end.
