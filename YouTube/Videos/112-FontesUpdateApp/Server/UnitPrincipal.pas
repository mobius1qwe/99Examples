unit UnitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDWAbout, uRESTDWBase;

type
  TFrmPrincipal = class(TForm)
    RESTServicePooler1: TRESTServicePooler;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses UnitDM;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    RESTServicePooler1.ServerMethodClass := Tdm;
    RESTServicePooler1.Active := true;
end;

end.
