unit UnitPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.TabControl,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit, System.JSON,
  uLoading, REST.Client;

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
    TabControl: TTabControl;
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
    img_detalhe_qtd: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    lbl_qtd_orc: TLabel;
    rect_cancelar: TRectangle;
    Label2: TLabel;
    lv_orcamentos: TListView;
    img_aprovar: TImage;
    img_chat: TImage;
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
    rect_bottom: TRectangle;
    img_aprovado: TImage;
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
    procedure lv_orcamentosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    ind_refresh_pedido : Boolean;
    lbl : TLabel;
    procedure AddOrcamento(seq_orcamento, seq_usuario: integer; foto64, nome,
      dt, status: string; valor: double);
    procedure MudarAba(indice: integer);
    procedure AbrirEdicaoItem(titulo: string; lbl_edicao: TLabel);
    procedure FecharEdicaoItem(ind_cancelar: Boolean);
    procedure ProcessarPedido;
    procedure ProcessarPedidoErro(Sender: TObject);
    procedure ProcessarOrcamento;
    procedure ProcessarAprovacaoOrc;
    { Private declarations }
  public
    { Public declarations }
    id_pedido : Integer;
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, REST.Types, UnitCategoria, UnitChat,
  FMX.DialogService;

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
                                  foto64, nome, dt, status: string;
                                  valor: double);
begin
    with lv_orcamentos.Items.Add do
    begin
        Tag := seq_orcamento;
        TagString := seq_usuario.ToString;

        Height := 80;

        // Foto base64...
        if foto64 <> '' then
        begin
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := FrmPrincipal.BitmapFromBase64(foto64);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := true;
        end;
        //

        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        //TListItemText(Objects.FindDrawable('TxtValor')).Text := FormatFloat('#,##0.00', valor);
        TListItemText(Objects.FindDrawable('TxtValor')).Text := Format('%.2m', [valor]);

        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;

        TListItemImage(Objects.FindDrawable('ImgAprovar')).Bitmap := img_aprovar.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgAprovar')).TagString := status;

        TListItemImage(Objects.FindDrawable('ImgChat')).Bitmap := img_chat.Bitmap;

        TListItemImage(Objects.FindDrawable('ImgAprovado')).Bitmap := img_aprovado.Bitmap;
    end;
end;

procedure TFrmPedido.ProcessarAprovacaoOrc;
var
    jsonObj : TJsonObject;
    json, retorno: string;
begin
    try
        ind_refresh_pedido := true;

        json := dm.RequestOrcamentoAprov.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if dm.RequestOrcamentoAprov.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;

    // Atualizar a lista dos orcamentos...
    dm.RequestOrcamento.Params.Clear;
    dm.RequestOrcamento.AddParameter('id_pedido', id_pedido.ToString);
    dm.RequestOrcamento.ExecuteAsync(ProcessarOrcamento, true, true, ProcessarPedidoErro);

end;

