unit UnitCompromisso;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Edit, FMX.ListBox, FMX.TabControl, System.Actions, FMX.ActnList,
  UnitCompromissoUsuarioDados, Data.DB;

type
  TFrmCompromisso = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_fechar: TImage;
    Layout3: TLayout;
    edt_descricao: TEdit;
    Layout2: TLayout;
    edt_data: TDateEdit;
    edt_hora: TTimeEdit;
    Label4: TLabel;
    btn_salvar: TSpeedButton;
    Label1: TLabel;
    img_cad_partic: TImage;
    lb_convite: TListBox;
    TabControl: TTabControl;
    TabCompromisso: TTabItem;
    TabBusca: TTabItem;
    ActionList1: TActionList;
    ActCompromisso: TChangeTabAction;
    ActBusca: TChangeTabAction;
    Layout4: TLayout;
    Label2: TLabel;
    img_voltar: TImage;
    edt_busca: TEdit;
    lb_busca: TListBox;
    Layout5: TLayout;
    btn_busca: TSpeedButton;
    procedure img_fecharClick(Sender: TObject);
    procedure img_cad_particClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn_buscaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure lb_buscaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
  public
    { Public declarations }
    modo : string; // I = Inclusao  A = Alteracao
    seq_compromisso : integer;
  end;

var
  FrmCompromisso: TFrmCompromisso;

implementation

{$R *.fmx}

uses UnitCompromissoUsuarioFrame, UnitDM, UnitPrincipal;


procedure CriaFrameBusca(n : TCompromissoUsuario);
var
    f : TFrameCompromissoUsuario;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 46;
    item.Align := TAlignLayout.Client;
    item.TagString := n.cod_usuario;
    item.Selectable := false;

    f := TFrameCompromissoUsuario.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.c_icone.Fill.Bitmap.Bitmap := n.icone;
    f.lbl_usuario.Text := n.cod_usuario;

    FrmCompromisso.lb_busca.AddObject(item);
end;

procedure ListarBusca();
var
    n : TCompromissoUsuario;
    x : integer;
    icone : TStream;
    bmp : TBitmap;
begin
    FrmCompromisso.lb_busca.Items.Clear;

    dm.sql_busca_usuario.Active := false;
    dm.sql_busca_usuario.SQL.Clear;
    dm.sql_busca_usuario.sql.Add('SELECT * FROM USUARIO');
    dm.sql_busca_usuario.sql.Add('WHERE COD_USUARIO <> :COD_USUARIO');

    // Filtro...
    if FrmCompromisso.edt_busca.Text <> '' then
    begin
        dm.sql_busca_usuario.sql.Add('AND COD_USUARIO = :COD_USUARIO_BUSCA');
        dm.sql_busca_usuario.ParamByName('COD_USUARIO_BUSCA').Value := FrmCompromisso.edt_busca.Text;
    end;

    dm.sql_busca_usuario.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
    dm.sql_busca_usuario.Active := true;

    while NOT dm.sql_busca_usuario.Eof do
    begin
        n.seq_compromisso := 0;

        if dm.sql_busca_usuario.FieldByName('ICONE').AsString <> '' then
        begin
            try
                icone := dm.sql_busca_usuario.CreateBlobStream(
                                dm.sql_busca_usuario.FieldByName('ICONE'),
                                bmread);

                bmp := TBitmap.Create;
                bmp.LoadFromStream(icone);

                n.icone := bmp;
            finally
                icone.DisposeOf;
            end;
        end;

        n.cod_usuario := dm.sql_busca_usuario.FieldByName('COD_USUARIO').AsString;

        CriaFrameBusca(n);

        bmp.DisposeOf;
        dm.sql_busca_usuario.Next;
    end;
end;


procedure CriaFrameConvite(n : TCompromissoUsuario);
var
    f : TFrameCompromissoUsuario;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 46;
    item.Align := TAlignLayout.Client;
    item.TagString := n.cod_usuario;
    item.Tag := n.seq_compromisso;
    item.Selectable := false;

    f := TFrameCompromissoUsuario.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.c_icone.Fill.Bitmap.Bitmap := n.icone;
    f.lbl_usuario.Text := n.cod_usuario;

    FrmCompromisso.lb_convite.AddObject(item);
end;

