unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmPrincipal = class(TForm)
    rect_toolbar: TRectangle;
    img_menu: TImage;
    img_add: TImage;
    Label1: TLabel;
    lv_catalogo: TListView;
    img_logo: TImage;
    img_editar: TImage;
    img_produtos: TImage;
    img_preview: TImage;
    procedure lv_catalogoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure img_addClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure OpenCadCatalogo(id_catalogo: integer);
    procedure AddCatalogoLista(id_catalogo: integer; nome: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitCatalogoCad, UnitCatalogoProd, UnitCatalogoPreview;

procedure TFrmPrincipal.AddCatalogoLista(id_catalogo: integer;
                                         nome: string);
begin
    with lv_catalogo.Items.Add do
    begin
        Height := 150;
        TListItemText(Objects.FindDrawable('TxtCatalogo')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtQtd')).Text := '10 produtos';
        TListItemImage(Objects.FindDrawable('ImgFoto')).Bitmap := img_logo.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgEditar')).Bitmap := img_editar.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgProdutos')).Bitmap := img_produtos.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgPreview')).Bitmap := img_preview.Bitmap;
    end;
end;

procedure TFrmPrincipal.OpenCadCatalogo(id_catalogo: integer);
begin
    if NOT Assigned(FrmCatalogoCad) then
        Application.CreateForm(TFrmCatalogoCad, FrmCatalogoCad);

    FrmCatalogoCad.ShowModal(
        procedure (ModalResult: TModalResult)
        begin
            // Atualizar a lista principal...
        end
    );
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    AddCatalogoLista(0, 'Lojas 99 Coders');
    AddCatalogoLista(0, 'Lojas 99 Coders');
    AddCatalogoLista(0, 'Lojas 99 Coders');
    AddCatalogoLista(0, 'Lojas 99 Coders');
    AddCatalogoLista(0, 'Lojas 99 Coders');
end;

procedure TFrmPrincipal.img_addClick(Sender: TObject);
begin
    OpenCadCatalogo(0);
end;

procedure TFrmPrincipal.lv_catalogoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if TListView(Sender).Selected <> nil then
    begin
        // Imagem...
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgEditar' then
                OpenCadCatalogo(0);
        end;

        // Produto...
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgProdutos' then
            begin
                if NOT Assigned(FrmCatalogoProd) then
                    Application.CreateForm(TFrmCatalogoProd, FrmCatalogoProd);

                FrmCatalogoProd.Show;
            end;
        end;

        // Preview...
        if ItemObject is TListItemImage then
        begin
            if TListItemImage(ItemObject).Name = 'ImgPreview' then
            begin
                if NOT Assigned(FrmCatalogoPreview) then
                    Application.CreateForm(TFrmCatalogoPreview, FrmCatalogoPreview);

                FrmCatalogoPreview.Show;
            end;
        end;
    end;
end;

end.
