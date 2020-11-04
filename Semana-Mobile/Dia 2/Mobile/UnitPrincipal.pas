unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  uCustomCalendar, DateUtils;

type
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
  private
    { Private declarations }
    cal : TCustomCalendar;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.ListarCompromisso();
begin
    lbl_mes.Text := cal.MonthName;
    lbl_dia.Text := 'Atividades do dia ' + FormatDateTime('DD/MM', cal.SelectedDate);

    // Buscar compromissos no servidor...
    cal.AddMarker(6);
    cal.AddMarker(15);
    cal.AddMarker(25, $FFFFFFFF, $FF4B7AF0);

    if (DayOf(cal.SelectedDate) = 6) or
       (DayOf(cal.SelectedDate) = 15) or
       (DayOf(cal.SelectedDate) = 25) then
    begin
        lyt_com_compromisso.Visible := true;
        lyt_sem_compromisso.Visible := false;
    end
    else
    begin
        lyt_com_compromisso.Visible := false;
        lyt_sem_compromisso.Visible := true;
        lbl_sem_compromisso.Text := 'Sem compromisso em ' + FormatDateTime('DD/MM', cal.SelectedDate);
    end;

end;

procedure TFrmPrincipal.DayClick(Sender: TObject);
begin
    // Carregar as atividades do dia...
    ListarCompromisso;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    cal.DisposeOf;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    cal := TCustomCalendar.Create(lyt_calendario);
    cal.OnClick := DayClick;

    // Setup calendario...
    cal.DayFontSize := 14;
    cal.DayFontColor := $FF737375;
    cal.SelectedDayColor := $FF4B7AF0;
    cal.BackgroundColor := $FFFFFFFF;

    // Monta calendario na tela...
    cal.ShowCalendar;

    // Ajustar labels de data...
    ListarCompromisso;
end;

procedure TFrmPrincipal.img_anteriorClick(Sender: TObject);
begin
    cal.PriorMonth;
    ListarCompromisso;
end;

procedure TFrmPrincipal.img_proximoClick(Sender: TObject);
begin
    cal.NextMonth;
    ListarCompromisso;
end;

end.
