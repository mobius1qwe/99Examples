unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, uDWAbout, uRESTDWServerEvents,
  uDWJSONObject, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, cUsuario, System.JSON,
  FMX.Graphics, Soap.EncdDecd, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.NetEncoding,
  Datasnap.DSHTTP;

type
  Tdm = class(TServerMethodDataModule)
    DWEvents: TDWServerEvents;
    conn: TFDConnection;
    QryGeral: TFDQuery;
    procedure DWEventsEventshoraReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsValidaLoginReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure DWEventsEventsCriarContaReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsListarCategoriaReplyEvent(var Params: TDWParams;
      var Result: string);
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

uses System.IniFiles, FMX.Dialogs, uDWConsts;

function LoadConfig(): string;
var
    arq_ini, base, usuario, senha, driver : string;
    ini : TIniFile;
begin
    try
        arq_ini := System.SysUtils.GetCurrentDir + '\servidor.ini';

        if NOT FileExists(arq_ini) then
        begin
            Result := 'Arquivo INI não encontrado: ' + arq_ini;
            exit;
        end;

        ini := TIniFile.Create(arq_ini);

        base := ini.ReadString('Banco de Dados', 'Database', '');
        usuario := ini.ReadString('Banco de Dados', 'User_Name', '');
        senha := ini.ReadString('Banco de Dados', 'Password', '');
        driver := ini.ReadString('Banco de Dados', 'DriverID', '');

        dm.conn.Params.Values['DriverID'] := driver;
        dm.conn.Params.Values['Database'] := base;
        dm.conn.Params.Values['User_Name'] := usuario;
        dm.conn.Params.Values['Password'] := senha;

        try
            dm.conn.Connected := true;
            Result := 'OK';
        except on ex:exception do
            Result := 'Erro ao conectar com o banco de dados: ' + ex.Message;
        end;
    finally
        ini.DisposeOf;
    end;
end;

function BitmapFromBase64(const base64: string): TBitmap;
var
  Input: TStringStream;
  Output: TBytesStream;
  Encoding: TBase64Encoding;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Encoding := TBase64Encoding.Create(0);
      Encoding.Decode(Input, Output);

      Output.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    finally
      Encoding.DisposeOf;
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

procedure Tdm.DWEventsEventsCriarContaReplyEvent(var Params: TDWParams;
  var Result: string);
var
    email, senha, foto64, erro : string;
    usuario : TUsuario;
    json : TJsonObject;
    foto_bmp : TBitmap;
    x : integer;
begin
    try
        email := Params.ItemsString['email'].AsString;
        senha := Params.ItemsString['senha'].AsString;
        foto64 := Params.ItemsString['foto'].AsString;

        json := TJsonObject.Create;

        // Validacoes...
        if (email = '') or (senha = '') or (foto64 = '') then
        begin
            json.AddPair('sucesso', 'N');
            json.AddPair('erro', 'Informe todos os parâmetros');
            json.AddPair('codusuario', '0');
            Result := json.ToString;

            exit;
        end;


        // Criar foto bitmap...
        try
            foto_bmp := BitmapFromBase64(foto64);
        except on ex:exception do
        begin
            json.AddPair('sucesso', 'N');
            json.AddPair('erro', 'Erro ao criar imagem no servidor: ' + ex.Message);
            json.AddPair('codusuario', '0');
            Result := json.ToString;

            exit;
        end;
        end;


        try
            usuario := TUsuario.Create(dm.conn);
            usuario.Email := email;
            usuario.Senha := senha;
            usuario.Foto := foto_bmp;

            if NOT usuario.CriarConta(erro) then
            begin
                json.AddPair('sucesso', 'N');
                json.AddPair('erro', erro);
                json.AddPair('codusuario', '0');
            end
            else
            begin
                json.AddPair('sucesso', 'S');
                json.AddPair('erro', '');
                json.AddPair('codusuario', usuario.Cod_Usuario.ToString);
            end;
        finally
            foto_bmp.DisposeOf;
            usuario.DisposeOf;
        end;

        Result := json.ToString;

    finally
        json.DisposeOf;
    end;
end;

procedure Tdm.DWEventsEventshoraReplyEvent(var Params: TDWParams;
  var Result: string);
begin
    Result := '{"hora": "' + FormatDateTime('hh:nn:ss', now) + '"}';
end;

procedure Tdm.DWEventsEventsListarCategoriaReplyEvent(var Params: TDWParams;
  var Result: string);
var
    json : uDWJSONObject.TJSONValue;
begin
    dm.QryGeral.Active := false;
    dm.QryGeral.SQL.Clear;
    dm.QryGeral.SQL.Add('SELECT COD_CATEGORIA, DESCRICAO, ICONE FROM TAB_CATEGORIA');
    dm.QryGeral.SQL.Add('WHERE IND_ATIVO = ''S'' ORDER BY ORDEM ');
    dm.QryGeral.Active := true;

    try
        json := uDWJSONObject.TJSONValue.Create;
        json.LoadFromDataset('', dm.QryGeral, false, jmPureJSON);

        Result := json.ToJSON;
    finally
        json.DisposeOf;
    end;
end;

procedure Tdm.DWEventsEventsValidaLoginReplyEvent(var Params: TDWParams;
  var Result: string);
var
    email, senha, erro : string;
    usuario : TUsuario;
    json : TJsonObject;
begin
    try
        sleep(4000);
        email := Params.ItemsString['email'].AsString;
        senha := Params.ItemsString['senha'].AsString;

        json := TJsonObject.Create;

        usuario := TUsuario.Create(dm.conn);
        usuario.Email := email;
        usuario.Senha := senha;

        if NOT usuario.ValidaLogin(erro) then
        begin
            //{"sucesso": "N", "erro":"Usuário não informado", "codusuario":"0"}
            json.AddPair('sucesso', 'N');
            json.AddPair('erro', erro);
            json.AddPair('codusuario', '0');
        end
        else
        begin
            json.AddPair('sucesso', 'S');
            json.AddPair('erro', '');
            json.AddPair('codusuario', usuario.Cod_Usuario.ToString);
        end;

        Result := json.ToString;

    finally
        json.DisposeOf;
        usuario.DisposeOf;
    end;
end;

procedure Tdm.ServerMethodDataModuleCreate(Sender: TObject);
var
    retorno : string;
begin
    retorno := LoadConfig;

    if retorno <> 'OK' then
        showmessage(retorno);
end;

end.
