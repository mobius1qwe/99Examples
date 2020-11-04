unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani;

type
  TForm1 = class(TForm)
    rect_menu: TRectangle;
    rect_toolbar: TRectangle;
    layout_fundo: TLayout;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Image1: TImage;
    GridLayout1: TGridLayout;
    Layout1: TLayout;
    Rectangle3: TRectangle;
    Image2: TImage;
    Layout2: TLayout;
    Rectangle4: TRectangle;
    Image3: TImage;
    Layout3: TLayout;
    Rectangle5: TRectangle;
    Image4: TImage;
    Layout4: TLayout;
    Rectangle6: TRectangle;
    Image5: TImage;
    Line1: TLine;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    layout_mod1: TLayout;
    Layout5: TLayout;
    Image6: TImage;
    Line2: TLine;
    layout_mod2: TLayout;
    Label7: TLabel;
    Label8: TLabel;
    Layout7: TLayout;
    Image7: TImage;
    Line3: TLine;
    layout_mod3: TLayout;
    Label9: TLabel;
    Label10: TLabel;
    Layout8: TLayout;
    Image8: TImage;
    Line4: TLine;
    FloatAnimation: TFloatAnimation;
    img_menu: TImage;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FloatAnimationFinish(Sender: TObject);
    procedure img_menuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Close_Menu();
begin
        with Form1 do
        begin
                FloatAnimation.Inverse := true;
                FloatAnimation.Start;
                rect_menu.AnimateFloat('Opacity', 0, 0.4);
                rect_menu.Tag := 0; // Menu fechado
        end;
end;

procedure Open_Menu();
begin
        with Form1 do
        begin
                FloatAnimation.Inverse := false;
                FloatAnimation.Start;
                rect_menu.AnimateFloat('Opacity', 1, 0.4);
                rect_menu.Tag := 1; // Menu aberto
        end;
end;

procedure Menu();
var
        larg_tela : integer;
begin
        {$IFDEF ANDROID}
        larg_tela := Screen.width;
        {$ENDIF}

        {$IFDEF MSWINDOWS}
        larg_tela := Form1.Width;
        {$ENDIF}


        with Form1 do
        begin
                if NOT FloatAnimation.Running then
                begin
                        // Recolhe o menu...
                        if (larg_tela < 600) and (rect_menu.Width > 0) then
                        begin
                                Close_Menu;
                        end;

                        // Expande o menu...
                        if (larg_tela >= 600) and (rect_menu.Width = 0) then
                        begin
                                Open_Menu;
                        end;
                end;
        end;
end;

procedure TForm1.FloatAnimationFinish(Sender: TObject);
begin
        if Form1.width < 600 then
                img_menu.AnimateFloat('Opacity', 1, 0.2)
        else
                img_menu.AnimateFloat('Opacity', 0, 0.2);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        with Form1 do
        begin
                // Esconde o menu...
                rect_menu.Width := 0;

                // Setup das animacoes do menu
                FloatAnimation.StartValue := 0;
                FloatAnimation.StopValue := 200; // Largura do menu
                FloatAnimation.Inverse := false;
        end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
        Menu();
end;

procedure TForm1.img_menuClick(Sender: TObject);
begin
        if Form1.rect_menu.Tag = 0 then
                Open_Menu
        else
                Close_Menu;
end;

end.
