unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Layouts, FMX.Edit;

type
  TForm1 = class(TForm)
    Rectangle1: TRectangle;
    lv: TListView;
    StyleBook1: TStyleBook;
    ListBox1: TListBox;
    Layout1: TLayout;
    ListBoxItem1: TListBoxItem;
    Label1: TLabel;
    ListBoxItem2: TListBoxItem;
    Label2: TLabel;
    ListBoxItem3: TListBoxItem;
    Label3: TLabel;
    ListBoxItem4: TListBoxItem;
    Label4: TLabel;
    RoundRect1: TRoundRect;
    RoundRect2: TRoundRect;
    Edit1: TEdit;
    Label5: TLabel;
    img_fundo: TImage;
    img_foto1: TImage;
    img_foto2: TImage;
    img_foto3: TImage;
    img_foto4: TImage;
    procedure lvUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvItemClick(const Sender: TObject; const AItem: TListViewItem);
  private
    procedure AddItem(codItem, descricao, preco: string; foto: TStream);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AddItem(codItem, descricao, preco: string; foto: TStream);
var
    img: TListItemImage;
    bmp : TBitmap;
begin
    with lv.Items.Add do
    begin
        Height := 165;
        TagString := codItem;
        img := TListItemImage(Objects.FindDrawable('ImgFundo'));
        img.Bitmap := img_fundo.Bitmap;


        bmp := TBitmap.Create;
        bmp.LoadFromStream(foto);
        img := TListItemImage(Objects.FindDrawable('ImgFoto'));
        img.OwnsBitmap := true;
        img.Bitmap := bmp;


        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtPreco')).Text := preco;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    // Esconde os objetos...
    img_fundo.Visible := false;
    img_foto1.Visible := false;
    img_foto2.Visible := false;
    img_foto3.Visible := false;
    img_foto4.Visible := false;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    foto : TStream;
    x : integer;
begin
    lv.BeginUpdate;

    for x := 1 to 10 do
    begin
        // Produto 1...
        foto := TMemoryStream.Create;
        img_foto1.Bitmap.SaveToStream(foto);
        foto.Position := 0;

        AddItem('001', 'Poltrona Decorativa Next Linho Azul Nuvem', 'R$ 2.499,00', foto);
        foto.DisposeOf;

        // Produto 2...
        foto := TMemoryStream.Create;
        img_foto2.Bitmap.SaveToStream(foto);
        foto.Position := 0;

        AddItem('002', 'Poltrona Moderna Style Linho Bege Barroco', 'R$ 3.790,00', foto);
        foto.DisposeOf;

        // Produto 3...
        foto := TMemoryStream.Create;
        img_foto3.Bitmap.SaveToStream(foto);
        foto.Position := 0;

        AddItem('003', 'Cadeira Coleção Galícia Azul Petróleo', 'R$ 1.510,00', foto);

        foto.DisposeOf;

        // Produto 4...
        foto := TMemoryStream.Create;
        img_foto4.Bitmap.SaveToStream(foto);
        foto.Position := 0;

        AddItem('004', 'Banqueta de Aço Moderna Preto Brilhante com Apoio', 'R$ 698,00', foto);

        foto.DisposeOf;
    end;

    lv.EndUpdate;
end;

procedure TForm1.lvItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
    showmessage('Clicou no item: ' + AItem.TagString);
end;

procedure TForm1.lvUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    img : TListItemImage;
begin
    // Ajusta fundo...
    img := TListItemImage(AItem.Objects.FindDrawable('ImgFundo'));
    img.ScalingMode := TImageScalingMode.Stretch;
    img.PlaceOffset.X := 10;
    img.PlaceOffset.Y := 20;
    img.Width := lv.Width - 20;
    img.Height := 140;


    // Ajusta foto...
    img := TListItemImage(AItem.Objects.FindDrawable('ImgFoto'));
    img.ScalingMode := TImageScalingMode.StretchWithAspect;
    img.Width := 140;
    img.Height := 140;
    img.PlaceOffset.X := lv.Width - img.Width - 30;
    img.PlaceOffset.Y := 5;


    // Ajusta largura da descricao...
    TListItemText(AItem.Objects.FindDrawable('TxtDescricao')).Width := lv.Width - 190;
end;

end.
