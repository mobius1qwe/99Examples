unit UnitChat;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  FMX.ScrollBox, FMX.Memo, System.JSON, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, uFunctions;

type
  TFrmChat = class(TForm)
    layout_toolbar: TLayout;
    lbl_titulo: TLabel;
    img_fechar: TImage;
    Line1: TLine;
    rect_prestador: TRectangle;
    c_foto: TCircle;
    lbl_nome: TLabel;
    lv_chat: TListView;
    rect_msg: TRectangle;
    img_enviar: TImage;
    m_msg: TMemo;
    Rectangle1: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure lv_chatUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_enviarClick(Sender: TObject);
    procedure img_fecharClick(Sender: TObject);
    procedure lv_chatPullRefresh(Sender: TObject);
  private
    procedure AddChat(id_usuario_de, id_usuario_para: integer;
                      msg, dt, ind_msg_minha: string);
    procedure ListarChat;
    procedure ProcessarChatErro(Sender: TObject);
    procedure ProcessarEnvioChat;
    { Private declarations }
  public
    { Public declarations }
    id_orcamento, id_usuario_destino, id_usuario_logado : integer;
    ReqOrcamentoChat, ReqOrcamentoChatEnv : TRestRequest;
  end;

var
  FrmChat: TFrmChat;

implementation

{$R *.fmx}

uses uDWJsonObject;

procedure TFrmChat.AddChat(id_usuario_de, id_usuario_para: integer;
                           msg, dt, ind_msg_minha: string);
begin
    with lv_chat.Items.Add do
    begin
        Tag := id_usuario_de;
        TagString := id_usuario_para.ToString;

        TListItemText(Objects.FindDrawable('TxtMensagem')).Text := msg;
        TListItemText(Objects.FindDrawable('TxtMensagem')).TagString := ind_msg_minha;
        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;
    end;

    lv_chat.RecalcSize;
end;

procedure TFrmChat.FormShow(Sender: TObject);
begin
    ListarChat;
end;

procedure TFrmChat.ProcessarEnvioChat;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, ind_msg_minha: string;
    i : integer;
begin
    try
        json := ReqOrcamentoChat.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        // Se deu erro...
        if ReqOrcamentoChat.Response.StatusCode <> 200 then
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
        // Popular listview das mensagens...
        lv_chat.Items.Clear;
        lv_chat.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            // Verifica se eu enviei a mensagem...
            if jsonArray.Get(i).GetValue<integer>('ID_USUARIO_DE', 0) = id_usuario_logado then
                ind_msg_minha := 'S'
            else
                ind_msg_minha := 'N';

            AddChat(jsonArray.Get(i).GetValue<integer>('ID_USUARIO_DE', 0),
                    jsonArray.Get(i).GetValue<integer>('ID_USUARIO_PARA', 0),
                    jsonArray.Get(i).GetValue<string>('TEXTO', ''),
                    jsonArray.Get(i).GetValue<string>('DT_GERACAO', ''),
                    ind_msg_minha);
        end;

        jsonArray.DisposeOf;

    finally
        lv_chat.EndUpdate;
        lv_chat.RecalcSize;
    end;
end;

procedure TFrmChat.ProcessarChatErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmChat.img_enviarClick(Sender: TObject);
begin
    try
        ReqOrcamentoChatEnv.Params.Clear;
        ReqOrcamentoChatEnv.AddParameter('id', '');
        ReqOrcamentoChatEnv.AddParameter('id_usuario_de', id_usuario_logado.ToString);
        ReqOrcamentoChatEnv.AddParameter('id_usuario_para', id_usuario_destino.ToString);
        ReqOrcamentoChatEnv.AddParameter('texto', m_msg.Text);
        ReqOrcamentoChatEnv.AddParameter('texto', escape_chars(m_msg.Text));
        ReqOrcamentoChatEnv.AddParameter('id_orcamento', id_orcamento.ToString);
        ReqOrcamentoChatEnv.Execute;

        AddChat(id_usuario_logado,
                id_usuario_destino,
                m_msg.Text,
                FormatDateTime('dd/mm - hh:nn', now) + 'h',
                'S');

        m_msg.Lines.Clear;
        lv_chat.ScrollTo(lv_chat.ItemCount - 1);
    except

    end;
end;

procedure TFrmChat.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmChat.ListarChat;
begin
    // Buscar pedidos no servidor...
    ReqOrcamentoChat.Params.Clear;
    ReqOrcamentoChat.AddParameter('id', '');
    ReqOrcamentoChat.AddParameter('id_orcamento', id_orcamento.ToString);
    ReqOrcamentoChat.AddParameter('id_usuario', id_usuario_logado.ToString);
    ReqOrcamentoChat.ExecuteAsync(ProcessarEnvioChat, true, true, ProcessarChatErro);
end;

procedure TFrmChat.lv_chatPullRefresh(Sender: TObject);
begin
    ListarChat;
end;

procedure TFrmChat.lv_chatUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt_data: TListItemText;
begin
    // Calcula tamanho da mensagem...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtMensagem'));
    txt.Width := lv_chat.Width * 0.60;
    txt.Height := TFunctions.GetTextHeight(txt, txt.Width, txt.Text) - 5;

    // Se mensagem é minha ou não...
    if txt.TagString = 'S' then
    begin
        txt.Align := TListItemAlign.Trailing;
        txt.PlaceOffset.X := -10;
        txt.TextColor := $FF343434;
        txt.TextAlign := TTextAlign.Trailing;
    end
    else
        txt.TextColor := $FF1A72E2;


    // Calcula objeto data da mensagem...
    txt_data := TListItemText(AItem.Objects.FindDrawable('TxtData'));
    txt_data.Width := lv_chat.Width;
    txt_data.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height - 5;

    // Se mensagem é minha ou não...
    if txt.TagString = 'S' then
    begin
        txt_data.Align := TListItemAlign.Trailing;
        txt_data.PlaceOffset.X := -10;
        txt_data.TextAlign := TTextAlign.Trailing;
    end
    else
        txt_data.TextAlign := TTextAlign.Leading;


    // Calcula altura do item da listview...
    Aitem.Height := Trunc(txt_data.PlaceOffset.Y + txt_data.Height + 25);
end;

end.
