unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, IPPeerClient,
  REST.Backend.PushTypes, System.JSON, REST.Backend.EMSPushDevice,
  System.PushNotification, REST.Backend.EMSProvider, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Backend.BindSource, REST.Backend.PushDevice,
  FMX.Platform,

  System.Threading,
  System.Net.HTTPClient, System.Notification

  ;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    PushEvents1: TPushEvents;
    EMSProvider1: TEMSProvider;
    NotificationCenter: TNotificationCenter;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoReceiveNotificationEvent(Sender: TObject; const ServiceNotification: TPushServiceNotification);
    procedure DoServiceConnectionChange(Sender: TObject; PushChanges: TPushService.TChanges);
    procedure FormCreate(Sender: TObject);
    function AppEventProc(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
    PushService: TPushService;
    ServiceConnection: TPushServiceConnection;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure Registra_Device(token : string);
begin
        // Envio o token para o servidor junto com o cod. do usuario...
end;

procedure CancelarNotificacao(nome : string);
begin
    with Form1 do
    begin
        if nome = '' then
            NotificationCenter.CancelAll
        else
            NotificationCenter.CancelNotification(nome);
    end;
end;

procedure TForm1.DoReceiveNotificationEvent(Sender: TObject; const ServiceNotification: TPushServiceNotification);
var
        MessageText: string;
        x: Integer;
        obj : TJSONObject;
        MyJSONPair : TJSONPair;
begin
        //MessageText := ServiceNotification.DataObject.GetValue('message').Value;


        try
                for x := 0 to ServiceNotification.DataObject.Count - 1 do
                begin
                        // iOS...
                        if ServiceNotification.DataKey = 'aps' then
                        begin
                                if ServiceNotification.DataObject.Pairs[x].JsonString.Value = 'alert' then
                                        MessageText := ServiceNotification.DataObject.Pairs[x].JsonValue.Value;
                        end;

                        // Android...
                        if ServiceNotification.DataKey = 'gcm' then
                        begin
                                if ServiceNotification.DataObject.Pairs[x].JsonString.Value = 'message' then
                                        MessageText := ServiceNotification.DataObject.Pairs[x].JsonValue.Value;
                        end;

                end;

        except on ex:exception do
                //showmessage(ex.Message);
        end;

        Memo1.Lines.Add(MessageText);


end;

procedure TForm1.DoServiceConnectionChange(Sender: TObject; PushChanges: TPushService.TChanges);
var
        device_token : string;
begin
        if TPushService.TChange.DeviceToken in PushChanges then
                device_token := PushService.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];

        memo1.Lines.Add(device_token);

        Registra_Device(device_token);
end;

procedure TForm1.FormActivate(Sender: TObject);
var
        Notif:  TPushData;
        x : integer;
begin
        notif := form1.PushEvents1.StartupNotification; // notificaoes que abriram meu app...

        try
                if Assigned(notif) then
                begin
                        showmessage(notif.Message);

                        // Android...
                        if PushEvents1.StartupNotification.GCM.Message <> '' then
                        begin
                                for x := 0 to notif.Extras.Count - 1 do
                                        memo1.lines.Add(notif.Extras[x].Key + ' = ' + notif.Extras[x].Value);
                        end;

                        // iOS...
                        if PushEvents1.StartupNotification.APS.Alert <> '' then
                        begin
                                for x := 0 to notif.Extras.Count - 1 do
                                        memo1.lines.Add(notif.Extras[x].Key + ' = ' + notif.Extras[x].Value);
                        end;
                end;

        finally
                notif.DisposeOf;
        end;
end;

function TForm1.AppEventProc(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
begin
    if (AAppEvent = TApplicationEvent.BecameActive) then
        CancelarNotificacao('');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    AppEvent : IFMXApplicationEventService;
begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(AppEvent)) then
    begin
            AppEvent.SetApplicationEventHandler(AppEventProc);
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        // Notificações Push...
        {$IFDEF IOS}
                PushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.APS);
                ServiceConnection := TPushServiceConnection.Create(PushService);
                ServiceConnection.OnChange := DoServiceConnectionChange;
                ServiceConnection.OnReceiveNotification := DoReceiveNotificationEvent;
                TTask.run(procedure
                begin
                        ServiceConnection.Active := True;
                end);
        {$ELSE}
                PushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.GCM);
                PushService.AppProps[TPushService.TAppPropNames.GCMAppID] := '?????????????'; // Troque aqui e no componente EMSProvider...
                ServiceConnection := TPushServiceConnection.Create(PushService);
                ServiceConnection.OnChange := DoServiceConnectionChange;
                ServiceConnection.OnReceiveNotification := DoReceiveNotificationEvent;

                TTask.run(procedure
                begin
                        ServiceConnection.Active := True;
                end);

        {$ENDIF}
         //-------------------
end;

end.
