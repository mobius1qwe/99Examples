unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFrmLogin = class(TForm)
    TabControl1: TTabControl;
    TabInicial: TTabItem;
    TabLogin: TTabItem;
    TabConta1: TTabItem;
    TabConta2: TTabItem;
    rect_fundo_aba1: TRectangle;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    rect_btn_entrar: TRectangle;
    Label5: TLabel;
    rect_btn_cadastrar: TRectangle;
    Label6: TLabel;
    rect_tb_login: TRectangle;
    rect_login_voltar: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Layout4: TLayout;
    Label9: TLabel;
    edt_login_email: TEdit;
    Label10: TLabel;
    edt_login_senha: TEdit;
    Rectangle1: TRectangle;
    Label11: TLabel;
    Label12: TLabel;
    Layout5: TLayout;
    Label13: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label14: TLabel;
    Rectangle2: TRectangle;
    Label15: TLabel;
    Rectangle3: TRectangle;
    Label16: TLabel;
    Image3: TImage;
    Label17: TLabel;
    Layout6: TLayout;
    Label18: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label19: TLabel;
    Rectangle4: TRectangle;
    Label20: TLabel;
    Rectangle5: TRectangle;
    Label21: TLabel;
    Image4: TImage;
    TabConta3: TTabItem;
    Label22: TLabel;
    Layout7: TLayout;
    Label24: TLabel;
    rect_conta_finalizar: TRectangle;
    Label25: TLabel;
    Rectangle7: TRectangle;
    Label26: TLabel;
    Image5: TImage;
    Circle1: TCircle;
    procedure rect_conta_finalizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.rect_conta_finalizarClick(Sender: TObject);
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;

    FrmPrincipal.Show;
    FrmLogin.Close;
end;

end.
