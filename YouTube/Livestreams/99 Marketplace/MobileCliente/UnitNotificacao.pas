unit UnitNotificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmNotificacao = class(TForm)
    layout_toolbar: TLayout;
    lbl_titulo: TLabel;
    img_notificacao: TImage;
    img_refresh: TImage;
    Line1: TLine;
    lv_notificacoes: TListView;
    img_delete: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_refreshClick(Sender: TObject);
    procedure img_notificacaoClick(Sender: TObject);
    procedure lv_notificacoesUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddNotificacao(seq_notificacao, seq_orcamento: integer; foto64,
      nome, dt, mensagem: string);
    procedure ListarNotificacao;
    
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmNotificacao: TFrmNotificacao;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmNotificacao.AddNotificacao(seq_notificacao, seq_orcamento : integer;
                                         foto64, nome, dt, mensagem: string);
begin
    with lv_notificacoes.Items.Add do
    begin
        Tag := seq_notificacao;
        TagString := seq_orcamento.ToString;

        Height := 80;

        // Foto base64...
        if foto64 <> '' then
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := FrmPrincipal.BitmapFromBase64(foto64);
        //

        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtMensagem')).Text := mensagem;
        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;
        TListItemImage(Objects.FindDrawable('ImgExcluir')).Bitmap := img_delete.Bitmap;
    end;
end;

procedure TFrmNotificacao.ListarNotificacao;
var
    x : integer;
begin
    // Buscar notificacaoes no servidor...

    lv_notificacoes.Items.Clear;

    for x := 1 to 10 do
        AddNotificacao(x, x, '', 'Heber Stein Mazutti', '20/10', 'Mensagem de teste Mensagem de teste Mensagem de teste ' + x.ToString);
end;

procedure TFrmNotificacao.lv_notificacoesUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt_msg: TListItemText;
    img: TListItemImage;
begin
    // Calcula tamanho da descricao...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtNome'));
    txt.Width := lv_notificacoes.Width - 145;
    txt.Height := FrmPrincipal.GetTextHeight(txt, txt.Width, txt.Text) - 15;

    // Calcula obejto texto da mensagem...
    txt_msg := TListItemText(AItem.Objects.FindDrawable('TxtMensagem'));
    txt_msg.Width := lv_notificacoes.Width - 175;
    txt_msg.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height;
    txt_msg.Height := FrmPrincipal.GetTextHeight(txt_msg, txt_msg.Width, txt_msg.Text);


    // Calcula altura do item da listview...
    Aitem.Height := Trunc(txt_msg.PlaceOffset.Y + txt_msg.Height + 20);

    if Aitem.Height < 95 then
        Aitem.Height := 95;

    // Botao excluir...
    img := TListItemImage(AItem.Objects.FindDrawable('ImgExcluir'));
    img.PlaceOffset.Y := Aitem.Height - 55;

end;

procedure TFrmNotificacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmNotificacao := nil;
end;

procedure TFrmNotificacao.img_notificacaoClick(Sender: TObject);
begin
    close;
end;

procedure TFrmNotificacao.img_refreshClick(Sender: TObject);
begin
    ListarNotificacao;
end;

end.
