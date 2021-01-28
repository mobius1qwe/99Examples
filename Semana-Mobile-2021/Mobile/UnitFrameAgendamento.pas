unit UnitFrameAgendamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFrameAgendamento = class(TFrame)
    lbl_servico: TLabel;
    lbl_nome: TLabel;
    Layout1: TLayout;
    Image1: TImage;
    lbl_data: TLabel;
    lbl_hora: TLabel;
    Image2: TImage;
    Image3: TImage;
    lbl_valor: TLabel;
    Layout2: TLayout;
    Image4: TImage;
    lbl_endereco: TLabel;
    Layout3: TLayout;
    rect_excluir: TRectangle;
    Label7: TLabel;
    Line1: TLine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
