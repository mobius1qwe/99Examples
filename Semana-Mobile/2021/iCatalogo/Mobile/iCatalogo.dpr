program iCatalogo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitCatalogoCad in 'UnitCatalogoCad.pas' {FrmCatalogoCad},
  UnitCatalogoProd in 'UnitCatalogoProd.pas' {FrmCatalogoProd},
  UnitCatalogoProdCad in 'UnitCatalogoProdCad.pas' {FrmCatalogoProdCad},
  UnitCatalogoPreview in 'UnitCatalogoPreview.pas' {FrmCatalogoPreview};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmCatalogoCad, FrmCatalogoCad);
  Application.CreateForm(TFrmCatalogoProd, FrmCatalogoProd);
  Application.CreateForm(TFrmCatalogoProdCad, FrmCatalogoProdCad);
  Application.CreateForm(TFrmCatalogoPreview, FrmCatalogoPreview);
  Application.Run;
end.
