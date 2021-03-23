unit uCustomCalendar;

interface

uses FMX.Layouts, FMX.Objects, FMX.Types, FMX.Forms, FMX.Graphics, FMX.Ani,
     FMX.StdCtrls, SysUtils, DateUtils, System.Types, System.UITypes;

type
  TExecutaClickWin = procedure(Sender: TObject) of Object;

  TCustomCalendar = class
  private
    rectCalendar, rectDay: TRectangle;
    lblDay : TLabel;
    maxWidth, maxHeight : Single;
    circleDay : TCircle;
    FMonthName : string;


    FDayFontSize : integer;
    FSelectedDate : TDate;
    FDayFontColor, FBackgroundColor, FSelectedDayColor : Cardinal;
    ACallBack: TExecutaClickWin;

  public
    constructor Create(lyt: TLayout);
    procedure ShowCalendar();
    procedure NextMonth();
    procedure PriorMonth();
    procedure AddMarker(day : integer; TextColor : TAlphaColor = $FFFFFFFF;
                       BackgroundColor : TAlphaColor = $FFE68B93);
    procedure DeleteMarker(day : integer);
    procedure SelectDay(day : integer);
    procedure ClearAllMarkers();
    procedure DayClick(Sender: TObject);
  published
    property DayFontSize: integer read FDayFontSize write FDayFontSize;
    property DayFontColor: Cardinal read FDayFontColor write FDayFontColor;
    property SelectedDayColor: Cardinal read FSelectedDayColor write FSelectedDayColor;
    property SelectedDate: TDate read FSelectedDate write FSelectedDate;
    property BackgroundColor: Cardinal read FBackgroundColor write FBackgroundColor;
    property OnClick: TExecutaClickWin read ACallBack write ACallBack;
    property MonthName: string read FMonthName write FMonthName;
end;


implementation

function GetMonthName(MyDate : Tdate) : string;
begin
    case MonthOf(MyDate) of
        1: Result := 'Janeiro';
        2: Result := 'Fevereiro';
        3: Result := 'Março';
        4: Result := 'Abril';
        5: Result := 'Maio';
        6: Result := 'Junho';
        7: Result := 'Julho';
        8: Result := 'Agosto';
        9: Result := 'Setembro';
        10: Result := 'Outubro';
        11: Result := 'Novembro';
        12: Result := 'Dezembro';
    end;

    Result := Result + '  ' + FormatDateTime('YYYY', MyDate);
end;

function WeekDayName(day : integer) : string;
begin
    case day of
        1: Result := 'D';
        2: Result := 'S';
        3: Result := 'T';
        4: Result := 'Q';
        5: Result := 'Q';
        6: Result := 'S';
        7: Result := 'S';
    end;
end;

constructor TCustomCalendar.Create(lyt: TLayout);
var
    x : integer;