procedure TFrmPedido.lv_orcamentosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if ItemObject is TListItemImage then
    begin
        if ItemObject.Name = 'ImgAprovar' then
        begin
            TDialogService.MessageDialog('Confirma aprovação do orçamento?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
            procedure(const AResult: TModalResult)
            var
                erro: string;
            begin
                if AResult = mrYes then
                begin
                    dm.RequestOrcamentoAprov.Params.Clear;
                    dm.RequestOrcamentoAprov.AddParameter('id', '');
                    dm.RequestOrcamentoAprov.AddParameter('id_orcamento', TListView(Sender).Items[ItemIndex].Tag.ToString);
                    dm.RequestOrcamentoAprov.AddParameter('id_pedido', id_pedido.ToString);
                    dm.RequestOrcamentoAprov.AddParameter('id_usuario_prestador', TListView(Sender).Items[ItemIndex].TagString);
                    dm.RequestOrcamentoAprov.Execute;

                    ProcessarAprovacaoOrc;
                end;
            end);
        end;

        if ItemObject.Name = 'ImgChat' then
        begin
            if NOT Assigned(FrmChat) then
                Application.CreateForm(TFrmChat, FrmChat);

            FrmChat.id_usuario_logado := FrmPrincipal.id_usuario_logado;
            FrmChat.ReqOrcamentoChat := dm.RequestOrcamentoChat;
            FrmChat.ReqOrcamentoChatEnv := dm.RequestOrcamentoChatEnv;
            FrmChat.id_usuario_destino := TListView(Sender).Items[ItemIndex].TagString.ToInteger;
            FrmChat.id_orcamento := TListView(Sender).Items[ItemIndex].Tag;
            FrmChat.lbl_nome.Text := TListItemText(TListView(Sender).Items[ItemIndex].Objects.FindDrawable('TxtNome')).Text;
            FrmChat.c_foto.Fill.Bitmap.Bitmap := TListItemImage(TListView(Sender).Items[ItemIndex].Objects.FindDrawable('ImgIcone')).Bitmap;
            FrmChat.Show;
        end
    end;
end;

procedure TFrmPedido.lv_orcamentosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt2: TListItemText;
    img_aprovar, img_chat: TListItemImage;
    status : string;
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
    img_aprovar := TListItemImage(AItem.Objects.FindDrawable('ImgAprovar'));
    img_aprovar.PlaceOffset.Y := Aitem.Height - 55;
    img_aprovar.Visible := false;
    status := img_aprovar.TagString;

    img_chat := TListItemImage(AItem.Objects.FindDrawable('ImgChat'));
    img_chat.PlaceOffset.Y := Aitem.Height - 55;
    img_chat.Visible := false;


    if status = 'P' then
    begin
        img_aprovar.Visible := true;
        img_chat.Visible := true;
    end;

    if status = 'A' then
    begin
        img_chat.Visible := true;
        TListItemImage(AItem.Objects.FindDrawable('ImgAprovado')).Visible := true;
    end;
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

    TabControl.GotoVisibleTab(indice, TTabTransition.Slide);
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
        if ((dm.RequestPedidoCad.Response.StatusCode < 200) and
           (dm.RequestPedidoCad.Response.StatusCode > 201)) or (retorno <> 'OK') then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;

    ind_refresh_pedido := true;
    close;
end;

procedure TFrmPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if ind_refresh_pedido then
        FrmPrincipal.ListarPendente;

    Action := TCloseAction.caFree;
    FrmPedido := nil;
end;

procedure TFrmPedido.ProcessarPedido;
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    try
        TLoading.Hide;

        json := dm.RequestPedidoDados.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if (dm.RequestPedidoDados.Response.StatusCode <> 200) then
        begin
            showmessage(retorno);
            exit;
        end;

        lbl_endereco.Text := jsonObj.GetValue('endereco').Value;
        lbl_grupo.Text := jsonObj.GetValue('categoria').Value + ' / ' + jsonObj.GetValue('grupo').Value;
        lbl_data.Text := Copy(jsonObj.GetValue('dt_servico').Value, 1, 16);
        lbl_detalhe.Text := jsonObj.GetValue('detalhe').Value;
        lbl_qtd_orc.Text := jsonObj.GetValue('qtd_max_orc').Value;

        lbl_categoria.TagString := jsonObj.GetValue('categoria').Value;
        lbl_grupo.TagString := jsonObj.GetValue('grupo').Value;

    finally
        jsonObj.DisposeOf;
    end;

    layout_cad.Visible := false;
    rect_fundo.Visible := false;
    MudarAba(0);


    try
        // Busca orcamentos do pedido...
        dm.RequestOrcamento.Params.Clear;
        dm.RequestOrcamento.AddParameter('id_pedido', id_pedido.ToString);
        dm.RequestOrcamento.ExecuteAsync(ProcessarOrcamento, true, true, ProcessarPedidoErro);

    except on ex:exception do
        begin
            TLoading.Hide;
            showmessage('Erro ao acessar o servidor: ' + ex.Message);
            exit;
        end;
    end;
