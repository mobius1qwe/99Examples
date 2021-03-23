unit UnitCompromissoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFrameCompromisso = class(TFrame)
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Layout3: TLayout;
    lbl_descricao: TLabel;
    lbl_data: TLabel;
    Layout4: TLayout;
    lbl_usuario: TLabel;
    Layout1: TLayout;
    lbl_hora: TLabel;
    Image1: TImage;
    lbl_qtd: TLabel;
    img_concluido: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
