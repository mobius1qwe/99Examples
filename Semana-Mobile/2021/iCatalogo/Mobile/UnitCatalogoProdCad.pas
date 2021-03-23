unit UnitCatalogoProdCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation;

type
  TFrmCatalogoProdCad = class(TForm)
    rect_toolbar: TRectangle;
    img_menu: TImage;
    img_add: TImage;
    Label1: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    edt_nome: TEdit;
    Layout2: TLayout;
    Label3: TLabel;
    Edit1: TEdit;
    Layout3: TLayout;
    Label4: TLabel;
    Edit2: TEdit;
    Layout4: TLayout;
    Label5: TLabel;
    Rectangle1: TRectangle;
    btn_salvar: TSpeedButton;
    Circle1: TCircle;
    Label6: TLabel;
    Switch1: TSwitch;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCatalogoProdCad: TFrmCatalogoProdCad;

implementation

{$R *.fmx}

end.
