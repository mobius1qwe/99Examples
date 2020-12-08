unit UnitChat;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  FMX.ScrollBox, FMX.Memo;

type
  TFrmChat = class(TForm)
    layout_toolbar: TLayout;
    lbl_titulo: TLabel;
    img_notificacao: TImage;
    Line1: TLine;
    rect_prestador: TRectangle;
    c_foto: TCircle;
    Label2: TLabel;
    lv_chat: TListView;
    rect_msg: TRectangle;
    img_enviar: TImage;
    m_msg: TMemo;
    Rectangle1: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure lv_chatUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_enviarClick(Sender: TObject);
  private
    procedure AddChat(seq_pedido, seq_usuario: integer;
                      msg, dt, ind_msg_minha: string);
    procedure ListarChat;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmChat: TFrmChat;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmChat.AddChat(seq_pedido, seq_usuario: integer;
                           msg, dt, ind_msg_minha: string);
begin
    with lv_chat.Items.Add do
    begin
        Tag := seq_pedido;
        TagString := seq_usuario.ToString;

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

procedure TFrmChat.img_enviarClick(Sender: TObject);
begin
    AddChat(0, 0, m_msg.Text, '15/10 - 09:30hs', 'S');
    m_msg.Lines.Clear;
end;

procedure TFrmChat.ListarChat;
var
    x : integer;
begin
    // Buscar pedidos no servidor...

    lv_chat.Items.Clear;

    lv_chat.BeginUpdate;
    for x := 1 to 10 do
        if Odd(x) then
            AddChat(x, 0, 'Mensagem de texto para testar a quebra de linha dos nossos itens... ' + x.ToString, '15/10 - 09:30hs', 'S')
        else
            AddChat(x, 0, 'Mensagem do prestador ' + x.ToString, '15/10 - 09:30hs', 'N');

    lv_chat.EndUpdate;
end;

procedure TFrmChat.lv_chatUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt_data: TListItemText;
begin
    // Calcula tamanho da mensagem...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtMensagem'));
    txt.Width := lv_chat.Width * 0.60;
    txt.Height := FrmPrincipal.GetTextHeight(txt, txt.Width, txt.Text) - 5;

    // Se mensagem é minha ou não...
    if txt.TagString = 'S' then
    begin
        txt.Align := TListItemAlign.Trailing;
        txt.PlaceOffset.X := -10;
        txt.TextColor := $FF343434;
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
