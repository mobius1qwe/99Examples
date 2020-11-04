unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.StdCtrls, FMX.Ani;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Layout1: TLayout;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    FloatAnimation1: TFloatAnimation;
    procedure Edit4Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Edit4Exit(Sender: TObject);
begin
        // Esconde os campos...
         Layout1.Visible := false;
         Image2.Visible := false;

         // Exibe a mensagem...
         Label5.Opacity := 0;
         Label5.Visible := true;
         FloatAnimation1.Start;
end;

end.
