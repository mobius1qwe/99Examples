unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, IPPeerClient,
  Data.Bind.Components, Data.Bind.ObjectScope,

  //---------------------
  REST.Client,
  Web.HTTPApp,
  REST.Types,
  System.JSON
  ;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    edt_origem: TEdit;
    edt_destino: TEdit;
    btn_calcular: TSpeedButton;
    lbl_distancia: TLabel;
    lbl_valor: TLabel;
    lbl_tempo: TLabel;
    Label7: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure btn_calcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btn_calcularClick(Sender: TObject);
var
        retorno : TJSONObject;
        prows : TJSONPair;
        arrayr : TJSONArray;
        orows : TJSONObject;
        arraye : TJSONArray;
        oelementos : TJSONObject;
        oduracao, odistancia : TJSONObject;

        distancia_str, duracao_str : string;
        distancia_int, duracao_int : integer;

        valor : double;
begin
        //https://developers.google.com/maps/documentation/distance-matrix/

        //http://maps.googleapis.com/maps/api/distancematrix/json?origins={origem}
        //&destinations={destino}&mode=driving&language=pt-BR&key=???????

        RESTRequest1.Resource := 'json?origins={origem}&destinations={destino}&mode=driving&language=pt-BR&key=';
        RESTRequest1.Params.AddUrlSegment('origem', edt_origem.Text);
        RESTRequest1.Params.AddUrlSegment('destino', edt_destino.Text);
        RESTRequest1.Execute;

        retorno := RESTRequest1.Response.JSONValue as TJSONObject;

        if retorno.GetValue('status').Value <> 'OK' then
        begin
                showmessage('Ocorreu um erro ao calcular a rota.');
                exit;
        end;


        prows := retorno.Get('rows');
        arrayr := prows.JsonValue as TJSONArray;
        orows := arrayr.Items[0] as TJSONObject;
        arraye := orows.GetValue('elements') as TJSONArray;
        oelementos := arraye.Items[0] as TJSONObject;

        odistancia := oelementos.GetValue('distance') as TJSONObject;
        oduracao := oelementos.GetValue('duration') as TJSONObject;

        distancia_str := odistancia.GetValue('text').Value;
        distancia_int := odistancia.GetValue('value').Value.ToInteger;

        duracao_str := oduracao.GetValue('text').Value;
        duracao_int := oduracao.GetValue('value').Value.ToInteger;


        lbl_distancia.Text := 'Distância: ' + distancia_str;
        lbl_tempo.Text := 'Tempo: ' + duracao_str;

        valor := (distancia_int * 0.01) + (duracao_int * 0.0001);
        lbl_valor.Text := 'R$ ' + FormatFloat('#,##0.00', valor);
end;

end.
