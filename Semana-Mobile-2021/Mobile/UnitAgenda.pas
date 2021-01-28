unit UnitAgenda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  uCustomCalendar;

type
  TFrmAgenda = class(TForm)
    Layout3: TLayout;
    Label1: TLabel;
    img_exp_voltar: TImage;
    Line2: TLine;
    layout_calendario: TLayout;
    Line1: TLine;
    lbl_servico: TLabel;
    lb_horario: TListBox;
    Line3: TLine;
    Label2: TLabel;
    lbl_valor: TLabel;
    Line4: TLine;
    rect_confirmar: TRectangle;
    Label6: TLabel;
    Layout1: TLayout;
    lbl_mes: TLabel;
    img_anterior: TImage;
    img_proximo: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img_anteriorClick(Sender: TObject);
    procedure img_proximoClick(Sender: TObject);
    procedure rect_confirmarClick(Sender: TObject);
  private
    cal : TCustomCalendar;
    procedure DayClick(Sender: TObject);
    procedure ListarHorarios;
    procedure AddHorario(hora: string);
    procedure SelecionaDia(Sender: TObject);
    procedure SelecionaDiaTap(Sender: TObject; const Point: TPointF);
  public
    { Public declarations }
  end;

var
  FrmAgenda: TFrmAgenda;

implementation

{$R *.fmx}

procedure TFrmAgenda.SelecionaDia(Sender: TObject);
var
    i, x : integer;
    item : TListBoxItem;
begin
    //showmessage('Horário: ' + TRectangle(Sender).TagString);

    for i := 0 to lb_horario.Items.Count - 1 do
    begin
        item := lb_horario.ItemByIndex(i);

        for x := 0 to item.ComponentCount - 1 do
        begin
            if item.Components[x] is TRectangle then
            begin
                TRectangle(item.Components[x]).Fill.Color := $FFFFFFFF;
                TRectangle(item.Components[x]).Tag := 0;
                TLabel(TRectangle(item.Components[x]).Components[0]).TextSettings.FontColor := $FFA0A0A0;
            end;
        end;
    end;

    TRectangle(Sender).Fill.Color := $FF5CC6BA;
    TRectangle(Sender).Tag := 1;
    TLabel(TRectangle(Sender).Components[0]).TextSettings.FontColor := $FFFFFFFF;
end;

procedure TFrmAgenda.SelecionaDiaTap(Sender: TObject; const Point: TPointF);
var
    i, x : integer;
    item : TListBoxItem;
begin
    for i := 0 to lb_horario.Items.Count - 1 do
    begin
        item := lb_horario.ItemByIndex(i);

        for x := 0 to item.ComponentCount - 1 do
        begin
            if item.Components[x] is TRectangle then
            begin
                TRectangle(item.Components[x]).Fill.Color := $FFFFFFFF;
                TRectangle(item.Components[x]).Tag := 0;
                TLabel(TRectangle(item.Components[x]).Components[0]).TextSettings.FontColor := $FFA0A0A0;
            end;
        end;
    end;

    TRectangle(Sender).Fill.Color := $FF5CC6BA;
    TRectangle(Sender).Tag := 1;
    TLabel(TRectangle(Sender).Components[0]).TextSettings.FontColor := $FFFFFFFF;
end;

procedure TFrmAgenda.AddHorario(hora : string);
var
    rect : TRectangle;
    lbl : TLabel;
    item : TListBoxItem;
begin
    // Criar o item da listbox...
    item := TListBoxItem.Create(lb_horario);
    item.Text := '';
    item.Height := 55;
    item.Width := 100;


    // Criar retangulo...
    rect := TRectangle.Create(item);
    with rect do
    begin
        Align := TAlignLayout.Client;
        Fill.Color := $FFFFFFFF;
        Stroke.Kind := TBrushKind.Solid;
        Stroke.Color := $FFECECEC;
        Margins.Top := 5;
        Margins.Bottom := 5;
        Margins.Right := 5;
        Margins.Left := 5;
        XRadius := 8;
        YRadius := 8;
        TagString := hora;
        Tag := 0;

        {$IFDEF MSWINDOWS}
        OnClick := SelecionaDia;
        {$ELSE}
        OnTap := SelecionaDiaTap;
        {$ENDIF}
    end;

    // Criar label do horario...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Align := TAlignLayout.Client;
        TextSettings.FontColor := $FFA0A0A0;
        Text := hora;
        font.Size := 16;
        //Font.Style := [TFontStyle.fsBold];
        TextSettings.HorzAlign := TTextAlign.Center;
        TextSettings.VertAlign := TTextAlign.Center;
        rect.AddObject(lbl);
    end;

    item.AddObject(rect);
    lb_horario.AddObject(item);
end;

procedure TFrmAgenda.ListarHorarios;
var
    i : integer;
begin
    lbl_mes.Text := cal.MonthName;

    for i := 9 to 15 do
        AddHorario(FormatFloat('00', i) + ':00');
end;

procedure TFrmAgenda.rect_confirmarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmAgenda.DayClick(Sender: TObject);
begin
    //showmessage('Clicou no dia: ' + FormatDateTime('dd/mm', cal.SelectedDate));

    ListarHorarios;
end;

procedure TFrmAgenda.FormCreate(Sender: TObject);
begin
    // Monta o calendario...
    cal := TCustomCalendar.Create(layout_calendario);
    cal.OnClick := DayClick;

    // Setup calendario...
    cal.DayFontSize := 14;
    cal.DayFontColor := $FF737375;
    cal.SelectedDayColor := $FF5CC6BA;
    cal.BackgroundColor := $FFFFFFFF;

    cal.ShowCalendar;
end;

procedure TFrmAgenda.FormDestroy(Sender: TObject);
begin
    cal.DisposeOf;
end;

procedure TFrmAgenda.img_anteriorClick(Sender: TObject);
begin
    cal.PriorMonth;

    ListarHorarios;
end;

procedure TFrmAgenda.img_proximoClick(Sender: TObject);
begin
    cal.NextMonth;

    ListarHorarios;
end;

end.
