unit UnitPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.TabControl,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit, System.JSON;

type
  TFrmPedido = class(TForm)
    layout_toolbar: TLayout;
    lbl_titulo: TLabel;
    img_notificacao: TImage;
    Line1: TLine;
    rect_abas: TRectangle;
    rect_aba1: TRectangle;
    lbl_aba1: TLabel;
    rect_aba2: TRectangle;
    lbl_aba2: TLabel;
    TabControl1: TTabControl;
    TabPedido: TTabItem;
    TabOrcamentos: TTabItem;
    ListBox1: TListBox;
    lbi_endereco: TListBoxItem;
    Image9: TImage;
    Layout2: TLayout;
    lbl_endereco: TLabel;
    Line2: TLine;
    lbi_servico: TListBoxItem;
    Image11: TImage;
    Layout4: TLayout;
    lbl_categoria: TLabel;
    lbl_grupo: TLabel;
    Line3: TLine;
    lbi_data: TListBoxItem;
    Image12: TImage;
    Layout5: TLayout;
    Label10: TLabel;
    lbl_data: TLabel;
    Line4: TLine;
    lbi_detalhe: TListBoxItem;
    Image13: TImage;
    Layout6: TLayout;
    Label12: TLabel;
    lbl_detalhe: TLabel;
    Line5: TLine;
    lbi_qtd: TListBoxItem;
    Image10: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    lbl_qtd_orc: TLabel;
    lbi_cancelar: TListBoxItem;
    rect_cancelar: TRectangle;
    Label2: TLabel;
    lv_orcamentos: TListView;
    img_aprovar: TImage;
    img_chat: TImage;
    lbi_salvar: TListBoxItem;
    rect_salvar: TRectangle;
    Label1: TLabel;
    rect_fundo: TRectangle;
    rect_cad: TRectangle;
    layout_cad: TLayout;
    lbl_cad_titulo: TLabel;
    rect_cad_salvar: TRectangle;
    Label25: TLabel;
    edt_cad_texto: TEdit;
    Label3: TLabel;
    img_cad_fechar: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure rect_aba1Click(Sender: TObject);
    procedure img_notificacaoClick(Sender: TObject);
    procedure lv_orcamentosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure rect_salvarClick(Sender: TObject);
    procedure lbi_enderecoClick(Sender: TObject);
    procedure rect_cad_salvarClick(Sender: TObject);
    procedure layout_cadClick(Sender: TObject);
    procedure img_cad_fecharClick(Sender: TObject);
    procedure lbi_dataClick(Sender: TObject);
    procedure lbi_detalheClick(Sender: TObject);
    procedure lbi_qtdClick(Sender: TObject);
    procedure lbi_servicoClick(Sender: TObject);
  private
    lbl : TLabel;
    procedure ListarOrcamento;
    procedure AddOrcamento(seq_orcamento, seq_usuario: integer; foto64, nome,
      dt: string; valor: double);
    procedure MudarAba(indice: integer);
    procedure AbrirEdicaoItem(titulo: string; lbl_edicao: TLabel);
    procedure FecharEdicaoItem(ind_cancelar: Boolean);
    { Private declarations }
  public
    { Public declarations }
    id_pedido : Integer;
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, REST.Types;

procedure TFrmPedido.AbrirEdicaoItem(titulo : string; lbl_edicao : TLabel);
begin
    lbl_cad_titulo.Text := titulo;
    edt_cad_texto.Text := lbl_edicao.Text;
    lbl := lbl_edicao;

    rect_cad.Margins.Top := -rect_cad.Height;
    rect_fundo.Visible := true;
    layout_cad.Visible := true;

    rect_cad.AnimateFloat('Margins.Top', 0, 0.3, TAnimationType.InOut,
                           TInterpolationType.Circular);
end;

procedure TFrmPedido.FecharEdicaoItem(ind_cancelar : Boolean);
begin
    if NOT ind_cancelar then
        lbl.Text := edt_cad_texto.Text;

    rect_cad.AnimateFloat('Margins.Top', -rect_cad.Height, 0.3,
                          TAnimationType.InOut,
                          TInterpolationType.Circular);

    TThread.CreateAnonymousThread(procedure
    begin
        Sleep(320);

        TThread.Synchronize(nil, procedure
        begin
            rect_fundo.Visible := false;
            layout_cad.Visible := false;
        end);
    end).Start;

end;


procedure TFrmPedido.AddOrcamento(seq_orcamento, seq_usuario : integer;
                                  foto64, nome, dt: string;
                                  valor: double);
begin
    with lv_orcamentos.Items.Add do
    begin
        Tag := seq_orcamento;
        TagString := seq_usuario.ToString;

        Height := 80;

        // Foto base64...
        if foto64 <> '' then
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := FrmPrincipal.BitmapFromBase64(foto64);
        //

        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        //TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);
        TListItemText(Objects.FindDrawable('TxtValor')).Text := Format('%.2m', [valor]);

        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;

        TListItemImage(Objects.FindDrawable('ImgAprovar')).Bitmap := img_aprovar.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgChat')).Bitmap := img_chat.Bitmap;
    end;
end;

procedure TFrmPedido.ListarOrcamento;
var
    x : integer;
begin
    // Buscar notificacaoes no servidor...

    lv_orcamentos.Items.Clear;

    for x := 1 to 10 do
        AddOrcamento(x, 0, '', 'Heber Stein Stein Mazutti', '20/10', 150.25 * x);
end;

