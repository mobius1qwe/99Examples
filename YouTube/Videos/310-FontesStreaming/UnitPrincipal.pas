unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, FMX.TextLayout, System.Net.HttpClientComponent, System.Net.HttpClient,
  uLoading, UnitVideo;

type
  TFrmPrincipal = class(TForm)
    Label1: TLabel;
    Rectangle1: TRectangle;
    lvVideos: TListView;
    procedure lvVideosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormShow(Sender: TObject);
    procedure lvVideosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure ListarVideos;
    procedure AddVideoListview(id_video, descricao, url_foto: string;
                                         plataforma: TPlataformaVideo);
    procedure LayoutListview(AItem: TListViewItem);
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
    procedure ThreadTerminate(Sender: TObject);
    procedure LoadImageFromURL(img: TBitmap; url: string);
    procedure DownloadFotoListview(lv: TListview; obj_foto: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.LoadImageFromURL(img: TBitmap; url: string);
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    try
        try
            http := TNetHTTPClient.Create(nil);
            vStream :=  TMemoryStream.Create;

            if (Pos('https', LowerCase(url)) > 0) then
                  HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                            THTTPSecureProtocol.TLS11,
                                            THTTPSecureProtocol.TLS12];

            http.Get(url, vStream);
            vStream.Position  :=  0;


            img.LoadFromStream(vStream);
        except
        end;

    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;
end;

procedure TFrmPrincipal.DownloadFotoListview(lv: TListview; obj_foto: string);
var
    t: TThread;
    foto: TBitmap;
    img: TListItemImage;
    url: string;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := 0 to lv.Items.Count - 1 do
        begin
            //sleep(2000);
            img := TListItemImage(lv.Items[i].Objects.FindDrawable(obj_foto));
            url := img.TagString;

            if (url <> '') then
            begin
                img.TagString := '';

                foto := TBitmap.Create;
                LoadImageFromURL(foto, url);

                TThread.Synchronize(TThread.CurrentThread, procedure
                begin
                    img.Bitmap := foto;
                    img.OwnsBitmap := true;
                end);
            end;
        end;

    end);

    t.Start;
end;

function TFrmPrincipal.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    Result := Round(Layout.Height);
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrmPrincipal.LayoutListview(AItem: TListViewItem);
var
    txt: TListItemText;
    img: TListItemImage;
    proporcao: double;
begin
    img := AItem.Objects.FindDrawable('imgVideo') as TListItemImage;
    txt := AItem.Objects.FindDrawable('txtTitulo') as TListItemText;


    // Ajusta dimensoes da imagem (mantendo proporcao)...
    proporcao := 1080 / 1920; // 0.5625
    img.PlaceOffset.X := 0;
    img.PlaceOffset.Y := 0;
    img.Width := lvVideos.Width;
    img.Height := img.Width * proporcao;


    // Ajusta posicao do texto
    txt.Width := lvVideos.Width - 20;
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 5;
    txt.PlaceOffset.Y := img.PlaceOffset.Y + img.Height + 3;


    // Calcula a altura do item da LV...
    AItem.Height := Trunc(txt.PlaceOffset.Y + txt.Height);
end;

procedure TFrmPrincipal.AddVideoListview(id_video, descricao, url_foto: string;
                                         plataforma: TPlataformaVideo);
var
    item: TListViewItem;
begin
    item := lvVideos.Items.Add;

    with item do
    begin
        Height := 150;
        TagString := id_video;

        if plataforma = TPlataformaVideo.YouTube then
            tag := 1
        else
            tag := 2;

        TListItemImage(Objects.FindDrawable('imgVideo')).TagString := url_foto;
        TListItemText(Objects.FindDrawable('txtTitulo')).Text := descricao;
    end;

    LayoutListview(item);
end;

procedure TFrmPrincipal.ThreadTerminate(Sender: TObject);
begin
    TLoading.Hide;
    lvVideos.EndUpdate;

    DownloadFotoListview(lvVideos, 'imgVideo');
end;

procedure TFrmPrincipal.ListarVideos;
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    lvVideos.ScrollTo(0);
    lvVideos.BeginUpdate;
    lvVideos.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    var
        i: integer;
    begin
        sleep(1000); // Simula request ao servidor...

        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            AddVideoListview('beoi6MdjIso', 'Como carregar vídeos dentro de suas aplicações Delphi',
                             'https://live-produtos.s3.amazonaws.com/video-no-app.png',
                             YouTube);

            AddVideoListview('ZVrTxYTULgw', 'Programação Web - Introdução ao React',
                             'https://live-produtos.s3.amazonaws.com/programacao-web.png',
                             YouTube);

            AddVideoListview('vxIj5KepGGY', 'SQLite: Banco de dados mobile com Delphi (criptografia e boas práticas)',
                             'https://live-produtos.s3.amazonaws.com/banco-de-dados.png',
                             YouTube);

            AddVideoListview('rodeR12N9Nk', 'Delphi Mobile - Trabalhando com gestos em seus apps',
                             'https://live-produtos.s3.amazonaws.com/gestos.png',
                             YouTube);

            AddVideoListview('429366855', 'SQLite: Banco de dados mobile com Delphi (criptografia e boas práticas)',
                             'https://live-produtos.s3.amazonaws.com/vimeo.png',
                             Vimeo);

        end);
    end);

    t.OnTerminate := ThreadTerminate;
    t.Start;
end;

procedure TFrmPrincipal.lvVideosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmVideo) then
        Application.CreateForm(TFrmVideo, FrmVideo);

    if AItem.Tag = 1 then
        FrmVideo.plataforma := TPlataformaVideo.YouTube
    else
        FrmVideo.plataforma := TPlataformaVideo.Vimeo;

    FrmVideo.codVideo := AItem.TagString;
    FrmVideo.titulo := TListItemText(AItem.Objects.FindDrawable('txtTitulo')).Text;
    FrmVideo.Show;
end;

procedure TFrmPrincipal.lvVideosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    LayoutListview(AItem);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarVideos;
end;

end.
