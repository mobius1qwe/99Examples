unit UnitResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmResumo = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Layout1: TLayout;
    Label3: TLabel;
    ListView1: TListView;
    rect_login: TRectangle;
    Label4: TLabel;
    Rectangle3: TRectangle;
    Label5: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmResumo: TFrmResumo;

implementation

{$R *.fmx}

end.