procedure TFrmPedido.lv_orcamentosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt2: TListItemText;
    img: TListItemImage;
begin
    // Calcula tamanho do nome...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtNome'));
    txt.Width := lv_orcamentos.Width - 110;
    txt.Height := FrmPrincipal.GetTextHeight(txt, txt.Width, txt.Text) - 15;

    // Calcula objeto valor...
    txt2 := TListItemText(AItem.Objects.FindDrawable('TxtValor'));
    //txt2.Width := lv_orcamentos.Width - 255;
    txt2.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height;


    // Calcula objeto data...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtData'));
    //txt.Width := lv_orcamentos.Width - 255;
    txt.PlaceOffset.Y := txt2.PlaceOffset.Y + txt2.Height;



    // Calcula altura do item da listview...
    Aitem.Height := Trunc(txt.PlaceOffset.Y + txt.Height + 20);

    if lv_orcamentos.Width < 330 then
        AItem.Height := AItem.Height + 40;


    // Botoes...
    img := TListItemImage(AItem.Objects.FindDrawable('ImgAprovar'));
    img.PlaceOffset.Y := Aitem.Height - 55;

    img := TListItemImage(AItem.Objects.FindDrawable('ImgChat'));
    img.PlaceOffset.Y := Aitem.Height - 55;
end;


procedure TFrmPedido.MudarAba(indice: integer);
begin
    // Reset para fundo branco...
    rect_aba1.Fill.Color := $FFFFFFFF;
    lbl_aba1.FontColor := $FFADADAD;
    rect_aba2.Fill.Color := $FFFFFFFF;
    lbl_aba2.FontColor := $FFADADAD;

    if indice = 0 then
    begin
        rect_aba1.Fill.Color := $FF1878F3;
        lbl_aba1.FontColor := $FFFFFFFF;
    end
    else
    begin
        rect_aba2.Fill.Color := $FF1878F3;
        lbl_aba2.FontColor := $FFFFFFFF;
    end;

    TabControl1.GotoVisibleTab(indice, TTabTransition.Slide);
end;

procedure TFrmPedido.rect_aba1Click(Sender: TObject);
begin
    MudarAba(TRectangle(Sender).Tag);
end;

procedure TFrmPedido.rect_cad_salvarClick(Sender: TObject);
begin
    FecharEdicaoItem(false);
end;

procedure TFrmPedido.rect_salvarClick(Sender: TObject);
var
    jsonObj : TJsonObject;
    json, retorno: string;
begin
    // Criar novo pedido no server...
    try
        dm.RequestPedidoCad.Params.Clear;
        dm.RequestPedidoCad.AddParameter('id', '');

        if id_pedido > 0 then
        begin
            // edicao
            lbl_grupo.TagString := 'Pet';
            dm.RequestPedidoCad.Method := rmPATCH;
            dm.RequestPedidoCad.AddParameter('id_pedido', id_pedido.tostring);
        end
        else
        begin
            // inclusao
            dm.RequestPedidoCad.Method := rmPOST;
            dm.RequestPedidoCad.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
            dm.RequestPedidoCad.AddParameter('qtd_max_orc', lbl_qtd_orc.Text);
        end;

        dm.RequestPedidoCad.AddParameter('categoria', lbl_categoria.TagString);
        dm.RequestPedidoCad.AddParameter('grupo', lbl_grupo.TagString);
        dm.RequestPedidoCad.AddParameter('endereco', lbl_endereco.Text);
        dm.RequestPedidoCad.AddParameter('dt_servico', lbl_data.Text + ':00');
        dm.RequestPedidoCad.AddParameter('detalhe', lbl_detalhe.Text);
        dm.RequestPedidoCad.Execute;
    except on ex:exception do
        begin
            showmessage('Erro ao acessar o servidor: ' + ex.Message);
            exit;
        end;
    end;


    try
        json := dm.RequestPedidoCad.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if (dm.RequestPedidoCad.Response.StatusCode < 200) and
           (dm.RequestPedidoCad.Response.StatusCode > 201) then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;

    FrmPrincipal.ListarPendente;
    close;
end;

procedure TFrmPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmPedido := nil;
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
    layout_cad.Visible := false;
    rect_fundo.Visible := false;
    MudarAba(0);
    ListarOrcamento;

    lbl_categoria.TagString := 'Serviços Domésticos';
    lbl_grupo.TagString := 'Limpeza';
end;

procedure TFrmPedido.img_cad_fecharClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmPedido.img_notificacaoClick(Sender: TObject);
begin
    close;
end;

procedure TFrmPedido.layout_cadClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmPedido.lbi_dataClick(Sender: TObject);
begin
    AbrirEdicaoItem('Data a ser prestado o serviço',
                    lbl_data);
end;

procedure TFrmPedido.lbi_detalheClick(Sender: TObject);
begin
    AbrirEdicaoItem('Detalhes do serviço',
                    lbl_detalhe);
end;

procedure TFrmPedido.lbi_enderecoClick(Sender: TObject);
begin
    AbrirEdicaoItem('Endereço a ser prestado o serviço',
                    lbl_endereco);
end;

procedure TFrmPedido.lbi_qtdClick(Sender: TObject);
begin
    AbrirEdicaoItem('Qtd . máxima de orçamentos',
                    lbl_qtd_orc);
end;

procedure TFrmPedido.lbi_servicoClick(Sender: TObject);
begin
    AbrirEdicaoItem('Escolha o serviço',
                    lbl_grupo);
end;

end.
