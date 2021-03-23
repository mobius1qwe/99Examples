unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWAbout, uRESTDWPoolerDB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uDWConstsData;

type
  TDM = class(TDataModule)
    RESTDWDataBase1: TRESTDWDataBase;
    sql_usuario: TRESTDWClientSQL;
    sql_compromisso: TRESTDWClientSQL;
    sql_calendar: TRESTDWClientSQL;
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
