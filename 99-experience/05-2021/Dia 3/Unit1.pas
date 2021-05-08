unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ListBox, FMX.Ani;

type
  TForm1 = class(TForm)
    rect_toolbar: TRectangle;
    img_menu: TImage;
    AnimationRotacao: TFloatAnimation;
    lyt_menu: TLayout;
    c_menu: TCircle;
    AnimationBall: TFloatAnimation;
    Layout1: TLayout;
    img_fechar: TImage;
    AnimationOpacidadeFechar: TFloatAnimation;
    lb_menu: TListBox;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    procedure img_menuClick(Sender: TObject);
    procedure AnimationBallProcess(Sender: TObject);
    procedure AnimationBallFinish(Sender: TObject);
    procedure AnimationOpacidadeFecharProcess(Sender: TObject);
  private
    procedure Menu;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Menu;
begin
    lyt_menu.Visible := true;

    AnimationRotacao.Start;
    AnimationBall.Start;
    AnimationOpacidadeFechar.Start;
end;

procedure TForm1.AnimationBallFinish(Sender: TObject);
begin
    TFloatAnimation(Sender).Inverse := Not TFloatAnimation(Sender).Inverse;
end;

procedure TForm1.AnimationBallProcess(Sender: TObject);
begin
    c_menu.Height := c_menu.Width;
end;

procedure TForm1.AnimationOpacidadeFecharProcess(Sender: TObject);
begin
    lb_menu.Opacity := img_fechar.Opacity;
end;

procedure TForm1.img_menuClick(Sender: TObject);
begin
    Menu;
end;

end.
