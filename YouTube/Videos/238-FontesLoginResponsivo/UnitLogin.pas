unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmLogin = class(TForm)
    layoutCircle: TLayout;
    circle: TCircle;
    AnimationCircle: TFloatAnimation;
    layoutLogin: TLayout;
    layoutLoginTexto: TLayout;
    layoutLoginCampos: TLayout;
    layoutNovo: TLayout;
    btnCriarConta: TRoundRect;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Layout2: TLayout;
    rectAcessar: TRoundRect;
    Label4: TLabel;
    Label5: TLabel;
    RoundRect3: TRoundRect;
    RoundRect4: TRoundRect;
    layoutConta: TLayout;
    layoutContaCampos: TLayout;
    layoutContaTexto: TLayout;
    Layout6: TLayout;
    RoundRect10: TRoundRect;
    Label9: TLabel;
    Label10: TLabel;
    RoundRect7: TRoundRect;
    RoundRect8: TRoundRect;
    RoundRect9: TRoundRect;
    Layout4: TLayout;
    btnFazerLogin: TRoundRect;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    imgLogin: TImage;
    imgConta: TImage;
    procedure AnimationCircleFinish(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure PosicionaObjetos;
    procedure Animar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

procedure TFrmLogin.Animar;
begin
    TAnimator.AnimateFloat(layoutLogin, 'Opacity', 0, 0.5);
    TAnimator.AnimateFloat(layoutConta, 'Opacity', 0, 0.5);
    AnimationCircle.Start;
end;

procedure TFrmLogin.AnimationCircleFinish(Sender: TObject);
begin
    layoutLogin.Visible := false;
    layoutConta.Visible := false;

    if AnimationCircle.Inverse then
    begin
        layoutLogin.Visible := true;
        TAnimator.AnimateFloat(layoutLogin, 'Opacity', 1, 0.5);
    end
    else
    begin
        layoutConta.Visible := true;
        TAnimator.AnimateFloat(layoutConta, 'Opacity', 1, 0.5);
    end;

    AnimationCircle.Inverse := NOT AnimationCircle.Inverse;
end;

procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
begin
    Animar;
end;

procedure TFrmLogin.FormResize(Sender: TObject);
begin
    PosicionaObjetos;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
    AnimationCircle.Inverse := false;
    Animar;
end;

procedure TFrmLogin.PosicionaObjetos;
begin
    // Paisagem...
    if layoutCircle.Width >= layoutCircle.Height then
    begin
        circle.Width := layoutCircle.Width * 1.5;
        circle.Height := circle.Width;
        circle.Margins.Bottom := circle.Width * 0.30;

        AnimationCircle.PropertyName := 'Margins.Right';
        AnimationCircle.StartValue := circle.Width;
        AnimationCircle.StopValue := -circle.Width;

        if NOT AnimationCircle.Inverse then
            circle.Margins.Right := AnimationCircle.StartValue
        else
            circle.Margins.Right := AnimationCircle.StopValue;

        layoutLoginTexto.Align := TAlignLayout.Left;
        layoutLoginTexto.Width := layoutCircle.Width / 2;

        layoutLoginCampos.Width := layoutCircle.Width / 2;
        layoutLoginCampos.Align := TAlignLayout.Right;

        layoutContaTexto.Align := TAlignLayout.Right;
        layoutContaTexto.Width := layoutCircle.Width / 2;

        layoutContaCampos.Width := layoutCircle.Width / 2;
        layoutCOntaCampos.Align := TAlignLayout.Left;

        imgLogin.Height := layoutCircle.Height * 0.40;
        imgConta.Height := layoutCircle.Height * 0.40;

        imgLogin.Visible := true;
        imgConta.Visible := true;
    end
    else
    // Retrato...
    begin
        circle.Height := layoutCircle.Height * 1.5;
        circle.Width := circle.Height;
        circle.Margins.Right := 0;

        AnimationCircle.PropertyName := 'Margins.Bottom';
        AnimationCircle.StartValue := circle.Width * 1.20;
        AnimationCircle.StopValue := -circle.Width * 1.20;

        if NOT AnimationCircle.Inverse then
            circle.Margins.Bottom := circle.Width * 1.20
        else
            circle.Margins.Bottom := -circle.Width * 1.20;

        layoutLoginTexto.Align := TAlignLayout.Top;
        layoutLoginTexto.Height := 200;

        layoutLoginCampos.Align := TAlignLayout.Client;

        layoutContaTexto.Align := TAlignLayout.Bottom;
        layoutContaTexto.Height := 200;

        layoutContaCampos.Align := TAlignLayout.Client;

        imgLogin.Visible := false;
        imgConta.Visible := false;
    end;

end;

end.
