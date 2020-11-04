unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TForm2 = class(TForm)
    Layout2: TLayout;
    rect_upload: TRectangle;
    Label3: TLabel;
    rect_progress: TRectangle;
    AnimationUpload: TFloatAnimation;
    Circle1: TCircle;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    procedure rect_uploadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.rect_uploadClick(Sender: TObject);
begin
    label3.Text := 'Enviando Foto...';
    rect_progress.Margins.Right := rect_upload.Width;
    rect_progress.Visible := true;
    AnimationUpload.StartValue := rect_upload.Width;
    AnimationUpload.Duration := 5;
    AnimationUpload.Loop := true;
    AnimationUpload.Start;


    TThread.CreateAnonymousThread(procedure
    begin
        Sleep(3000); // Upload da imagem....

        TThread.Synchronize(nil, procedure
        begin
            AnimationUpload.StopAtCurrent;
            AnimationUpload.Loop := false;
            AnimationUpload.Duration := 0.5;
            AnimationUpload.Start;

            rect_progress.Corners := [TCorner.BottomLeft, TCorner.BottomRight];
            label3.Text := 'Envio Realizado';
        end);

    end).Start;

end;

end.
