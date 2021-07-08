unit UnitOS;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmOS = class(TForm)
    rectOSToolbar: TRectangle;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    imgSalvar: TImage;
    rectDados: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    lblOS: TLabel;
    lblStatus: TLabel;
    Label4: TLabel;
    Layout2: TLayout;
    imgWhats: TImage;
    imgEmail: TImage;
    rectAbas: TRectangle;
    imgAbaOS: TImage;
    imgAbaFoto: TImage;
    imgAbaAssinatura: TImage;
    TabControl: TTabControl;
    TabOS: TTabItem;
    TabFoto: TTabItem;
    TabAssinatura: TTabItem;
    ListBox1: TListBox;
    lbiCliente: TListBoxItem;
    Image1: TImage;
    Layout3: TLayout;
    Image5: TImage;
    Label5: TLabel;
    lblCliente: TLabel;
    lbiEndereco: TListBoxItem;
    Image6: TImage;
    Image7: TImage;
    Line2: TLine;
    Layout4: TLayout;
    Label7: TLabel;
    lblEndereco: TLabel;
    Line1: TLine;
    lbiData: TListBoxItem;
    Image8: TImage;
    Image9: TImage;
    Line3: TLine;
    Layout5: TLayout;
    Label9: TLabel;
    lblData: TLabel;
    lbiAssunto: TListBoxItem;
    Image10: TImage;
    Image11: TImage;
    Line4: TLine;
    Layout6: TLayout;
    Label11: TLabel;
    lblAssunto: TLabel;
    lbiProblema: TListBoxItem;
    Image12: TImage;
    Image13: TImage;
    Line5: TLine;
    Layout7: TLayout;
    Label13: TLabel;
    lblProblema: TLabel;
    lvFoto: TListView;
    imgCapturarFoto: TImage;
    Label3: TLabel;
    imgAssinatura: TImage;
    procedure imgAbaOSClick(Sender: TObject);
  private
    procedure MudarAba(Image: TImage);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOS: TFrmOS;

implementation

{$R *.fmx}

procedure TFrmOS.MudarAba(Image: TImage);
begin
    imgAbaOS.Opacity := 0.4;
    imgAbaFoto.Opacity := 0.4;
    imgAbaAssinatura.Opacity := 0.4;

    Image.Opacity := 1;
    TabControl.GotoVisibleTab(Image.Tag);
end;


procedure TFrmOS.imgAbaOSClick(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

end.
