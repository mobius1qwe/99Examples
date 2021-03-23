unit UnitCatalogoPreview;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmCatalogoPreview = class(TForm)
    rect_toolbar: TRectangle;
    img_menu: TImage;
    Label1: TLabel;
    Rectangle1: TRectangle;
    edt_nome: TEdit;
    Image1: TImage;
    Layout1: TLayout;
    Label2: TLabel;
    ListBox1: TListBox;
    Layout2: TLayout;
    Label3: TLabel;
    lv_produto: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCatalogoPreview: TFrmCatalogoPreview;

implementation

{$R *.fmx}

end.
