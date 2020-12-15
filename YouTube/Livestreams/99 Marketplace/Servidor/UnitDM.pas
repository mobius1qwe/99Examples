unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    function CarregarConfig: string;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDm.CarregarConfig(): string;
begin
    conn.Connected := true;
    Result := 'OK';
end;

end.
