unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TForm2 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    btn_salvar: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure btn_salvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses Loading;

procedure TForm2.btn_salvarClick(Sender: TObject);
begin
        TLoading.Show(Form2, 'Salvando os dados...');


        TThread.CreateAnonymousThread(procedure
        begin
                sleep(5000);
                // Salvando os dados do cliente na base...


                TThread.Synchronize(nil, procedure
                begin
                        TLoading.Hide;
                        form2.Close;
                end);

        end).Start;
end;

end.
