unit UnitCatalogoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts;

type
  TFrmCatalogoCad = class(TForm)
    rect_toolbar: TRectangle;
    img_menu: TImage;
    img_add: TImage;
    Label1: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    edt_nome: TEdit;
    Rectangle1: TRectangle;
    btn_salvar: TSpeedButton;
    Circle1: TCircle;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCatalogoCad: TFrmCatalogoCad;

implementation

{$R *.fmx}

end.
