unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON, uFunctions;

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
    edt_cidade: TEdit;
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
    edt_busca: TEdit;
    lv_explorar: TListView;
    rect_buscar: TRectangle;
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
    img_nao_reserva: TImage;
    Line5: TLine;
    procedure FormShow(Sender: TObject);
    procedure img_aba1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure img_exp_voltarClick(Sender: TObject);
    procedure lv_explorarItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure edt_cidadeExit(Sender: TObject);
    procedure lb_categoriasItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure rect_buscarClick(Sender: TObject);
    procedure lv_explorarUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure CarregarCategorias(cidade: string);
    procedure MudarAba(img: TImage);
    procedure CarregarExplorar(cidade, termo: string; id_categoria: integer);
    { Private declarations }
  public
    { Public declarations }
    id_cat_global : integer;
    id_usuario_global : integer;
    ind_fechar_telas : boolean;
    procedure CarregarAgendamentos;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitFrameCategoria, UnitFrameAgendamento, UnitDetalheEmpresa, UnitDM;

procedure TFrmPrincipal.CarregarExplorar(cidade, termo: string; id_categoria: integer);
var
    i : integer;
    jsonArray : TJSONArray;
    erro: string;
begin
    lv_explorar.Items.Clear;

    // Acessar os dados no servidor...
    if NOT dm.ListarEmpresa(cidade, termo, 'N', '',
                           id_categoria, jsonArray, erro) then
    begin
        showmessage(erro);
        exit;
    end;

    for i := 0 to jsonArray.Size - 1 do
    begin
        with lv_explorar.Items.Add do
        begin
            Height := 100;
            Tag := jsonArray.Get(i).GetValue<integer>('ID_EMPRESA', 0);

            TListItemText(Objects.FindDrawable('Txt_nome')).Text := jsonArray.Get(i).GetValue<string>('NOME', '');
            TListItemText(Objects.FindDrawable('Txt_endereco')).Text :=
                    jsonArray.Get(i).GetValue<string>('ENDERECO', '') + sLineBreak +
                    jsonArray.Get(i).GetValue<string>('BAIRRO', '') + ' - ' +
                    jsonArray.Get(i).GetValue<string>('CIDADE', '') + sLineBreak +
                    jsonArray.Get(i).GetValue<string>('FONE', '');
        end;
    end;

    jsonArray.DisposeOf;
end;

procedure TFrmPrincipal.edt_cidadeExit(Sender: TObject);
begin
    CarregarCategorias(edt_cidade.Text);
end;

procedure TFrmPrincipal.MudarAba(img: TImage);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img.Opacity := 1;
    TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);


    // Aba de agendamentos confirmados...
    if img.Tag = 2 then
        CarregarAgendamentos;
end;

procedure TFrmPrincipal.rect_buscarClick(Sender: TObject);
begin
    CarregarExplorar(edt_cidade.Text, edt_busca.Text, id_cat_global);
end;

procedure TFrmPrincipal.CarregarAgendamentos;
var
    i : integer;
    item : TListBoxItem;
    frame : TFrameAgendamento;
    jsonArray : TJSONArray;
    erro: string;
begin
    lb_agenda.Items.Clear;
    img_nao_reserva.Visible := false;

    // Acessar o servidor e buscar as categorias...
    if NOT dm.ListarReserva(id_usuario_global, jsonArray, erro) then
    begin
        showmessage(erro);
        exit;
    end;


    for i := 0 to jsonArray.Size - 1 do
    begin
        item := TListBoxItem.Create(lb_agenda);
        item.Text := '';
        item.Height := 250;

        frame := TFrameAgendamento.Create(item);
        frame.Parent := item;
        frame.Align := TAlignLayout.Client;

        frame.lbl_servico.Text := jsonArray.Get(i).GetValue<string>('DESCRICAO', '');
        frame.lbl_nome.Text := jsonArray.Get(i).GetValue<string>('NOME', '');
        frame.lbl_data.Text := jsonArray.Get(i).GetValue<string>('DATA_RESERVA', '').Substring(0, 10);
        frame.lbl_hora.Text := jsonArray.Get(i).GetValue<string>('HORA', '');
        frame.lbl_valor.Text := 'R$ ' + FormatFloat('#,##0.00', jsonArray.Get(i).GetValue<double>('VALOR', 0));
        frame.lbl_endereco.Text := jsonArray.Get(i).GetValue<string>('ENDERECO', '') + sLineBreak +
                                   jsonArray.Get(i).GetValue<string>('BAIRRO', '') + ' - ' +
                                   jsonArray.Get(i).GetValue<string>('CIDADE', '') + sLineBreak +
                                   jsonArray.Get(i).GetValue<string>('FONE', '');
        frame.rect_excluir.Tag := jsonArray.Get(i).GetValue<integer>('ID_RESERVA', 0);

        lb_agenda.AddObject(item);
    end;

    img_nao_reserva.Visible := jsonArray.Size = 0;

    jsonArray.DisposeOf;

