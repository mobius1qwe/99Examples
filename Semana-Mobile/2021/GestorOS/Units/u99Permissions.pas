/////////////////////////////////////////////////////////////////////////////
{
    Unit u99Permissions
    Criação: 99 Coders (Heber Stein Mazutti - heber@99coders.com.br)
    Versão: 1.1
}
/////////////////////////////////////////////////////////////////////////////

unit u99Permissions;

interface

uses System.Permissions, FMX.DialogService, FMX.MediaLibrary.Actions

{$IFDEF ANDROID}
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
{$ENDIF}


;

type
    TCallbackProc = procedure(Sender: TObject) of Object;

    T99Permissions = class
    private
        CurrentRequest : string;
        pCamera, pReadStorage, pWriteStorage : string; // Camera / Library
        pFineLocation, pCoarseLocation : string; // GPS
        pPhoneState : string; // Phone State

        procedure PermissionRequestResult( Sender: TObject;
                    const APermissions: TArray<string>;
                    const AGrantResults: TArray<TPermissionStatus>);
    public
        MyCallBack, MyCallBackError : TCallbackProc;
        MyCameraAction : TTakePhotoFromCameraAction;
        MyLibraryAction : TTakePhotoFromLibraryAction;

        constructor Create;
        function VerifyCameraAccess(): boolean;
        procedure Camera(ActionPhoto: TTakePhotoFromCameraAction;
                          ACallBackError: TCallbackProc = nil);
        procedure PhotoLibrary(ActionLibrary: TTakePhotoFromLibraryAction;
                        ACallBackError: TCallbackProc = nil);
        procedure Location(ACallBack: TCallbackProc = nil;
                        ACallBackError: TCallbackProc = nil);
        procedure PhoneState(ACallBack: TCallbackProc = nil;
                        ACallBackError: TCallbackProc = nil);
        procedure ReadWriteFiles(ACallBack: TCallbackProc = nil;
                                 ACallBackError: TCallbackProc = nil);
    published
        //property CameraGranted: boolean read FCameraGranted write FCameraGranted;
end;

implementation

function T99Permissions.VerifyCameraAccess(): boolean;
begin
    Result := false;

    {$IFDEF ANDROID}
    Result := PermissionsService.IsEveryPermissionGranted([pCamera,
                                                           pReadStorage,
                                                           pWriteStorage]);
    {$ENDIF}
end;

constructor T99Permissions.Create();
begin
    {$IFDEF ANDROID}
    pCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
    pReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    pWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
    pCoarseLocation := JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION);
    pFineLocation := JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION);
    pPhoneState := JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE);
    {$ENDIF}
end;

procedure T99Permissions.PermissionRequestResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
var
    ret : boolean;
begin
    ret := false;

    // CAMERA (CAMERA + READ_EXTERNAL_STORAGE + WRITE_EXTERNAL_STORAGE)
    if CurrentRequest = 'CAMERA' then
    begin
        if (Length(AGrantResults) = 3) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) and
           (AGrantResults[2] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyCameraAction) then
                MyCameraAction.Execute;
        end;
    end;

    // LIBRARY (READ_EXTERNAL_STORAGE + WRITE_EXTERNAL_STORAGE)
    if CurrentRequest = 'LIBRARY' then
    begin        
        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyLibraryAction) then
                MyLibraryAction.Execute;
        end;
    end;

    // LOCATION (ACCESS_COARSE_LOCATION + ACCESS_FINE_LOCATION)
    if CurrentRequest = 'LOCATION' then
    begin
        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
        begin
            ret := true;
            
            if Assigned(MyCallBack) then            
                MyCallBack(Self);
        end;
    end;

    // PHONE STATE
    if CurrentRequest = 'READ_PHONE_STATE' then
    begin
        if (Length(AGrantResults) = 1) and
           (AGrantResults[0] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyCallBack) then
                MyCallBack(Self);
        end;
    end;

    // READ WRITE FILES (READ_EXTERNAL_STORAGE + WRITE_EXTERNAL_STORAGE)
    if CurrentRequest = 'READ_WRITE_FILES' then
    begin
        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
        begin
            ret := true;

            if Assigned(MyCallBack) then
                MyCallBack(Self);
        end;
    end;

    if NOT ret then    
    begin
        if Assigned(MyCallBackError) then
            MyCallBackError(Self);
    end;
end;

procedure T99Permissions.Camera(ActionPhoto: TTakePhotoFromCameraAction;
                                ACallBackError: TCallbackProc = nil);
begin
    MyCameraAction := ActionPhoto;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'CAMERA';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pCamera, pReadStorage, pWriteStorage],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    if Assigned(MyCameraAction) then
        MyCameraAction.Execute;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('Não suportado no Windows');
    {$ENDIF}
end;

procedure T99Permissions.ReadWriteFiles(ACallBack: TCallbackProc = nil;
                                  ACallBackError: TCallbackProc = nil);
begin
    MyCallBack := ACallBack;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'READ_WRITE_FILES';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pReadStorage, pWriteStorage],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    if Assigned(MyCameraAction) then
        MyCameraAction.Execute;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    if Assigned(ACallBack) then
        ACallBack(Self);
    {$ENDIF}
end;

procedure T99Permissions.PhotoLibrary(ActionLibrary: TTakePhotoFromLibraryAction;
                                      ACallBackError: TCallbackProc = nil);
begin
    MyLibraryAction := ActionLibrary;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'LIBRARY';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pReadStorage, pWriteStorage],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    ActionLibrary.Execute;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('Não suportado no Windows');
    {$ENDIF}
end;


procedure T99Permissions.Location(ACallBack: TCallbackProc = nil;
                                  ACallBackError: TCallbackProc = nil);
begin
    MyCallBack := ACallBack;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'LOCATION';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pCoarseLocation, pFineLocation],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    if Assigned(MyCallBack) then
        ACallBack(Self);
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('Não suportado no Windows');
    {$ENDIF}
end;

procedure T99Permissions.PhoneState(ACallBack: TCallbackProc = nil;
                                  ACallBackError: TCallbackProc = nil);
begin
    MyCallBack := ACallBack;
    MyCallBackError := ACallBackError;
    CurrentRequest := 'READ_PHONE_STATE';

    {$IFDEF ANDROID}
    PermissionsService.RequestPermissions([pPhoneState],
                                           PermissionRequestResult);
    {$ENDIF}

    {$IFDEF IOS}
    if Assigned(MyCallBack) then
        ACallBack(Self);
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    TDialogService.ShowMessage('Não suportado no Windows');
    {$ENDIF}
end;

end.
