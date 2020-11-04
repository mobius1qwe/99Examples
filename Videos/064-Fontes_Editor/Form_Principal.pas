unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  System.Permissions;

type
  TFrm_Principal = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    Layout3: TLayout;
    Image2: TImage;
    Label1: TLabel;
    Image3: TImage;
    Label2: TLabel;
    Image4: TImage;
    Label3: TLabel;
    img_foto_fundo: TImage;
    img_foto_view: TImageViewer;
    ActionList1: TActionList;
    ActLibrary: TTakePhotoFromLibraryAction;
    ActFoto: TTakePhotoFromCameraAction;
    OpenDialog: TOpenDialog;
    procedure ActFotoDidFinishTaking(Image: TBitmap);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
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
  Frm_Principal: TFrm_Principal;

implementation

{$R *.fmx}

uses Form_Editor, FMX.DialogService

{$IFDEF ANDROID}
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
{$ENDIF}

;

{$IFDEF ANDROID}
procedure TFrm_Principal.TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 3 Permissoes: CAMERA, READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 3) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) and
           (AGrantResults[2] = TPermissionStatus.Granted) then
                ActFoto.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para tirar fotos');
end;

procedure TFrm_Principal.LibraryPermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 2 Permissoes: READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
                ActLibrary.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para acessar as fotos');
end;

procedure TFrm_Principal.DisplayMessageCamera(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
begin
        TDialogService.ShowMessage('O app precisa acessar a câmera e as fotos do seu dispositivo',
                procedure(const AResult: TModalResult)
                begin
                        APostProc;
                end);
end;

procedure TFrm_Principal.DisplayMessageLibrary(Sender: TObject;
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

procedure TFrm_Principal.ActFotoDidFinishTaking(Image: TBitmap);
begin
        if NOT Assigned(Frm_Editor) then
                Application.CreateForm(TFrm_Editor, Frm_Editor);

        Frm_Editor.imagem := Image;
        Frm_Editor.ShowModal(procedure (ModalResult : TModalResult)
                        begin
                                if NOT Frm_Editor.ind_cancelar then
                                begin
                                        img_foto_view.Bitmap.Assign(Frm_Editor.imagem);
                                        img_foto_view.BestFit;
                                end;
                        end);
end;

procedure TFrm_Principal.ActLibraryDidFinishTaking(Image: TBitmap);
begin
        if NOT Assigned(Frm_Editor) then
                Application.CreateForm(TFrm_Editor, Frm_Editor);

        Frm_Editor.imagem := Image;
        Frm_Editor.ShowModal(procedure (ModalResult : TModalResult)
                        begin
                                if NOT Frm_Editor.ind_cancelar then
                                begin
                                        img_foto_view.Bitmap.Assign(Frm_Editor.imagem);
                                        img_foto_view.BestFit;
                                end;
                        end);
end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
        {$IFDEF ANDROID}
        PermissaoCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
        PermissaoReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
        PermissaoWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
        {$ENDIF}
end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
        img_foto_fundo.Height := img_foto_fundo.Width;
end;

procedure TFrm_Principal.Image2Click(Sender: TObject);
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
        ActFoto.Execute;
        {$ENDIF}
end;

procedure TFrm_Principal.Image3Click(Sender: TObject);
begin
        {$IFDEF MSWINDOWS}
        if Frm_Principal.OpenDialog.Execute then
        begin
                Frm_Principal.img_foto_view.Bitmap.LoadFromFile(Frm_Principal.OpenDialog.FileName);
                Frm_Principal.img_foto_view.BitmapScale := 1;
                Frm_Principal.img_foto_view.BestFit;
        end;
        {$ENDIF}

        {$IFDEF ANDROID}
        PermissionsService.RequestPermissions([PermissaoReadStorage,
                                               PermissaoWriteStorage],
                                               LibraryPermissionRequestResult,
                                               DisplayMessageLibrary
                                               );
        {$ENDIF}

        {$IFDEF IOS}
        ActLibrary.Execute;
        {$ENDIF}
end;

procedure TFrm_Principal.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
        TImage(Sender).Opacity := 0.5;
end;

procedure TFrm_Principal.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
        TImage(Sender).Opacity := 1;
end;

procedure TFrm_Principal.Image4Click(Sender: TObject);
begin
        if NOT Assigned(Frm_Editor) then
                Application.CreateForm(TFrm_Editor, Frm_Editor);

        Frm_Editor.imagem := img_foto_view.Bitmap;
        Frm_Editor.ShowModal(procedure (ModalResult : TModalResult)
                        begin
                                if NOT Frm_Editor.ind_cancelar then
                                begin
                                        img_foto_view.Bitmap.Assign(Frm_Editor.imagem);
                                        img_foto_view.BestFit;
                                end;
                        end);

end;

end.
