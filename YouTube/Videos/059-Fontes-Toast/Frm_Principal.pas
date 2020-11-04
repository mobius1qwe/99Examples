unit Frm_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.Media, System.IOUtils;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Layout2: TLayout;
    Label2: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    img_produto: TImage;
    Layout4: TLayout;
    rect_cor1: TRectangle;
    rect_cor2: TRectangle;
    rect_cor3: TRectangle;
    rect_cor4: TRectangle;
    Layout5: TLayout;
    rect_carrinho: TRectangle;
    lbl_botao: TLabel;
    circle_cor: TCircle;
    Layout6: TLayout;
    img1: TImage;
    img2: TImage;
    img4: TImage;
    img3: TImage;
    Line1: TLine;
    MediaPlayer: TMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure rect_cor1Click(Sender: TObject);
    procedure rect_carrinhoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Notificacao;

procedure SetupSound();
var
        arq : string;
begin
        with form1 do
        begin
                {$IFDEF IOS}
                arq := TPath.Combine(TPath.GetDocumentsPath, 'success.wav');
                {$ENDIF}

                {$IFDEF ANDROID}
                arq := TPath.Combine(TPath.GetDocumentsPath, 'success.wav');
                {$ENDIF}

                {$IFDEF MSWINDOWS}
                arq := 'D:\99Coders\Posts\59 - Mensagens Toast no Delphi --------\Fontes\Sounds\success.wav';
                {$ENDIF}

                MediaPlayer.Clear;
                MediaPlayer.FileName := arq;
        end;
end;

procedure PlaySound();
begin
        with form1 do
        begin
                if MediaPlayer.State = TMediaState.Playing then
                        MediaPlayer.Stop;

                if MediaPlayer.Media <> nil then
                        MediaPlayer.Play;
        end;
end;

procedure Seleciona_Cor(rect_cor : TRectangle);
begin
        with Form1 do
        begin
                // Anima a selecao...
                circle_cor.AnimateFloat('Position.X',
                                        rect_cor.Position.X + 17,
                                        0.4,
                                        TAnimationType.&In,
                                        TInterpolationType.Circular);

                // Fade out cadeira...
                img_produto.AnimateFloat('Opacity', 0, 0.2);

                TThread.CreateAnonymousThread(procedure
                begin
                        sleep(300);

                        case rect_cor.Tag of
                          1: img_produto.Bitmap := img1.Bitmap;
                          2: img_produto.Bitmap := img2.Bitmap;
                          3: img_produto.Bitmap := img3.Bitmap;
                          4: img_produto.Bitmap := img4.Bitmap;
                        end;

                        // Fade in cadeira...
                        img_produto.AnimateFloat('Opacity', 1, 0.2);
                end).Start;


        end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        img1.Visible := false;
        img2.Visible := false;
        img3.Visible := false;
        img4.Visible := false;

        SetupSound();
end;

procedure TForm1.rect_carrinhoClick(Sender: TObject);
begin
        lbl_botao.Text := 'Adicionando...';
        TLoading.Show(Form1, '');

        TThread.CreateAnonymousThread(procedure
        begin
                sleep(3000); // Acesso ao banco... acesso WS...

                TThread.Synchronize(nil, procedure
                begin
                        lbl_botao.Text := 'Adicionar ao carrinho';
                        TLoading.Hide;

                        TLoading.ToastMessage(Form1,
                                              'Adicionado com sucesso',
                                              TAlignLayout.Top);

                        {$IFDEF MSWINDOWS}
                        SetupSound();
                        {$ENDIF}

                        PlaySound();
                end);

        end).Start;
end;

procedure TForm1.rect_cor1Click(Sender: TObject);
begin
        Seleciona_Cor(TRectangle(Sender));
end;

end.
