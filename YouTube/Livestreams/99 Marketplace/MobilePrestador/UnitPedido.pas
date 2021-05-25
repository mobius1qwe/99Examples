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
    TabControl: TTabControl;
    TabPedido: TTabItem;
    TabOrcamentos: TTabItem;
    ListBox1: TListBox;
    lbi_endereco: TListBoxItem;
    Layout2: TLayout;
    lbl_endereco: TLabel;
    Line2: TLine;
    lbi_servico: TListBoxItem;
    Layout4: TLayout;
    lbl_categoria: TLabel;
    lbl_grupo: TLabel;
    Line3: TLine;
    lbi_data: TListBoxItem;
    Layout5: TLayout;
    Label10: TLabel;
    lbl_data: TLabel;
    Line4: TLine;
    lbi_detalhe: TListBoxItem;
    Layout6: TLayout;
    Label12: TLabel;
    lbl_detalhe: TLabel;
    Line5: TLine;
    lbi_valor: TListBoxItem;
    img_detalhe_qtd: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    lbl_valor: TLabel;
    rect_cancelar: TRectangle;
    Label2: TLabel;
    lv_orcamentos: TListView;
    img_aprovar: TImage;
    rect_salvar: TRectangle;
    lbl_salvar: TLabel;
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
    lbi_obs: TListBoxItem;
    Image1: TImage;
    Layout1: TLayout;
    Label4: TLabel;
    lbl_obs: TLabel;
    Line6: TLine;
    Line7: TLine;
    img_chat: TImage;
    lbi_cliente: TListBoxItem;
    c_foto: TCircle;
    lbl_nome: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure img_notificacaoClick(Sender: TObject);
    procedure rect_salvarClick(Sender: TObject);
    procedure rect_cad_salvarClick(Sender: TObject);
    procedure layout_cadClick(Sender: TObject);
    procedure img_cad_fecharClick(Sender: TObject);
    procedure lbi_valorClick(Sender: TObject);
    procedure lbi_obsClick(Sender: TObject);
    procedure img_chatClick(Sender: TObject);
  private
    ind_refresh_pedido : Boolean;
    lbl : TLabel;
    procedure AbrirEdicaoItem(titulo: string; lbl_edicao: TLabel);
    procedure FecharEdicaoItem(ind_cancelar: Boolean);
    procedure ProcessarPedido;
    procedure ProcessarPedidoErro(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    id_pedido, id_orcamento, id_usuario_cliente : Integer;
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM, REST.Types, UnitCategoria,
  FMX.DialogService, UnitChat;

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

procedure TFrmPedido.rect_cad_salvarClick(Sender: TObject);
begin
    FecharEdicaoItem(false);
end;

procedure TFrmPedido.rect_salvarClick(Sender: TObject);
var
    jsonObj : TJsonObject;
    json, retorno: string;
begin
    // Criar ou editar um orcamento no server...
    try
        dm.RequestOrcamentoCad.Params.Clear;
        dm.RequestOrcamentoCad.AddParameter('id', '');

        if id_orcamento > 0 then
        begin
            // edicao do orcamento
            dm.RequestOrcamentoCad.Method := rmPATCH;
            dm.RequestOrcamentoCad.AddParameter('id_orcamento', id_orcamento.ToString);
        end
        else
        begin
            // inclusao do orcamento
            dm.RequestOrcamentoCad.Method := rmPOST;
            dm.RequestOrcamentoCad.AddParameter('id_pedido', id_pedido.ToString);
        end;

        dm.RequestOrcamentoCad.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
        dm.RequestOrcamentoCad.AddParameter('valor_total', FormatFloat('0', lbl_valor.Text.ToDouble * 100));
        dm.RequestOrcamentoCad.AddParameter('obs', lbl_obs.Text);
        dm.RequestOrcamentoCad.Execute;

    except on ex:exception do
        begin
            showmessage('Erro ao acessar o servidor: ' + ex.Message);
            exit;
        end;
    end;


    try
        json := dm.RequestOrcamentoCad.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if ((dm.RequestOrcamentoCad.Response.StatusCode < 200) and
           (dm.RequestOrcamentoCad.Response.StatusCode > 201)) or (retorno <> 'OK') then
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
        lbl_valor.Text := jsonObj.GetValue('valor_orcado').Value;
        lbl_obs.Text := jsonObj.GetValue('obs_orcado').Value;


    finally
        jsonObj.DisposeOf;
    end;

    layout_cad.Visible := false;
    rect_fundo.Visible := false;
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
    img_detalhe_qtd.Visible := true;
    lbl_categoria.TagString := '';
    lbl_grupo.TagString := '';

    lbl_valor.Text := '0,00';
    lbl_obs.Text := '';

    img_chat.Visible := id_orcamento > 0;

    if id_orcamento > 0 then
        lbl_salvar.Text := 'Salvar Alterações'
    else
        lbl_salvar.Text := 'Enviar Orçamento';

    TLoading.Show(FrmPedido, 'Carregando...');

    try
        // Busca dados do pedido...
        dm.RequestPedidoDados.Params.Clear;
        dm.RequestPedidoDados.AddParameter('id', '');
        dm.RequestPedidoDados.AddParameter('id_usuario_prestador', FrmPrincipal.id_usuario_logado.ToString);
        dm.RequestPedidoDados.Resource := 'prestadores/pedido/' + id_pedido.ToString;
        dm.RequestPedidoDados.Method := rmGET;
        dm.RequestPedidoDados.ExecuteAsync(ProcessarPedido, true, true, ProcessarPedidoErro);

    except on ex:exception do
        begin
            //TLoading.Hide;
            showmessage('Erro ao acessar o servidor: ' + ex.Message);
            exit;
        end;
    end;

end;

procedure TFrmPedido.img_cad_fecharClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmPedido.img_chatClick(Sender: TObject);
begin
    if NOT Assigned(FrmChat) then
        Application.CreateForm(TFrmChat, FrmChat);

    FrmChat.id_usuario_logado := FrmPrincipal.id_usuario_logado;
    FrmChat.ReqOrcamentoChat := dm.RequestOrcamentoChat;
    FrmChat.ReqOrcamentoChatEnv := dm.RequestOrcamentoChatEnv;
    FrmChat.id_usuario_destino := id_usuario_cliente;
    FrmChat.id_orcamento := FrmPedido.id_orcamento;
    FrmChat.lbl_nome.Text := FrmPedido.lbl_nome.Text;
    FrmChat.c_foto.Fill.Bitmap.Bitmap := FrmPedido.c_foto.Fill.Bitmap.Bitmap;
    FrmChat.Show;
end;

procedure TFrmPedido.img_notificacaoClick(Sender: TObject);
begin
    close;
end;

procedure TFrmPedido.layout_cadClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmPedido.lbi_obsClick(Sender: TObject);
begin
     AbrirEdicaoItem('Obs do Orçamento', lbl_obs);
end;

procedure TFrmPedido.lbi_valorClick(Sender: TObject);
begin
    AbrirEdicaoItem('Valor do Orçamento', lbl_valor);
end;

end.
