unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit;

type
  TFrmPrincipal = class(TForm)
    VertScrollBox1: TVertScrollBox;
    rect_titulo: TRectangle;
    rect_valor: TRectangle;
    Label1: TLabel;
    Edit1: TEdit;
    StyleBook1: TStyleBook;
    Line1: TLine;
    Image1: TImage;
    Image2: TImage;
    lbl_titulo: TLabel;
    img_fundo: TImage;
    layout_botoes: TLayout;
    Rectangle1: TRectangle;
    Image3: TImage;
    procedure VertScrollBox1ViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure ResizeObjects;
    procedure AddDestaque(cod_item, titulo, descricao, icone : string;
                          vl_estimado, vl_minimo, rentabilidade : double;
                          prazo : integer);
    procedure AddItem(cod_item, descricao, icone: string; vl_estimado, vl_minimo,
      rentabilidade: double; prazo: integer);
    procedure SelecionaItem(Sender: TObject);
    procedure SelecionaItemTap(Sender: TObject; const Point: TPointF);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.SelecionaItem(Sender: TObject);
begin
    showmessage('Item selecionado: ' + TRectangle(Sender).TagString);
end;

procedure TFrmPrincipal.SelecionaItemTap(Sender: TObject; const Point: TPointF);
begin
    showmessage('Item selecionado: ' + TRectangle(Sender).TagString);
end;


procedure TFrmPrincipal.AddDestaque(cod_item, titulo, descricao, icone : string;
                                    vl_estimado, vl_minimo, rentabilidade : double;
                                    prazo : integer);
var
    rect, rect_barra, rect_icone : TRectangle;
    lbl : TLabel;
begin
    // Fundo...
    rect := TRectangle.Create(VertScrollBox1);
    with rect do
    begin
        Align := TAlignLayout.Top;
        Height := 130;
        Fill.Color := $FFFFFFFF;
        Stroke.Kind := TBrushKind.None;
        Margins.Top := 210;
        Margins.Left := 10;
        Margins.Right := 10;
        XRadius := 8;
        YRadius := 8;
        TagString := cod_item;

        {$IFDEF MSWINDOWS}
        OnClick := SelecionaItem;
        {$ELSE}
        OnTap := SelecionaItemTap;
        {$ENDIF}

    end;


    // Barra inferior...
    rect_barra := TRectangle.Create(rect);
    with rect_barra do
    begin
        Align := TAlignLayout.Bottom;
        Height := 55;
        Fill.Color := $FF685FEE;
        Stroke.Kind := TBrushKind.None;
        XRadius := 8;
        YRadius := 8;
        Corners := [TCorner.BottomLeft,TCorner.BottomRight];
        rect.AddObject(rect_barra);
        HitTest := false;
    end;


     // Label destaque...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Align := TAlignLayout.Top;
        Height := 20;
        TextSettings.FontColor := $FF685FEE;
        Text := titulo;
        font.Size := 10;
        Margins.Left := 10;
        Margins.Right := 10;
        Margins.Top := 5;
        Font.Style := [TFontStyle.fsBold];
        rect.AddObject(lbl);
    end;


    // Caixa de Icone...
    rect_icone := TRectangle.Create(rect);
    with rect_icone do
    begin
        Height := 30;
        Width := 30;
        Fill.Color := $FF685FEE;
        Stroke.Kind := TBrushKind.None;
        XRadius := 4;
        YRadius := 4;
        Position.X := 10;
        Position.Y := 32;
        HitTest := false;
        rect.AddObject(rect_icone);
    end;


    // Label do icone...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Align := TAlignLayout.Client;
        Height := 20;
        TextSettings.FontColor := $FFFFFFFF;
        TextSettings.VertAlign := TTextAlign.Center;
        TextSettings.HorzAlign := TTextAlign.Center;
        Text := icone;
        font.Size := 9;
        Font.Style := [TFontStyle.fsBold];
        rect_icone.AddObject(lbl);
    end;


    // Descricao...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF333333;
        Text := descricao;
        font.Size := 12;
        Font.Style := [TFontStyle.fsBold];
        Position.X := 50;
        Position.Y := 40;
        rect.AddObject(lbl);
    end;


    // Resultado estimado...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Anchors := [TAnchorKind.akTop,TAnchorKind.akRight];
        TextSettings.FontColor := $FFCCCCCC;
        TextSettings.HorzAlign := TTextAlign.Trailing;
        Text := 'Resultado Estimado';
        font.Size := 10;
        Width := 150;
        Position.X := -160;
        Position.Y := 27;
        rect.AddObject(lbl);
    end;


    // Valor resultado estimado...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Anchors := [TAnchorKind.akTop,TAnchorKind.akRight];
        TextSettings.FontColor := $FF333333;
        TextSettings.HorzAlign := TTextAlign.Trailing;
        Text := 'R$ ' + FormatFloat('#,##0.00', vl_estimado);
        font.Size := 13;
        Width := 150;
        Position.X := -160;//VertScrollBox1.Width - 180;
        Position.Y := 43;
        Font.Style := [TFontStyle.fsBold];
        rect.AddObject(lbl);
    end;


    // Texto Valor minimo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FFFFFFFF;
        Text := 'Valor Mínimo';
        font.Size := 9;
        Width := 150;
        Position.X := 10;
        Position.Y := 7;
        rect_barra.AddObject(lbl);
    end;

    // Valor minimo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FFFFFFFF;
        Text := 'R$ ' + FormatFloat('#,##0.00', vl_minimo);
        font.Size := 11;
        Width := 150;
        Position.X := 10;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect_barra.AddObject(lbl);
    end;

    // Texto rentabilidade...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FFFFFFFF;
        Text := 'Rentabilidade';
        font.Size := 9;
        Width := 150;
        Position.X := 90;
        Position.Y := 7;
        rect_barra.AddObject(lbl);
    end;

    // Valor rentabilidade...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FFFFFFFF;
        Text := FormatFloat('#,##0.00', rentabilidade) + '% CDI';
        font.Size := 11;
        Width := 150;
        Position.X := 90;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect_barra.AddObject(lbl);
    end;

    // Texto prazo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FFFFFFFF;
        Text := 'Prazo';
        font.Size := 9;
        Width := 150;
        Position.X := 170;
        Position.Y := 7;
        rect_barra.AddObject(lbl);
    end;

    // Valor prazo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FFFFFFFF;
        Text := prazo.ToString + ' dias';
        font.Size := 11;
        Width := 150;
        Position.X := 170;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect_barra.AddObject(lbl);
    end;

    VertScrollBox1.AddObject(rect);
