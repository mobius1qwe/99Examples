unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, uListBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Image4: TImage;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    lbl_qtd: TLabel;
    ListBox: TListBox;
    img_fone: TImage;
    img_fone2: TImage;
    img_iphone: TImage;
    img_suporte: TImage;
    conn: TFDConnection;
    qry_produto: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Image3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
    lb : TCustomListBox;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses System.IOUtils;

procedure ConectarDB;
begin
        with form1.conn do
        begin
                {$IFDEF MSWINDOWS}
                try
                        Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\banco-loja.db';
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ELSE}
                try
                        Params.Values['DriverID'] := 'SQLite';
                        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco-loja.db');
                        Connected := true;
                except on E:Exception do
                        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
                end;
                {$ENDIF}
        end;
end;

procedure AtualizaQtd;
begin
    with Form1 do
        lbl_qtd.Text := ListBox.Items.Count.ToString + ' Produtos';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    ConectarDB;

    try
        lb := TCustomListBox.Create(ListBox);

        lb.ItemHeight := 230;
        lb.QtdColumns := 2;
        lb.Setup;

        lb.AddItem('1', img_fone.Bitmap, '', 980.00, 'Fones de ouvido AirPods Apple não acompanha carregador');
        lb.AddItem('2', img_fone2.Bitmap, '', 1199.00, 'AirPods Apple. Fones de ouvido com carregador incluso');
        lb.AddItem('3', img_iphone.Bitmap, '', 3910.00, 'Apple Iphone X 64GB com capa original');
        lb.AddItem('4', img_suporte.Bitmap, '', 35.00, 'Suporte para celular com acabamento em silicone');

        AtualizaQtd;
    finally
        lb.DisposeOf;
    end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
    ListBox.Items.Clear;
    AtualizaQtd;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
    lb := TCustomListBox.Create(ListBox);
    lb.ItemHeight := 230;
    lb.QtdColumns := 2;
    lb.Setup;

    lb.LoadFromWS('http://files.99coders.com.br/get-json-listbox.html');

    lb.DisposeOf;

    AtualizaQtd;
end;

procedure TForm1.Image3Click(Sender: TObject);
var
    x : integer;
    foto : TBitmap;
    foto_stream : TStream;
begin
    lb := TCustomListBox.Create(ListBox);
    lb.ItemHeight := 230;
    lb.QtdColumns := 2;
    lb.Setup;

    qry_produto.Active := false;
    qry_produto.sql.Clear;
    qry_produto.sql.Add('SELECT * FROM TAB_PRODUTO ORDER BY VALOR');
    qry_produto.Active := true;

    while NOT qry_produto.eof do
    begin
        if qry_produto.FieldByName('ICONE').AsString <> '' then
        begin
            foto_stream := qry_produto.CreateBlobStream(qry_produto.FieldByName('ICONE'), TBlobStreamMode.bmRead);

            foto := TBitmap.Create;
            foto.LoadFromStream(foto_stream);
        end;

        lb.AddItem(qry_produto.FieldByName('COD_PRODUTO').AsString,
                   foto,
                   '',
                   qry_produto.FieldByName('VALOR').AsFloat,
                   qry_produto.FieldByName('DESCRICAO').AsString);

        foto_stream.DisposeOf;
        foto.DisposeOf;

        qry_produto.Next;
    end;

    lb.DisposeOf;

    AtualizaQtd;
end;

procedure TForm1.ListBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    showmessage('Abrir detalhes do produto: ' + Item.tagstring);
end;

end.
