unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, System.Notification,
  DateUtils;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Layout2: TLayout;
    Image1: TImage;
    Label3: TLabel;
    Image2: TImage;
    Layout3: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Label6: TLabel;
    NotificationCenter: TNotificationCenter;
    procedure Image3Click(Sender: TObject);
    procedure NotificationCenterReceiveLocalNotification(Sender: TObject;
      ANotification: TNotification);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Enviar_Notificacao(nome, titulo, texto : string);
var
        MinhaNotificacao : TNotification;
begin
        with Form1 do
        begin
                MinhaNotificacao := NotificationCenter.CreateNotification;

                try
                        MinhaNotificacao.Name := nome;
                        MinhaNotificacao.Title := titulo;
                        MinhaNotificacao.AlertBody := texto;

                        NotificationCenter.PresentNotification(MinhaNotificacao);
                finally
                        MinhaNotificacao.DisposeOf;
                end;
        end;
end;


procedure Enviar_Notificacao_Agendada(nome, titulo, texto : string; segundos : integer);
var
        MinhaNotificacao : TNotification;
begin
        with Form1 do
        begin
                MinhaNotificacao := NotificationCenter.CreateNotification;

                try
                        MinhaNotificacao.Name := nome;
                        MinhaNotificacao.Title := titulo;
                        MinhaNotificacao.AlertBody := texto;
                        MinhaNotificacao.FireDate := IncSecond(now, segundos);

                        //NotificationCenter.PresentNotification(MinhaNotificacao);
                        NotificationCenter.ScheduleNotification(MinhaNotificacao);
                finally
                        MinhaNotificacao.DisposeOf;
                end;
        end;
end;

procedure Cancelar_Notificacao(nome : string);
begin
        with form1 do
        begin
                if nome = '' then
                        NotificationCenter.CancelAll
                else
                        NotificationCenter.CancelNotification(nome);
        end;
end;


procedure TForm1.FormShow(Sender: TObject);
begin
        Enviar_Notificacao_Agendada('Compra100', 'Aproveite', 'A promoção acaba em 1 dia.', 10);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
        Cancelar_Notificacao('Compra200');
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
        Enviar_Notificacao('Compra100', 'Parabéns pela 100a compra', 'Ganhou um desconto de R$ 100,00 na próxima compra.');
        Enviar_Notificacao('Compra200', 'Parabéns pela 200a compra', 'Ganhou um desconto de R$ 100,00 na próxima compra.');
        Enviar_Notificacao('Compra300', 'Parabéns pela 300a compra', 'Ganhou um desconto de R$ 100,00 na próxima compra.');
end;

procedure TForm1.NotificationCenterReceiveLocalNotification(Sender: TObject;
  ANotification: TNotification);
begin
        if ANotification.Name = 'Compra100' then
                ShowMessage('Utilize o cupom ABCDE para ganhar R$ 100,00 na próxima compra');

end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
        Cancelar_Notificacao('');
end;

end.
