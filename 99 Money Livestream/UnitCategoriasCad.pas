unit UnitCategoriasCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox;

type
  TFrmCategoriasCad = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    img_save: TImage;
    Layout2: TLayout;
    Label2: TLabel;
    edt_login_email: TEdit;
    Line1: TLine;
    Label1: TLabel;
    lb_icone: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    img_selecao: TImage;
    procedure img_voltarClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    icone_selecionado: TBitmap;
    procedure SelecionaIcone(img: TImage);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategoriasCad: TFrmCategoriasCad;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmCategoriasCad.SelecionaIcone(img: TImage);
begin
    //icone_selecionado := img.Bitmap; // Salvei o icone selecionado...

    img_selecao.Parent := img.Parent;
end;

procedure TFrmCategoriasCad.FormResize(Sender: TObject);
begin
     lb_icone.Columns := Trunc(lb_icone.Width / 80);
end;

procedure TFrmCategoriasCad.Image1Click(Sender: TObject);
begin
    SelecionaIcone(TImage(Sender));
end;

procedure TFrmCategoriasCad.img_voltarClick(Sender: TObject);
begin
    close;
end;

end.
