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
    lbl_menu: TLabel;
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

procedure Esconde_Menu();
begin
        with Form1 do
        begin
                // Esconde o menu...
                AnimaMenu.Inverse := true;
                AnimaMenu.Start;

                // Anima a rotacao do botao...
                Circle2.Tag := 0;
                Circle2.RotationAngle := 180;
                Circle2.AnimateFloatWait('RotationAngle', 0, 0.5,
                                     TAnimationType.InOut,
                                     TInterpolationType.Circular);
                lbl_menu.Text := '+';
        end;
end;

procedure TForm1.Circle2Click(Sender: TObject);
begin
        if Circle2.Tag = 0 then
        begin
                // Posiciona o menu na parte de baixo da tela...
                Layout_Menu.Position.Y := Form1.Height + 20;
                Layout_Menu.Visible := true;

                // Faz a nimacao de entrada do menu (deslizar para cima)...
                AnimaMenu.Inverse := false;
                AnimaMenu.StartValue := Form1.Height + 20;
                AnimaMenu.StopValue := 0;
                AnimaMenu.Start;

                // Anima a rotacao do botao...
                Circle2.Tag := 1;
                Circle2.RotationAngle := 0;
                Circle2.AnimateFloatWait('RotationAngle', 180, 0.5,
                                     TAnimationType.InOut,
                                     TInterpolationType.Circular);
                lbl_menu.Text := '-';
        end
        else
                Esconde_Menu();
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
        Esconde_Menu();
end;


procedure TForm1.AnimaMenuFinish(Sender: TObject);
begin
        if AnimaMenu.Inverse = true then
                layout_menu.Visible := false;

end;


end.
