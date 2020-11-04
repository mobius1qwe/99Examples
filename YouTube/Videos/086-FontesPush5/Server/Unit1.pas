unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  JSON,
  system.net.httpclient

  ;

type
  TForm1 = class(TForm)
    edt_msg: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
        client : THTTPClient;
        v_json : TJSONObject;
        v_jsondata : TJSONObject;
        v_registerids : TJSONArray;
        v_data : TStringStream;
        v_response : TStringStream;
        //-------
        token_celular : string;
        codigo_projeto : string;
        api : string;
        url_google : string;
begin
        try
                //url_google := 'https://android.googleapis.com/gcm/send';
                url_google := 'https://fcm.googleapis.com/fcm/send'; // Firebase
                token_celular := 'APA91bF3JOb5sRAKn-.....'; // Token do celular...
                codigo_projeto := '????????????'; // Coloque o codigo do seu projeto...
                api := 'AIzaSyA23wrRD7TAJQ9Wqld3rOHRIC......';  // Coloque sua API...

                //--------------------------------

                v_registerids := TJSONArray.Create;
                v_registerids.Add(token_celular);

                v_jsondata := TJSONObject.Create;
                v_jsondata.AddPair('id', codigo_projeto);
                v_jsondata.AddPair('message', edt_msg.Text);
                v_jsondata.AddPair('campo_extra', '12345');

                v_json := TJSONObject.Create;
                v_json.AddPair('registration_ids', v_registerids);
                v_json.AddPair('priority', 'high');
                v_json.AddPair('data', v_jsondata);

                client := THTTPClient.Create;
                client.ContentType := 'application/json';
                client.CustomHeaders['Authorization'] := 'key=' + api;

                memo1.Lines.Add(v_json.ToString);

                v_data := TStringStream.Create(v_json.ToString);
                V_data.Position := 0;

                v_response := TStringStream.Create;

                client.Post(url_google, v_data, v_response);
                v_response.Position := 0;

                memo1.Lines.Add(v_response.DataString);
        except on e:exception do
                showmessage('Erro: ' + e.Message);
        end;

end;

end.
