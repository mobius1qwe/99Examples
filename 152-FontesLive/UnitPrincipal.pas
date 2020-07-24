unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.JSON;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_menu: TImage;
    Circle1: TCircle;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Layout6: TLayout;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Rectangle1: TRectangle;
    Image4: TImage;
    Rectangle2: TRectangle;
    Layout7: TLayout;
    Label9: TLabel;
    lv_lancamento: TListView;
    img_categoria: TImage;
    img_uncheck: TImage;
    img_check: TImage;
    img_delete: TImage;
    procedure FormShow(Sender: TObject);
    procedure lv_lancamentoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_lancamentoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure lv_lancamentoDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
    procedure img_deleteClick(Sender: TObject);
    procedure img_checkClick(Sender: TObject);
  private
    procedure AddLancamento(id_lancamento, descricao, categoria: string;
      valor: double;
      dt: TDateTime;
      foto: TStream);
    procedure CarregaJSON;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.AddLancamento(id_lancamento, descricao,
                                      categoria: string;
                                      valor: double;
                                      dt: TDateTime;
                                      foto: TStream);
var
    txt : TListItemText;
    img : TListItemImage;
    bmp : TBitmap;
begin
    with lv_lancamento.Items.Add do
    begin
        TagString := id_lancamento;

        txt := TListItemText(Objects.FindDrawable('TxtDescricao'));
        txt.Text := descricao;

        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);
        TListItemText(Objects.FindDrawable('TxtData')).Text := FormatDateTime('dd/mm', dt);

        // Icone...
        img := TListItemImage(Objects.FindDrawable('ImgIcone'));

        if foto <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(foto);

            img.OwnsBitmap := true;
            img.Bitmap := bmp;
        end;

        // Icone checkbox...
        img := TListItemImage(Objects.FindDrawable('ImgCheck'));
        img.Bitmap := img_uncheck.Bitmap;
        img.TagFloat := 0;

    end;
end;

procedure TFrmPrincipal.CarregaJSON();
var
    JsonStr : string;
    JsonArray : TJsonArray;
    x : integer;
begin
    try
        JsonStr := '[{"id_lanc":"001", "descricao":"Mercado", "categoria":"Geral", "valor":50},'+
                   ' {"id_lanc":"002", "descricao":"Padaria", "categoria":"Alimentação", "valor":3},'+
                   ' {"id_lanc":"003", "descricao":"Celular", "categoria":"Eletrônicos", "valor":1800}]';

        JsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonStr), 0) as TJSONArray;

        for x := 0 to JsonArray.Size - 1 do
        begin
            AddLancamento(JsonArray.Get(x).GetValue<string>('id_lanc'),
                          JsonArray.Get(x).GetValue<string>('descricao'),
                          JsonArray.Get(x).GetValue<string>('categoria'),
                          JsonArray.Get(x).GetValue<double>('valor'),
                          date, nil);
        end;

    finally
        JsonArray.DisposeOf;
    end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
var
    foto : TStream;
    x : integer;
begin
    // Personalizando o texto do swipe to delete...
    lv_lancamento.DeleteButtonText := 'Excluir';
    //---------------------------------------------


    foto := TMemoryStream.Create;
    img_categoria.Bitmap.SaveToStream(foto);
    foto.Position := 0;

    for x := 1 to 10 do
        AddLancamento(x.ToString, 'Compra de Passagem: ' + x.ToString,
                      'Transporte', -45, date, foto);


    foto.DisposeOf;


    //CarregaJSON();
end;

procedure TFrmPrincipal.img_checkClick(Sender: TObject);
var
    ind : Boolean;
    x : integer;
    img : TListItemImage;
begin
    if TImage(Sender).Tag > 0 then
    begin
        img_check.Visible := false;
        img_uncheck.Visible := true;

        // Exibir LV...
        ind := false;
    end
    else
    begin
        img_check.Visible := true;
        img_uncheck.Visible := false;

        // Esconde LV...
        ind := true;
    end;

    for x := lv_lancamento.Items.Count - 1 downto 0 do
    begin
        img := TListItemImage(lv_lancamento.Items[x].Objects.FindDrawable('ImgCheck'));
        img.Visible := ind;
        img.TagFloat := 1;
        img.Bitmap := img_check.Bitmap;
    end;
