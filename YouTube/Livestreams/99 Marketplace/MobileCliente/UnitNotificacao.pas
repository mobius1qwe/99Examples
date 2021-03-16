unit UnitNotificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.JSON;

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
    procedure FormShow(Sender: TObject);
    procedure lv_notificacoesItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    procedure AddNotificacao(seq_notificacao, id_usuario_de : integer;
                             extra1, extra2,
                             foto64, nome, dt, mensagem: string);
    procedure ListarNotificacao;
    procedure BuscarNotificacoes;
    procedure ProcessarNotificacaoErro(Sender: TObject);
    procedure ProcessarExclusao(indice: integer);
    
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmNotificacao: TFrmNotificacao;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitDM;

procedure TFrmNotificacao.AddNotificacao(seq_notificacao, id_usuario_de : integer;
                                         extra1, extra2,
                                         foto64, nome, dt, mensagem: string);
begin
    with lv_notificacoes.Items.Add do
    begin
        Tag := seq_notificacao;
        TagString := extra2;

        Height := 80;

        // Foto base64...
        if foto64 <> '' then
        begin
            TListItemImage(Objects.FindDrawable('ImgIcone')).Bitmap := FrmPrincipal.BitmapFromBase64(foto64);
            TListItemImage(Objects.FindDrawable('ImgIcone')).OwnsBitmap := true;
        end;

        //

        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtMensagem')).Text := mensagem;
        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;
        TListItemImage(Objects.FindDrawable('ImgExcluir')).Bitmap := img_delete.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgExcluir')).TagString := seq_notificacao.ToString;
    end;
end;

procedure TFrmNotificacao.ListarNotificacao;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin
    try
        json := dm.RequestNotif.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        // Se deu erro...
        if dm.RequestNotif.Response.StatusCode <> 200 then
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
        // Popular listview das notificacoes...
        lv_notificacoes.Items.Clear;
        lv_notificacoes.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddNotificacao(jsonArray.Get(i).GetValue<integer>('ID_NOTIFICACAO', 0),
                           jsonArray.Get(i).GetValue<integer>('ID_USUARIO_DE', 0),
                           jsonArray.Get(i).GetValue<string>('EXTRA1', ''),
                           jsonArray.Get(i).GetValue<string>('EXTRA2', ''),
                           jsonArray.Get(i).GetValue<string>('FOTO', ''),
                           jsonArray.Get(i).GetValue<string>('NOME_ORIGEM', ''),
                           jsonArray.Get(i).GetValue<string>('DT_GERACAO', '00/00/00 00:00'),
                           jsonArray.Get(i).GetValue<string>('TEXTO', ''));
        end;

        jsonArray.DisposeOf;

    finally
        lv_notificacoes.EndUpdate;
        lv_notificacoes.RecalcSize;
    end;
end;

procedure TFrmNotificacao.ProcessarNotificacaoErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmNotificacao.BuscarNotificacoes;
begin
    // Buscar notificacoes no servidor...
    dm.RequestNotif.Params.Clear;
    dm.RequestNotif.AddParameter('id', '');
    dm.RequestNotif.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
    dm.RequestNotif.ExecuteAsync(ListarNotificacao, true, true, ProcessarNotificacaoErro);
end;


procedure TFrmNotificacao.ProcessarExclusao(indice: integer);
var
    jsonObj : TJsonObject;
    json, retorno: string;
begin
    try
        json := dm.RequestNotifDelete.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if dm.RequestNotifDelete.Response.StatusCode <> 202 then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;

    lv_notificacoes.Items.Delete(indice);
end;

procedure TFrmNotificacao.lv_notificacoesItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if ItemObject is TListItemImage then
    begin
        if ItemObject.Name = 'ImgExcluir' then
        begin
            dm.RequestNotifDelete.Params.Clear;
            dm.RequestNotifDelete.AddParameter('id', '');
            dm.RequestNotifDelete.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
            dm.RequestNotifDelete.AddParameter('id_notificacao', TListItemImage(ItemObject).TagString);
            dm.RequestNotifDelete.Execute;

            ProcessarExclusao(ItemIndex);
        end;
    end;
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

procedure TFrmNotificacao.FormShow(Sender: TObject);
begin
    BuscarNotificacoes;
end;

procedure TFrmNotificacao.img_notificacaoClick(Sender: TObject);
begin
    close;
end;

procedure TFrmNotificacao.img_refreshClick(Sender: TObject);
begin
    BuscarNotificacoes;
end;

end.
