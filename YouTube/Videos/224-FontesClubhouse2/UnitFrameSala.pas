unit UnitFrameSala;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFrameSala = class(TFrame)
    rect_fundo_sala: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Layout2: TLayout;
    Rectangle5: TRectangle;
    Rectangle4: TRectangle;
    Label3: TLabel;
    Image2: TImage;
    Label4: TLabel;
    Image3: TImage;
    Label5: TLabel;
    Image4: TImage;
    Label6: TLabel;
    Image5: TImage;
    Label7: TLabel;
    Image6: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
