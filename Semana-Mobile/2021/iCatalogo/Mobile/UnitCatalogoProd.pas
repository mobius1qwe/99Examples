unit UnitCatalogoProd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFrmCatalogoProd = class(TForm)
    rect_toolbar: TRectangle;
    img_voltar: TImage;
    lbl_titulo: TLabel;
    img_add: TImage;
    lbl_catalogo: TLabel;
    edt_nome: TEdit;
    Rectangle1: TRectangle;
    Image1: TImage;
    lv_produto: TListView;
    img_foto: TImage;
    img_excluir: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCatalogoProd: TFrmCatalogoProd;

implementation

{$R *.fmx}

end.
