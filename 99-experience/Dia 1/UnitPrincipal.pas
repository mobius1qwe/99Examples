unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.TabControl, FMX.Objects, FMX.Ani, System.Actions, FMX.ActnList;

type
  TFrmPrincipal = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    rect_tabs: TRectangle;
    StyleBook1: TStyleBook;
    layout_aba1: TLayout;
    img_aba1: TImage;
    img_aba1_sel: TImage;
    layout_aba2: TLayout;
    img_aba2: TImage;
    img_aba2_sel: TImage;
    layout_aba3: TLayout;
    img_aba3: TImage;
    img_aba3_sel: TImage;
    layout_aba4: TLayout;
    img_aba4: TImage;
    img_aba4_sel: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    img_ball: TImage;
    img_pulso: TImage;
    ActionList1: TActionList;
    ActTab1: TChangeTabAction;
    ActTab2: TChangeTabAction;
    ActTab3: TChangeTabAction;
    ActTab4: TChangeTabAction;
    AnimationBall: TFloatAnimation;
    AnimationPulso: TFloatAnimation;
    AnimationPulsoW: TFloatAnimation;
    procedure layout_aba1Click(Sender: TObject);
    procedure AnimationBallFinish(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure SelecionaAba(lyt: TLayout);
    procedure PaintIcone(aba: integer);
    procedure Pulsar(aba: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.Pulsar(aba : integer);
begin
    img_pulso.SendToBack;
    img_pulso.Parent := TLayout(FrmPrincipal.FindComponent('layout_aba' + aba.ToString));

    AnimationPulso.Start;

    AnimationPulsoW.StopValue := layout_aba1.Width;
    AnimationPulsoW.Start;
end;

procedure TFrmPrincipal.PaintIcone(aba : integer);
begin
    img_ball.Visible := false;

    TImage(FrmPrincipal.FindComponent('img_aba' + aba.ToString)).Visible := false;
    TImage(FrmPrincipal.FindComponent('img_aba' + aba.ToString + '_sel')).Visible := true;
end;

procedure TFrmPrincipal.SelecionaAba(lyt : TLayout);
var
    x : integer;
begin
    // Exibir apenas imagem cinza...
    for x := 1 to 4 do
    begin
        TImage(FrmPrincipal.FindComponent('img_aba' + x.ToString)).Visible := true;
        TImage(FrmPrincipal.FindComponent('img_aba' + x.ToString + '_sel')).Visible := false;
    end;

    // Move a bolinha...
    img_ball.Visible := true;
    AnimationBall.Tag := lyt.Tag; // Guarda a aba selecionada....
    AnimationBall.StopValue := lyt.Position.X + (lyt.Width / 2) - (img_ball.Width / 2);
    AnimationBall.Start;

    // Executar o pulasr...
    Pulsar(lyt.Tag);

    // Mover tabcontrol...
    TChangeTabAction(FrmPrincipal.FindComponent('ActTab' + lyt.tag.ToString)).Execute;
end;

procedure TFrmPrincipal.AnimationBallFinish(Sender: TObject);
begin
    PaintIcone(AnimationBall.Tag);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    SelecionaAba(layout_aba1);
end;

procedure TFrmPrincipal.layout_aba1Click(Sender: TObject);
begin
    SelecionaAba(TLayout(Sender));
end;

end.
