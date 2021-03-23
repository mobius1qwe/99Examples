unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  uCustomCalendar, DateUtils, UnitCompromissoDados;

type
  TMyThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TFrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label4: TLabel;
    img_notificacao: TImage;
    c_notiticacao: TCircle;
    btn_sair: TSpeedButton;
    Layout2: TLayout;
    img_anterior: TImage;
    img_proximo: TImage;
    lbl_mes: TLabel;
    lyt_calendario: TLayout;
    lyt_sem_compromisso: TLayout;
    Image3: TImage;
    lbl_sem_compromisso: TLabel;
    img_dica: TImage;
    lyt_com_compromisso: TLayout;
    lb_compromisso: TListBox;
    Layout3: TLayout;
    lbl_dia: TLabel;
    img_cad_compromisso: TImage;
    procedure FormShow(Sender: TObject);
    procedure DayClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_proximoClick(Sender: TObject);
    procedure img_anteriorClick(Sender: TObject);
    procedure ListarCompromisso();
    procedure img_notificacaoClick(Sender: TObject);
    procedure img_cad_compromissoClick(Sender: TObject);
    procedure img_dicaClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure CarregaDadosCalendario();
    procedure lb_compromissoItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
  public
    { Public declarations }
    cal : TCustomCalendar;
    pcod_usuario : string;
    MyThread : TMyThread;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitCompromisso, UnitNotificacao, UnitLogin, UnitCompromissoFrame, UnitDM;

procedure TMyThread.Execute;
var
        cont : integer;
begin
        cont := 0;

        // Busca as notificacoes...
        while NOT Terminated do
        begin
                sleep(1000);
                cont := cont + 1;

                if cont >= 5 then
                begin
                        // Busca notificacoes no servidor...
                        dm.sql_getnotif.Active := false;
                        dm.sql_getnotif.sql.Clear;
                        dm.sql_getnotif.sql.Add('SELECT COUNT(*) AS QTD FROM NOTIFICACAO');
                        dm.sql_getnotif.sql.Add('WHERE COD_USUARIO_PARA = :COD_USUARIO');
                        dm.sql_getnotif.sql.Add('AND IND_LIDO = ''N''');
                        dm.sql_getnotif.ParamByName('COD_USUARIO').Value := FrmPrincipal.pcod_usuario;
                        dm.sql_getnotif.Active := true;

                        if dm.sql_getnotif.FieldByName('QTD').AsInteger > 0 then
                                Synchronize(procedure
                                            begin
                                                FrmPrincipal.c_notiticacao.Visible := true;
                                            end);

                        cont := 0;
                end;
        end;
end;



procedure CriaFrame(n : TCompromisso);
var
    f : TFrameCompromisso;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 120;
    item.Align := TAlignLayout.Client;
    item.Tag := n.seq_compromisso;
    item.Selectable := false;

    f := TFrameCompromisso.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.lbl_descricao.Text := n.descricao;
    f.lbl_usuario.Text := n.cod_usuario;
    f.lbl_data.Text := n.data;
    f.lbl_hora.text := n.hora;
    f.lbl_qtd.Text := n.qtd_partic.ToString;

    if n.ind_concluido = 'S' then
        f.img_concluido.Visible := true
    else
        f.img_concluido.Visible := false;

    FrmPrincipal.lb_compromisso.AddObject(item);
end;

procedure TFrmPrincipal.CarregaDadosCalendario();
var
    x : integer;
    dia, mes, ano : word;
