unit Form_Editor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.Effects, FMX.Filter.Effects, FMX.ExtCtrls;

type
  TFrm_Editor = class(TForm)
    scroll_efeitos: THorzScrollBox;
    Layout1: TLayout;
    img_efeito2: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    img_efeito1: TImage;
    Label2: TLabel;
    InvertEffect1: TInvertEffect;
    Layout3: TLayout;
    img_efeito8: TImage;
    Label3: TLabel;
    Layout4: TLayout;
    img_efeito7: TImage;
    Label4: TLabel;
    Layout5: TLayout;
    img_efeito6: TImage;
    Label5: TLabel;
    Layout6: TLayout;
    img_efeito5: TImage;
    Label6: TLabel;
    Layout7: TLayout;
    img_efeito4: TImage;
    Label7: TLabel;
    Layout8: TLayout;
    img_efeito3: TImage;
    Label8: TLabel;
    HueAdjustEffect1: THueAdjustEffect;
    MonochromeEffect1: TMonochromeEffect;
    ContrastEffect1: TContrastEffect;
    RadialBlurEffect1: TRadialBlurEffect;
    PixelateEffect1: TPixelateEffect;
    ToonEffect1: TToonEffect;
    Rectangle1: TRectangle;
    layout_edit: TLayout;
    img_rotate: TImage;
    track_zoom: TTrackBar;
    RoundRect1: TRoundRect;
    lbl_botao: TLabel;
    img_fechar: TImage;
    rect_foto: TRectangle;
    Layout10: TLayout;
    ImageViewer1: TImageViewer;
    rect_voltar: TRoundRect;
    Label10: TLabel;
    InvertEffect2: TInvertEffect;
    HueAdjustEffect2: THueAdjustEffect;
    MonochromeEffect2: TMonochromeEffect;
    ContrastEffect2: TContrastEffect;
    RadialBlurEffect2: TRadialBlurEffect;
    PixelateEffect2: TPixelateEffect;
    ToonEffect2: TToonEffect;
    procedure FormShow(Sender: TObject);
    procedure img_fecharClick(Sender: TObject);
    procedure img_efeito1Click(Sender: TObject);
    procedure img_rotateClick(Sender: TObject);
    procedure rect_voltarClick(Sender: TObject);
    procedure RoundRect1Click(Sender: TObject);
    procedure track_zoomChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    imagem : TBitmap;
    ind_cancelar : boolean;
  end;

var
  Frm_Editor: TFrm_Editor;

implementation

{$R *.fmx}

procedure Aplicar_Efeito(img : TImage);
begin
        with  Frm_Editor do
        begin
                InvertEffect2.Enabled := img.Tag = 2;
                HueAdjustEffect2.Enabled := img.Tag = 3;
                MonochromeEffect2.Enabled := img.Tag = 4;
                ContrastEffect2.Enabled := img.Tag = 5;
                RadialBlurEffect2.Enabled := img.Tag = 6;
                PixelateEffect2.Enabled := img.Tag = 7;
                ToonEffect2.Enabled := img.Tag = 8;
        end;
end;

procedure Setup_Pagina(pg : integer);
begin
        with Frm_Editor do
        begin
                if pg = 1 then
                        lbl_botao.text := 'Avançar'
                else
                        lbl_botao.text := 'Salvar';

                layout_edit.Visible := pg = 1;
                scroll_efeitos.Visible := pg = 2;
                rect_voltar.Visible := pg = 2;
                img_fechar.Visible := pg = 1;
                ImageViewer1.DisableMouseWheel := pg = 2;
                ImageViewer1.HitTest := pg = 1;
        end;
end;

procedure Reset_Imagem();
begin
        with Frm_Editor do
        begin
                Setup_Pagina(1);

                track_zoom.Value := 1;
                ImageViewer1.BitmapScale := 1;
                ImageViewer1.BestFit;

                Aplicar_Efeito(img_efeito1);
        end;
end;

procedure Preview_Efeitos();
var
        foto : TBitmap;
begin
        with Frm_Editor do
        begin
                foto := Layout10.MakeScreenshot;

                img_efeito1.Bitmap := foto;
                img_efeito2.Bitmap := foto;
                img_efeito3.Bitmap := foto;
                img_efeito4.Bitmap := foto;
                img_efeito5.Bitmap := foto;
                img_efeito6.Bitmap := foto;
                img_efeito7.Bitmap := foto;
                img_efeito8.Bitmap := foto;
        end;
end;

procedure TFrm_Editor.FormShow(Sender: TObject);
begin
        ImageViewer1.Bitmap.Assign(imagem);
        Reset_Imagem();
        ind_cancelar := true;

        TThread.CreateAnonymousThread(procedure
        begin
                sleep(300);
                Preview_Efeitos();
        end).Start;

end;

procedure TFrm_Editor.img_efeito1Click(Sender: TObject);
begin
        Aplicar_Efeito(TImage(Sender));
end;

procedure TFrm_Editor.img_fecharClick(Sender: TObject);
begin
        ind_cancelar := true;
        close;
end;

procedure TFrm_Editor.img_rotateClick(Sender: TObject);
begin
        ImageViewer1.Bitmap.Rotate(-90);
end;

procedure TFrm_Editor.rect_voltarClick(Sender: TObject);
begin
        Setup_Pagina(1);
end;

procedure TFrm_Editor.RoundRect1Click(Sender: TObject);
begin
        if lbl_botao.Text = 'Avançar' then
                Setup_Pagina(2)
        else
        begin
                ind_cancelar := false;
                imagem := Layout10.MakeScreenshot;

                close;
        end;
end;

procedure TFrm_Editor.track_zoomChange(Sender: TObject);
begin
        ImageViewer1.BitmapScale := track_zoom.Value;
end;

end.
