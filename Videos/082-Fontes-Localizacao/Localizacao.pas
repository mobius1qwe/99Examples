unit Localizacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Maps, FMX.Objects, FMX.Edit,
  FMX.Ani;

type
  TForm1 = class(TForm)
    MapView1: TMapView;
    SpeedButton1: TSpeedButton;
    p_endereco: TPanel;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Image1: TImage;
    p_menu: TPanel;
    Rectangle2: TRectangle;
    img_normal: TImage;
    img_satelite: TImage;
    FloatAnimation1: TFloatAnimation;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
var
        posicao : TMapCoordinate;
begin
        MapView1.MapType := TMapType.Normal;

        // Centralizar o mapa...
        posicao.Latitude := -23.548094;
        posicao.Longitude := -46.635063;
        MapView1.Location := posicao;

        // Zoom...
        MapView1.Zoom := 11;

        // Animacao do menu...
        FloatAnimation1.StartValue := MapView1.Height + 160;
        FloatAnimation1.StopValue := MapView1.Height - 150;
        p_menu.Position.X := 0;
        p_menu.Position.Y := MapView1.Height + 160;
        p_menu.Width := MapView1.Width;


        // Barra de busca...
        p_endereco.Position.X := 10;
        p_endereco.Position.Y := 60;
        p_endereco.Width := MapView1.Width - 20;

end;

procedure TForm1.Image1Click(Sender: TObject);
var
        posicao : TMapCoordinate;
        marcador : TMapMarkerDescriptor;
begin
        posicao.Latitude := -23.548094;
        posicao.Longitude := -46.635063;

        marcador := TMapMarkerDescriptor.Create(posicao, 'Citroen C3');
        marcador.Snippet := 'Placa: ABC-1234';
        //marcador.Icon :=...

        marcador.Draggable := true;
        marcador.Visible := true;

        MapView1.AddMarker(marcador);
end;

end.
