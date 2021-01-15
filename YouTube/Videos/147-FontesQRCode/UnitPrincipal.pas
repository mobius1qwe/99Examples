unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, u99permissions;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Layout1: TLayout;
    img_camera: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img_cameraClick(Sender: TObject);
  private
    permissao : T99Permissions;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses UnitCamera;

procedure TForm1.FormCreate(Sender: TObject);
begin
    permissao := T99Permissions.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    permissao.DisposeOf;
end;

procedure TForm1.img_cameraClick(Sender: TObject);
begin
    if NOT permissao.VerifyCameraAccess then
        permissao.Camera(nil, nil)
    else
    begin
        FrmCamera.ShowModal(procedure(ModalResult: TModalResult)
        begin
            Label1.Text := FrmCamera.codigo;
        end);
    end;
end;

end.
