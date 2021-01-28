unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB, uDWAbout, uRESTDWServerEvents,
  uDWJSONObject, uDWConsts, System.JSON, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  Tdm = class(TServerMethodDataModule)
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    EventsUsuario: TDWServerEvents;
    EventsCategoria: TDWServerEvents;
    EventsEmpresa: TDWServerEvents;
    EventsServico: TDWServerEvents;
    conn: TFDConnection;
    EventsReserva: TDWServerEvents;
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure EventsUsuarioEventsloginReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsCategoriaEventslistarReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsUsuarioEventscadastroReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsEmpresaEventslistarReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsServicoEventslistarReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsServicoEventshorarioReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsServicoEventsagendarReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure EventsReservaEventslistarReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
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

// categoria/listar
// Parametros: cidade
procedure Tdm.EventsCategoriaEventslistarReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    qry : TFDQuery;
    json : uDWJsonObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJsonObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.sql.Add('SELECT distinct C.ID_CATEGORIA, C.DESCRICAO, C.ICONE ');
        qry.sql.Add('FROM TAB_CATEGORIA C');
        qry.sql.Add('JOIN TAB_EMPRESA E ON (E.ID_CATEGORIA = C.ID_CATEGORIA)');
        qry.sql.Add('WHERE E.CIDADE = :CIDADE');
        qry.sql.Add('ORDER BY C.ORDEM');
        qry.ParamByName('CIDADE').Value := Params.ItemsString['cidade'].AsString;
        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// empresa/listar
// Parametros: cidade, id_empresa, busca, ind_foto (algumas consultas nao precisam de foto)
procedure Tdm.EventsEmpresaEventslistarReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    qry : TFDQuery;
    json : uDWJsonObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJsonObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.sql.Add('SELECT E.ID_EMPRESA, E.NOME, ENDERECO, BAIRRO,');
        qry.sql.Add('CIDADE, ESTADO, FONE, ID_CATEGORIA');

        // algumas consultas nao precisam de foto...
        if Params.ItemsString['ind_foto'].AsString = 'S' then
            qry.sql.Add(', FOTO')
        else
            qry.sql.Add(', NULL AS FOTO');

        qry.sql.Add('FROM TAB_EMPRESA E');
        qry.sql.Add('WHERE E.CIDADE = :CIDADE');
        qry.ParamByName('CIDADE').Value := Params.ItemsString['cidade'].AsString;

        if Params.ItemsString['busca'].AsString <> '' then
        begin
            qry.sql.Add('AND E.NOME LIKE :NOME');
            qry.ParamByName('NOME').Value := '%' + Params.ItemsString['busca'].AsString + '%';
        end;

        if Params.ItemsString['id_empresa'].AsString <> '' then
        begin
            qry.sql.Add('AND E.ID_EMPRESA = :ID_EMPRESA');
            qry.ParamByName('ID_EMPRESA').Value := Params.ItemsString['id_empresa'].AsString;
        end;

        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// reserva/listar
// Parametros: id_usuario
procedure Tdm.EventsReservaEventslistarReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    qry : TFDQuery;
    json : uDWJsonObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJsonObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.sql.Add('SELECT R.*, S.DESCRICAO, E.NOME, S.VALOR, E.ENDERECO, E.BAIRRO, E.CIDADE, E.FONE');
        qry.sql.Add('FROM TAB_RESERVA R');
        qry.sql.Add('JOIN TAB_SERVICO S ON (S.ID_SERVICO = R.ID_SERVICO)');
        qry.sql.Add('JOIN TAB_EMPRESA E ON (E.ID_EMPRESA = S.ID_EMPRESA)');
        qry.sql.Add('WHERE R.ID_USUARIO = :ID_USUARIO');

        try
            qry.ParamByName('ID_USUARIO').Value := Params.ItemsString['id_usuario'].AsInteger;
        except
            qry.ParamByName('ID_USUARIO').Value := 0;
        end;

        qry.sql.Add('ORDER BY R.DATA_RESERVA, R.HORA');
        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// servico/listar
