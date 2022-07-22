unit Frame.Cliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TFrameCliente = class(TFrame)
    rectFundo: TRectangle;
    imgFoto: TImage;
    imgEditar: TImage;
    Layout1: TLayout;
    lblCidade: TLabel;
    lblNome: TLabel;
    imgDelete: TImage;
  private
    FId_cliente: integer;
    FNome: string;
    { Private declarations }
  public
    property id_cliente: integer read FId_cliente write FId_cliente;
    property nome: string read FNome write FNome;
  end;

implementation

{$R *.fmx}

end.
