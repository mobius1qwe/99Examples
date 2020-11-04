unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    lyt_pesquisa: TLayout;
    lbl_qtd: TLabel;
    ListBox: TListBox;
    rect_toolbar: TRectangle;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Rectangle2: TRectangle;
    Image4: TImage;
    Label2: TLabel;
    ListBoxItem1: TListBoxItem;
    Image1: TImage;
    Layout2: TLayout;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBoxItem2: TListBoxItem;
    Image5: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ListBoxItem3: TListBoxItem;
    Image6: TImage;
    Layout4: TLayout;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ListBoxItem4: TListBoxItem;
    Image7: TImage;
    Layout5: TLayout;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    rect_transicao: TRectangle;
    FloatAnimation1: TFloatAnimation;
    Rectangle1: TRectangle;
    procedure ListBoxItem1Click(Sender: TObject);
    procedure FloatAnimation1Finish(Sender: TObject);
    procedure DetalheProduto;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitProduto;

procedure TFrmPrincipal.DetalheProduto;
begin
    rect_transicao.BringToFront;
    FloatAnimation1.Tag := 1;
    FloatAnimation1.Inverse := false;
    FloatAnimation1.StartValue := FrmPrincipal.Height + 100;
    FloatAnimation1.StopValue := 0;
    FloatAnimation1.Start;
    ListBox.ItemIndex := -1;
end;

procedure TFrmPrincipal.FloatAnimation1Finish(Sender: TObject);
begin
    if FloatAnimation1.Tag = 1 then
    begin
        FloatAnimation1.Tag := 0;

        if NOT Assigned(FrmProduto) then
            Application.CreateForm(TFrmProduto, FrmProduto);

        FrmProduto.Show;
    end;

    FloatAnimation1.Inverse := NOT FloatAnimation1.Inverse;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    rect_transicao.Margins.Top := FrmPrincipal.Height + 100;
end;

procedure TFrmPrincipal.ListBoxItem1Click(Sender: TObject);
begin
    DetalheProduto;
end;

end.
