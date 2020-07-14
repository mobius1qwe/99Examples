unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Maps, FMX.Objects, FMX.Edit,
  FMX.Ani, System.Permissions, System.Sensors, System.Sensors.Components,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client,

  Math, Generics.Collections, System.IOUtils, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FMX.Layouts;

type
  TForm1 = class(TForm)
    MapView1: TMapView;
    Rectangle2: TRectangle;
    img_car: TImage;
    rect_localizacao: TRoundRect;
    LocationSensor: TLocationSensor;
    rect_100: TRoundRect;
    Label1: TLabel;
    Rectangle1: TRectangle;
    lbl_distancia: TLabel;
    conn: TFDConnection;
    img_localizacao: TImage;
    qry: TFDQuery;
    Layout1: TLayout;
    Image1: TImage;
    rect_500: TRoundRect;
    Label2: TLabel;
    rect_1500: TRoundRect;
    Label3: TLabel;
    rect_5000: TRoundRect;
    Label4: TLabel;
    Arc1: TArc;
    FloatAnimation1: TFloatAnimation;
    procedure FormCreate(Sender: TObject);
    procedure rect_localizacaoClick(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure FormShow(Sender: TObject);
    procedure Add_Motorista(posicao: TMapCoordinate; nome, dist : string);
    procedure Limpar_Carros();
    procedure rect_100Click(Sender: TObject);
  private
    { Private declarations }

    minha_pos : TMapCoordinate;
    FMarkers : TList<TMapMarker>;


    {$IFDEF ANDROID}
    FAccess_Coarse_Location, FAccess_Fine_Location : string;
    procedure DisplayRationale(Sender: TObject;
              const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure LocationPermissionRequestResult
                (Sender: TObject; const APermissions: TArray<string>;
                const AGrantResults: TArray<TPermissionStatus>);
    {$ENDIF}

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses FMX.DialogService

{$IFDEF ANDROID}
  ,Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os
{$ENDIF}
;


procedure Animacao(ind : boolean);
begin
        with Form1 do
        begin
                Arc1.Visible := ind;

                if ind then
                    FloatAnimation1.Start
                else
                    FloatAnimation1.Stop;
        end;
end;


{$IFDEF ANDROID}
procedure TForm1.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do
  begin
    if (APermissions[I] = FAccess_Coarse_Location) or (APermissions[I] = FAccess_Fine_Location) then
      RationaleMsg := 'O app precisa de acesso ao GPS'
  end;

  TDialogService.ShowMessage(RationaleMsg,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end)
end;

procedure TForm1.LocationPermissionRequestResult
  (Sender: TObject; const APermissions: TArray<string>;
const AGrantResults: TArray<TPermissionStatus>);
var
         x : integer;
begin
  if (Length(AGrantResults) = 2) and
    (AGrantResults[0] = TPermissionStatus.Granted) and
    (AGrantResults[1] = TPermissionStatus.Granted) then
        LocationSensor.Active := true
  else
  begin
    Animacao(false);
    TDialogService.ShowMessage
      ('Não é possível acessar o GPS porque o app não possui acesso')
  end;

end;

{$ENDIF}



procedure Conectar_Banco();
begin
        with Form1.Conn do
        begin
                {$IFDEF IOS}
                Params.Values['DriverID'] := 'SQLite';
                try
                        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ENDIF}

                {$IFDEF ANDROID}
                Params.Values['DriverID'] := 'SQLite';
                try
                        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ENDIF}

                {$IFDEF MSWINDOWS}
                Form1.Rectangle2.Visible := false;
                showmessage('App não suportado no windows');
                {$ENDIF}
        end;
end;

procedure TForm1.Limpar_Carros();
var
        Marker: TMapMarker;
begin
        for Marker in FMarkers do
                Marker.Remove;

        FMarkers.Clear;
end;

function Distancia(lat1, long1, lat2, long2:double): double;
const
        diameter = 2 * 6372.8;
var
        dx, dy, dz: double;
begin
        long1 := degtorad(long1 - long2);
        lat1 := degtorad(lat1);
        lat2 := degtorad(lat2);

        dz := sin(lat1) - sin(lat2);
        dx := cos(long1) * cos(lat1) - cos(lat2);
        dy := sin(long1) * cos(lat1);

        Result := arcsin(sqrt(sqr(dx) + sqr(dy) + sqr(dz)) / 2) * diameter;
end;

procedure TForm1.Add_Motorista(posicao: TMapCoordinate; nome, dist : string);
var
        marcador : TMapMarkerDescriptor;