begin
    FDayFontSize := 14;
    FDayFontColor := $FF737375;
    FBackgroundColor := $FFFFFFFF;
    FSelectedDate := now;
    FMonthName := GetMonthName(SelectedDate);
    FSelectedDayColor := $FFCCCCCC;


    maxWidth := lyt.Width;
    maxHeight := lyt.Height;


    // Cria retangulo de fundo...
    rectCalendar := TRectangle.Create(lyt);
    rectCalendar.Fill.Color := FBackgroundColor;
    rectCalendar.Fill.Kind := TBrushKind.Solid;
    rectCalendar.Stroke.Kind := TBrushKind.None;
    rectCalendar.Align := TAlignLayout.Contents;


    // Cria os retangulos dos dias da semana (D S T Q Q S S)...
    for x := 1 to 7 do
    begin
        rectDay := TRectangle.Create(rectCalendar);
        rectDay.Width := trunc(lyt.Width / 7);
        rectDay.Height := rectDay.Width;
        rectDay.Visible := false;
        rectDay.Name := 'day_name' + IntToStr(x);
        rectDay.Parent := rectCalendar;
        rectDay.Stroke.Kind := TBrushKind.None;
        rectDay.Fill.Color := FBackgroundColor;
        rectDay.Fill.Kind := TBrushKind.Solid;

        lblDay := TLabel.Create(rectDay);
        lblDay.Align := TAlignLayout.Client;
        lblDay.TextSettings.HorzAlign := TTextAlign.Center;
        lblDay.Text := WeekDayName(x);
        lblDay.StyledSettings := lblDay.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
        lblDay.FontColor := $FFBDBDBD;
        lblDay.Font.Size := FDayFontSize;

        rectDay.AddObject(lblDay);
    end;


    // Cria os dias do mes (1 a 31)...
    for x := 1 to 31 do
    begin
        rectDay := TRectangle.Create(rectCalendar);
        rectDay.Width := trunc(lyt.Width / 7);
        rectDay.Height := rectDay.Width;
        rectDay.Visible := false;
        rectDay.Name := 'day' + x.ToString;
        rectDay.Parent := rectCalendar;
        rectDay.Stroke.Kind := TBrushKind.None;
        rectDay.Fill.Color := FBackgroundColor;
        rectDay.Fill.Kind := TBrushKind.Solid;

        lblDay := TLabel.Create(rectDay);
        lblDay.Align := TAlignLayout.Contents;
        lblDay.TextSettings.HorzAlign := TTextAlign.Center;
        lblDay.TextSettings.VertAlign := TTextAlign.Center;
        lblDay.Text := x.ToString;
        lblDay.StyledSettings := lblDay.StyledSettings - [TStyledSetting.Style, TStyledSetting.Size, TStyledSetting.FontColor];
        lblDay.Font.Style := [TFontStyle.fsBold];
        lblDay.FontColor := FDayFontColor;
        lblDay.Font.Size := FDayFontSize;
        lblDay.HitTest := true;
        lblDay.OnClick := DayClick;
        lblDay.Name := 'lbl_day_' + x.ToString;
        lblDay.Tag := x;

        circleDay := TCircle.Create(rectDay);
        circleDay.Align := TAlignLayout.Center;;
        circleDay.Fill.Kind := TBrushKind.Solid;
        circleDay.Fill.Color := $FFE68B93;
        circleDay.Name := 'day_c' + x.ToString;
        circleDay.Stroke.Kind := TBrushKind.None;
        circleDay.Stroke.Thickness := 2;
        //circleDay.Stroke.Dash := TStrokeDash.Dash;

        circleDay.Visible := false;
        circleDay.HitTest := false;
        circleDay.Width := 30;
        circleDay.Height := 30;

        rectDay.AddObject(circleDay);

        rectDay.AddObject(lblDay);
    end;

    lyt.AddObject(rectCalendar);
end;


procedure TCustomCalendar.DayClick(Sender: TObject);
var
    day, month, year : integer;
begin
    day := TLabel(Sender).tag;
    month := strtoint(FormatDateTime('MM', FSelectedDate));
    year := strtoint(FormatDateTime('YYYY', FSelectedDate));

    FSelectedDate := EncodeDate(year, month, day);
    FMonthName := GetMonthName(SelectedDate);
    ACallBack(Sender);

    SelectDay(day);
end;


procedure TCustomCalendar.ClearAllMarkers();
var
    c : TCircle;
    lbl : TLabel;
    x : integer;
begin
    for x := 1 to 31 do
    begin
        rectDay := rectCalendar.FindComponent('day' + x.ToString) as TRectangle;

        c := rectDay.FindComponent('day_c' + x.ToString) as TCircle;
        c.Stroke.Kind := TBrushKind.None;
        c.Visible := false;
        c.Tag := 0;

        lbl := rectDay.FindComponent('lbl_day_' + x.ToString) as TLabel;
        lbl.FontColor := FDayFontColor;
        lbl.TagString := '';
    end;
end;

procedure TCustomCalendar.NextMonth();
begin
    FSelectedDate := IncMonth(FSelectedDate, 1);
    FMonthName := GetMonthName(SelectedDate);
    ClearAllMarkers;
    ShowCalendar;
end;

procedure TCustomCalendar.PriorMonth();
begin
    FSelectedDate := IncMonth(FSelectedDate, -1);
    FMonthName := GetMonthName(SelectedDate);
    ClearAllMarkers;
    ShowCalendar;
end;

procedure TCustomCalendar.SelectDay(day : integer);
var
    c : TCircle;
    x : integer;
begin
    for x := 1 to 31 do
    begin
        rectDay := rectCalendar.FindComponent('day' + x.ToString) as TRectangle;

        c := rectDay.FindComponent('day_c' + x.ToString) as TCircle;
        c.Stroke.Kind := TBrushKind.None;
    end;

    rectDay := rectCalendar.FindComponent('day' + day.ToString) as TRectangle;

    c := rectDay.FindComponent('day_c' + day.ToString) as TCircle;
    c.Visible := true;


    if c.Tag = 0 then
        c.Fill.Kind := TBrushKind.None
    else
        c.Fill.Kind := TBrushKind.Solid;


    c.Stroke.Kind := TBrushKind.Solid;
    c.Stroke.Color := FSelectedDayColor;
