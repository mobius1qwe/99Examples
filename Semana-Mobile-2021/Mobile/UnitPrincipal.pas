unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    img_aba1: TImage;
    img_aba2: TImage;
    img_aba3: TImage;
    img_aba4: TImage;
    TabControl: TTabControl;
    TabAba1: TTabItem;
    TabAba2: TTabItem;
    TabAba3: TTabItem;
    TabAba4: TTabItem;
    Layout4: TLayout;
    Image5: TImage;
    Layout2: TLayout;
    rect_cidade: TRectangle;
    edt_conta_nome: TEdit;
    Label4: TLabel;
    Image6: TImage;
    lb_categorias: TListBox;
    Layout3: TLayout;
    Label1: TLabel;
    img_exp_voltar: TImage;
    Layout5: TLayout;
    Label2: TLabel;
    Layout6: TLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    lv_explorar: TListView;
    rect_exp_buscar: TRectangle;
    Label3: TLabel;
    Layout7: TLayout;
    Label5: TLabel;
    lb_agenda: TListBox;
    Layout8: TLayout;
    Label6: TLabel;
    Layout9: TLayout;
    Rectangle4: TRectangle;
    edt_perfil_nome: TEdit;
    rect_perfil_senha: TRectangle;
    Label7: TLabel;
    Rectangle7: TRectangle;
    edt_perfil_email: TEdit;
    Rectangle2: TRectangle;
    Label8: TLabel;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    procedure FormShow(Sender: TObject);
    procedure img_aba1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure img_exp_voltarClick(Sender: TObject);
    procedure lv_explorarItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure CarregarCategorias(cidade: string);
    procedure MudarAba(img: TImage);
    procedure CarregarExplorar(cidade, termo: string);
    procedure CarregarAgendamentos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitFrameCategoria, UnitFrameAgendamento, UnitDetalheEmpresa;

procedure TFrmPrincipal.CarregarExplorar(cidade, termo: string);
var
    i : integer;
begin
    lv_explorar.Items.Clear;

    // Acessar os dados no servidor...


    for i := 1 to 10 do
    begin
        with lv_explorar.Items.Add do
        begin
            Height := 100;
            TagString := i.ToString;

            TListItemText(Objects.FindDrawable('Txt_nome')).Text := 'Clínica ' + i.ToString;
            TListItemText(Objects.FindDrawable('Txt_endereco')).Text := 'Av. Brasil, 1500' + sLineBreak +
                                                                        'Jardins - São Paulo' + sLineBreak +
                                                                        '(11) 0000-0000';
        end;
    end;
end;

procedure TFrmPrincipal.MudarAba(img: TImage);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img.Opacity := 1;
    TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);
end;

procedure TFrmPrincipal.CarregarAgendamentos;
var
    i : integer;
    item : TListBoxItem;
    frame : TFrameAgendamento;
begin
    lb_agenda.Items.Clear;

    // Acessar o servidor e buscar as categorias...

    for i := 1 to 5 do
    begin
        item := TListBoxItem.Create(lb_agenda);
        item.Text := '';
        item.Height := 250;

        frame := TFrameAgendamento.Create(item);
        frame.Parent := item;
        frame.Align := TAlignLayout.Client;

        lb_agenda.AddObject(item);
    end;
end;

procedure TFrmPrincipal.CarregarCategorias(cidade: string);
var
    i : integer;
    item : TListBoxItem;
    frame : TFrameCategoria;
begin
    lb_categorias.Items.Clear;

    // Acessar o servidor e buscar as categorias...

    for i := 1 to 9 do
    begin
        item := TListBoxItem.Create(lb_categorias);
        item.Text := '';
        item.Width := 105;
        item.Height := 150;

        frame := TFrameCategoria.Create(item);
        frame.Parent := item;
        frame.Align := TAlignLayout.Client;


        lb_categorias.AddObject(item);
    end;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
    lb_categorias.Columns := Trunc(lb_categorias.Width / 105);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    MudarAba(img_aba1);
    CarregarCategorias('');
    CarregarExplorar('', '');
    CarregarAgendamentos;
end;

procedure TFrmPrincipal.img_aba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.img_exp_voltarClick(Sender: TObject);
begin
    MudarAba(img_aba1);
end;

procedure TFrmPrincipal.lv_explorarItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    FrmDetalheEmpresa.Show;
end;

end.
