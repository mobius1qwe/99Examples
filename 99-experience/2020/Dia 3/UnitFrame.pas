unit UnitFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TTipoItem = (Password = 1, Card = 2, Note = 3);

  TFrmFrame = class(TFrame)
    Rectangle8: TRectangle;
    img_icone: TImage;
    Line9: TLine;
    lbl_titulo: TLabel;
    lbl_subtitulo: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
