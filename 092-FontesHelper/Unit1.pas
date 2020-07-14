unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TEditHelper = class helper for TEdit
  private
  public
    function Reverse : String;
    function SomenteNumero : String;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


{ TEditHelper }

function TEditHelper.Reverse: String;
var
    x : integer;
begin
    for x := Length(Self.Text) downto 1 do
        Result := Result + Copy(Self.Text, x, 1);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Edit2.Text := Edit1.SomenteNumero;
end;

function TEditHelper.SomenteNumero: String;
var
    x : integer;
begin
    for x := 1 to Length(self.Text) do
        if (Copy(self.Text, x, 1) >= '0') and (Copy(self.Text, x, 1) <= '9') then
            Result := Result  + Copy(self.Text, x, 1);

end;

end.