end;

procedure TFrmPedido.ProcessarOrcamento;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin
    try
        lv_orcamentos.Items.Clear;

        json := dm.RequestOrcamento.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        // Se deu erro...
        if dm.RequestOrcamento.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

    except on ex:exception do
        begin
            showmessage(ex.Message);
            exit;
        end;
    end;

    try
        // Popular listview dos pedidos...
        lv_orcamentos.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddOrcamento(jsonArray.Get(i).GetValue<integer>('ID_ORCAMENTO', 0),
                        jsonArray.Get(i).GetValue<integer>('ID_USUARIO', 0),
                        jsonArray.Get(i).GetValue<string>('FOTO', ''),
                        jsonArray.Get(i).GetValue<string>('NOME', ''),
                        jsonArray.Get(i).GetValue<string>('DT_GERACAO', '01/01/2000 00:00:00'),
                        jsonArray.Get(i).GetValue<string>('STATUS', ''),
                        jsonArray.Get(i).GetValue<double>('VALOR_TOTAL', 0)
                        );
        end;

        jsonArray.DisposeOf;

    finally
        lv_orcamentos.EndUpdate;
        lv_orcamentos.RecalcSize;
    end;
end;

procedure TFrmPedido.ProcessarPedidoErro(Sender: TObject);
begin
    TLoading.Hide;

    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
    ind_refresh_pedido := false;
    lbl_endereco.Text := '';
    lbl_grupo.Text := '';
    lbl_data.Text := '';
    lbl_detalhe.Text := '';
    lbl_qtd_orc.Text := '03';
    img_detalhe_qtd.Visible := true;
    lbl_categoria.TagString := '';
    lbl_grupo.TagString := '';

    // Edicao...
    if id_pedido > 0 then
    begin
        TLoading.Show(FrmPedido, 'Carregando...');

        img_detalhe_qtd.Visible := false;

        try
            // Busca dados do pedido...
            dm.RequestPedidoDados.Params.Clear;
            dm.RequestPedidoDados.Resource := 'pedidos/pedido/' + id_pedido.ToString;
            dm.RequestPedidoDados.Method := rmGET;
            dm.RequestPedidoDados.ExecuteAsync(ProcessarPedido, true, true, ProcessarPedidoErro);

            // Busca orcamentos do pedido...
            //dm.RequestOrcamento.Params.Clear;
            //dm.RequestOrcamento.AddParameter('id_pedido', id_pedido.ToString);
            //dm.RequestOrcamento.ExecuteAsync(ProcessarOrcamento, true, true, ProcessarPedidoErro);

        except on ex:exception do
            begin
                TLoading.Hide;
                showmessage('Erro ao acessar o servidor: ' + ex.Message);
                exit;
            end;
        end;

    end;


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
    // Nao é possivel editar a qtd...
    if id_pedido > 0 then
        exit;

    AbrirEdicaoItem('Qtd . máxima de orçamentos',
                    lbl_qtd_orc);
end;

procedure TFrmPedido.lbi_servicoClick(Sender: TObject);
begin
    if NOT Assigned(FrmCategoria) then
        Application.CreateForm(TFrmCategoria, FrmCategoria);

    FrmCategoria.request_categoria := dm.RequestCategoria;
    FrmCategoria.request_grupo := dm.RequestGrupo;

    FrmCategoria.ShowModal(procedure(ModalResult: TModalResult)
    begin
        if FrmCategoria.categoria <> '' then
        begin
            lbl_categoria.TagString := FrmCategoria.categoria;
            lbl_grupo.TagString := FrmCategoria.grupo;

            lbl_grupo.Text := FrmCategoria.categoria + ' / ' + FrmCategoria.grupo;
        end;
    end);
end;

end.
