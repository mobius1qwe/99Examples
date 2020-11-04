unit UnitNotificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  UnitNotificacaoDados;

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

uses UnitNotificacaoFame;

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

    f := TFrameNotificacao.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.c_icone.Fill.Bitmap.Bitmap := n.icone;
    f.lbl_usuario.Text := n.cod_usuario;
    f.lbl_data.Text := n.data;
    f.lbl_texto.Text := n.texto;

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
begin
    FrmNotificacao.lb_notificacao.Items.Clear;

    for x := 1 to 5 do
    begin
        n.id := x;
        n.icone := FrmNotificacao.img_fechar.Bitmap;
        n.cod_usuario := 'Joao';
        n.data := '15/01';
        n.texto := 'O usuário João está convidando você para a atividade Reunião de Trabalho.';
        n.tipo := 'C';

        CriaFrame(n);
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
end;

procedure TFrmNotificacao.img_fecharClick(Sender: TObject);
begin
    close;
end;

end.
