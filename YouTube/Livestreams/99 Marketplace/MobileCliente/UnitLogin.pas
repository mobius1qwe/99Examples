unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Platform,

  {$IFDEF ANDROID}
  FMX.VirtualKeyboard,
  {$ENDIF}

  FMX.Edit;

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
    rect_login: TRectangle;
    Label11: TLabel;
    Label12: TLabel;
    Layout5: TLayout;
    Label13: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label14: TLabel;
    rect_prox1: TRectangle;
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
    rect_prox2: TRectangle;
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
    img_voltar: TImage;
    Circle1: TCircle;
    procedure rect_conta_finalizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TabConta1Click(Sender: TObject);
    procedure rect_btn_cadastrarClick(Sender: TObject);
    procedure rect_loginClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    procedure NavegarAbas(pag: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;



procedure TFrmLogin.NavegarAbas(pag: integer);
begin
    if (TabControl1.TabIndex = 0) and (pag < 0) then
        exit;
    if (TabControl1.TabIndex = 4) and (pag > 0) then
        exit;

    TabControl1.GotoVisibleTab(TabControl1.TabIndex + pag, TTabTransition.Slide);
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
end;

procedure TFrmLogin.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}

begin
    {$IFDEF ANDROID}
    if (Key = vkHardwareBack) then
    begin
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                          IInterface(FService));

        if (FService <> nil) and
           (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
        begin
            // Botao back pressionado e teclado visivel...
            // (apenas fecha o teclado)

        end
        else
        begin
            // Botao back pressionado e teclado NAO visivel...
            if TabControl1.TabIndex > 0 then
            begin
                Key := 0;
                NavegarAbas(-1);
            end;
        end;
    end;
    {$ENDIF}
end;


procedure TFrmLogin.FormShow(Sender: TObject);
begin
    TabControl1.ActiveTab := TabInicial;
end;

procedure TFrmLogin.img_voltarClick(Sender: TObject);
begin
    NavegarAbas(-1);
end;

procedure TFrmLogin.rect_btn_cadastrarClick(Sender: TObject);
begin
    NavegarAbas(2);
end;

procedure TFrmLogin.rect_conta_finalizarClick(Sender: TObject);
begin
    // Criar a conta no server...


    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;

    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
begin
    // Validar o login no server...


    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;

    FrmPrincipal.Show;
    FrmLogin.Close;
end;

procedure TFrmLogin.TabConta1Click(Sender: TObject);
begin
    NavegarAbas(1);
end;

end.
