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
    lbi_obs: TListBoxItem;
    Image1: TImage;
    Layout1: TLayout;
    Label4: TLabel;
    lbl_obs: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure img_notificacaoClick(Sender: TObject);
    procedure rect_salvarClick(Sender: TObject);
    procedure lbi_enderecoClick(Sender: TObject);
    procedure rect_cad_salvarClick(Sender: TObject);
    procedure layout_cadClick(Sender: TObject);
    procedure img_cad_fecharClick(Sender: TObject);
    procedure lbi_dataClick(Sender: TObject);
    procedure lbi_detalheClick(Sender: TObject);
    procedure lbi_valorClick(Sender: TObject);
    procedure lbi_servicoClick(Sender: TObject);
  private
    ind_refresh_pedido : Boolean;
    lbl : TLabel;
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

uses UnitPrincipal, UnitDM, REST.Types, UnitCategoria,
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

procedure TFrmPedido.rect_cad_salvarClick(Sender: TObject);
begin
    FecharEdicaoItem(false);
end;

procedure TFrmPedido.rect_salvarClick(Sender: TObject);
var
    jsonObj : TJsonObject;
    json, retorno: string;
begin
    {
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
    }
end;

procedure TFrmPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if ind_refresh_pedido then
        FrmPrincipal.ListarPendente;

    Action := TCloseAction.caFree;
    FrmPedido := nil;
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
        //TLoading.Show(FrmPedido, 'Carregando...');

        img_detalhe_qtd.Visible := false;

        try
            // Busca dados do pedido...
            {
            dm.RequestPedidoDados.Params.Clear;
            dm.RequestPedidoDados.Resource := 'pedidos/pedido/' + id_pedido.ToString;
            dm.RequestPedidoDados.Method := rmGET;
            dm.RequestPedidoDados.ExecuteAsync(ProcessarPedido, true, true, ProcessarPedidoErro);
            }
        except on ex:exception do
            begin
                //TLoading.Hide;
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

procedure TFrmPedido.lbi_valorClick(Sender: TObject);
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
