unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects

  {$IFDEF ANDROID}
  ,Androidapi.JNI.Os, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,  Androidapi.JNIBridge
  {$ENDIF}

  ;

type
  TForm1 = class(TForm)
    rect_vibrar: TRectangle;
    Label1: TLabel;
    procedure rect_vibrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Vibrar(tempo : Integer);
{$IFDEF ANDROID}
var
    vibrar : JVibrator;
{$ENDIF}
begin
    {$IFDEF ANDROID}
    vibrar := TJVibrator.Wrap((SharedActivityContext.getSystemService(tjcontext.JavaClass.VIBRATOR_SERVICE) as ILocalObject).GetObjectID);
    vibrar.vibrate(tempo);
    {$ENDIF}
end;

procedure TForm1.rect_vibrarClick(Sender: TObject);
begin
    Vibrar(500);
    sleep(1500);
    Vibrar(500);
    sleep(1500);
    Vibrar(500);
end;

end.
