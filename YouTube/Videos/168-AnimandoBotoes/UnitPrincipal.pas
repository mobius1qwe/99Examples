unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Ani;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    rect_processar: TRectangle;
    img_processar: TImage;
    lbl_processar: TLabel;
    AnimeProcessar: TFloatAnimation;
    Layout2: TLayout;
    rect_pdf: TRectangle;
    img_icone: TImage;
    AnimePDF: TFloatAnimation;
    lbl_pdf: TLabel;
    img_pdf: TImage;
    Layout3: TLayout;
    rect_enviar: TRectangle;
    img_enviar: TImage;
    AnimeEnviar: TFloatAnimation;
    lbl_enviar: TLabel;
    Layout4: TLayout;
    procedure rect_processarClick(Sender: TObject);
    procedure rect_pdfClick(Sender: TObject);
    procedure rect_enviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure StartButtonAnimation(rectButton: TRectangle;
                               lbl: TLabel; text: string;
                               icon: TImage;
                               animation: TFloatAnimation);
begin
    icon.Visible := true;
    animation.Start;

    rectButton.Opacity := 0.99;
    rectButton.Enabled := false;

    lbl.TagString := lbl.Text;
    lbl.Text := text;
end;

procedure StopButtonAnimation(rectButton: TRectangle;
                              lbl: TLabel;
                              icon: TImage;
                              animation: TFloatAnimation;
                              hideIcon: Boolean);
begin
    if lbl.TagString <> '' then
        lbl.Text := lbl.TagString;

    rectButton.Opacity := 1;
    rectButton.Enabled := true;

    icon.Visible := NOT hideIcon;
    animation.Stop;
end;

procedure TForm1.rect_enviarClick(Sender: TObject);
begin
    StartButtonAnimation(rect_enviar, lbl_enviar, 'Enviando...',
                         img_enviar, AnimeEnviar);

    TThread.CreateAnonymousThread(procedure
    begin
        sleep(5000); // Acesso a banco... acesso WS... etc

        TThread.Synchronize(nil, procedure
        begin
            StopButtonAnimation(rect_enviar, lbl_enviar, img_enviar,
                                AnimeEnviar, true);
        end);

    end).Start;
end;

procedure TForm1.rect_pdfClick(Sender: TObject);
begin
    StartButtonAnimation(rect_pdf, lbl_pdf, 'Gerando...',
                         img_pdf, AnimePDF);

    TThread.CreateAnonymousThread(procedure
    begin
        sleep(5000); // Acesso a banco... acesso WS... etc

        TThread.Synchronize(nil, procedure
        begin
            StopButtonAnimation(rect_pdf, lbl_pdf, img_pdf,
                                AnimePDF, true);
        end);

    end).Start;
end;

procedure TForm1.rect_processarClick(Sender: TObject);
begin
    StartButtonAnimation(rect_processar, lbl_processar, 'Aguarde...',
                         img_processar, AnimeProcessar);

    TThread.CreateAnonymousThread(procedure
    begin
        sleep(5000); // Acesso a banco... acesso WS... etc

        TThread.Synchronize(nil, procedure
        begin
            StopButtonAnimation(rect_processar, lbl_processar, img_processar,
                                AnimeProcessar, false);
        end);

    end).Start;

end;

end.
