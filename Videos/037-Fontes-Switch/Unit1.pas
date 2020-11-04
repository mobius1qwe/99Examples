unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    lbl_titulo: TLabel;
    lbl_descricao: TLabel;
    circle_fundo1: TCircle;
    Layout3: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle0: TRectangle;
    rect_switch: TRectangle;
    circle_indicador: TCircle;
    Image1: TImage;
    lbl_titulo2: TLabel;
    lbl_descricao2: TLabel;
    Layout1: TLayout;
    circle_fundo2: TCircle;
    rect_switch2: TRectangle;
    Circle2: TCircle;
    Image2: TImage;
    Switch1: TSwitch;
    procedure FormShow(Sender: TObject);
    procedure rect_switchClick(Sender: TObject);
    procedure rect_switch2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure TForm1.FormShow(Sender: TObject);
begin
        with Form1 do
        begin
                circle_fundo1.Height := 0;
                circle_fundo1.Width := 0;
                lbl_titulo.FontColor := $FF48A1CF;
                lbl_descricao.FontColor := $FF9D9D9D;

                circle_fundo2.Height := 0;
                circle_fundo2.Width := 0;
                lbl_titulo2.FontColor := $FF48A1CF;
                lbl_descricao2.FontColor := $FF9D9D9D;
        end;
end;

procedure Switch(rect : TRectangle; circle_fundo : TCircle);
var
        circle : TCircle;
        x : integer;
begin
        // Loop nos componentes do form para encontrar o circle do SWITCH...
        with Form1 do
        begin
            for x := 0 to ComponentCount - 1 do
                if (Components[x].GetParentComponent.Name =  rect.Name) and (Components[x] is TCircle) then
                    circle := Components[x] as TCircle;
        end;

        // Se não encontrou...
        if circle = nil then
            exit;


        // If switch NÃO checked...
        if rect.Tag = 0 then
        begin
                // Anima o slide...
                circle.AnimateFloat('Position.X', rect.Width - circle.Width - 4, 0.2);

                // Marca como checked...
                rect.Tag := 1;
                rect.Fill.Kind := TBrushKind.None;

                // Anima o funco redondo...
                circle_fundo.AnimateFloat('Height', 800, 0.4);
                circle_fundo.AnimateFloat('Width', 800, 0.4);
        end
        else
        begin
                // Anima o slide...
                circle.AnimateFloat('Position.X', 4, 0.2);

                // Marca como NÃO checked...
                rect.Tag := 0;
                rect.Fill.Kind := TBrushKind.Solid;

                // Anima o funco redondo...
                circle_fundo.AnimateFloat('Height', 0, 0.4);
                circle_fundo.AnimateFloat('Width', 0, 0.4);
        end;
end;

procedure TForm1.rect_switchClick(Sender: TObject);
begin
        Switch(TRectangle(Sender), circle_fundo1);

        TThread.CreateAnonymousThread(procedure
        begin
                sleep(200);

                TThread.Synchronize(nil, procedure
                begin
                        if rect_switch.Tag = 1 then
                        begin
                                lbl_titulo.FontColor := $FFFFFFFF;
                                lbl_descricao.FontColor := $FF000000;
                        end
                        else
                        begin
                                lbl_titulo.FontColor := $FF1BA3EB;
                                lbl_descricao.FontColor := $FF9D9D9D;
                        end;
                end);

        end).Start;
end;

procedure TForm1.rect_switch2Click(Sender: TObject);
begin
        Switch(TRectangle(Sender), circle_fundo2);

        TThread.CreateAnonymousThread(procedure
        begin
                sleep(200);

                TThread.Synchronize(nil, procedure
                begin
                        if rect_switch2.Tag = 1 then
                        begin
                                lbl_titulo2.FontColor := $FFFFFFFF;
                                lbl_descricao2.FontColor := $FF000000;
                        end
                        else
                        begin
                                lbl_titulo2.FontColor := $FF1BA3EB;
                                lbl_descricao2.FontColor := $FF9D9D9D;
                        end;
                end);

        end).Start;


end;


end.
