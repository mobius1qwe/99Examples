unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TabControl, FMX.ListBox, FMX.Layouts,
  FMX.VirtualKeyboard

  {$IFDEF ANDROID}
  ,Androidapi.Jni.Net, Androidapi.Jni.JavaTypes, Androidapi.Jni,
  Androidapi.JNIBridge, Androidapi.Helpers, FMX.Helpers.Android,
  Androidapi.Jni.GraphicsContentViewText
  {$ENDIF ANDROID}

  {$IFDEF IOS}
  ,Macapi.Helpers, iOSapi.Foundation, FMX.Helpers.iOS
  {$ENDIF IOS}

  ,FMX.Platform;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    btn_compartilhar: TSpeedButton;
    procedure btn_compartilharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btn_compartilharClick(Sender: TObject);
var
        mensagem : string;
        ret : boolean;

{$IFDEF ANDROID}
        IntentWhats : JIntent;
{$ENDIF ANDROID}

{$IFDEF IOS}
        NSU: NSUrl;
{$ENDIF IOS}
begin
        mensagem := 'Recomendo o canal 99 Coders: http://www.99coders.com.br';
        mensagem := 'whatsapp://send?text=' + mensagem;

        {$IFDEF ANDROID}
        IntentWhats := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
        IntentWhats.setType(StringToJString('text/plain'));
        IntentWhats.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(mensagem));
        IntentWhats.setPackage(StringToJString('com.whatsapp'));
        SharedActivity.startActivity(IntentWhats);
        {$ENDIF ANDROID}

        {$IFDEF IOS}
        NSU := StrToNSUrl(mensagem);
        ret := SharedApplication.openUrl(NSU);
        {$ENDIF IOS}

end;

end.
