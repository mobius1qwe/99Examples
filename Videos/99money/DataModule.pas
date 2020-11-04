unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  system.IOUtils, FireDAC.Comp.UI;

type
  Tdm = class(TDataModule)
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDConn: TFDConnection;
    qry_categoria: TFDQuery;
    qry_lancamento: TFDQuery;
    qry_categoriaID_CATEGORIA: TIntegerField;
    qry_categoriaDESCRICAO: TStringField;
    qry_lancamentoID_LANCAMENTO: TIntegerField;
    qry_lancamentoVALOR: TBCDField;
    qry_lancamentoDATA: TDateTimeField;
    qry_lancamentoDESCRICAO: TStringField;
    qry_lancamentoID_CATEGORIA: TIntegerField;
    qry_lancamentoTIPO_LANCAMENTO: TStringField;
    qry_lancamentoCATEGORIA: TStringField;
    qry_lancamentoICONE: TLargeintField;
    qry_geral: TFDQuery;
    qry_perfil: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure qry_lancamentoCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
        with FDConn do
        begin
                {$IFDEF IOS}
                Params.Values['DriverID'] := 'SQLite';
                try
                        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'database.db');
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ENDIF}

                {$IFDEF ANDROID}
                Params.Values['DriverID'] := 'SQLite';
                try
                        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'database.db');
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ENDIF}

                {$IFDEF MSWINDOWS}
                try
                        Params.Values['Database'] := 'D:\GoogleDrive\99money\DB\database.db';
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ENDIF}
        end;
end;

procedure Tdm.qry_lancamentoCalcFields(DataSet: TDataSet);
begin
        if dm.qry_lancamento.FieldByName('TIPO_LANCAMENTO').AsString = 'C' then
                dm.qry_lancamento.FieldByName('ICONE').Value := 0
        else
                dm.qry_lancamento.FieldByName('ICONE').Value := 1;

end;

end.