// Parametros: id_empresa
procedure Tdm.EventsServicoEventslistarReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    qry : TFDQuery;
    json : uDWJsonObject.TJSONValue;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJsonObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.sql.Add('SELECT S.*');
        qry.sql.Add('FROM TAB_SERVICO S');
        qry.sql.Add('WHERE S.ID_EMPRESA = :ID_EMPRESA');

        try
            qry.ParamByName('ID_EMPRESA').Value := Params.ItemsString['id_empresa'].AsInteger;
        except
            qry.ParamByName('ID_EMPRESA').Value := 0;
        end;

        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// servico/agendar
// Parametros: id_usuario, id_servico, dt (yyyy-mm-dd), hora (hh:mm)
procedure Tdm.EventsServicoEventsagendarReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    json : TJsonObject;
    qry : TFDQuery;
    dt : TDate;
    dia, mes, ano : integer;
begin
    try
        json := TJsonObject.Create;
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        // Valida parametros...
        if (Params.ItemsString['id_usuario'].AsString = '') or
           (Params.ItemsString['id_servico'].AsString = '') or
           (Params.ItemsString['dt'].AsString = '') or
           (Params.ItemsString['hora'].AsString = '') then
        begin
            json.AddPair('retorno', 'Informa todos os parametros');
            Result := json.ToString;
            exit;
        end;

        try
            Params.ItemsString['id_usuario'].AsInteger;
            Params.ItemsString['id_servico'].AsInteger;
        except
            json.AddPair('retorno', 'Parametros inválidos');
            Result := json.ToString;
            exit;
        end;


        // converte parametro "dt" para o formato TDate
        try
            ano := Copy(Params.ItemsString['dt'].AsString, 1, 4).ToInteger;
            mes := Copy(Params.ItemsString['dt'].AsString, 6, 2).ToInteger;
            dia := Copy(Params.ItemsString['dt'].AsString, 9, 2).ToInteger;
            dt := EncodeDate(ano, mes, dia);
        except
            dt := date;
        end;

        try
            with dm do
            begin
                // Validar se vaga ainda está disponivel...
                qry.Active := false;
                qry.SQL.Clear;
                qry.sql.Add('SELECT * FROM TAB_RESERVA');
                qry.sql.Add('WHERE ID_SERVICO=:ID_SERVICO AND DATA_RESERVA=:DATA_RESERVA');
                qry.sql.Add('AND HORA=:HORA');

                try
                    qry.ParamByName('ID_SERVICO').Value := Params.ItemsString['id_servico'].AsInteger;
                except
                    qry.ParamByName('ID_SERVICO').Value := 0;
                end;

                qry.ParamByName('DATA_RESERVA').AsDate := dt;
                qry.ParamByName('HORA').value := Params.ItemsString['hora'].AsString;
                qry.Active := true;

                if qry.RecordCount > 0 then
                begin
                    json.AddPair('retorno', 'Esse horário não está mais disponível');
                    Result := json.ToString;
                    exit;
                end;



                qry.Active := false;
                qry.SQL.Clear;
                qry.sql.Add('INSERT INTO TAB_RESERVA(ID_USUARIO, ID_SERVICO, DATA_RESERVA, HORA, DIA_SEMANA)');
                qry.sql.Add('VALUES(:ID_USUARIO, :ID_SERVICO, :DATA_RESERVA, :HORA, :DIA_SEMANA)');
                qry.ParamByName('ID_USUARIO').Value := Params.ItemsString['id_usuario'].AsInteger;
                qry.ParamByName('ID_SERVICO').Value := Params.ItemsString['id_servico'].AsInteger;
                qry.ParamByName('DATA_RESERVA').AsDate := dt;
                qry.ParamByName('HORA').Value := Params.ItemsString['hora'].AsString;
                qry.ParamByName('DIA_SEMANA').Value := DayOfWeek(dt);
                qry.ExecSQL;


                // Busca o id_usuario cadastrado...
                qry.Active := false;
                qry.SQL.Clear;
                qry.sql.Add('SELECT MAX(ID_RESERVA) AS ID_RESERVA FROM TAB_RESERVA');
                qry.sql.Add('WHERE ID_USUARIO=:ID_USUARIO AND ID_SERVICO=:ID_SERVICO');
                qry.sql.Add('AND DATA_RESERVA=:DATA_RESERVA AND HORA=:HORA');
                qry.ParamByName('ID_USUARIO').Value := Params.ItemsString['id_usuario'].AsInteger;
                qry.ParamByName('ID_SERVICO').Value := Params.ItemsString['id_servico'].AsInteger;
                qry.ParamByName('DATA_RESERVA').AsDate := dt;
                qry.ParamByName('HORA').Value := Params.ItemsString['hora'].AsString;
                qry.Active := true;


                json.AddPair('retorno', 'OK');
                json.AddPair('id_reserva', qry.FieldByName('ID_RESERVA').AsString);

                Result := json.ToString;
            end;
        except on ex:exception do
            begin
                json.AddPair('retorno', ex.Message);
                Result := json.ToString;
            end;
        end;

    finally
        qry.DisposeOf;
        json.DisposeOf;
    end;