end;


procedure TFrmPrincipal.AddItem(cod_item, descricao, icone : string;
                                    vl_estimado, vl_minimo, rentabilidade : double;
                                    prazo : integer);
var
    rect, rect_barra, rect_icone : TRectangle;
    lbl : TLabel;
begin
    // Fundo...
    rect := TRectangle.Create(VertScrollBox1);
    with rect do
    begin
        Align := TAlignLayout.Top;
        Height := 110;
        Fill.Color := $FFFFFFFF;
        Stroke.Kind := TBrushKind.Solid;
        Stroke.Color := $FFd4d5d7;
        Margins.Top := 10;
        Margins.Left := 10;
        Margins.Right := 10;
        XRadius := 8;
        YRadius := 8;
        TagString := cod_item;

        {$IFDEF MSWINDOWS}
        OnClick := SelecionaItem;
        {$ELSE}
        OnTap := SelecionaItemTap;
        {$ENDIF}
    end;


    // Barra inferior...
    rect_barra := TRectangle.Create(rect);
    with rect_barra do
    begin
        Align := TAlignLayout.Bottom;
        Height := 55;
        Fill.Color := $FFf4f4f4;
        Stroke.Kind := TBrushKind.Solid;
        Stroke.Color := $FFd4d5d7;
        Sides := [TSide.Left, TSide.Bottom, TSide.Right];
        XRadius := 8;
        YRadius := 8;
        Corners := [TCorner.BottomLeft,TCorner.BottomRight];
        HitTest := false;
        rect.AddObject(rect_barra);
    end;


    // Caixa de Icone...
    rect_icone := TRectangle.Create(rect);
    with rect_icone do
    begin
        Height := 30;
        Width := 30;
        Fill.Color := $FF08dabd;
        Stroke.Kind := TBrushKind.None;
        XRadius := 4;
        YRadius := 4;
        Position.X := 10;
        Position.Y := 12;
        HitTest := false;
        rect.AddObject(rect_icone);
    end;


    // Label do icone...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Align := TAlignLayout.Client;
        Height := 20;
        TextSettings.FontColor := $FFFFFFFF;
        TextSettings.VertAlign := TTextAlign.Center;
        TextSettings.HorzAlign := TTextAlign.Center;
        Text := icone;
        font.Size := 9;
        Font.Style := [TFontStyle.fsBold];
        rect_icone.AddObject(lbl);
    end;


    // Descricao...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF333333;
        Text := descricao;
        font.Size := 12;
        Font.Style := [TFontStyle.fsBold];
        Position.X := 50;
        Position.Y := 20;
        rect.AddObject(lbl);
    end;


    // Resultado estimado...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Anchors := [TAnchorKind.akTop,TAnchorKind.akRight];
        TextSettings.FontColor := $FFCCCCCC;
        TextSettings.HorzAlign := TTextAlign.Trailing;
        Text := 'Resultado Estimado';
        font.Size := 10;
        Width := 150;
        Position.X := -160;
        Position.Y := 7;
        rect.AddObject(lbl);
    end;


    // Valor resultado estimado...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        Anchors := [TAnchorKind.akTop,TAnchorKind.akRight];
        TextSettings.FontColor := $FF685FEE;
        TextSettings.HorzAlign := TTextAlign.Trailing;
        Text := 'R$ ' + FormatFloat('#,##0.00', vl_estimado);
        font.Size := 13;
        Width := 150;
        Position.X := -160;//VertScrollBox1.Width - 180;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect.AddObject(lbl);
    end;


    // Texto Valor minimo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF666666;
        Text := 'Valor Mínimo';
        font.Size := 9;
        Width := 150;
        Position.X := 10;
        Position.Y := 7;
        rect_barra.AddObject(lbl);
    end;

    // Valor minimo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF333333;
        Text := 'R$ ' + FormatFloat('#,##0.00', vl_minimo);
        font.Size := 11;
        Width := 150;
        Position.X := 10;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect_barra.AddObject(lbl);
    end;

    // Texto rentabilidade...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF666666;
        Text := 'Rentabilidade';
        font.Size := 9;
        Width := 150;
        Position.X := 90;
        Position.Y := 7;
        rect_barra.AddObject(lbl);
    end;

    // Valor rentabilidade...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF333333;
        Text := FormatFloat('#,##0.00', rentabilidade) + '% CDI';
        font.Size := 11;
        Width := 150;
        Position.X := 90;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect_barra.AddObject(lbl);
    end;

    // Texto prazo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF666666;
        Text := 'Prazo';
        font.Size := 9;
        Width := 150;
        Position.X := 170;
        Position.Y := 7;
        rect_barra.AddObject(lbl);
    end;

    // Valor prazo...
    lbl := TLabel.Create(rect);
    with lbl do
    begin
        StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TextSettings.FontColor := $FF333333;
        Text := prazo.ToString + ' dias';
        font.Size := 11;
        Width := 150;
        Position.X := 170;
        Position.Y := 23;
        Font.Style := [TFontStyle.fsBold];
        rect_barra.AddObject(lbl);
    end;

    VertScrollBox1.AddObject(rect);
