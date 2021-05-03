unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListBox;

type
  TFrmPrincipal = class(TForm)
    layout_toolbar: TLayout;
    layout_botao_menu: TLayout;
    rect_menu1: TRectangle;
    rect_menu2: TRectangle;
    rect_menu3: TRectangle;
    Animation2Opacity: TFloatAnimation;
    Animation1Rotate: TFloatAnimation;
    Animation1Width: TFloatAnimation;
    Animation1Margin: TFloatAnimation;
    Animation3Margin: TFloatAnimation;
    Animation3Rotate: TFloatAnimation;
    Animation3Width: TFloatAnimation;
    StyleBook1: TStyleBook;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure layout_botao_menuClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    procedure CloseMenu;
    procedure OpenMenu;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Unit1, Unit2, Unit3, Unit4;

procedure TFrmPrincipal.OpenMenu;
begin
    // Menu hamburguer...
    Animation1Margin.Inverse := false;
    Animation1Rotate.Inverse := false;
    Animation1Width.Inverse := false;
    Animation2Opacity.Inverse := false;
    Animation3Margin.Inverse := false;
    Animation3Rotate.Inverse := false;
    Animation3Width.Inverse := false;

    Animation2Opacity.Start;

    Animation1Width.Start;
    Animation1Rotate.Start;
    Animation1Margin.Start;

    Animation3Width.Start;
    Animation3Rotate.Start;
    Animation3Margin.Start;

    rect_menu1.Tag := 1;

end;

procedure TFrmPrincipal.CloseMenu;
begin
    // Menu hamburguer...
    Animation1Margin.Inverse := true;
    Animation1Rotate.Inverse := true;
    Animation1Width.Inverse := true;
    Animation2Opacity.Inverse := true;
    Animation3Margin.Inverse := true;
    Animation3Rotate.Inverse := true;
    Animation3Width.Inverse := true;

    Animation2Opacity.Start;

    Animation1Width.Start;
    Animation1Rotate.Start;
    Animation1Margin.Start;

    Animation3Width.Start;
    Animation3Rotate.Start;
    Animation3Margin.Start;

    rect_menu1.Tag := 0;

end;

procedure TFrmPrincipal.layout_botao_menuClick(Sender: TObject);
begin
    if rect_menu1.Tag = 0 then
        OpenMenu
    else
        CloseMenu;
end;

procedure TFrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
    form1.Show;
end;

procedure TFrmPrincipal.SpeedButton2Click(Sender: TObject);
begin
    form2.Show;
end;

procedure TFrmPrincipal.SpeedButton3Click(Sender: TObject);
begin
    Form3.Show;
end;

procedure TFrmPrincipal.SpeedButton4Click(Sender: TObject);
begin
    form4.Show;
end;

end.
