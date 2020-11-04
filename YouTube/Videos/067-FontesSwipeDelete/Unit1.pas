unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView, FMX.Objects;

type
  TForm1 = class(TForm)
    listview: TListView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    img_andamento: TImage;
    img_importante: TImage;
    img_feito: TImage;
    img_fazer: TImage;
    SpeedButton2: TSpeedButton;
    Line1: TLine;
    procedure listviewUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure listviewDeletingItem(Sender: TObject; AIndex: Integer;
      var ACanDelete: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Add_Tarefa(id, tipo : integer; descricao : string);
var
        item : TListViewItem;
        txt : TListItemText;
        img : TListItemImage;
begin
        with form1 do
        begin
                item := listview.Items.Add;
                item.Objects.Clear;
                item.TagString := id.ToString;

                with item do
                begin
                        // Cor da tarefa...
                        img := TListItemImage(Objects.FindDrawable('Image2'));
                        img.PlaceOffset.X := 0;
                        img.PlaceOffset.Y := 0;
                        img.Width := 10;
                        img.Height := 70;
                        img.ScalingMode := TImageScalingMode.Stretch;

                        case tipo of
                            1: img.Bitmap := img_fazer.Bitmap;
                            2: img.Bitmap := img_importante.Bitmap;
                            3: img.Bitmap := img_andamento.Bitmap;
                            4: img.Bitmap := img_feito.Bitmap;
                        end;



                        // Descrição da tarefa...
                        txt := TListItemText(Objects.FindDrawable('Text1'));
                        txt.Text := descricao;
                        txt.Font.Size := 18;
                        txt.Height := 70;
                        //txt.Font.Style := [TFontStyle.fsBold];
                        txt.PlaceOffset.X := 25;
                        txt.PlaceOffset.Y := 0;
                        txt.TagString := id.ToString;

                end;
        end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        img_andamento.Visible := false;
        img_importante.Visible := false;
        img_feito.Visible := false;
        img_fazer.Visible := false;

        // Configurar texto do botao delete..
        listview.DeleteButtonText := 'Excluir';
end;

procedure TForm1.listviewDeletingItem(Sender: TObject; AIndex: Integer;
  var ACanDelete: Boolean);
var
    txt : TListItemText;
begin
    txt := TListItemText(Form1.listview.Items[AIndex].Objects.FindDrawable('Text1'));

    if txt.TagString <> '111' then
        showmessage('Excluindo tarefa id = ' + txt.tagstring)
    else
        ACanDelete := false;

end;

procedure TForm1.listviewUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
        img : TListItemImage;
        txt : TListItemText;
begin
        with AItem do
        begin
                // Cor da tarefa...
                img := TListItemImage(Objects.FindDrawable('Image2'));
                img.ScalingMode := TImageScalingMode.Stretch;
                img.Width := 15;
                img.Height := 70;


                // Tarefa...
                txt := TListItemText(Objects.FindDrawable('Text1'));
                txt.PlaceOffset.X := 25;
                txt.PlaceOffset.Y := 0;
                txt.Height := 70;
                txt.Font.Size := 18;
        end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
        listview.BeginUpdate;

        Add_Tarefa(110, 1, 'Imprimir Relatório');
        Add_Tarefa(111, 2, 'Enviar Proposta');
        Add_Tarefa(112, 3, 'Desenvolver Site');
        Add_Tarefa(113, 4, 'Configurar Servidor');
        Add_Tarefa(114, 1, 'Configurar Database');
        Add_Tarefa(115, 4, 'Criar Planilhas');
        Add_Tarefa(116, 1, 'Responder Chamados');
        Add_Tarefa(117, 2, 'Importar Dados Clientes');
        Add_Tarefa(118, 3, 'Tratar Fotos Produtos');

        listview.EndUpdate;
end;

end.
