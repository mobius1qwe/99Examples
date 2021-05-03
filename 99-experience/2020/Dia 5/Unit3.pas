unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TForm3 = class(TForm)
    Layout4: TLayout;
    rect_inserir: TRoundRect;
    lbl_email: TLabel;
    AnimationInserirLabel: TFloatAnimation;
    AnimationInserirWidth: TFloatAnimation;
    EditInserir: TEdit;
    lbl_enviar_email: TLabel;
    Image1: TImage;
    procedure AnimationInserirWidthFinish(Sender: TObject);
    procedure lbl_enviar_emailClick(Sender: TObject);
    procedure rect_inserirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.AnimationInserirWidthFinish(Sender: TObject);
begin
    if NOT AnimationInserirWidth.Inverse then
        EditInserir.Visible := true
    else
        lbl_email.Text := 'Enviado';
end;

procedure TForm3.lbl_enviar_emailClick(Sender: TObject);
begin
    lbl_email.Text := '';
    EditInserir.Visible := false;
    AnimationInserirWidth.Inverse := true;
    AnimationInserirWidth.Start;

    AnimationInserirLabel.Inverse := true;
    AnimationInserirLabel.Start;
end;

procedure TForm3.rect_inserirClick(Sender: TObject);
begin
    EditInserir.Text := '';

    AnimationInserirWidth.Inverse := false;
    AnimationInserirWidth.Start;

    AnimationInserirLabel.Inverse := false;
    AnimationInserirLabel.Start;
end;


end.