end;

procedure TFrmPrincipal.CarregarCategorias(cidade: string);
var
    i : integer;
    item : TListBoxItem;
    frame : TFrameCategoria;
    jsonArray : TJsonArray;
    erro, icone64 : string;
begin
    if cidade = '' then
        exit;

    lb_categorias.Items.Clear;

    // Acessar o servidor e buscar as categorias...
    if NOT dm.ListarCategoria(cidade, jsonArray, erro)  then
    begin
        showmessage(erro);
        exit;
    end;


    for i := 0 to jsonArray.Size - 1 do
    begin
        item := TListBoxItem.Create(lb_categorias);
        item.Text := '';
        item.Width := 105;
        item.Height := 150;
        item.Selectable := false;
        item.Tag := jsonArray.Get(i).GetValue<integer>('ID_CATEGORIA', 0);

        frame := TFrameCategoria.Create(item);
        frame.Parent := item;
        frame.Align := TAlignLayout.Client;

        frame.lbl_cat.Text := jsonArray.Get(i).GetValue<string>('DESCRICAO', '');

        icone64 := jsonArray.Get(i).GetValue<string>('ICONE', '');

        try
            if icone64 <> '' then
                frame.img_cat.Bitmap := TFunctions.BitmapFromBase64(icone64);
        except
        end;

        lb_categorias.AddObject(item);
    end;

    jsonArray.DisposeOf;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
    lb_categorias.Columns := Trunc(lb_categorias.Width / 105);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    MudarAba(img_aba1);
    CarregarCategorias(edt_cidade.Text);
end;

procedure TFrmPrincipal.img_aba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.img_exp_voltarClick(Sender: TObject);
begin
    MudarAba(img_aba1);
end;

procedure TFrmPrincipal.lb_categoriasItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    id_cat_global := item.Tag;
    CarregarExplorar(edt_cidade.Text, '', item.tag);
    MudarAba(img_aba2);
end;

procedure TFrmPrincipal.lv_explorarItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
    i : integer;
    jsonArray : TJSONArray;
    erro: string;
begin
    ind_fechar_telas := false;

    if NOT Assigned(FrmDetalheEmpresa) then
        Application.CreateForm(TFrmDetalheEmpresa, FrmDetalheEmpresa);

    // Busca detalhes dessa empresa selecionada...
    if NOT dm.ListarEmpresa(edt_cidade.Text, '', 'S', Aitem.Tag.ToString,
                           id_cat_global, jsonArray, erro) then
    begin
        showmessage(erro);
        exit;
    end;


    if jsonArray.Size = 0 then
    begin
        showmessage('Detalhes da empresa não encontrado');
        jsonArray.DisposeOf;
        exit;
    end;

    // Popula objetos do formulario a ser aberto...
    FrmDetalheEmpresa.id_emp := jsonArray.Get(0).GetValue<integer>('ID_EMPRESA', 0);
    FrmDetalheEmpresa.lbl_nome.Text := jsonArray.Get(0).GetValue<string>('NOME', '');
    FrmDetalheEmpresa.lbl_endereco.Text := jsonArray.Get(0).GetValue<string>('ENDERECO', '') + sLineBreak +
                                            jsonArray.Get(0).GetValue<string>('BAIRRO', '') + ' - ' +
                                            jsonArray.Get(0).GetValue<string>('CIDADE', '') + sLineBreak +
                                            jsonArray.Get(0).GetValue<string>('FONE', '');

    if jsonArray.Get(0).GetValue<string>('FOTO', '') <> '' then
        FrmDetalheEmpresa.img_foto.Bitmap := TFunctions.BitmapFromBase64(jsonArray.Get(0).GetValue<string>('FOTO', ''))
    else
        FrmDetalheEmpresa.img_foto.Bitmap := FrmDetalheEmpresa.img_no_foto.Bitmap;

    FrmDetalheEmpresa.Showmodal(procedure(Modal:TmodalResult)
    begin
        if ind_fechar_telas then
            MudarAba(img_aba3);
    end);

    jsonArray.DisposeOf;
end;

procedure TFrmPrincipal.lv_explorarUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    TListItemText(AItem.Objects.FindDrawable('Txt_nome')).Font.Size := 13;
    TListItemText(AItem.Objects.FindDrawable('Txt_endereco')).Font.Size := 13;
end;

end.
