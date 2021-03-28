program iCatalogo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitCatalogoCad in 'UnitCatalogoCad.pas' {FrmCatalogoCad},
  UnitCatalogoProd in 'UnitCatalogoProd.pas' {FrmCatalogoProd},
  UnitCatalogoProdCad in 'UnitCatalogoProdCad.pas' {FrmCatalogoProdCad},
  UnitCatalogoPreview in 'UnitCatalogoPreview.pas' {FrmCatalogoPreview},
  uFunctions in 'Units\uFunctions.pas',
  UnitDM in 'UnitDM.pas' {dm: TDataModule};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmCatalogoCad, FrmCatalogoCad);
  Application.CreateForm(TFrmCatalogoProd, FrmCatalogoProd);
  Application.CreateForm(TFrmCatalogoProdCad, FrmCatalogoProdCad);
  Application.CreateForm(TFrmCatalogoPreview, FrmCatalogoPreview);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
