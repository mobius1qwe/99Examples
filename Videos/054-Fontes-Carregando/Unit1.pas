unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    btn_menu: TSpeedButton;
    rect_botao: TRoundRect;
    Label10: TLabel;
    procedure rect_botaoClick(Sender: TObject);
    procedure btn_menuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses Loading, Unit2;

procedure TForm1.btn_menuClick(Sender: TObject);
begin
        form2.show;
end;

procedure TForm1.rect_botaoClick(Sender: TObject);
begin
        //TLoading.Show(Form1, 'Aguarde... Estamos trabalhando na sua requisição. Isso pode demorar alguns segundos...');
        TLoading.Show(Form1, 'Consultando...');


        TThread.CreateAnonymousThread(procedure
        begin
                sleep(5000);
                // Acesso ao banco...
                // Acesso aos WS...
                // Processamento...

                TThread.Synchronize(nil, procedure
                begin
                        TLoading.Hide;
                end);

        end).Start;
end;

end.
