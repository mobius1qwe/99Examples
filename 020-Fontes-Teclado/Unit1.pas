unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Ani;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    btn_salvar: TSpeedButton;
    layout_nome: TLayout;
    Label4: TLabel;
    edt_nome: TEdit;
    layout_endereco: TLayout;
    Label1: TLabel;
    edt_endereco: TEdit;
    layout_fone: TLayout;
    Label2: TLabel;
    edt_fone: TEdit;
    Label3: TLabel;
    VScroll: TVertScrollBox;
    layout_codigo: TLayout;
    Label5: TLabel;
    edt_codigo: TEdit;
    layout_prazo: TLayout;
    Label8: TLabel;
    sw_prazo: TSwitch;
    layout_cidade: TLayout;
    Label6: TLabel;
    edt_cidade: TEdit;
    ColorAnimation1: TColorAnimation;
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edt_nomeEnter(Sender: TObject);
  private
    { Private declarations }
    foco : TControl;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Ajustar_Scroll();
var
        x : integer;
begin
        with Form1 do
        begin
                VScroll.Margins.Bottom := 250;
                VScroll.ViewportPosition := PointF(VScroll.ViewportPosition.X,
                                            TControl(foco).Position.Y - 90);

        end;
end;

procedure TForm1.edt_nomeEnter(Sender: TObject);
begin
        foco := TControl(TEdit(sender).Parent);
        Ajustar_Scroll();
end;

procedure TForm1.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
        VScroll.Margins.Bottom := 0;
     
end;

end.
