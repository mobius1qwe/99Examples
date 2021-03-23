unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.FMXUI.Wait,
  uRESTDWPoolerDB, uRestDWDriverFD, uDWAbout, Data.DB, FireDAC.Comp.Client;

type
  TDM = class(TServerMethodDataModule)
    conn: TFDConnection;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