end;

procedure TCustomCalendar.AddMarker(day : integer; TextColor : TAlphaColor = $FFFFFFFF;
                                    BackgroundColor : TAlphaColor = $FFE68B93);
var
    c : TCircle;
    lbl : TLabel;
begin
    rectDay := rectCalendar.FindComponent('day' + day.ToString) as TRectangle;

    c := rectDay.FindComponent('day_c' + day.ToString) as TCircle;
    c.Visible := true;
    c.Fill.Kind := TBrushKind.Solid;
    c.Fill.Color := BackgroundColor;
    c.Tag := 1;

    lbl := rectDay.FindComponent('lbl_day_' + day.ToString) as TLabel;
    lbl.FontColor := TextColor;
    lbl.TagString := 'M';
end;

procedure TCustomCalendar.DeleteMarker(day : integer);
var
    c : TCircle;
    lbl : TLabel;
begin
    rectDay := rectCalendar.FindComponent('day' + day.ToString) as TRectangle;

    c := rectDay.FindComponent('day_c' + day.ToString) as TCircle;
    c.Visible := false;
    c.Tag := 0;


    lbl := rectDay.FindComponent('lbl_day_' + day.ToString) as TLabel;
    lbl.FontColor := FDayFontColor;
    lbl.TagString := '';

    if DayOf(FSelectedDate) = day then
        SelectDay(day);
end;


procedure TCustomCalendar.ShowCalendar();
var
    x, y, cont : integer;
    WeekDay : integer;
    DayHeight : Single;
    lbl : TLabel;
begin
    Y := 1;
    cont := 1;

    rectCalendar.Fill.Color := FBackgroundColor;

    // Quantas "linhas" tem o calendario?
    // (usando para calcular a altura dos itens)
    for x := 1 to 31 do
    begin
        rectDay := rectCalendar.FindComponent('day' + x.ToString) as TRectangle;
        rectDay.Fill.Color := FBackgroundColor;

        if x <= MonthDays[IsLeapYear(YearOf(FSelectedDate)), MonthOf(FSelectedDate)] then
        begin
            WeekDay := DayOfWeek(EncodeDate(YearOf(FSelectedDate), MonthOf(FSelectedDate), x));

            if (WeekDay = 7) then
                inc(cont)
            else
            if (WeekDay <> 7) and (x = MonthDays[IsLeapYear(YearOf(FSelectedDate)), MonthOf(FSelectedDate)]) then
                inc(cont);
        end;

        lbl := rectDay.FindComponent('lbl_day_' + x.ToString) as TLabel;

        if lbl.TagString = '' then
            lbl.FontColor := FDayFontColor;
    end;

    DayHeight := Trunc(maxHeight / cont);


    // Atualiza os dias da semana (D S T Q Q S S)...
    for x := 1 to 7 do
    begin
        rectDay := rectCalendar.FindComponent('day_name' + x.ToString) as TRectangle;
        rectDay.Fill.Color := FBackgroundColor;

        rectDay.Position.X := (x - 1) * rectDay.Width;
        rectDay.Position.Y := 1;
        rectDay.Height := DayHeight;
        rectDay.Visible := true;
    end;

    y := y + Trunc(rectDay.Height);


    // Atualiza os dias do mes (1 a 31)...
    for x := 1 to 31 do
    begin
        rectDay := rectCalendar.FindComponent('day' + x.ToString) as TRectangle;

        if x <= MonthDays[IsLeapYear(YearOf(FSelectedDate)), MonthOf(FSelectedDate)] then
        begin
            rectDay.Visible := true;

            WeekDay := DayOfWeek(EncodeDate(YearOf(FSelectedDate), MonthOf(FSelectedDate), x));

            rectDay.Position.X := (WeekDay - 1) * rectDay.Width;
            rectDay.Position.Y := y;
            rectDay.Height := DayHeight;


            if WeekDay = 7 then
                y := y + Trunc(rectDay.Height);
        end
        else
            rectDay.Visible := false;
    end;

    SelectDay(DayOf(FSelectedDate));

end;





end.

