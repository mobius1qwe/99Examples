unit UnitNotificacaoFame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.ListBox;

type
  TFrameNotificacao = class(TFrame)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    lbl_usuario: TLabel;
    lbl_data: TLabel;
    lbl_texto: TLabel;
    btn_aceitar: TSpeedButton;
    btn_excluir: TSpeedButton;
    c_icone: TCircle;
    procedure btn_aceitarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses UnitDM, UnitPrincipal;

procedure TFrameNotificacao.btn_aceitarClick(Sender: TObject);
var
    seq_compromisso : integer;
begin
    try
        // Descobre o compromisso...
        dm.sql_notif.Active := false;
        dm.sql_notif.SQL.Clear;
        dm.sql_notif.sql.Add('SELECT SEQ_COMPROMISSO FROM NOTIFICACAO');
        dm.sql_notif.sql.Add('WHERE SEQ_NOTIFICACAO = :SEQ_NOTIFICACAO');
        dm.sql_notif.ParamByName('SEQ_NOTIFICACAO').Value := TSpeedButton(Sender).Tag;
        dm.sql_notif.Active := true;

        seq_compromisso := dm.sql_notif.FieldByName('SEQ_COMPROMISSO').AsInteger;

        // Atualiza o compromisso...
        dm.sql_notif.Active := false;
        dm.sql_notif.SQL.Clear;
        dm.sql_notif.sql.Add('UPDATE COMPROMISSO_CONVITE');
        dm.sql_notif.sql.Add('SET IND_ACEITO = ''S''');
        dm.sql_notif.sql.Add('WHERE SEQ_COMPROMISSO = :SEQ_COMPROMISSO');
        dm.sql_notif.sql.Add('AND COD_USUARIO = :COD_USUARIO');
        dm.sql_notif.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
        dm.sql_notif.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
        dm.sql_notif.ExecSQL;

        // Atualiza o numero de participantes...
        dm.sql_notif.Active := false;
        dm.sql_notif.SQL.Clear;
        dm.sql_notif.sql.Add('UPDATE COMPROMISSO');
        dm.sql_notif.sql.Add('SET QTD_PARTIC = QTD_PARTIC + 1 ');
        dm.sql_notif.sql.Add('WHERE SEQ_COMPROMISSO = :SEQ_COMPROMISSO');
        dm.sql_notif.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
        dm.sql_notif.ExecSQL;

        // Atualiza notificacao...
        dm.sql_notif.Active := false;
        dm.sql_notif.SQL.Clear;
        dm.sql_notif.sql.Add('UPDATE NOTIFICACAO SET TIPO = ''T''');
        dm.sql_notif.sql.Add('WHERE SEQ_NOTIFICACAO = :SEQ_NOTIFICACAO');
        dm.sql_notif.ParamByName('SEQ_NOTIFICACAO').Value := TSpeedButton(Sender).Tag;
        dm.sql_notif.ExecSQL;

        // Enviar notificacao...
        dm.sql_notif.Active := false;
        dm.sql_notif.SQL.Clear;
        dm.sql_notif.sql.Add('INSERT INTO NOTIFICACAO(COD_USUARIO_DE, COD_USUARIO_PARA, DT, TEXTO, ');
        dm.sql_notif.sql.Add('TIPO, SEQ_COMPROMISSO, IND_LIDO)');
        dm.sql_notif.sql.Add('VALUES(:COD_USUARIO_DE, :COD_USUARIO_PARA, GETDATE(), :TEXTO, ');
        dm.sql_notif.sql.Add('''T'', :SEQ_COMPROMISSO, ''N'')');
        dm.sql_notif.ParamByName('COD_USUARIO_DE').Value := FrmPrincipal.pcod_usuario;
        dm.sql_notif.ParamByName('COD_USUARIO_PARA').Value := TSpeedButton(Sender).TagString;
        dm.sql_notif.ParamByName('TEXTO').Value := FrmPrincipal.pcod_usuario + ' aceitou seu convite';
        dm.sql_notif.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
        dm.sql_notif.ExecSQL;

        TSpeedButton(Sender).Visible := false;
    except

    end;
end;

procedure TFrameNotificacao.btn_excluirClick(Sender: TObject);
var
    Item : TListBoxItem;
begin
    // Atualiza notificacao...
    dm.sql_notif.Active := false;
    dm.sql_notif.SQL.Clear;
    dm.sql_notif.sql.Add('DELETE NOTIFICACAO');
    dm.sql_notif.sql.Add('WHERE SEQ_NOTIFICACAO = :SEQ_NOTIFICACAO');
    dm.sql_notif.ParamByName('SEQ_NOTIFICACAO').Value := TSpeedButton(Sender).Tag;
    dm.sql_notif.ExecSQL;

    // Esconde o item...
    Item := TFrameNotificacao(
                                TRectangle(
                                            TLayout(
                                                        Tlayout(TSpeedButton(Sender).Parent).Parent
                                                   ).Parent
                                           ).Parent
                             ).Parent as TListBoxItem;
    Item.Visible := false;

end;

end.
