unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWConstsData, uRESTDWPoolerDB,
  uDWAbout, FMX.Layouts, FMX.ListBox, FMX.StdCtrls, FMX.Edit, REST.Types,
  REST.Client, REST.Authenticator.Basic, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Json;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    Memo1: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
    JsonObj : TJSONObject;
begin
    memo1.Lines.Clear;

    // Tenta consumir servico...
    try
        RESTRequest1.Execute;
    except
        memo1.Lines.Add('Erro ao acessar o servidor. Verifique sua conexão com a internet.');
        exit;
    end;

    // Trata retorno em JSON...
    try
        memo1.Lines.Add(RESTRequest1.Response.JSONValue.ToString);

        JsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(memo1.lines.text), 0) as TJSONObject;
        Edit1.Text := TJSONObject(JsonObj).GetValue('HORA').Value;
    finally
        JsonObj.DisposeOf;
    end;
end;

end.
