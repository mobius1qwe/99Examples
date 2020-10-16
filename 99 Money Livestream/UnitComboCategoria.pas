unit UnitComboCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FireDAC.Comp.Client, FireDAC.DApt, Data.DB;

type
  TFrmComboCategoria = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_voltar: TImage;
    lv_categoria: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure ListarCategorias;
    { Private declarations }
  public
    { Public declarations }
    CategoriaSelecao: string;
    IdCategoriaSelecao: Integer;
  end;

var
  FrmComboCategoria: TFrmComboCategoria;

implementation

{$R *.fmx}

uses UnitPrincipal, cCategoria, UnitDM;

procedure TFrmComboCategoria.ListarCategorias;
var
    cat : TCategoria;
    qry: TFDQuery;
    erro: string;
    icone: TStream;
begin
    try
        lv_categoria.Items.Clear;

        cat := TCategoria.Create(dm.conn);
        qry := cat.ListarCategoria(erro);

        while NOT qry.Eof do
        begin
            // Icone...
            if qry.FieldByName('ICONE').AsString <> '' then
                icone := qry.CreateBlobStream(qry.FieldByName('ICONE'), TBlobStreamMode.bmRead)
            else
                icone := nil;

            FrmPrincipal.AddCategoria(FrmComboCategoria.lv_categoria,
                                      qry.FieldByName('ID_CATEGORIA').AsString,
                                      qry.FieldByName('DESCRICAO').AsString,
                                      icone);

            if icone <> nil then
                icone.DisposeOf;

            qry.Next;
        end;

    finally
        qry.DisposeOf;
        cat.DisposeOf;
    end;
end;

procedure TFrmComboCategoria.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    IdCategoriaSelecao := Aitem.TagString.ToInteger;
    CategoriaSelecao := TListItemText(Aitem.Objects.FindDrawable('TxtCategoria')).Text;
    close;
end;

procedure TFrmComboCategoria.FormShow(Sender: TObject);
begin
    ListarCategorias;
end;

procedure TFrmComboCategoria.img_voltarClick(Sender: TObject);
begin
    IdCategoriaSelecao := 0;
    CategoriaSelecao := '';
    close;
end;

end.