end;

// servico/horario  =>  (somente horarios disponiveis)
// Parametros: id_servico, dt (yyyy-mm-dd)
procedure Tdm.EventsServicoEventshorarioReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    qry : TFDQuery;
    json : uDWJsonObject.TJSONValue;
    dt : TDate;
    dia, mes, ano : Integer;
begin

    // converte parametro "dt" para o formato TDate
    if Params.ItemsString['dt'].AsString <> '' then
    begin
        ano := Copy(Params.ItemsString['dt'].AsString, 1, 4).ToInteger;
        mes := Copy(Params.ItemsString['dt'].AsString, 6, 2).ToInteger;
        dia := Copy(Params.ItemsString['dt'].AsString, 9, 2).ToInteger;
        dt := EncodeDate(ano, mes, dia);
    end
    else
        dt := date;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        json := uDWJsonObject.TJSONValue.Create;

        qry.Active := false;
        qry.SQL.Clear;
        qry.sql.Add('SELECT H.*');
        qry.sql.Add('FROM TAB_SERVICO S');
        qry.sql.Add('JOIN TAB_SERVICO_HORARIO H ON (H.ID_SERVICO = S.ID_SERVICO)');
        qry.sql.Add('WHERE S.ID_SERVICO = :ID_SERVICO');
        qry.sql.Add('AND H.DIA_SEMANA = :DIA_SEMANA');

        // se for hoje, nao listar as horas passadas...
        if dt = date then
            qry.sql.Add('AND H.HORA > ''' + FormatDateTime('HH:nn', now) + '''');


        qry.sql.Add('AND NOT EXISTS( SELECT  0');
        qry.sql.Add('        FROM    TAB_RESERVA R');
        qry.sql.Add('        WHERE   R.ID_SERVICO = S.ID_SERVICO');
        qry.sql.Add('        AND     R.HORA = H.HORA');
        qry.sql.Add('        AND     H.DIA_SEMANA = R.DIA_SEMANA');
        qry.sql.Add('        AND     R.DATA_RESERVA = :DATA_RESERVA)');

        try
            qry.ParamByName('ID_SERVICO').Value := Params.ItemsString['id_servico'].AsInteger;
        except
            qry.ParamByName('ID_SERVICO').Value := 0;
        end;

        qry.ParamByName('DIA_SEMANA').Value := DayOfWeek(dt);
        qry.ParamByName('DATA_RESERVA').AsDate := dt;

        qry.sql.Add('ORDER BY H.HORA');
        qry.Active := true;

        json.LoadFromDataset('', qry, false, jmPureJSON, 'dd/mm/yyyy hh:nn:ss');

        Result := json.ToJSON;
    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

// usuario/cadastro
// Parametros: id_usuario, nome, email, senha
procedure Tdm.EventsUsuarioEventscadastroReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    json : TJsonObject;
    qry : TFDQuery;
begin
    try
        json := TJsonObject.Create;
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        // Valida parametros vazios...
        if (Params.ItemsString['email'].AsString = '') or
           (Params.ItemsString['nome'].AsString = '') or
           (Params.ItemsString['senha'].AsString = '') then
        begin
            json.AddPair('retorno', 'Informa todos os parametros');
            Result := json.ToString;
            exit;
        end;

        // Valida email ja cadastrado (quando tiver cadastrando um novo usuario)...
        if Params.ItemsString['id_usuario'].AsString = '' then
        begin
            qry.Active := false;
            qry.SQL.Clear;
            qry.sql.Add('SELECT * FROM TAB_USUARIO');
            qry.sql.Add('WHERE EMAIL=:EMAIL');
            qry.ParamByName('EMAIL').Value := Params.ItemsString['email'].AsString;
            qry.Active := true;

            if qry.RecordCount > 0 then
            begin
                json.AddPair('retorno', 'Esse email já está em uso por outra conta');
                Result := json.ToString;
                exit;
            end;
        end;

        try
            with dm do
            begin
                qry.Active := false;
                qry.SQL.Clear;

                // Se passou id_usuario, vamos atualizar...
                if Params.ItemsString['id_usuario'].AsString <> '' then
                begin
                    qry.sql.Add('UPDATE TAB_USUARIO SET EMAIL=:EMAIL, SENHA=:SENHA, NOME=:NOME');
                    qry.sql.Add('WHERE ID_USUARIO = :ID_USUARIO');

                    qry.ParamByName('ID_USUARIO').Value := Params.ItemsString['id_usuario'].AsString;
                end
                else
                begin
                    qry.sql.Add('INSERT INTO TAB_USUARIO(NOME, EMAIL, SENHA)');
                    qry.sql.Add('VALUES(:NOME, :EMAIL, :SENHA)');
                end;

                qry.ParamByName('NOME').Value := Params.ItemsString['nome'].AsString;
                qry.ParamByName('EMAIL').Value := Params.ItemsString['email'].AsString;
                qry.ParamByName('SENHA').Value := Params.ItemsString['senha'].AsString;
                qry.ExecSQL;


                // Busca o id_usuario cadastrado...
                qry.Active := false;
                qry.SQL.Clear;
                qry.sql.Add('SELECT MAX(ID_USUARIO) AS ID_USUARIO FROM TAB_USUARIO');
                qry.sql.Add('WHERE EMAIL=:EMAIL');
                qry.ParamByName('EMAIL').Value := Params.ItemsString['email'].AsString;
                qry.Active := true;


                json.AddPair('retorno', 'OK');
                json.AddPair('id_usuario', qry.FieldByName('id_usuario').AsString);

                Result := json.ToString;
            end;
        except on ex:exception do
            begin
                json.AddPair('retorno', ex.Message);
                Result := json.ToString;
            end;
        end;

    finally
        qry.DisposeOf;
        json.DisposeOf;
    end;
end;

// usuario/login
// Parametros: email, senha
procedure Tdm.EventsUsuarioEventsloginReplyEventByType(var Params: TDWParams;
  var Result: string; const RequestType: TRequestType; var StatusCode: Integer;
  RequestHeader: TStringList);
var
    json : TJsonObject;
    qry : TFDQuery;
begin
    try
        json := TJsonObject.Create;
        qry := TFDQuery.Create(nil);
        qry.Connection := dm.conn;

        if Params.ItemsString['email'].AsString = '' then
        begin
            // {"retorno":"erro..."}
            json.AddPair('retorno', 'Email não informado');
            Result := json.ToString;
            exit;
        end;

        try
            with dm do
            begin
                qry.Active := false;
                qry.SQL.Clear;
                qry.sql.Add('SELECT * FROM TAB_USUARIO WHERE EMAIL=:EMAIL AND SENHA=:SENHA');
                qry.ParamByName('EMAIL').Value := Params.ItemsString['email'].AsString;
                qry.ParamByName('SENHA').Value := Params.ItemsString['senha'].AsString;
                qry.Active := true;

                if qry.RecordCount > 0 then
                begin
                    json.AddPair('retorno', 'OK');
                    json.AddPair('id_usuario', qry.FieldByName('id_usuario').AsString);
                    json.AddPair('nome', qry.FieldByName('nome').AsString)
                end
                else
                    json.AddPair('retorno', 'Email ou senha inválida');

                Result := json.ToString;
            end;
        except on ex:exception do
            begin
                json.AddPair('retorno', ex.Message);
                Result := json.ToString;
            end;
        end;

    finally
        json.DisposeOf;
        qry.DisposeOf;
    end;
end;

procedure Tdm.ServerMethodDataModuleCreate(Sender: TObject);
begin
    dm.conn.Params.Clear;
    dm.conn.Params.Values['DriverID'] := 'FB';
    dm.conn.Params.Values['Database'] := 'D:\caminho-do-seu-banco\BANCO.FDB';
    dm.conn.Params.Values['User_Name'] := 'SYSDBA';
    dm.conn.Params.Values['Password'] := 'masterkey';
    dm.conn.Connected := true;
end;

end.
