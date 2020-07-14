unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Ani;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    btn_menu: TSpeedButton;
    Label1: TLabel;
    layout_menu: TLayout;
    rect_fundo: TRectangle;
    rect_selecao: TRoundRect;
    rect_base: TRectangle;
    Label2: TLabel;
    HorzScrollBox1: THorzScrollBox;
    Label3: TLabel;
    Layout1: TLayout;
    Label4: TLabel;
    Layout2: TLayout;
    Label5: TLabel;
    Layout3: TLayout;
    Label6: TLabel;
    Layout4: TLayout;
    Label7: TLabel;
    Layout5: TLayout;
    Label8: TLabel;
    Layout6: TLayout;
    Label9: TLabel;
    Layout7: TLayout;
    Label10: TLabel;
    lbl_cancelar: TLabel;
    Line1: TLine;
    Layout8: TLayout;
    Line2: TLine;
    Label12: TLabel;
    Label13: TLabel;
    Rectangle1: TRectangle;
    Layout9: TLayout;
    Layout10: TLayout;
    Rectangle2: TRectangle;
    Label14: TLabel;
    Label15: TLabel;
    Layout11: TLayout;
    Rectangle3: TRectangle;
    Label16: TLabel;
    Label17: TLabel;
    procedure btn_menuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbl_cancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Exibe_Menu();
begin
        with Form1 do
        begin
                rect_base.Width := layout_menu.Width - 16;
                rect_base.Position.X := 8;
                rect_base.Position.Y := layout_menu.Height + 20;


                layout_menu.Visible := true;
                rect_fundo.Opacity := 0;
                rect_fundo.AnimateFloat('Opacity', 0.4, 0.2);

                rect_base.AnimateFloat('Position.Y',
                                        layout_menu.Height - 270 - 8,
                                        0.5,
                                        TAnimationType.InOut,
                                        TInterpolationType.Circular);

        end;
end;

procedure Esconde_Menu();
begin
        with Form1 do
        begin
                rect_base.AnimateFloat('Position.Y',
                                        layout_menu.Height + 20,
                                        0.3,
                                        TAnimationType.InOut,
                                        TInterpolationType.Circular);

                rect_fundo.AnimateFloat('Opacity', 0, 0.6);

                TThread.CreateAnonymousThread(procedure
                begin
                        sleep(800);
                        layout_menu.Visible := false;
                end).Start;

        end;
end;

procedure TForm1.btn_menuClick(Sender: TObject);
begin
        Exibe_Menu;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        layout_menu.Visible := false;
end;

procedure TForm1.lbl_cancelarClick(Sender: TObject);
begin
        Esconde_Menu;
end;

end.