begin
        // Criar o marcador...
        marcador := TMapMarkerDescriptor.Create(posicao, nome);
        marcador.Snippet := dist;
        marcador.Visible := true;
        marcador.Icon := form1.img_car.Bitmap;


        // Direcao do carro...
        marcador.Rotation := Random(360) + 1;


        // Adiciona marcador no lista e no mapa...
        FMarkers.Add(MapView1.AddMarker(marcador));
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        Conectar_Banco;
end;

procedure Localiza_Carros(minha_localizacao: TMapCoordinate; distancia_maxima: double);
var
        pos_carro: TMapCoordinate;
        raio, distancia_maxima_graus : double;
        cont : integer;
begin
        // 0.000001 graus = 0,11132 m
        distancia_maxima_graus := (distancia_maxima * 0.000001) / 0.11132;
        cont := 0;

        with form1 do
        begin
                qry.Active := false;
                qry.sql.Clear;
                qry.sql.Add('SELECT * FROM TAB_MOTORISTA');

                // Restringir distancia...
                if distancia_maxima > 0 then
                begin
                        qry.sql.Add('WHERE LATITUDE >= :LAT1 AND LATITUDE <= :LAT2');
                        qry.sql.Add('AND   LONGITUDE >= :LONG1 AND LONGITUDE <= :LONG2');
                        qry.ParamByName('LAT1').Value := minha_localizacao.Latitude - distancia_maxima_graus;
                        qry.ParamByName('LAT2').Value := minha_localizacao.Latitude + distancia_maxima_graus;
                        qry.ParamByName('LONG1').Value := minha_localizacao.Longitude - distancia_maxima_graus;
                        qry.ParamByName('LONG2').Value := minha_localizacao.Longitude + distancia_maxima_graus;
                end;

                qry.Active := true;

                while NOT qry.eof do
                begin
                        pos_carro.Latitude := qry.FieldByName('LATITUDE').AsFloat;
                        pos_carro.Longitude := qry.FieldByName('LONGITUDE').AsFloat;


                        // Calcula se está dentro do raio...
                        raio := Distancia(minha_pos.latitude,
                                                      minha_pos.longitude,
                                                      pos_carro.Latitude,
                                                      pos_carro.Longitude) * 1000;

                        if raio <= distancia_maxima then
                        begin
                                inc(cont);
                                Add_Motorista(pos_carro,
                                              qry.FieldByName('NOME').AsString,
                                              trunc(raio).ToString + 'm');
                        end;

                        qry.next;
                end;

                lbl_distancia.text := cont.ToString + ' Motorista(s)';
                qry.Active := false;
        end;
end;

procedure TForm1.LocationSensorLocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
var
        posicao : TMapCoordinate;
        marcador : TMapMarkerDescriptor;
begin
        LocationSensor.Active := false;

        // Obtem nova localizacao...
        posicao.Latitude := NewLocation.Latitude;
        posicao.Longitude := NewLocation.Longitude;


        // Criar o marcador...
        marcador := TMapMarkerDescriptor.Create(posicao, 'Passageiro');
        marcador.Snippet := 'Heber';
        marcador.Visible := true;

        // Icone do marcador...
        marcador.Icon := img_localizacao.Bitmap;

        // Adiciona marcardor no mapa...
        MapView1.AddMarker(marcador);

        // Centraliza mapa no marcador...
        MapView1.Location := posicao;

        // Zoom...
        MapView1.Zoom := 14;

        minha_pos := posicao;

        Animacao(false);
end;


procedure TForm1.FormCreate(Sender: TObject);
var
        posicao : TMapCoordinate;
begin
        MapView1.MapType := TMapType.Normal;
        img_car.Visible := false;
        img_localizacao.Visible := false;
        FMarkers := TList<TMapMarker>.Create;
        Arc1.Visible := false;

        // Centralizar o mapa em SP...
        posicao.Latitude := -23.561973;
        posicao.Longitude := -46.656010;
        MapView1.Location := posicao;

        // Zoom...
        MapView1.Zoom := 11;

        // Permissoes do GPS...
        {$IFDEF ANDROID}
        FAccess_Coarse_Location := JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION);
        FAccess_Fine_Location := JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION);
        {$ENDIF}
end;

procedure TForm1.rect_100Click(Sender: TObject);
begin
        Limpar_Carros;
        Localiza_Carros(minha_pos, TRoundRect(Sender).Tag);
end;

procedure TForm1.rect_localizacaoClick(Sender: TObject);
begin
        Animacao(true);

        {$IFDEF ANDROID}
        PermissionsService.RequestPermissions([FAccess_Coarse_Location,
                                               FAccess_Fine_Location],
                                               LocationPermissionRequestResult,
                                               DisplayRationale);
        {$ENDIF}

        {$IFDEF IOS}
        LocationSensor.Active := true;
        {$ENDIF}
end;

end.
