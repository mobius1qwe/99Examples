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

  {$IFDEF ANDROID}
  FMX.PushNotification.Android,
  {$ENDIF}

  System.Threading,
  System.Net.HTTPClient, System.Notification

  ;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    NotificationCenter: TNotificationCenter;
    procedure FormActivate(Sender: TObject);
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
begin
        MessageText := '';

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
                        if ServiceNotification.DataKey = 'fcm' then
                        begin
                                // Firebase console...
                                if ServiceNotification.DataObject.Pairs[x].JsonString.Value = 'gcm.notification.body' then
                                        MessageText := ServiceNotification.DataObject.Pairs[x].JsonValue.Value;

                                // Nosso server...
                                if ServiceNotification.DataObject.Pairs[x].JsonString.Value = 'mensagem' then
                                        MessageText := ServiceNotification.DataObject.Pairs[x].JsonValue.Value;
                        end;

                        if Length(MessageText) > 0 then
                            break;

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

        memo1.Lines.Add('Token:');
        memo1.Lines.Add(device_token);
        memo1.Lines.Add('-----------------------------');

        Registra_Device(device_token);
end;

procedure TForm1.FormActivate(Sender: TObject);
var
        Notifications : TArray<TPushServiceNotification>;
        x : integer;
begin
        Notifications := PushService.StartupNotifications; // notificaoes que abriram meu app...

        if Length(Notifications) > 0 then
        begin
            // Android...
            if Notifications[0].DataKey = 'fcm' then
            begin
                    for x := 0 to Notifications[0].DataObject.Count - 1 do
                        memo1.lines.Add(Notifications[0].DataObject.Pairs[x].JsonString.Value + ' = ' +
                                        Notifications[0].DataObject.Pairs[x].JsonValue.Value);

            end;

            // iOS...
            if Notifications[0].DataKey = 'aps' then
            begin
                    for x := 0 to Notifications[0].DataObject.Count - 1 do
                        memo1.lines.Add(Notifications[0].DataObject.Pairs[x].JsonString.Value + ' = ' +
                                        Notifications[0].DataObject.Pairs[x].JsonValue.Value);

            end;
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
    // Eventos do app (para exclusao das notificacoes)...
    if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(AppEvent)) then
        AppEvent.SetApplicationEventHandler(AppEventProc);

    // Notificações Push...
    {$IFDEF IOS}
    PushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.APS);
    {$ELSE}
    PushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.GCM);
    {$ENDIF}

    ServiceConnection := TPushServiceConnection.Create(PushService);
    ServiceConnection.OnChange := DoServiceConnectionChange;
    ServiceConnection.OnReceiveNotification := DoReceiveNotificationEvent;
    ServiceConnection.Active := True;

end;

end.
