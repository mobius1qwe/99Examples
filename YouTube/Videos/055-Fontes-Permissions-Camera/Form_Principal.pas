unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  System.Permissions;

type
  TForm1 = class(TForm)
    img_camera: TImage;
    img_fotos: TImage;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    circle_foto: TCircle;
    Label1: TLabel;
    Label2: TLabel;
    Layout1: TLayout;
    ActionList1: TActionList;
    ActPhotoLibrary: TTakePhotoFromLibraryAction;
    ActPhotoCamera: TTakePhotoFromCameraAction;
    procedure FormActivate(Sender: TObject);
    procedure img_cameraClick(Sender: TObject);
    procedure img_fotosClick(Sender: TObject);
    procedure ActPhotoLibraryDidFinishTaking(Image: TBitmap);
    procedure ActPhotoCameraDidFinishTaking(Image: TBitmap);
  private
    { Private declarations }

    {$IFDEF ANDROID}
    PermissaoCamera, PermissaoReadStorage, PermissaoWriteStorage : string;
    procedure TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
    procedure DisplayMessageCamera(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
    procedure LibraryPermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
    procedure DisplayMessageLibrary(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
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
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
{$ENDIF}

;

{$IFDEF ANDROID}
procedure TForm1.TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 3 Permissoes: CAMERA, READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 3) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) and
           (AGrantResults[2] = TPermissionStatus.Granted) then
                ActPhotoCamera.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para tirar fotos');
end;

procedure TForm1.LibraryPermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 2 Permissoes: READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
                ActPhotoLibrary.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para acessar as fotos');
end;

procedure TForm1.ActPhotoCameraDidFinishTaking(Image: TBitmap);
begin
        circle_foto.Fill.Bitmap.Bitmap := Image;
end;

procedure TForm1.ActPhotoLibraryDidFinishTaking(Image: TBitmap);
begin
        circle_foto.Fill.Bitmap.Bitmap := Image;
end;

procedure TForm1.DisplayMessageCamera(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
begin
        TDialogService.ShowMessage('O app precisa acessar a câmera e as fotos do seu dispositivo',
                procedure(const AResult: TModalResult)
                begin
                        APostProc;
                end);
end;

procedure TForm1.DisplayMessageLibrary(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
begin
        TDialogService.ShowMessage('O app precisa acessar as fotos do seu dispositivo',
                procedure(const AResult: TModalResult)
                begin
                        APostProc;
                end);
end;
{$ENDIF}

procedure TForm1.FormActivate(Sender: TObject);
begin
        {$IFDEF ANDROID}
        PermissaoCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
        PermissaoReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
        PermissaoWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
        {$ENDIF}
end;

procedure TForm1.img_cameraClick(Sender: TObject);
begin
        {$IFDEF ANDROID}
        PermissionsService.RequestPermissions([PermissaoCamera,
                                               PermissaoReadStorage,
                                               PermissaoWriteStorage],
                                               TakePicturePermissionRequestResult,
                                               DisplayMessageCamera
                                               );
        {$ENDIF}

        {$IFDEF IOS}
        ActPhotoCamera.Execute;
        {$ENDIF}
end;

procedure TForm1.img_fotosClick(Sender: TObject);
begin
        {$IFDEF ANDROID}
        PermissionsService.RequestPermissions([PermissaoReadStorage,
                                               PermissaoWriteStorage],
                                               LibraryPermissionRequestResult,
                                               DisplayMessageLibrary
                                               );
        {$ENDIF}

        {$IFDEF IOS}
        ActPhotoLibrary.Execute;
        {$ENDIF}
end;

end.
