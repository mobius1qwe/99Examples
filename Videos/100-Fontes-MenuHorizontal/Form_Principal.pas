unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  uHorizontalMenu, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  System.Actions, FMX.ActnList;

type
  TForm1 = class(TForm)
    HorzScrollBox: THorzScrollBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    Rectangle1: TRectangle;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Image2: TImage;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    SpeedButton4: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);

    {$IFDEF MSWINDOWS}
    procedure ClickItem(Sender: TObject);
    {$ELSE}
    procedure ClickItem(Sender: TObject; const Point: TPointF);
    {$ENDIF}

    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }
    h : THorizontalMenu;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{$IFDEF MSWINDOWS}
procedure TForm1.ClickItem(Sender: TObject);
var
    cod_item : string;
begin
    cod_item := TLayout(Sender).TagString;

    showmessage('Abrir detalhes categoria ' + cod_item);
end;
{$ELSE}
procedure TForm1.ClickItem(Sender: TObject; const Point: TPointF);
var
    cod_item : string;
begin
    cod_item := TLayout(Sender).TagString;

    showmessage('Abrir detalhes categoria ' + cod_item);
end;
{$ENDIF}


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    h.DisposeOf;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    x : integer;
    json : string;
begin
    h := THorizontalMenu.Create(HorzScrollBox);
    h.MarginPadrao := 10;

    try
            json := '[{"codItem":"123", "urlImage":"https://99xp.s3.amazonaws.com/icone-brasileira.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Brasileira"},';
            json := json + '{"codItem":"456", "urlImage":"https://99xp.s3.amazonaws.com/icone-mercado.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Mercado"},';
            json := json + '{"codItem":"789", "urlImage":"https://99xp.s3.amazonaws.com/icone-saudavel.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Saudável"},';
            json := json + '{"codItem":"001", "urlImage":"https://99xp.s3.amazonaws.com/icone-pastel.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Pastel"},';
            json := json + '{"codItem":"002", "urlImage":"https://99xp.s3.amazonaws.com/icone-salgados.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Salgados"},';
            json := json + '{"codItem":"003", "urlImage":"https://99xp.s3.amazonaws.com/icone-doces.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Doces"}]';
            h.LoadFromJSON(json, ClickItem);
    finally
    end;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
    h.DeleteAll;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
    h.AddItem(Random(9999).tostring,
              image1.Bitmap,
              '', // URL
              110,
              $FFCCCCCC,
              6,
              $FF6E6E6E,
              'Saudável',
              ClickItem);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
var
    json : string;
begin
    json := '[{"codItem":"789", "urlImage":"https://99xp.s3.amazonaws.com/icone-saudavel.png", "itemWidth":"110", "bgColor":"$FF008000", "borderRadius":"6", "fontColor":"$FF000000", "itemText":"Saudável"}]';
    h.LoadFromJSON(json, ClickItem);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
    h.LoadFromWS('http://files.99coders.com.br/get-json.html', ClickItem);

end;

end.
