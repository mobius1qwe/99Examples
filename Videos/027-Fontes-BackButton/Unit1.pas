unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TabControl, FMX.ListBox, FMX.Layouts,

  FMX.VirtualKeyboard, FMX.Platform;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    lbl_cliente: TLabel;
    ListBox1: TListBox;
    ListBoxItem2: TListBoxItem;
    ListBoxItem1: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    Label2: TLabel;
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);

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

                        if TabControl1.ActiveTab = TabItem2 then
                        begin
                                // "Cancela" o efeito do botao back para nao fechar o app...
                                Key := 0;

                                // Volta para a aba 1...
                                TabControl1.ActiveTab := TabItem1;
                        end;

                end;
        end;
        {$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        TabControl1.ActiveTab := TabItem1;
end;

procedure TForm1.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
        lbl_cliente.Text := Item.Text;
        TabControl1.ActiveTab := TabItem2;
end;

end.
