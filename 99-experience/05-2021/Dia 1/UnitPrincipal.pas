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
    layout_aba1: TLayout;
    img_aba1: TImage;
    layout_aba2: TLayout;
    layout_aba3: TLayout;
    img_aba3: TImage;
    layout_aba4: TLayout;
    img_aba4: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    img_aba2: TImage;
    img_selecao: TImage;
    AnimationAba: TFloatAnimation;
    procedure layout_aba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure SelecionarAba(lyt: TLayout);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.SelecionarAba(lyt: TLayout);
var
    x : integer;
    img : TImage;
begin
    // Reset nas configuracoes dos 4 icones...
    for x := 1 to 4 do
    begin
        with TImage(FrmPrincipal.FindComponent('img_aba' + x.ToString)) do
        begin
            Margins.Bottom := 0;
            Height := 30;
            Width := 30;
            Opacity := 0.6;
        end;
    end;

    // Mover marcador de selecao...
    AnimationAba.Tag := lyt.Tag;
    AnimationAba.StopValue := lyt.Position.X + (lyt.Width/2) - (img_selecao.Width/2);
    AnimationAba.Start;

    // Mobe Tabcontrol...
    TabControl.GotoVisibleTab(lyt.Tag - 1, TTabTransition.Slide);

    // Configurar as propriedades da imagem selecionada...
    img := TImage(FrmPrincipal.FindComponent('img_aba' + lyt.Tag.ToString));
    with img do
    begin
        Margins.Bottom := 17;
        //Height := 40;
        //Width := 40;
        TAnimator.AnimateFloat(img, 'Height', 40, 0.4, TAnimationType.Out, TInterpolationType.elastic);
        TAnimator.AnimateFloat(img, 'Width', 40, 0.4, TAnimationType.Out, TInterpolationType.elastic);
        Opacity := 1;
    end;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
var
    lyt : TLayout;
begin
    lyt := TLayout(FrmPrincipal.FindComponent('layout_aba' + AnimationAba.Tag.ToString));
    img_selecao.Position.X := lyt.Position.X + (lyt.Width/2) - (img_selecao.Width/2);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    SelecionarAba(layout_aba1);
end;

procedure TFrmPrincipal.layout_aba1Click(Sender: TObject);
begin
    SelecionarAba(TLayout(Sender));
end;

end.
