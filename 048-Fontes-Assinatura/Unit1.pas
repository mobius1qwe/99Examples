unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    img_assinar: TImage;
    img_assinatura: TImage;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Label1: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Layout2: TLayout;
    Label4: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Rectangle4: TRectangle;
    Layout3: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Rectangle5: TRectangle;
    Layout4: TLayout;
    Label8: TLabel;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Rectangle6: TRectangle;
    Layout5: TLayout;
    Label9: TLabel;
    Label11: TLabel;
    Rectangle7: TRectangle;
    Layout6: TLayout;
    Label10: TLabel;
    Label12: TLabel;
    Rectangle8: TRectangle;
    Layout7: TLayout;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    procedure img_assinarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Unit2;


procedure TForm1.img_assinarClick(Sender: TObject);
begin
        form2.Show;
end;

end.
