unit UnitVideo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TPlataformaVideo = (YouTube, Vimeo);

  TFrmVideo = class(TForm)
    WebBrowser1: TWebBrowser;
    lblTitulo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FTitulo: string;
    FPlataforma: TPlataformaVideo;
    FCod_video: string;
    procedure LoadVideoVimeo(browser: TWebBrowser; codVideo: string;
      autoplay: boolean);
    procedure LoadVideoYoutube(browser: TWebBrowser; codVideo: string);
    procedure AjustarTamanhoVideo(browser: TWebBrowser);
    { Private declarations }
  public
    property codVideo: string read FCod_video write FCod_video;
    property titulo: string read FTitulo write FTitulo;
    property plataforma: TPlataformaVideo read FPlataforma write FPlataforma;
  end;

var
  FrmVideo: TFrmVideo;

const
  PROPORCAO = 0.5625;  // 1920x1080  (1080 dividido por 1920)

implementation

{$R *.fmx}

procedure TFrmVideo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    WebBrowser1.Stop;
    Action := TCloseAction.caFree;
    FrmVideo := nil;
end;

procedure TFrmVideo.FormResize(Sender: TObject);
begin
    AjustarTamanhoVideo(WebBrowser1);
end;

procedure TFrmVideo.AjustarTamanhoVideo(browser: TWebBrowser);
var
    w, h: integer;
begin
    w := Trunc(browser.width - 30);
    h := Trunc(w * PROPORCAO) + 10;

    browser.Height := h;
end;

procedure TFrmVideo.LoadVideoYoutube(browser: TWebBrowser; codVideo: string);
var
    html: string;
begin
    html := '<!DOCTYPE html>' +
      '<html>' +
      '<head>' +
      '<style>' +
      '.container {position: relative; overflow: hidden; width: 100%; padding-top: 56.25%;} ' +
      '.responsive-iframe {position: absolute; top: 0; left: 0; bottom: 0; right: 0; width: 100%; height: 100%;} ' +
      '</style>' +
      '<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>' + // compatibility mode
      '</head>' +
      '<body style="margin:0;height: 100%; overflow: hidden">' +
      '<iframe class="responsive-iframe"  ' +
      'src="https://www.youtube.com/embed/' + codVideo +
      '?controls=0' +
      ' frameborder="0" ' +
      ' autoplay=1&rel=0&controls=0&showinfo=0" ' +
      ' allow="autoplay" frameborder="0">' +
      '</iframe>' +
       '</body>' +
      '</html>';

    AjustarTamanhoVideo(browser);
    browser.LoadFromStrings(html, '');
end;

procedure TFrmVideo.LoadVideoVimeo(browser: TWebBrowser; codVideo: string; autoplay: boolean);
var
    html: string;
    play: string;
begin
    if autoplay then play := '1' else play := '0';


    html := '<!DOCTYPE html>' +
      '<html>' +
      '<head>' +
      '<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>' +
      '</head>' +
      '<body style="margin:0;height: 100%; overflow: hidden">' +

      '<div style="padding:56.25% 0 0 0;position:relative;">' +
      '<iframe  src="https://player.vimeo.com/video/' + codVideo + '?h=3ca13aab9d&autoplay=' +  play + '&title=0&byline=0&portrait=0" ' +
      'style="position:absolute;top:0;left:0;width:100%;height:100%;" ' +
      'frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen>' +
      '</iframe>' +
      '</div>' +
      '<script src="https://player.vimeo.com/api/player.js"></script>' +

       '</body>' +
      '</html>';

    AjustarTamanhoVideo(browser);
    browser.LoadFromStrings(html, '');
end;

procedure TFrmVideo.FormShow(Sender: TObject);
begin
    lblTitulo.Text := titulo;

    if plataforma = YouTube then
        LoadVideoYouTube(WebBrowser1, codVideo)
    else
        LoadVideoVimeo(WebBrowser1, codVideo, false);
end;

end.

