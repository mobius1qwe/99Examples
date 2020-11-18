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
        AddNotificacao(x, x, '', 'Heber Mazutti', '20/10', 'Mensagem de teste ' + x.ToString);
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
