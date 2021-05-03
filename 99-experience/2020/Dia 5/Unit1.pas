unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    Layout3: TLayout;
    RoundRect1: TRoundRect;
    Label1: TLabel;
    AnimationMarginBottom: TFloatAnimation;
    AnimationOpacity: TFloatAnimation;
    AnimationMarginTop: TFloatAnimation;
    Layout1: TLayout;
    RoundRect2: TRoundRect;
    Label2: TLabel;
    FloatAnimation1: TFloatAnimation;
    FloatAnimation2: TFloatAnimation;
    FloatAnimation3: TFloatAnimation;
    procedure AnimationMarginBottomFinish(Sender: TObject);
    procedure RoundRect1Click(Sender: TObject);
    procedure RoundRect2Click(Sender: TObject);
  private
    procedure TextoBotao(lbl: TLabel; Texto: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AnimationMarginBottomFinish(Sender: TObject);
begin
    TLabel(AnimationMarginBottom.parent).Text := AnimationMarginBottom.TagString;
    TLabel(AnimationMarginBottom.parent).Margins.Bottom := 0;

    AnimationMarginTop.Start;

    AnimationOpacity.Inverse := true;
    AnimationOpacity.Start;
end;

procedure TForm1.TextoBotao(lbl : TLabel; Texto : string);
begin
    AnimationOpacity.Parent := lbl;
    AnimationMarginBottom.Parent := lbl;
    AnimationMarginTop.Parent := lbl;

    AnimationMarginBottom.TagString := Texto;

    AnimationMarginBottom.Start;

    AnimationOpacity.Inverse := false;
    AnimationOpacity.Start;
end;

procedure TForm1.RoundRect1Click(Sender: TObject);
begin
    TextoBotao(label1, 'Salvando...');


    RoundRect1.Enabled := false;

    TThread.CreateAnonymousThread(procedure
    begin
        Sleep(3000); // Acesso banco... WS.... etc...

        TThread.Synchronize(nil, procedure
        begin
            TextoBotao(label1, 'Salvo');
            RoundRect1.Enabled := true;
        end);

    end).Start;

end;

procedure TForm1.RoundRect2Click(Sender: TObject);
begin
    TextoBotao(Label2, 'Enviando...');
end;

end.
