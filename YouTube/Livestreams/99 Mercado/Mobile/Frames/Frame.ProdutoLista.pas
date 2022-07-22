unit Frame.ProdutoLista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFrameProdutoLista = class(TFrame)
    imgFoto: TImage;
    lblDescricao: TLabel;
    lblValor: TLabel;
    Layout1: TLayout;
    lblQtd: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
