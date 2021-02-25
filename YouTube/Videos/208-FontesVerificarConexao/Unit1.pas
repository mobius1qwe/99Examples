unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Net.HttpClient,

  NetworkState
  ;

type
  TForm1 = class(TForm)
    rect_button: TRectangle;
    Label1: TLabel;
    lblConexao: TLabel;
    procedure rect_buttonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

function CheckInternet: boolean;
var
    http : THTTPClient;
begin
    Result := false;

    try
        http := THTTPClient.Create;

        try
            Result := http.Head('https://google.com').StatusCode < 400;
        except
        end;
    finally
        http.DisposeOf;
    end;
end;

function NetState(out tipoConexao: string): boolean;
var
    NS: TNetworkState;
begin
    try
        NS := TNetworkState.Create;
        Result := false;

        try
            {$IFNDEF MSWINDOWS}
            if not NS.IsConnected then
                tipoConexao := ''
            else
            if NS.IsWifiConnected then
            begin
                tipoConexao := 'WIFI';
                Result := true;
            end
            else
            if NS.IsMobileConnected then
            begin
                tipoConexao := 'MOBILE';
                Result := true;
            end;
            {$ELSE}
            tipoConexao := 'Não implementado no Windows';
            Result := true;
            showmessage(tipoConexao);
            {$ENDIF}

        except on ex:exception do
        begin
            Result := false;
            tipoConexao := ex.Message;
        end;
        end;
    finally
        NS.DisposeOf;
    end;
end;

procedure TForm1.rect_buttonClick(Sender: TObject);
var
    tipoConexao : string;
begin
    {
    if NOT CheckInternet then
        lblConexao.Text := 'Sem internet'
    else
        lblConexao.Text := 'Conexão ativa';
    }

    if NOT NetState(tipoConexao) then
        lblConexao.Text := 'Sem internet'
    else
        lblConexao.Text := tipoConexao;

end;

end.
