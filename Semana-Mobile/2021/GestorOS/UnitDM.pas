unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, System.IOUtils;

type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    procedure connBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure connAfterConnect(Sender: TObject);
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

procedure Tdm.connAfterConnect(Sender: TObject);
begin
    // Cria tabela de Clientes...
    conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_CLIENTE(' +
                 'COD_CLIENTE VARCHAR(20) PRIMARY KEY,' +
                 'NOME VARCHAR(100),' +
                 'ENDERECO VARCHAR(100),' +
                 'CIDADE VARCHAR(100),' +
                 'UF VARCHAR(2),' +
                 'FONE VARCHAR(20),' +
                 'EMAIL VARCHAR(100)' +
                 ')');

    // Cria tabela de OS...
    conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_OS(' +
                 'COD_OS VARCHAR(20) PRIMARY KEY,' +
                 'COD_CLIENTE VARCHAR(20),' +
                 'ENDERECO VARCHAR(100),' +
                 'DT_OS DATETIME,' +
                 'ASSUNTO VARCHAR(100),' +
                 'PROBLEMA VARCHAR(1000),' +
                 'STATUS CHAR(1),' +
                 'ASSINATURA BLOB' +
                 ')' );

    // Cria tabela de Fotos...
    conn.ExecSQL('CREATE TABLE IF NOT EXISTS TAB_OS_FOTO(' +
                 'COD_FOTO VARCHAR(20) PRIMARY KEY,' +
                 'COD_OS VARCHAR(20),' +
                 'FOTO BLOB,' +
                 'DESCRICAO VARCHAR(50),' +
                 'DT_FOTO DATETIME' +
                 ')' );

    // Carga de Clientes...
    try
    conn.ExecSQL('INSERT INTO TAB_CLIENTE(COD_CLIENTE, NOME, ENDERECO, CIDADE, UF, FONE, EMAIL) ' +
                 'VALUES(''00000000001'', ''99 Coders'', ''Av. Brasil, 1500'', ''São Paulo'', ''SP'', ''(11) 0000-0000'', ''heber@99coders.com.br'')');
    except
    end;
end;

procedure Tdm.connBeforeConnect(Sender: TObject);
begin
    conn.DriverName := 'SQLite';

    {$IFDEF MSWINDOWS}
    conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\GestorOS.db';
    {$ELSE}
    conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'GestorOS.db');
    {$ENDIF}
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
    conn.Connected := true;
end;

end.
