unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Maps, FMX.Objects, FMX.Edit,
  FMX.Ani, System.Permissions, System.Sensors, System.Sensors.Components;

type
  TForm1 = class(TForm)
    MapView1: TMapView;
    p_menu: TPanel;
    Rectangle2: TRectangle;
    img_car: TImage;
    rect_localizacao: TRoundRect;
    lbl_botao: TLabel;
    LocationSensor: TLocationSensor;
    procedure FormCreate(Sender: TObject);
    procedure rect_localizacaoClick(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
  private
    { Private declarations }

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
  begin
        lbl_botao.Text := 'Localizando...';
        LocationSensor.Active := true;
  end
  else
    TDialogService.ShowMessage
      ('Não é possível acessar o GPS porque o app não possui acesso')

end;

{$ENDIF}

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
        marcador := TMapMarkerDescriptor.Create(posicao, 'Citroen C3');
        marcador.Snippet := 'Placa: ABC-1234';
        marcador.Visible := true;

        // Icone do marcador...
        marcador.Icon := img_car.Bitmap;

        // Adiciona marcardor no mapa...
        MapView1.AddMarker(marcador);

        // Centraliza mapa no marcador...
        MapView1.Location := posicao;

        // Zoom...
        MapView1.Zoom := 17;

        lbl_botao.Text := 'Obter Localização';
end;


procedure TForm1.FormCreate(Sender: TObject);
var
        posicao : TMapCoordinate;
begin
        MapView1.MapType := TMapType.Normal;
        img_car.Visible := false;

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



procedure TForm1.rect_localizacaoClick(Sender: TObject);
begin
        {$IFDEF ANDROID}
        PermissionsService.RequestPermissions([FAccess_Coarse_Location,
                                               FAccess_Fine_Location],
                                               LocationPermissionRequestResult,
                                               DisplayRationale);
        {$ENDIF}

        {$IFDEF IOS}
        lbl_botao.text := 'Localizando...';
        LocationSensor.Active := true;
        {$ENDIF}
end;

end.
