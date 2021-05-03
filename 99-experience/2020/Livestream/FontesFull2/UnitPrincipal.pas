unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListBox;

type
  TFrmPrincipal = class(TForm)
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
    Image1: TImage;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    rect_principal: TRectangle;
    Line1: TLine;
    Line2: TLine;
    ListBoxItem2: TListBoxItem;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Line4: TLine;
    ListBoxItem3: TListBoxItem;
    Image4: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Line3: TLine;
    Line5: TLine;
    ListBoxItem4: TListBoxItem;
    Image5: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Line6: TLine;
    Line7: TLine;
    ListBoxItem5: TListBoxItem;
    Image6: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Line8: TLine;
    Line9: TLine;
    ListBoxItem6: TListBoxItem;
    Image7: TImage;
    Label11: TLabel;
    Label12: TLabel;
    Line10: TLine;
    Line11: TLine;
    ListBoxItem7: TListBoxItem;
    Image8: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Line12: TLine;
    Line13: TLine;
    ListBoxItem8: TListBoxItem;
    Image9: TImage;
    Label15: TLabel;
    Label16: TLabel;
    Line14: TLine;
    Line15: TLine;
    rect_menu: TRectangle;
    AnimationWidth: TFloatAnimation;
    layout_toolbar: TLayout;
    procedure layout_botao_menuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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


    // Menu slide...
    AnimationWidth.Inverse := false;
    AnimationWidth.Start;
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


    // Menu slide...
    AnimationWidth.Inverse := true;
    AnimationWidth.Start;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    rect_menu.Width := 0;
end;

procedure TFrmPrincipal.layout_botao_menuClick(Sender: TObject);
begin
    if rect_menu1.Tag = 0 then
        OpenMenu
    else
        CloseMenu;
end;


end.
