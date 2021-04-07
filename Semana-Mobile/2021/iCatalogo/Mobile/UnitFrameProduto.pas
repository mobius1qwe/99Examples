unit UnitFrameProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameProduto = class(TFrame)
    Image1: TImage;
    img_foto: TImage;
    lbl_nome: TLabel;
    lbl_preco: TLabel;
    lbl_promocao: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
