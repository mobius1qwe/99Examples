unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,

  {$IFDEF ANDROID}
  Android.KeyguardManager,
  {$ENDIF}

  {$IFDEF IOS}
  Macapi.Helpers, iOSapi.Foundation, iOSapi.LocalAuthentication,
  {$ENDIF}

  FMX.Ani;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    layout_menu: TLayout;
    img_digital: TImage;
    Label2: TLabel;
    Arc1: TArc;
    FloatAnimation1: TFloatAnimation;
    rect_login: TRoundRect;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure rect_loginClick(Sender: TObject);
    procedure img_digitalClick(Sender: TObject);
  private
    procedure Autenticar;

    {$IFDEF IOS}
    function TryTouchID: Boolean;
    procedure TouchIDReply(success, error: Pointer);
    procedure ThreadTerminate(Sender: TObject);
    {$ENDIF}

    procedure Sucesso(Sender: TObject);
    procedure Erro(Sender: TObject);

  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;


procedure TFrmLogin.FormCreate(Sender: TObject);
begin
    layout_menu.Margins.Bottom := -220;
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
begin
    if layout_menu.Tag = 0 then
    begin
        layout_menu.Tag := 1;
        layout_menu.AnimateFloat('Margins.Bottom', 0, 0.3,
                                 TAnimationType.&In, TInterpolationType.Circular);
    end
    else
    begin
        layout_menu.Tag := 0;
        layout_menu.AnimateFloat('Margins.Bottom', -220, 0.3,
                                 TAnimationType.&In, TInterpolationType.Circular);
    end;
end;

procedure TFrmLogin.Sucesso(Sender: TObject);
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    FrmPrincipal.lbl_msg.Text := 'SUCESSO';
    FrmPrincipal.Fill.Color := $FF20ce93;
    FrmPrincipal.Show;
end;

procedure TFrmLogin.Erro(Sender: TObject);
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    FrmPrincipal.lbl_msg.Text := 'FALHA';
    FrmPrincipal.Fill.Color := $FFe45446;
    FrmPrincipal.Show;
end;


{$IFDEF ANDROID}
procedure TFrmLogin.Autenticar;
var
 Android: TEventResultClass;
begin
    Android:= TEventResultClass.Create(self);

    if Android.DeviceSecure then
        Android.StartActivityKeyGuard(Sucesso, Erro);
end;
{$ENDIF}

{$IFDEF IOS}

procedure TFrmLogin.ThreadTerminate(Sender: TObject);
begin
    if Assigned(TThread(Sender).FatalException) then
        showmessage(Exception(TThread(Sender).FatalException).Message);
end;

procedure TFrmLogin.TouchIDReply(success: Pointer; error: Pointer);
var
  E: NSError;
begin
  if Assigned(success) then
  begin
    TThread.Synchronize(nil,
      procedure
      begin
        FrmLogin.Sucesso(Self);
      end);
  end
  else
  begin
    TThread.Synchronize(nil,
      procedure
      begin
        FrmLogin.Erro(Self);
      end);
  end;
end;

function TFrmLogin.TryTouchID: Boolean;
var
  Context: LAContext;
  canEvaluate: Boolean;
begin
  Result := false;
  TThread.Synchronize(nil,
    procedure
    begin
      try
        Context := TLAContext.Alloc;
        Context := TLAContext.Wrap(Context.init);

        canEvaluate := Context.canEvaluatePolicy
          (LAPolicy.DeviceOwnerAuthenticationWithBiometrics, nil);
        if canEvaluate then
        begin

          Context.evaluatePolicy
            (LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            StrToNSSTR('Mensagem LocalAuthentication'), TouchIDReply);
        end;
      finally
        Context.release;
      end;
    end);

end;

procedure TFrmLogin.Autenticar;
var
    t : TThread;
begin
    t := TThread.CreateAnonymousThread(
  procedure
  begin

    TThread.Synchronize(Tthread.CurrentThread,
    procedure
    begin
      TryTouchID;
    end);

  end);

  t.OnTerminate := ThreadTerminate;
  t.Start;

end;
{$ENDIF}



procedure TFrmLogin.img_digitalClick(Sender: TObject);
begin
    Autenticar;
end;



end.
