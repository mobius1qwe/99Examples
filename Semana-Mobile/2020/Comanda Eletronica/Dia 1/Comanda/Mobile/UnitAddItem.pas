unit UnitAddItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Edit;

type
  TFrmAddItem = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    Image1: TImage;
    ListView1: TListView;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Image2: TImage;
    Rectangle6: TRectangle;
    Edit2: TEdit;
    Rectangle7: TRectangle;
    Label7: TLabel;
    ListView2: TListView;
    Rectangle3: TRectangle;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAddItem: TFrmAddItem;

implementation

{$R *.fmx}

end.
