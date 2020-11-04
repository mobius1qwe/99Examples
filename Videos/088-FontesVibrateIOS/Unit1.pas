unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Platform,
  FMX.Controls.Presentation

{$IFDEF ANDROID}
  ,Androidapi.JNI.Os,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
{$ENDIF}
{$IFDEF IOS}
  ,IOSapi.MediaPlayer,  IOSapi.CoreGraphics,  FMX.Platform.IOS,  IOSapi.UIKit,
  Macapi.ObjCRuntime, Macapi.ObjectiveC,  iOSapi.Cocoatypes,
  Macapi.CoreFoundation,  iOSapi.Foundation,  iOSapi.CoreImage,
  iOSapi.QuartzCore,  iOSapi.CoreData,
{$ENDIF}

  FMX.StdCtrls, FMX.Objects;

{$IFDEF IOS}
Const
  libAudioToolbox = '/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox';
  kSystemSoundID_vibrate = $FFF;

Procedure AudioServicesPlaySystemSound( inSystemSoundID: integer ); Cdecl; External libAudioToolbox Name _PU + 'AudioServicesPlaySystemSound';
{$ENDIF}

type
  TForm1 = class(TForm)
    rect_vibrar: TRectangle;
    Label1: TLabel;
    Image1: TImage;
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

procedure TForm1.rect_vibrarClick(Sender: TObject);
{$IFDEF ANDROID}
Var
  Vibrator:JVibrator;
{$ENDIF}
begin
{$IFDEF ANDROID}
  Vibrator:=TJVibrator.Wrap((SharedActivityContext.getSystemService(TJContext.JavaClass.VIBRATOR_SERVICE) as ILocalObject).GetObjectID);
  Vibrator.vibrate(100);
{$ENDIF}

{$IFDEF IOS}
  AudioServicesPlaySystemSound( kSystemSoundID_vibrate );
{$ENDIF}

end;


end.
