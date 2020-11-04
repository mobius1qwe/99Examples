unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, System.Actions,
  FMX.ActnList, FMX.Layouts;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Button1: TButton;
    ActionList1: TActionList;
    actMudar: TChangeTabAction;
    LayoutDetalhe: TLayout;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FormAtivo : TForm;

implementation

{$R *.fmx}

uses Unit2, Unit3;

Procedure Mudar_Aba(tabItem: TTabItem; sender: TObject);
begin
        with Form1 do
        begin
                actMudar.Tab := tabItem;
                actMudar.ExecuteTarget(sender);
        end;
end;

procedure Abrir_Form(FormClass: TComponentClass);
var
        LayoutPadrao : TComponent;
begin
        if Assigned(FormAtivo) then
        begin
                if FormAtivo.ClassType = FormClass then
                        exit
                else
                begin
                        FormAtivo.DisposeOf;
                        FormAtivo := nil;
                end;
        end;

        Application.CreateForm(FormClass, FormAtivo);

        // Busca pelo layout no form a ser aberto...
        LayoutPadrao := FormAtivo.FindComponent('LayoutPadrao');

        if Assigned(LayoutPadrao) then
                Form1.LayoutDetalhe.AddObject(TLayout(LayoutPadrao));


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
        Abrir_Form(TForm3);
        Mudar_Aba(TabItem2, sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
        if Not Assigned(Form2) then
                Application.CreateForm(TForm2, Form2);

        Form2.Show;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
        if Not Assigned(Form2) then
                Application.CreateForm(TForm2, Form2);

        form2.ShowModal(procedure(ModalResult: TModalResult)
                        begin
                                if ModalResult = mrOk then
                                begin
                                        showmessage('Clicou OK... atualizar lista dos dados');
                                end;
                        end);

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
        Mudar_Aba(TabItem1, sender);
end;

end.
