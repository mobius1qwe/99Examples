unit UnitCamera;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Media, FMX.Layouts, FMX.Effects, FMX.Filter.Effects;

type
  TFrmCamera = class(TForm)
    CameraComponent: TCameraComponent;
    img_camera: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Layout1: TLayout;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    MonochromeEffect1: TMonochromeEffect;
    procedure CameraComponentSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
  private
    procedure QualityCamera(quality: TVideoCaptureQuality);
    { Private declarations }
  public
    { Public declarations }
    cancel : Boolean;
  end;

var
  FrmCamera: TFrmCamera;

implementation

{$R *.fmx}

procedure TFrmCamera.QualityCamera(quality: TVideoCaptureQuality);
begin
    CameraComponent.Active := false;
    CameraComponent.Quality := quality;
    CameraComponent.Active := true;
end;

procedure TFrmCamera.CameraComponentSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
    CameraComponent.SampleBufferToBitmap(img_camera.Bitmap, true);
end;

procedure TFrmCamera.FormShow(Sender: TObject);
begin
    CameraComponent.Active := true;
end;

procedure TFrmCamera.Image1Click(Sender: TObject);
begin
    cancel := true;
    CameraComponent.Active := false;
    Close;
end;

procedure TFrmCamera.Image2Click(Sender: TObject);
begin
    QualityCamera(TVideoCaptureQuality.LowQuality);
end;

procedure TFrmCamera.Image3Click(Sender: TObject);
begin
    QualityCamera(TVideoCaptureQuality.MediumQuality);
end;

procedure TFrmCamera.Image4Click(Sender: TObject);
begin
    QualityCamera(TVideoCaptureQuality.HighQuality);
end;

procedure TFrmCamera.Image5Click(Sender: TObject);
begin
    cancel := false;
    CameraComponent.SampleBufferToBitmap(img_camera.Bitmap, true);
    CameraComponent.Active := false;
    Close;
end;

procedure TFrmCamera.Image6Click(Sender: TObject);
begin
    MonochromeEffect1.Enabled := NOT MonochromeEffect1.Enabled;
end;

procedure TFrmCamera.Image7Click(Sender: TObject);
begin
    CameraComponent.Active := false;

    if CameraComponent.Kind = TCameraKind.FrontCamera then
        CameraComponent.Kind := TCameraKind.BackCamera
    else
        CameraComponent.Kind := TCameraKind.FrontCamera;

    CameraComponent.Active := true;
end;

end.
