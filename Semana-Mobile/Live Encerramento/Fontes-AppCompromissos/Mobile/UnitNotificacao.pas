unit UnitNotificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  UnitNotificacaoDados, Data.DB;

type
  TFrmNotificacao = class(TForm)
    Layout1: TLayout;
    Label4: TLabel;
    img_fechar: TImage;
    lb_notificacao: TListBox;
    procedure img_fecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmNotificacao: TFrmNotificacao;

implementation

{$R *.fmx}

uses UnitNotificacaoFame, UnitDM, UnitPrincipal;

procedure CriaFrame(n : TNotificacao);
var
    f : TFrameNotificacao;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 120;
    item.Align := TAlignLayout.Client;
    item.Tag := n.id;
    item.Selectable := false;

    f := TFrameNotificacao.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.c_icone.Fill.Bitmap.Bitmap := n.icone;
    f.lbl_usuario.Text := n.cod_usuario;
    f.lbl_data.Text := n.data;
    f.lbl_texto.Text := n.texto;
    f.btn_aceitar.Tag := n.id;
    f.btn_excluir.Tag := n.id;
    f.btn_aceitar.Tagstring := n.cod_usuario;
    f.btn_excluir.TagString := n.cod_usuario;

    if n.tipo = 'C' then
        f.btn_aceitar.Visible := true
    else
        f.btn_aceitar.Visible := false;

    FrmNotificacao.lb_notificacao.AddObject(item);
end;

procedure ListarNotificacao();
var
    n : TNotificacao;
    x : integer;
    icone : TStream;
    bmp : TBitmap;
begin
    FrmNotificacao.lb_notificacao.Items.Clear;

    dm.sql_notif.Active := false;
    dm.sql_notif.sql.Clear;
    dm.sql_notif.SQL.Add('SELECT N.*, U.ICONE FROM NOTIFICACAO N');
    dm.sql_notif.SQL.Add('JOIN USUARIO U ON (U.COD_USUARIO = N.COD_USUARIO_DE)');
    dm.sql_notif.SQL.Add('WHERE N.COD_USUARIO_PARA = :COD_USUARIO');
    dm.sql_notif.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
    dm.sql_notif.Active := true;

    while NOT dm.sql_notif.Eof do
    begin
        n.id := dm.sql_notif.FieldByName('SEQ_NOTIFICACAO').AsInteger;

        if dm.sql_notif.FieldByName('ICONE').AsString <> '' then
        begin
            try
                icone := dm.sql_notif.CreateBlobStream(dm.sql_notif.FieldByName('ICONE'), bmread);

                bmp := TBitmap.Create;
                bmp.LoadFromStream(icone);

                n.icone := bmp;
            finally
                icone.DisposeOf;
            end;
        end;

        n.cod_usuario := dm.sql_notif.FieldByName('COD_USUARIO_DE').AsString;
        n.data := FormatDateTime('DD/MM', dm.sql_notif.FieldByName('DT').AsDateTime);
        n.texto := dm.sql_notif.FieldByName('TEXTO').AsString;
        n.tipo := dm.sql_notif.FieldByName('TIPO').AsString;

        CriaFrame(n);

        bmp.DisposeOf;
        dm.sql_notif.Next;
    end;
end;

procedure TFrmNotificacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmNotificacao := nil;
end;

procedure TFrmNotificacao.FormShow(Sender: TObject);
begin
    ListarNotificacao;

    // Marcar notificaoes como lidas...
    dm.sql_notif.Active := false;
    dm.sql_notif.sql.Clear;
    dm.sql_notif.SQL.Add('UPDATE NOTIFICACAO SET IND_LIDO = ''S''');
    dm.sql_notif.SQL.Add('WHERE COD_USUARIO_PARA = :COD_USUARIO');
    dm.sql_notif.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
    dm.sql_notif.ExecSQL;
end;

procedure TFrmNotificacao.img_fecharClick(Sender: TObject);
begin
    // Atualizar dados...
    FrmPrincipal.ListarCompromisso;
    FrmPrincipal.CarregaDadosCalendario;

    close;
end;

end.
