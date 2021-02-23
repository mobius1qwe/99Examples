unit cCategoria;

interface

uses FireDAC.Comp.Client, Data.DB, FMX.Graphics;

type
    TCategoria = class
    private
        FConn : TFDConnection;
        FCATEGORIA: string;
        FGRUPO: string;
    public
        constructor Create(conn : TFDConnection);
        property CATEGORIA : string read FCATEGORIA write FCATEGORIA;
        property GRUPO : string read FGRUPO write FGRUPO;

        function ListarCategoria(order_by: string; out erro: string): TFDQuery;
        function ListarGrupo(order_by: string; out erro: string): TFDQuery;
end;

implementation

uses
  System.SysUtils;

{ TUsuario }

constructor TCategoria.Create(conn: TFDConnection);
begin
    FConn := conn;
end;

function TCategoria.ListarCategoria(order_by: string; out erro: string): TFDQuery;
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
            SQL.Add('SELECT *');
            SQL.Add('FROM TAB_CATEGORIA');

            if order_by = '' then
                SQL.Add('ORDER BY ORDEM')
            else
                SQL.Add('ORDER BY ' + order_by);

            Active := true;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar categorias: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

function TCategoria.ListarGrupo(order_by: string; out erro: string): TFDQuery;
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
            SQL.Add('SELECT *');
            SQL.Add('FROM TAB_CATEGORIA_GRUPO');

            if CATEGORIA <> '' then
            begin
                SQL.Add('WHERE CATEGORIA = :CATEGORIA');
                ParamByName('CATEGORIA').Value := CATEGORIA;
            end;

            if order_by = '' then
                SQL.Add('ORDER BY ORDEM')
            else
                SQL.Add('ORDER BY ' + order_by);

            Active := true;
        end;

        erro := '';
        result := qry;

    except on ex:exception do
        begin
            erro := 'Erro ao listar grupos: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

end.
