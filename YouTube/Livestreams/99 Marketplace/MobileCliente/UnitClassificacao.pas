unit UnitClassificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TFrmClassificar = class(TForm)
    rect_login: TRectangle;
    Label11: TLabel;
    lbl_titulo: TLabel;
    Layout7: TLayout;
    img1: TImage;
    Img4: TImage;
    Img3: TImage;
    Img2: TImage;
    Img5: TImage;
    img_vazia: TImage;
    img_cheia: TImage;
    procedure img1Click(Sender: TObject);
    procedure rect_loginClick(Sender: TObject);
  private
    avaliacao : integer;
    procedure Avaliar(nota: integer);
    function DesenharEstrela(indCheia: boolean): TBitmap;
  public
    { Public declarations }
  end;

var
  FrmClassificar: TFrmClassificar;

implementation

{$R *.fmx}

function TFrmClassificar.DesenharEstrela(indCheia : boolean): TBitmap;
begin
    if indCheia then
        Result := img_cheia.Bitmap
    else
        Result := img_vazia.Bitmap;
end;

procedure TFrmClassificar.Avaliar(nota: integer);
begin
    avaliacao := nota;
    img1.Bitmap := DesenharEstrela(nota >= 1);
    img2.Bitmap := DesenharEstrela(nota >= 2);
    img3.Bitmap := DesenharEstrela(nota >= 3);
    img4.Bitmap := DesenharEstrela(nota >= 4);
    img5.Bitmap := DesenharEstrela(nota >= 5);
end;

procedure TFrmClassificar.img1Click(Sender: TObject);
begin
    Avaliar(TImage(Sender).Tag);
end;

procedure TFrmClassificar.rect_loginClick(Sender: TObject);
begin
    close;
end;

end.
