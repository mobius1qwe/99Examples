unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, IPPeerClient,
  REST.Backend.PushTypes, System.JSON, REST.Backend.EMSPushDevice,
  System.PushNotification, REST.Backend.EMSProvider, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Backend.BindSource, REST.Backend.PushDevice,

  System.Net.HTTPClient

  ;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    PushEvents1: TPushEvents;
    EMSProvider1: TEMSProvider;
    procedure PushEvents1DeviceTokenReceived(Sender: TObject);
    procedure PushEvents1DeviceTokenRequestFailed(Sender: TObject;
      const AErrorMessage: string);
    procedure PushEvents1PushReceived(Sender: TObject; const AData: TPushData);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure Registra_Device(token : string);
begin
        // Envio o token para o servidor junto com o cod. do usuario...
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

procedure TForm1.PushEvents1DeviceTokenReceived(Sender: TObject);
begin
        memo1.Lines.Add(PushEvents1.DeviceToken);

        Registra_Device(PushEvents1.DeviceToken);
end;

procedure TForm1.PushEvents1DeviceTokenRequestFailed(Sender: TObject;
  const AErrorMessage: string);
begin
        //.....
end;

procedure TForm1.PushEvents1PushReceived(Sender: TObject;
  const AData: TPushData);
var
        x : integer;
begin
        showmessage(AData.Message);

        for x := 0 to Adata.Extras.Count - 1 do
                memo1.lines.Add(Adata.Extras[x].Key + ' = ' + Adata.Extras[x].Value);
end;

end.
