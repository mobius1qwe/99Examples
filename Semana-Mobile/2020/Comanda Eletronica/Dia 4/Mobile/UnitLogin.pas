unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.TabControl;

type
  TFrmLogin = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Edit1: TEdit;
    rect_login: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConfig: TTabItem;
    Layout2: TLayout;
    Label4: TLabel;
    Edit2: TEdit;
    rect_save_config: TRectangle;
    Label5: TLabel;
    lbl_config: TLabel;
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbl_configClick(Sender: TObject);
    procedure rect_save_configClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    TabControl.ActiveTab := TabLogin;
end;

procedure TFrmLogin.lbl_configClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1, TTabTransition.Slide);
    lbl_titulo.Text := 'Configurações';
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    FrmPrincipal.Show;
    Application.MainForm := FrmPrincipal;
    FrmLogin.Close;
end;

procedure TFrmLogin.rect_save_configClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
    lbl_titulo.Text := 'Acesso';
end;

end.
