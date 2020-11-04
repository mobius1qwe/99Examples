unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Edit, FMX.TabControl,
  System.Actions, FMX.ActnList;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    Layout2: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    edt_usuario_login: TEdit;
    Rectangle1: TRectangle;
    btn_login: TSpeedButton;
    Layout4: TLayout;
    Image2: TImage;
    Layout5: TLayout;
    lbl_criar_conta: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    ActionList1: TActionList;
    ActLogin: TChangeTabAction;
    ActConta: TChangeTabAction;
    Layout6: TLayout;
    Image3: TImage;
    Layout7: TLayout;
    Label3: TLabel;
    Label5: TLabel;
    Layout8: TLayout;
    Label6: TLabel;
    Edit1: TEdit;
    Rectangle2: TRectangle;
    SpeedButton1: TSpeedButton;
    Label7: TLabel;
    Layout9: TLayout;
    img_icone1: TImage;
    img_icone2: TImage;
    img_icone4: TImage;
    img_icone3: TImage;
    img_icone6: TImage;
    img_icone5: TImage;
    c_selecao: TCircle;
    Layout10: TLayout;
    lbl_login: TLabel;
    Layout11: TLayout;
    Image10: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lbl_criar_contaClick(Sender: TObject);
    procedure lbl_loginClick(Sender: TObject);
    procedure img_icone1Click(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure SelecioneIcone(Sender: TObject);
begin
     with FrmLogin do
    begin
        img_icone1.Tag := 0;
        img_icone2.Tag := 0;
        img_icone3.Tag := 0;
        img_icone4.Tag := 0;
        img_icone5.Tag := 0;
        img_icone6.Tag := 0;

        TImage(Sender).Tag := 1;


        c_selecao.AnimateFloat('Position.X', TImage(Sender).Position.X + 20 - 4, 0.2);
    end;
end;

procedure TFrmLogin.btn_loginClick(Sender: TObject);
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    TabControl.TabPosition := TTabPosition.None;
    TabControl.ActiveTab := TabLogin;
end;

procedure TFrmLogin.img_icone1Click(Sender: TObject);
begin
    SelecioneIcone(Sender);
end;

procedure TFrmLogin.lbl_criar_contaClick(Sender: TObject);
begin
    ActConta.Execute;
end;

procedure TFrmLogin.lbl_loginClick(Sender: TObject);
begin
    ActLogin.Execute;
end;

end.
