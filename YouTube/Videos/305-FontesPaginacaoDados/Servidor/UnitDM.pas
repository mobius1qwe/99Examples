unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,

  // Precisa instalar o Dataset Seriualize
  // URL: https://github.com/viniciussanchez/dataset-serialize
  DataSet.Serialize, DataSet.Serialize.Config,
  //--------------------------------------

  FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.JSON, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, FireDAC.DApt;

type
  TDm = class(TDataModule)
    conn: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure connBeforeConnect(Sender: TObject);
    function ListarProduto( pagina, tamanho_pagina: integer;
                            busca: string) : TJSONArray;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDm.ListarProduto( pagina, tamanho_pagina: integer;
                            busca: string) : TJSONArray;
var
    erro : string;
    qry : TFDQuery;
    offset : integer;
begin
    try
        // Configura paginacao...
        offset := (pagina * tamanho_pagina) - tamanho_pagina;
        //------------------------

        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        qry.SQL.Add('select id_produto, descricao, categoria, url_foto');
        qry.SQL.Add('from TAB_PRODUTO where id_produto > 0');

        if busca <> '' then
        begin
            qry.SQL.Add('and descricao like :descricao');
            qry.ParamByName('descricao').Value := '%' + busca + '%';
        end;

        qry.SQL.Add('order by id_produto');
        qry.SQL.Add('limit ' + tamanho_pagina.ToString + ' offset ' + offset.ToString);
        qry.Active := true;

        Result := qry.ToJSONArray();

    finally
        qry.DisposeOf;
    end;
end;

procedure TDm.connBeforeConnect(Sender: TObject);
begin
    conn.DriverName := 'SQLite';
    conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco.db';
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
    conn.Connected := true;

    // Configura Dataset Serialize...
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
    TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

end.
