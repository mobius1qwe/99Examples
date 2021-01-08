unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, u99permissions, System.Actions, FMX.ActnList;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_camera: TImage;
    img_foto: TImage;
    procedure img_cameraClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    permissao : T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitCamera;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    permissao.DisposeOf;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    permissao := T99Permissions.Create;
end;

procedure TFrmPrincipal.TrataErroPermissao(Sender: TObject);
begin
    showmessage('Você não possui acesso a câmera');
end;

procedure TFrmPrincipal.img_cameraClick(Sender: TObject);
begin
    if NOT permissao.VerifyCameraAccess then
    begin
        permissao.Camera(nil, TrataErroPermissao);
        exit;
    end
    else
    begin
        FrmCamera.ShowModal(procedure(Modal: TModalResult)
        begin
            if NOT FrmCamera.cancel then
                FrmPrincipal.img_foto.Bitmap := FrmCamera.img_camera.MakeScreenshot;
        end);
    end;
end;

end.
