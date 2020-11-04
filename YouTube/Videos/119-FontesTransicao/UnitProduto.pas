unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,

  // Teclado...
  FMX.VirtualKeyboard, FMX.Platform;

type
  TFrmProduto = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    img_back: TImage;
    Layout1: TLayout;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    rect_compra: TRectangle;
    VertScrollBox1: TVertScrollBox;
    Label2: TLabel;
    Image2: TImage;
    Image3: TImage;
    procedure img_backClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal;


procedure TFrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmProduto := nil;

    FrmPrincipal.FloatAnimation1.Start;
end;

procedure TFrmProduto.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
{$IFDEF ANDROID}
var
    FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
    {$IFDEF ANDROID}
    if (Key = vkHardwareBack) then
    begin
        TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));

        if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
        begin
            // Botao back pressionado e teclado visivel...
            // (apenas fecha o teclado)
        end
        else
        begin
            // Botao back pressionado e teclado NAO visivel...


            // "Cancela" o efeito do botao back para nao fechar o app...
            Key := 0;

            close;
        end;
    end;
    {$ENDIF}
end;

procedure TFrmProduto.FormShow(Sender: TObject);
begin
    VertScrollBox1.ViewportPosition := TPointF.Create(0, 0);
end;

procedure TFrmProduto.img_backClick(Sender: TObject);
begin
    close;
end;

end.
