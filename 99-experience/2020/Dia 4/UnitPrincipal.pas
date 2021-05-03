unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Ani;

type
  TForm1 = class(TForm)
    img_menu: TImage;
    img_config: TImage;
    img_chart: TImage;
    layout_menu: TLayout;
    img_check: TImage;
    img_favorite: TImage;
    img_location: TImage;
    img_chat: TImage;
    img_new: TImage;
    img_refresh: TImage;
    img_search: TImage;
    img_lock: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    img_opcoes: TImage;
    AnimationOpcoes: TFloatAnimation;
    AnimationMenuOpacity: TFloatAnimation;
    Image1: TImage;
    img_seta1: TImage;
    AnimationSeta: TFloatAnimation;
    AnimationMexer: TFloatAnimation;
    procedure layout_menuMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure layout_menuMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure layout_menuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure img_chatClick(Sender: TObject);
    procedure img_opcoesClick(Sender: TObject);
    procedure AnimationMenuProcess(Sender: TObject);
    procedure AnimationMenuOpacityFinish(Sender: TObject);
    procedure AnimationOpcoesFinish(Sender: TObject);
  private
    Pressed: Boolean;
    PosY, CurrentRotation : single;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AnimationMenuOpacityFinish(Sender: TObject);
begin
    AnimationMexer.Start;

    AnimationMenuOpacity.Inverse := NOT AnimationMenuOpacity.Inverse;
end;

procedure TForm1.AnimationMenuProcess(Sender: TObject);
begin
    img_menu.Width := img_menu.Height;
end;

procedure TForm1.AnimationOpcoesFinish(Sender: TObject);
begin
    AnimationOpcoes.Inverse := NOT AnimationOpcoes.Inverse;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Pressed := false;
    img_menu.Opacity := 0;
    img_seta1.Opacity := 0;
end;

procedure TForm1.img_chatClick(Sender: TObject);
begin
    showmessage('Click');
end;

procedure TForm1.img_opcoesClick(Sender: TObject);
begin
    AnimationSeta.Inverse := AnimationMenuOpacity.Inverse;
    AnimationSeta.Start;

    AnimationOpcoes.Start;
    AnimationMenuOpacity.Start;
end;

procedure TForm1.layout_menuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    layout_menu.Root.Captured := layout_menu;
    Pressed := true;
    PosY := Y;
    CurrentRotation := img_menu.RotationAngle;
end;

procedure TForm1.layout_menuMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
     if Pressed and (ssLeft In Shift) then
    begin

        img_menu.RotationAngle := CurrentRotation + ((PosY - Y) / 3);


        img_chart.RotationAngle := img_menu.RotationAngle * -1;
        img_config.RotationAngle := img_menu.RotationAngle * -1;
        img_check.RotationAngle := img_menu.RotationAngle * -1;
        img_favorite.RotationAngle := img_menu.RotationAngle * -1;
        img_chat.RotationAngle := img_menu.RotationAngle * -1;
        img_location.RotationAngle := img_menu.RotationAngle * -1;
        img_lock.RotationAngle := img_menu.RotationAngle * -1;
        img_search.RotationAngle := img_menu.RotationAngle * -1;
        img_refresh.RotationAngle := img_menu.RotationAngle * -1;
        img_new.RotationAngle := img_menu.RotationAngle * -1;
    end;
end;

procedure TForm1.layout_menuMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    Pressed := false;
end;

end.
