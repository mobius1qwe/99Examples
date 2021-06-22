unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    imgRefresh: TImage;
    Label1: TLabel;
    lbl: TLabel;
    Button1: TButton;
    procedure imgRefreshClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    etapa : string;
    t : TThread;
    procedure ThreadEnd(Sender: TObject);
    procedure FimCriacaoForm(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Unit2;

procedure TFrmPrincipal.ThreadEnd(Sender: TObject);
begin
    if Assigned(TThread(Sender).FatalException) then
        showmessage('Erro na etapa: ' + etapa + ' - ' + Exception(TThread(Sender).FatalException).Message);

    //showmessage('Fim da Thread');
end;

procedure TFrmPrincipal.FimCriacaoForm(Sender: TObject);
begin
    if Assigned(TThread(Sender).FatalException) then
        showmessage(Exception(TThread(Sender).FatalException).Message)
    else
    if Assigned(form2) then
        form2.Show;
end;


procedure TFrmPrincipal.Button1Click(Sender: TObject);
var
    t : TThread;
begin
    if NOT Assigned(form2) then
            Application.CreateForm(TForm2, Form2);

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(3000);
    end);

    t.OnTerminate := FimCriacaoForm;
    t.Start;
end;

procedure TFrmPrincipal.imgRefreshClick(Sender: TObject);
begin
    t := TThread.CreateAnonymousThread(procedure
    var
        x : integer;
    begin
        for x := 1 to 5 do
        begin
            sleep(1000);

            etapa := 'Banco';
            // Acesso ao banco... (select * from tab_pedido...)


            etapa := 'API';
            // Request API JSON...


            etapa := 'Função externa';
            //StrToFloat('99Coders');
            // Chamada de funcao externa...

            TThread.Synchronize(nil, procedure
            begin
                lbl.Text := x.ToString;
                //
                //
                //
            end);

            {
            TThread.Queue(nil, procedure
            begin
                lbl.Text := x.ToString;
            end);
            }

        end;
    end);

    //t.FreeOnTerminate := true;
    t.OnTerminate := ThreadEnd;
    t.Start;


end;

end.
