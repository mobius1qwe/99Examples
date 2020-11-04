unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.WebBrowser, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  System.Permissions, System.Sensors, System.Sensors.Components;

type
  TForm1 = class(TForm)
    WebBrowser: TWebBrowser;
    Layout1: TLayout;
    Switch: TSwitch;
    Label1: TLabel;
    Layout2: TLayout;
    RoundRect1: TRoundRect;
    lbl_endereco: TLabel;
    LocationSensor: TLocationSensor;
    procedure FormCreate(Sender: TObject);
    procedure SwitchClick(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure lbl_enderecoClick(Sender: TObject);
  private
    { Private declarations }
    Location: TLocationCoord2D;
    FGeocoder: TGeocoder;

    {$IFDEF ANDROID}
     Access_Fine_Location, Access_Coarse_Location : string;
     procedure DisplayRationale(Sender: TObject;
              const APermissions: TArray<string>; const APostRationaleProc: TProc);
     procedure LocationPermissionRequestResult
                (Sender: TObject; const APermissions: TArray<string>;
                const AGrantResults: TArray<TPermissionStatus>);
    {$ENDIF}

    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses FMX.DialogService

{$IFDEF ANDROID}
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
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
    if (APermissions[I] = Access_Coarse_Location) or (APermissions[I] = Access_Fine_Location) then
      RationaleMsg := 'O app precisa de acesso ao GPS para obter sua localização'
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
    Form1.LocationSensor.Active := true
  else
  begin
    Switch.IsChecked := false;
    TDialogService.ShowMessage
      ('Não é possível acessar o GPS porque o app não possui acesso')
  end;

end;

{$ENDIF}

procedure TForm1.OnGeocodeReverseEvent(const Address: TCivicAddress);
var
        msg : string;
begin
        msg :=  Address.AdminArea + ', ' +
                Address.CountryCode + ', ' +
                Address.CountryName + ', ' +
                Address.FeatureName + ', ' +
                Address.Locality + ', ' +
                Address.PostalCode + ', ' +
                Address.SubAdminArea + ', ' +
                Address.SubLocality + ', ' +
                Address.SubThoroughfare + ', ' +
                Address.Thoroughfare;

        TDialogService.ShowMessage(msg);
end;

procedure TForm1.LocationSensorLocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
var
        lt, lg, url : string;
begin
        Location := NewLocation;
        lt := StringReplace(Format('%2.6f', [NewLocation.Latitude]), ',', '.', [rfReplaceAll]);
        lg := StringReplace(Format('%2.6f', [NewLocation.Longitude]), ',', '.', [rfReplaceAll]);

        LocationSensor.Active := false;
        Switch.IsChecked := false;

        url := 'https://maps.google.com/maps?q=' + lt + ',' + lg;
        WebBrowser.Navigate(url);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
        {$IFDEF ANDROID}
        Access_Coarse_Location := JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION);
        Access_Fine_Location := JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION);
        {$ENDIF}
end;



procedure TForm1.lbl_enderecoClick(Sender: TObject);
begin
        try
                // Tratando a instancia TGeocoder...
                if not Assigned(FGeocoder) then
                begin
                        if Assigned(TGeocoder.Current) then
                                FGeocoder := TGeocoder.Current.Create;

                        if Assigned(FGeocoder) then
                                FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
                end;

                // Tratar a traducao do endereco...
                if Assigned(FGeocoder) and not FGeocoder.Geocoding then
                        FGeocoder.GeocodeReverse(Location);
        except
                showmessage('Erro no serviço Geocoder');
        end;
end;

procedure TForm1.SwitchClick(Sender: TObject);
begin
        if Switch.IsChecked then
        begin
                {$IFDEF ANDROID}
                PermissionsService.RequestPermissions([Access_Coarse_Location,
                                                       Access_Fine_Location],
                                                       LocationPermissionRequestResult,
                                                       DisplayRationale);
                {$ENDIF}

                {$IFDEF IOS}
                LocationSensor.Active := true;
                {$ENDIF}
        end;
end;




end.