end;

procedure TFrmPrincipal.img_deleteClick(Sender: TObject);
var
    x : integer;
    img : TListItemImage;
begin
    for x := lv_lancamento.Items.Count - 1 downto 0 do
    begin
        img := TListItemImage(lv_lancamento.Items[x].Objects.FindDrawable('ImgCheck'));

        if img.TagFloat > 0 then
        begin
            showmessage('Exluir o item: ' + lv_lancamento.Items[x].TagString);
            lv_lancamento.Items.Delete(x);
            // delete no banco...
            // chamaria ws exclusao...
        end;

    end;
end;

procedure TFrmPrincipal.lv_lancamentoDeletingItem(Sender: TObject;
  AIndex: Integer; var ACanDelete: Boolean);
begin
    if AIndex = 0 then
    begin
        // acessando o seu banco e fazendo delete...
        // acessando o WS...
        showmessage('Excluindo o item: ' + lv_lancamento.Items[AIndex].TagString);
    end
    else
    begin
        ACanDelete := false;
        ShowMessage('O item não pode ser excluído');
    end;
end;

procedure TFrmPrincipal.lv_lancamentoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    //showmessage(Aitem.TagString);
end;

procedure TFrmPrincipal.lv_lancamentoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin

    if TListView(Sender).Selected <> nil then
    begin
        //TListView(Sender).Selected.Index;

        if ItemObject is TListItemImage then
        begin
            //Image3.Bitmap := TListItemImage(ItemObject).Bitmap;

            if TListItemImage(ItemObject).Name = 'ImgIcone' then
            begin
                showmessage('Excluindo item: ' + lv_lancamento.Items[ItemIndex].TagString);
                // Vai no banco e faz o delete...
                // Vai no WS...

                lv_lancamento.Items.Delete(ItemIndex);
            end;

            if TListItemImage(ItemObject).Name = 'ImgCheck' then
            begin
                if TListItemImage(ItemObject).TagFloat = 0 then // desmarcado
                begin
                    TListItemImage(ItemObject).Bitmap := img_check.Bitmap;
                    TListItemImage(ItemObject).TagFloat := 1;
                end
                else
                begin
                    TListItemImage(ItemObject).Bitmap := img_uncheck.Bitmap;
                    TListItemImage(ItemObject).TagFloat := 0;
                end
            end;


        end;

        if ItemObject is TListItemText then
        begin
            Label2.Text := TListItemText(ItemObject).Text;
        end;
    end;

end;

procedure TFrmPrincipal.lv_lancamentoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
    {
    if lv_lancamento.Items.Count > 0 then
        if lv_lancamento.GetItemRect(lv_lancamento.items.Count - 4).Bottom <= lv_lancamento.Height then
        begin
            AddLancamento('00001', 'Supermercado', 'Transporte', -45, date, nil);
            AddLancamento('00001', 'Supermercado 1', 'Transporte', -45, date, nil);
            AddLancamento('00001', 'Supermercado 2', 'Transporte', -45, date, nil);
            AddLancamento('00001', 'Supermercado 3', 'Transporte', -45, date, nil);
            AddLancamento('00001', 'Supermercado 4', 'Transporte', -45, date, nil);
        end;
    }
end;

procedure TFrmPrincipal.lv_lancamentoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt : TListItemText;
    //img : TListItemImage;
begin

    txt := TListItemText(AItem.Objects.FindDrawable('TxtDescricao'));
    txt.Width := lv_lancamento.Width - txt.PlaceOffset.X - 100;

    {
    img := TListItemImage(AItem.Objects.FindDrawable('ImgIcone'));

    if lv_lancamento.Width < 200 then
    begin
        img.Visible := false;
        txt.PlaceOffset.X := 2;
    end;
    }
end;

end.
