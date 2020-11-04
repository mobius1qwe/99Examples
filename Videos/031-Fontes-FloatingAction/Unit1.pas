unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Ani;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Layout2: TLayout;
    Circle1: TCircle;
    Layout3: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Layout4: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout5: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Line1: TLine;
    Circle2: TCircle;
    Label7: TLabel;
    GridLayout1: TGridLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    layout_menu: TLayout;
    Rectangle5: TRectangle;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    AnimaMenu: TFloatAnimation;
    procedure Circle2Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AnimaMenuFinish(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
        Layout_Menu.Visible := false;
end;

procedure TForm1.Circle2Click(Sender: TObject);
begin
        Layout_Menu.Position.Y := Form1.Height + 20;
        Layout_Menu.Visible := true;

        AnimaMenu.Inverse := false;
        AnimaMenu.StartValue := Form1.Height + 20;
        AnimaMenu.StopValue := 0;
        AnimaMenu.Start;
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
        AnimaMenu.Inverse := true;
        AnimaMenu.Start;
end;


procedure TForm1.AnimaMenuFinish(Sender: TObject);
begin
        if AnimaMenu.Inverse = true then
                layout_menu.Visible := false;
end;


end.
