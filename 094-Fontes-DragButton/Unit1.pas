unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Ani,
  FMX.Gestures;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    Circle1: TCircle;
    Layout3: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Layout4: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout5: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Line1: TLine;
    Circle2: TCircle;
    GestureManager1: TGestureManager;
    Image7: TImage;
    Layout6: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure Circle2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Circle2Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Circle2Click(Sender: TObject);
    procedure Circle2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Layout6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
  private
    { Private declarations }
    MoveObjeto : Boolean;
    Offset : TPointF;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Modo_Edicao(editar : boolean);
begin
    with Form1 do
    begin
        if editar then
        begin
            circle2.Stroke.Color := $FFFFFFFF; // branco
            circle2.Stroke.Dash := TStrokeDash.Dash; // tracos
            circle2.Tag := 1; // indica SIM modo edicao
            circle2.Opacity := 0.7;
        end
        else
        begin
            circle2.Stroke.Color := $FFFD5872; // vermelho
            circle2.Stroke.Dash := TStrokeDash.Solid; // linha solida
            circle2.Tag := 0; // indica NAO modo edicao
            circle2.Opacity := 1;
        end
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        Modo_Edicao(false);
end;

procedure TForm1.Circle2Click(Sender: TObject);
begin
        if Circle2.Tag = 0 then
        begin
            showmessage('Abrir opções...');
        end;
end;

procedure TForm1.Circle2Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
        // Mobile: long tap seta modo edicao para TRUE...
        if EventInfo.GestureID = igiLongTap then
            Modo_Edicao(true);

        // Mobile: double tap seta modo edicao para FALSE...
        if EventInfo.GestureID = igiDoubleTap then
            Modo_Edicao(false);

end;

procedure TForm1.Circle2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
        // Seta o layout para capturar o mouse...
        if Circle2.Tag = 1 then
                layout6.Root.Captured := layout6;

        // Indica que objeto pode se mover...
        MoveObjeto := true;

        Offset.X := X;
        Offset.Y := Y;

        // Windows: Botao direito muda modo edicao...
        if Button = TMouseButton.mbRight then
                Modo_Edicao(NOT Circle2.Tag.ToBoolean);
end;

procedure TForm1.Circle2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin


        MoveObjeto := false;
end;

procedure TForm1.Layout6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
    if (Circle2.Tag = 1) and (MoveObjeto) and (ssLeft In Shift) then
    begin
            Circle2.Position.X := X - Offset.X;
            Circle2.Position.Y := Y - Offset.Y;
    end;

end;

end.
