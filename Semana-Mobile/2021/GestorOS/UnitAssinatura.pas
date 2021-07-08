unit UnitAssinatura;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  System.Generics.Collections;

type
  TAssinatura = Record
      PosicaoCursor : TPointF;
      PosState : Byte;
  End;

  TFrmAssinatura = class(TForm)
    rectOSToolbar: TRectangle;
    Label1: TLabel;
    rect_assinatura: TRectangle;
    imgSalvar: TImage;
    imgVoltar: TImage;
    imgLimpar: TImage;
    procedure rect_assinaturaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure rect_assinaturaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_assinaturaPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure imgVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgLimparClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AddPoint(const x, y: single; const state: byte);
    { Private declarations }
  public
    codOS: string;
    Assina : TList<TAssinatura>;
    botao : boolean;
  end;

var
  FrmAssinatura: TFrmAssinatura;

implementation

{$R *.fmx}

uses UnitDM;

procedure TFrmAssinatura.AddPoint(const x, y: single; const state: byte);
var
    p : TAssinatura;
begin
    p.PosicaoCursor := PointF(x, y);
    p.PosState := state;

    if Assina.Count - 1 < 0 then
            p.PosState := 0;

    if p.PosState <> 1 then
        Assina.Add(p)
    else
    if p.PosicaoCursor.Distance(Assina.Last.PosicaoCursor) > 0.8 then
        Assina.Add(p);

    rect_assinatura.Repaint;
end;


procedure TFrmAssinatura.FormCreate(Sender: TObject);
begin
    Assina := TList<TAssinatura>.Create;
end;

procedure TFrmAssinatura.FormDestroy(Sender: TObject);
begin
    FreeAndNil(Assina);
end;

procedure TFrmAssinatura.FormShow(Sender: TObject);
begin
    Assina.Clear;
end;

procedure TFrmAssinatura.imgLimparClick(Sender: TObject);
begin
    Assina.Clear;
    rect_assinatura.Repaint;
end;

procedure TFrmAssinatura.imgSalvarClick(Sender: TObject);
var
    assinatura : TBitmap;
begin
    try
        assinatura := rect_assinatura.MakeScreenshot;
        assinatura.Rotate(90);

        // Atualizo a tabela de OS...
        dm.qryGeral.Active := false;
        dm.qryGeral.SQL.Clear;
        dm.qryGeral.SQL.Add('UPDATE TAB_OS SET ASSINATURA=:ASSINATURA WHERE COD_OS=:COD_OS');
        dm.qryGeral.ParamByName('ASSINATURA').Assign(assinatura);
        dm.qryGeral.ParamByName('COD_OS').Value := codOS;
        dm.qryGeral.ExecSQL;
    finally
        assinatura.DisposeOf;
    end;

    close;
end;

procedure TFrmAssinatura.imgVoltarClick(Sender: TObject);
begin
    Assina.Clear;
    close;
end;

procedure TFrmAssinatura.rect_assinaturaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
     // Se botao pressionado...
    if ssLeft in Shift then
    begin
        if NOT botao then
        begin
            // Desenha o inicio do traco...
            AddPoint(x, y, 0);
            botao := true;
        end
        else
            AddPoint(x, y, 1);
    end;
end;

procedure TFrmAssinatura.rect_assinaturaMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
    botao := false;
    AddPoint(x, y, 2);
end;

procedure TFrmAssinatura.rect_assinaturaPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
    p : TAssinatura;
    p1, p2 : TPointF;
begin
    if NOT (Assina.Count - 1 > 0) then
        exit;

    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Dash := TStrokeDash.Solid;
    Canvas.Stroke.Thickness := 4;
    Canvas.Stroke.Color := TAlphaColorRec.Black;

    for p in Assina do
    begin
        case p.PosState of
            0 : p1 := p.PosicaoCursor;
            1 : begin
                    p2 := p.PosicaoCursor;
                    Canvas.DrawLine(p1, p2, 1, Canvas.Stroke);
                    p1 := p.PosicaoCursor;
                end;
            2 : begin
                    p2 := p.PosicaoCursor;
                    Canvas.DrawLine(p1, p2, 1, Canvas.Stroke);
                end;
        end;
    end;

end;

end.
