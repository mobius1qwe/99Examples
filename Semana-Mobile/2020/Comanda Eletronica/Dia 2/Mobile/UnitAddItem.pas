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
    img_fechar: TImage;
    ListView1: TListView;
    TabControl: TTabControl;
    TabCategoria: TTabItem;
    TabProduto: TTabItem;
    Rectangle2: TRectangle;
    Label2: TLabel;
    img_voltar: TImage;
    Rectangle6: TRectangle;
    Edit2: TEdit;
    Rectangle7: TRectangle;
    Label7: TLabel;
    ListView2: TListView;
    Rectangle3: TRectangle;
    Label3: TLabel;
    procedure img_fecharClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAddItem: TFrmAddItem;

implementation

{$R *.fmx}

procedure TFrmAddItem.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmAddItem.img_voltarClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

end.
