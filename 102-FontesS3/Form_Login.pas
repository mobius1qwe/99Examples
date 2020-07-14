unit Form_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Types,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  u99Permissions, Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI;

type
  TFrm_Login = class(TForm)
    rect_enviar: TRoundRect;
    label2: TLabel;
    Layout1: TLayout;
    circle_foto: TCircle;
    Layout2: TLayout;
    rect_download: TRoundRect;
    Label1: TLabel;
    Label3: TLabel;
    ActionList1: TActionList;
    ActLibrary: TTakePhotoFromLibraryAction;
    OpenDialog: TOpenDialog;
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure circle_fotoClick(Sender: TObject);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure rect_enviarClick(Sender: TObject);
    procedure rect_downloadClick(Sender: TObject);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure ErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Frm_Login: TFrm_Login;

implementation

{$R *.fmx}

procedure TFrm_Login.ErroPermissao(Sender: TObject);
begin
    showmessage('Você não tem permissão para acessar a biblioteca de fotos');
end;

procedure TFrm_Login.ActLibraryDidFinishTaking(Image: TBitmap);
begin
    circle_foto.Fill.Bitmap.Bitmap := Image;
end;

procedure TFrm_Login.circle_fotoClick(Sender: TObject);
begin
    {$IFDEF ANDROID}
    permissao.PhotoLibrary(ActLibrary, ErroPermissao);
    {$ELSE}

    if OpenDialog.Execute then
        circle_foto.Fill.Bitmap.Bitmap.LoadFromFile(OpenDialog.FileName);

    {$ENDIF}
end;

procedure TFrm_Login.FormCreate(Sender: TObject);
begin
    permissao := T99Permissions.Create;
end;

procedure TFrm_Login.FormDestroy(Sender: TObject);
begin
    permissao.DisposeOf;
end;

procedure TFrm_Login.rect_downloadClick(Sender: TObject);
var
    StorageService : TAmazonStorageService;
    img_stream : TBytesStream;
    Response : TCloudResponseInfo;
begin
    try
        StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
        Response := TCloudResponseInfo.Create;

        img_stream := TBytesStream.Create;

        if StorageService.GetObject('teste99cod', 'foto_perfil.jpg', img_stream, Response) then
            circle_foto.Fill.Bitmap.Bitmap.LoadFromStream(img_stream)
        else
            showmessage('Erro ao buscar objeto: ' + Response.StatusMessage);

    finally
        Response.DisposeOf;
        img_stream.DisposeOf;
        StorageService.DisposeOf;
    end;
end;

procedure TFrm_Login.rect_enviarClick(Sender: TObject);
var
    StorageService : TAmazonStorageService;
    img_stream : TBytesStream;
    Metadata, Header : TStringList;
    Response : TCloudResponseInfo;
begin
    try
        StorageService := TAmazonStorageService.Create(AmazonConnectionInfo1);
        Response := TCloudResponseInfo.Create;

        Metadata := TStringList.Create;
        Metadata.Values['Obs'] := 'Teste de upload';

        Header := TStringList.Create;
        Header.Values['Content-Type'] := 'image/jpeg';

        img_stream := TBytesStream.Create;
        circle_foto.Fill.Bitmap.Bitmap.SaveToStream(img_stream);

        if StorageService.UploadObject('teste99cod',
                                       'foto_perfil.jpg',
                                       img_stream.Bytes,
                                       false,
                                       Metadata,
                                       Header,
                                       amzbaPublicReadWrite,
                                       Response) then
            showmessage('Objeto enviado com sucesso')
        else
            showmessage('Erro ao enviar objeto: ' + Response.StatusMessage);

    finally
        Response.DisposeOf;
        Header.DisposeOf;
        Metadata.DisposeOf;
        img_stream.DisposeOf;
        StorageService.DisposeOf;
    end;
end;

end.