begin
    DecodeDate(cal.SelectedDate, ano, mes, dia);

    // Buscar compromissos no servidor...
    dm.sql_calendar.Active := false;
    dm.sql_calendar.SQL.Clear;
    dm.sql_calendar.SQL.Add('SET DATEFORMAT DMY');
    dm.sql_calendar.SQL.Add('SELECT DT FROM COMPROMISSO');
    dm.sql_calendar.SQL.Add('WHERE COD_USUARIO = :COD_USUARIO');
    dm.sql_calendar.SQL.Add('AND DT >= :DATA1 AND DT <= :DATA2');

    dm.sql_calendar.SQL.Add('UNION');

    dm.sql_calendar.SQL.Add('SELECT C.DT FROM COMPROMISSO C');
    dm.sql_calendar.SQL.Add('JOIN COMPROMISSO_CONVITE V ON (V.SEQ_COMPROMISSO = C.SEQ_COMPROMISSO)');
    dm.sql_calendar.SQL.Add('WHERE V.COD_USUARIO = :COD_USUARIO2');
    dm.sql_calendar.SQL.Add('AND C.DT >= :DATA3 AND C.DT <= :DATA4');
    dm.sql_calendar.SQL.Add('AND V.IND_ACEITO = ''S''');


    dm.sql_calendar.ParamByName('COD_USUARIO').Value := pcod_usuario;
    dm.sql_calendar.ParamByName('DATA1').Value := FormatDateTime('DD/MM/YYYY', EncodeDate(ano, mes, 1));
    dm.sql_calendar.ParamByName('DATA2').Value := FormatDateTime('DD/MM/YYYY', EndOfTheMonth(cal.SelectedDate));

    dm.sql_calendar.ParamByName('COD_USUARIO2').Value := pcod_usuario;
    dm.sql_calendar.ParamByName('DATA3').Value := FormatDateTime('DD/MM/YYYY', EncodeDate(ano, mes, 1));
    dm.sql_calendar.ParamByName('DATA4').Value := FormatDateTime('DD/MM/YYYY', EndOfTheMonth(cal.SelectedDate));

    dm.sql_calendar.Active := true;

    for x := 1 to dm.sql_calendar.RecordCount do
    begin
        cal.AddMarker(FormatDateTime('DD', dm.sql_calendar.FieldByName('DT').AsDateTime).ToInteger);

        dm.sql_calendar.Next;
    end;
end;

procedure TFrmPrincipal.ListarCompromisso();
var
    c : TCompromisso;
    x : integer;

begin
    lbl_mes.Text := cal.MonthName;
    lbl_dia.Text := 'Atividades do dia ' + FormatDateTime('DD/MM', cal.SelectedDate);
    FrmPrincipal.lb_compromisso.Items.Clear;

    // Buscar compromissos no servidor...
    dm.sql_compromisso.Active := false;
    dm.sql_compromisso.SQL.Clear;
    dm.sql_compromisso.SQL.Add('SET DATEFORMAT DMY');
    dm.sql_compromisso.SQL.Add('(SELECT SEQ_COMPROMISSO, COD_USUARIO, DESCRICAO, DT, HORA, IND_CONCLUIDO, QTD_PARTIC');
    dm.sql_compromisso.SQL.Add('FROM COMPROMISSO');
    dm.sql_compromisso.SQL.Add('WHERE COD_USUARIO = :COD_USUARIO');
    dm.sql_compromisso.SQL.Add('AND DT = :DATA');

    dm.sql_compromisso.SQL.Add('UNION');

    dm.sql_compromisso.SQL.Add('SELECT C.SEQ_COMPROMISSO, C.COD_USUARIO, C.DESCRICAO, C.DT, C.HORA, C.IND_CONCLUIDO, C.QTD_PARTIC');
    dm.sql_compromisso.SQL.Add('FROM COMPROMISSO C');
    dm.sql_compromisso.SQL.Add('JOIN COMPROMISSO_CONVITE V ON (V.SEQ_COMPROMISSO = C.SEQ_COMPROMISSO)');
    dm.sql_compromisso.SQL.Add('WHERE V.COD_USUARIO = :COD_USUARIO2');
    dm.sql_compromisso.SQL.Add('AND C.DT = :DATA2');
    dm.sql_compromisso.SQL.Add('AND V.IND_ACEITO = ''S''');


    dm.sql_compromisso.SQL.Add(') ORDER BY HORA');
    dm.sql_compromisso.ParamByName('COD_USUARIO').Value := pcod_usuario;
    dm.sql_compromisso.ParamByName('DATA').Value := FormatDateTime('DD/MM/YYYY', cal.SelectedDate);

    dm.sql_compromisso.ParamByName('COD_USUARIO2').Value := pcod_usuario;
    dm.sql_compromisso.ParamByName('DATA2').Value := FormatDateTime('DD/MM/YYYY', cal.SelectedDate);

    dm.sql_compromisso.Active := true;

    if dm.sql_compromisso.RecordCount = 0 then
    begin
        lyt_com_compromisso.Visible := false;
        lyt_sem_compromisso.Visible := true;
        lbl_sem_compromisso.Text := 'Sem compromisso em ' + FormatDateTime('DD/MM', cal.SelectedDate);
    end
    else
    begin
        lyt_com_compromisso.Visible := true;
        lyt_sem_compromisso.Visible := false;

        for x := 1 to dm.sql_compromisso.RecordCount do
        begin
            with dm.sql_compromisso do
            begin
                c.seq_compromisso := FieldByName('SEQ_COMPROMISSO').AsInteger;
                c.cod_usuario := FieldByName('COD_USUARIO').AsString;
                c.data := FormatDateTime('DD/MM', FieldByName('DT').AsDateTime);
                c.hora := FieldByName('HORA').AsString + 'hs';
                c.descricao := FieldByName('DESCRICAO').AsString;
                c.ind_concluido := FieldByName('IND_CONCLUIDO').AsString;
                c.qtd_partic := FieldByName('QTD_PARTIC').AsInteger;

                CriaFrame(c);

                dm.sql_compromisso.Next;
            end;
        end;

    end;

