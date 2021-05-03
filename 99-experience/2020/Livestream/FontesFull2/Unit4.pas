unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TForm4 = class(TForm)
    Layout5: TLayout;
    RoundRect3: TRoundRect;
    lbl_arc: TLabel;
    Arc1: TArc;
    AnimationArc: TFloatAnimation;
    AnimationLarg: TFloatAnimation;
    procedure AnimationLargFinish(Sender: TObject);
    procedure RoundRect3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}


procedure TForm4.RoundRect3Click(Sender: TObject);
begin
    AnimationLarg.Inverse := false;
    AnimationLarg.Start;
    lbl_arc.AnimateFloat('Opacity', 0, 0.4);

    TThread.CreateAnonymousThread(procedure
    begin
        Sleep(4000);

        TThread.Synchronize(nil, procedure
        begin
            AnimationArc.Stop;
            Arc1.Visible := false;

            AnimationLarg.Inverse := true;
            AnimationLarg.Start;
            lbl_arc.Text := 'Ops! Tente novamente.';
            lbl_arc.AnimateFloat('Opacity', 1, 0.4);
        end);

    end).Start;
end;

procedure TForm4.AnimationLargFinish(Sender: TObject);
begin
    if NOT AnimationLarg.Inverse then
    begin
        Arc1.Visible := true;
        AnimationArc.Start;
    end;
end;


end.
