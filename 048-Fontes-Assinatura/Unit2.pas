unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,

  System.Generics.Collections

  ;

type
  TAssinatura = Record
          PosicaoCursor : TPointF;
          PosState : Byte;
  End;

  TForm2 = class(TForm)
    rect_assinatura: TRectangle;
    btn_ok: TSpeedButton;
    Layout1: TLayout;
    btn_voltar: TSpeedButton;
    Label1: TLabel;
    img_temp: TImage;
    btn_clear: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);
    procedure btn_voltarClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure rect_assinaturaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure rect_assinaturaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_assinaturaPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
    Assina : TList<TAssinatura>;
    botao : boolean;
    procedure AddPoint(const x, y : single; const state: byte);
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses Unit1;

{ TForm2 }

procedure TForm2.AddPoint(const x, y: single; const state: byte);
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



procedure TForm2.btn_clearClick(Sender: TObject);
begin
        Assina.Clear;
        rect_assinatura.Repaint;
end;

procedure TForm2.btn_okClick(Sender: TObject);
begin
        // Rotacionar a assinatura...
        img_temp.RotationAngle := 0;
        img_temp.Bitmap := rect_assinatura.MakeScreenshot;
        img_temp.Bitmap.Rotate(90);

        // Envia assinatura para o Form1...
        form1.img_assinatura.Bitmap.Assign(img_temp.MakeScreenshot);
        close;
end;

procedure TForm2.btn_voltarClick(Sender: TObject);
begin
        Assina.Clear;
        close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
        Assina := TList<TAssinatura>.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
        FreeAndNil(Assina);
end;

procedure TForm2.FormShow(Sender: TObject);
begin
        Assina.Clear;
end;

procedure TForm2.rect_assinaturaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
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

procedure TForm2.rect_assinaturaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
        botao := false;
        AddPoint(x, y, 2);
end;

procedure TForm2.rect_assinaturaPaint(Sender: TObject; Canvas: TCanvas;
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
        Canvas.Stroke.Color := TAlphaColorRec.Darkblue;


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
