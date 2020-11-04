unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Ani;

type
  TFrmLogin = class(TForm)
    Image1: TImage;
    layout_campos: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Image2: TImage;
    edt_usuario: TEdit;
    StyleBook1: TStyleBook;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    Image3: TImage;
    edt_senha: TEdit;
    rect_botao: TRectangle;
    Label1: TLabel;
    Layout4: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    FloatAnimation1: TFloatAnimation;
    img_loading: TImage;
    FloatAnimation2: TFloatAnimation;
    FloatAnimation3: TFloatAnimation;
    procedure FormCreate(Sender: TObject);
    procedure rect_botaoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_botaoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_botaoClick(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

procedure TFrmLogin.FloatAnimation1Finish(Sender: TObject);
begin
    layout_campos.Visible := false;
    img_loading.Visible := true;
    FloatAnimation2.Start;
    FloatAnimation3.Start;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    edt_usuario.Margins.Top := 5;
    edt_senha.Margins.Top := 5;
    {$ENDIF}
end;

procedure TFrmLogin.rect_botaoClick(Sender: TObject);
begin
    FloatAnimation1.Start;
end;

procedure TFrmLogin.rect_botaoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TRectangle(Sender).Opacity := 0.8;
end;

procedure TFrmLogin.rect_botaoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    TRectangle(Sender).Opacity := 1;
end;

end.
