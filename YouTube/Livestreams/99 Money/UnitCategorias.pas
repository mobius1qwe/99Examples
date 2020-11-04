unit UnitCategorias;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FireDAC.Comp.Client, FireDAC.DApt, Data.DB;

type
  TFrmCategorias = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    img_voltar: TImage;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    lbl_qtd: TLabel;
    img_add: TImage;
    lv_categoria: TListView;
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lv_categoriaUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_addClick(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure CadCategoria(id_cat: string);
    { Private declarations }
  public
    { Public declarations }
    procedure ListarCategorias;
  end;

var
  FrmCategorias: TFrmCategorias;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitCategoriasCad, cCategoria, UnitDM;

procedure TFrmCategorias.ListarCategorias;
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

            FrmPrincipal.AddCategoria(lv_categoria,
                                      qry.FieldByName('ID_CATEGORIA').AsString,
                                      qry.FieldByName('DESCRICAO').AsString,
                                      icone);

            if icone <> nil then
                icone.DisposeOf;

            qry.Next;
        end;

        lbl_qtd.Text := lv_categoria.Items.Count.ToString + ' categoria(s)';

    finally
        qry.DisposeOf;
        cat.DisposeOf;
    end;
end;

procedure TFrmCategorias.CadCategoria(id_cat: string);
begin
    if NOT Assigned(FrmCategoriasCad) then
        Application.CreateForm(TFrmCategoriasCad, FrmCategoriasCad);

    // INCLUSAO
    if id_cat = '' then
    begin
        FrmCategoriasCad.id_cat := 0;
        FrmCategoriasCad.modo := 'I';
        FrmCategoriasCad.lbl_titulo.text := 'Nova Categoria'
    end
    else

    // ALTERACAO
    begin
        FrmCategoriasCad.id_cat := id_cat.tointeger;
        FrmCategoriasCad.modo := 'A';
        FrmCategoriasCad.lbl_titulo.text := 'Editar Categoria';
    end;

    FrmCategoriasCad.Show;
end;

procedure TFrmCategorias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmCategorias := nil;
end;

procedure TFrmCategorias.FormShow(Sender: TObject);
begin
    ListarCategorias;
end;

procedure TFrmCategorias.img_addClick(Sender: TObject);
begin
    CadCategoria('');
end;

procedure TFrmCategorias.img_voltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmCategorias.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    CadCategoria(AItem.TagString);
end;

procedure TFrmCategorias.lv_categoriaUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmPrincipal.SetupCategoria(lv_categoria, AItem);
end;

end.