end;

procedure TFrmPrincipal.ResizeObjects;
begin
    img_fundo.Position.X := -80;
    img_fundo.Width := VertScrollBox1.Width + 160;
    layout_botoes.Width := VertScrollBox1.Width;
    rect_titulo.Width := VertScrollBox1.Width;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
    ResizeObjects;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    ResizeObjects;

    AddDestaque('001', 'DESTAQUE DA SEMANA', 'Modal', 'LCA', 5271.36, 1000, 99, 361);
    AddItem('002', 'Omni', 'LC', 4771.36, 5221.36, 122, 1800);
    AddItem('003', 'ABC', 'CDB', 971.36, 5410.40, 100, 1800);
    AddItem('004', 'Modal', 'LCA', 421.36, 1800, 100, 1600);
    AddItem('005', 'ABC', 'LC', 1256.36, 4050, 95, 1000);
    AddItem('006', 'Omni', 'LC', 4771.36, 5221.36, 122, 1800);
    AddItem('007', 'ABC', 'CDB', 971.36, 5410.40, 100, 1800);
    AddItem('008', 'Modal', 'LCA', 421.36, 1800, 100, 1600);
    AddItem('009', 'ABC', 'LC', 1256.36, 4050, 95, 1000);
end;

procedure TFrmPrincipal.VertScrollBox1ViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin

    if VertScrollBox1.ViewportPosition.Y < 100 then
        rect_valor.Margins.Top := 100 - VertScrollBox1.ViewportPosition.Y
    else
        rect_valor.Margins.Top := 0;


    if VertScrollBox1.ViewportPosition.Y < 50 then
        img_fundo.Position.Y := rect_valor.Margins.Top - 100
    else
        img_fundo.Position.Y := -50;


    rect_valor.Margins.Left := trunc(rect_valor.Margins.Top / 2);
    rect_valor.Margins.Right := rect_valor.Margins.Left;

    if rect_valor.Margins.Top > 10 then
        rect_valor.XRadius := 10
    else
        rect_valor.XRadius := rect_valor.Margins.Top;

    rect_valor.YRadius := rect_valor.XRadius;
    lbl_titulo.Opacity := (rect_valor.Margins.Top / 100);

end;

end.