end;

procedure TFrmPrincipal.btn_sairClick(Sender: TObject);
begin
    if NOT Assigned(FrmLogin) then
        Application.CreateForm(TFrmLogin, FrmLogin);

    Application.MainForm := FrmLogin;
    FrmLogin.Show;
    FrmPrincipal.Close;
end;

procedure TFrmPrincipal.DayClick(Sender: TObject);
begin
    // Carregar as atividades do dia...
    ListarCompromisso;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    cal.DisposeOf;
    MyThread.DisposeOf;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    cal := TCustomCalendar.Create(lyt_calendario);
    cal.OnClick := DayClick;

    MyThread := TMyThread.Create(true);
    MyThread.Start;

    c_notiticacao.Visible := false;

    // Setup calendario...
    cal.DayFontSize := 14;
    cal.DayFontColor := $FF737375;
    cal.SelectedDayColor := $FF4B7AF0;
    cal.BackgroundColor := $FFFFFFFF;

    // Monta calendario na tela...
    cal.ShowCalendar;

    // Pintar dias com compromisso...
    CarregaDadosCalendario();

    // Ajustar labels de data...
    ListarCompromisso;
end;

procedure TFrmPrincipal.img_anteriorClick(Sender: TObject);
begin
    cal.PriorMonth;
    CarregaDadosCalendario();
    ListarCompromisso;
end;

procedure TFrmPrincipal.img_cad_compromissoClick(Sender: TObject);
begin
    if NOT Assigned(FrmCompromisso) then
        Application.CreateForm(TFrmCompromisso, FrmCompromisso);

    FrmCompromisso.modo := 'I';
    FrmCompromisso.seq_compromisso := 0;
    FrmCompromisso.Show;
end;

procedure TFrmPrincipal.img_dicaClick(Sender: TObject);
begin
    if NOT Assigned(FrmCompromisso) then
        Application.CreateForm(TFrmCompromisso, FrmCompromisso);

    FrmCompromisso.modo := 'I';
    FrmCompromisso.seq_compromisso := 0;
    FrmCompromisso.Show;
end;

procedure TFrmPrincipal.img_notificacaoClick(Sender: TObject);
begin
    if NOT Assigned(FrmNotificacao) then
        Application.CreateForm(TFrmNotificacao, FrmNotificacao);

    c_notiticacao.Visible := false;
    FrmNotificacao.Show;
end;

procedure TFrmPrincipal.img_proximoClick(Sender: TObject);
begin
    cal.NextMonth;
    CarregaDadosCalendario();
    ListarCompromisso;
end;

procedure TFrmPrincipal.lb_compromissoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    if NOT Assigned(FrmCompromisso) then
        Application.CreateForm(TFrmCompromisso, FrmCompromisso);

    FrmCompromisso.modo := 'A';
    FrmCompromisso.seq_compromisso := Item.Tag;
    FrmCompromisso.Show;
end;

end.