procedure ListarConvites();
var
    n : TCompromissoUsuario;
    x : integer;
    icone : TStream;
    bmp : TBitmap;
begin
    FrmCompromisso.lb_convite.Items.Clear;

    // Buscar convites no banco...
    dm.sql_convite.Active := false;
    dm.sql_convite.SQL.Clear;
    dm.sql_convite.SQL.Add('SELECT C.*, U.ICONE FROM COMPROMISSO_CONVITE C');
    dm.sql_convite.SQL.Add('JOIN USUARIO U ON (C.COD_USUARIO = U.COD_USUARIO)');
    dm.sql_convite.SQL.Add('WHERE C.SEQ_COMPROMISSO=:SEQ_COMPROMISSO');
    dm.sql_convite.ParamByName('SEQ_COMPROMISSO').Value := FrmCompromisso.seq_compromisso;
    dm.sql_convite.Active := true;

    while NOT dm.sql_convite.Eof do
    begin
        n.seq_compromisso := dm.sql_convite.FieldByName('SEQ_COMPROMISSO').AsInteger;

        if dm.sql_convite.FieldByName('ICONE').AsString <> '' then
        begin
            try
                icone := dm.sql_convite.CreateBlobStream(dm.sql_convite.FieldByName('ICONE'), bmread);

                bmp := TBitmap.Create;
                bmp.LoadFromStream(icone);

                n.icone := bmp;
            finally
                icone.DisposeOf;
            end;
        end;

        n.cod_usuario := dm.sql_convite.FieldByName('COD_USUARIO').AsString;

        CriaFrameConvite(n);

        bmp.DisposeOf;

        dm.sql_convite.Next;
    end;
end;


procedure TFrmCompromisso.btn_buscaClick(Sender: TObject);
begin
    ListarBusca;
end;

procedure TFrmCompromisso.btn_salvarClick(Sender: TObject);
var
    x : integer;
begin
    dm.sql_compromisso.Active := false;
    dm.sql_compromisso.SQL.Clear;
    dm.sql_compromisso.SQL.Add('SET DATEFORMAT DMY');

    if modo = 'I' then
    begin
        dm.sql_compromisso.SQL.Add('INSERT INTO COMPROMISSO(COD_USUARIO,');
        dm.sql_compromisso.SQL.Add('DESCRICAO, DT, HORA, IND_CONCLUIDO, QTD_PARTIC)');
        dm.sql_compromisso.SQL.Add('VALUES(:COD_USUARIO, :DESCRICAO, :DT, :HORA, ''N'', 1)');

        dm.sql_compromisso.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
    end
    else
    begin
        dm.sql_compromisso.SQL.Add('UPDATE COMPROMISSO SET DESCRICAO=:DESCRICAO, DT=:DT, HORA=:HORA ');
        dm.sql_compromisso.SQL.Add('WHERE SEQ_COMPROMISSO=:SEQ_COMPROMISSO');

        dm.sql_compromisso.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
    end;

    dm.sql_compromisso.ParamByName('DESCRICAO').Value := edt_descricao.Text;
    dm.sql_compromisso.ParamByName('DT').Value := FormatDateTime('DD/MM/YYYY', edt_data.Date);
    dm.sql_compromisso.ParamByName('HORA').Value := edt_hora.Text;

    dm.sql_compromisso.ExecSQL;

    // Busca novo compromisso criado...
    if modo = 'I' then
    begin
        dm.sql_compromisso.Active := false;
        dm.sql_compromisso.SQL.Clear;
        dm.sql_compromisso.sql.Add('SELECT MAX(SEQ_COMPROMISSO) AS SEQ_COMPROMISSO');
        dm.sql_compromisso.sql.Add('FROM COMPROMISSO');
        dm.sql_compromisso.sql.Add('WHERE COD_USUARIO = :COD_USUARIO');
        dm.sql_compromisso.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
        dm.sql_compromisso.Active := true;

        seq_compromisso := dm.sql_compromisso.FieldByName('SEQ_COMPROMISSO').AsInteger;
    end;

    // Gravar convites...
    for x := 0 to lb_convite.Items.Count - 1 do
    begin
        if TListBoxItem(lb_convite.ItemByIndex(x)).Tag = 0 then
        begin
            dm.sql_compromisso.Active := false;
            dm.sql_compromisso.SQL.Clear;
            dm.sql_compromisso.sql.Add('INSERT INTO COMPROMISSO_CONVITE(SEQ_COMPROMISSO, COD_USUARIO, DT, IND_ACEITO)');
            dm.sql_compromisso.sql.Add('VALUES(:SEQ_COMPROMISSO, :COD_USUARIO, GETDATE(), ''N'')');
            dm.sql_compromisso.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
            dm.sql_compromisso.ParamByName('COD_USUARIO').Value := TListBoxItem(lb_convite.ItemByIndex(x)).TagString;
            dm.sql_compromisso.ExecSQL;

            // Enviar notificacao...
            dm.sql_notif.Active := false;
            dm.sql_notif.SQL.Clear;
            dm.sql_notif.sql.Add('INSERT INTO NOTIFICACAO(COD_USUARIO_DE, COD_USUARIO_PARA, DT, TEXTO, ');
            dm.sql_notif.sql.Add('TIPO, SEQ_COMPROMISSO, IND_LIDO)');
            dm.sql_notif.sql.Add('VALUES(:COD_USUARIO_DE, :COD_USUARIO_PARA, GETDATE(), :TEXTO, ');
            dm.sql_notif.sql.Add('''C'', :SEQ_COMPROMISSO, ''N'')');
            dm.sql_notif.ParamByName('COD_USUARIO_DE').Value := FrmPrincipal.pcod_usuario;
            dm.sql_notif.ParamByName('COD_USUARIO_PARA').Value := TListBoxItem(lb_convite.ItemByIndex(x)).TagString;
            dm.sql_notif.ParamByName('TEXTO').Value := FrmPrincipal.pcod_usuario + ' convidou você para: ' + edt_descricao.Text;
            dm.sql_notif.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
            dm.sql_notif.ExecSQL;

        end;
    end;

    // Atualizar dados...
    FrmPrincipal.ListarCompromisso;
    FrmPrincipal.CarregaDadosCalendario;

    close;
end;

procedure TFrmCompromisso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmCompromisso := nil;
end;

procedure TFrmCompromisso.FormCreate(Sender: TObject);
begin
    TabControl.TabPosition := TTabPosition.None;
    TabControl.ActiveTab := TabCompromisso;
end;

procedure TFrmCompromisso.FormShow(Sender: TObject);
begin
    if modo = 'I' then
    begin
        edt_descricao.Text := '';
        edt_data.Date := FrmPrincipal.cal.SelectedDate;
    end
    else
    begin
        dm.sql_compromisso.Active := false;
        dm.sql_compromisso.SQL.Clear;
        dm.sql_compromisso.SQL.Add('SELECT * FROM COMPROMISSO');
        dm.sql_compromisso.SQL.Add('WHERE SEQ_COMPROMISSO=:SEQ_COMPROMISSO');
        dm.sql_compromisso.ParamByName('SEQ_COMPROMISSO').Value := seq_compromisso;
        dm.sql_compromisso.Active := true;

        edt_descricao.Text := dm.sql_compromisso.FieldByName('DESCRICAO').AsString;
        edt_data.Date := dm.sql_compromisso.FieldByName('DT').AsDateTime;
        edt_hora.text := dm.sql_compromisso.FieldByName('HORA').AsString;
    end;

    ListarConvites;
end;

procedure TFrmCompromisso.img_cad_particClick(Sender: TObject);
begin
    ActBusca.Execute;
end;

procedure TFrmCompromisso.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmCompromisso.img_voltarClick(Sender: TObject);
begin
    ActCompromisso.Execute;
end;

procedure TFrmCompromisso.lb_buscaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
    n : TCompromissoUsuario;
    c : TCircle;
    f : TFrameCompromissoUsuario;
begin
    // Insere usuario na lista de convites...
    n.seq_compromisso := 0;

    f := Item.FindComponent('FrameCompromissoUsuario') as TFrameCompromissoUsuario;
    c := f.FindComponent('c_icone') as TCircle;

    n.icone := c.Fill.Bitmap.Bitmap;
    n.cod_usuario := Item.TagString;

    CriaFrameConvite(n);

    lb_busca.Items.Delete(Item.Index);
end;

end.
