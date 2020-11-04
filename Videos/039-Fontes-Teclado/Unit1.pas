unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ChangeTabAction2: TChangeTabAction;
    Label1: TLabel;
    Rectangle1: TRectangle;
    lbl_valor: TLabel;
    layout_valor: TLayout;
    Layout2: TLayout;
    lbl_tecla7: TLabel;
    Layout3: TLayout;
    lbl_tecla8: TLabel;
    Layout4: TLayout;
    lbl_tecla9: TLabel;
    lbl_tecla4: TLayout;
    Label5: TLabel;
    Layout6: TLayout;
    lbl_tecla5: TLabel;
    Layout7: TLayout;
    lbl_tecla6: TLabel;
    Layout8: TLayout;
    lbl_tecla1: TLabel;
    Layout9: TLayout;
    lbl_tecla2: TLabel;
    Layout10: TLayout;
    lbl_tecla3: TLabel;
    Layout11: TLayout;
    lbl_tecla00: TLabel;
    Layout12: TLayout;
    lbl_tecla0: TLabel;
    Layout13: TLayout;
    img_backspace: TImage;
    img_salvar: TImage;
    RoundRect1: TRoundRect;
    Circle1: TCircle;
    img_limpar: TImage;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure img_salvarClick(Sender: TObject);
    procedure lbl_tecla0Click(Sender: TObject);
    procedure img_backspaceClick(Sender: TObject);
    procedure img_limparClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure Tecla_Backspace();
var
        valor : string;
begin
        with Form1 do
        begin
                valor := lbl_valor.Text;  // 5.200,00
                valor := StringReplace(valor, '.', '', [rfReplaceAll]); // 5200,00
                valor := StringReplace(valor, ',', '', [rfReplaceAll]); // 520000

                if Length(valor) > 1 then
                        valor := Copy(valor, 1, length(valor) - 1) // 520,00
                else
                        valor := '0';

                lbl_valor.Text := FormatFloat('#,##0.00', StrToFloat(valor) / 100);
        end;
end;

procedure Tecla_Numero(lbl : TObject);
var
        valor : string;
begin
        with Form1 do
        begin
                valor := lbl_valor.Text;
                valor := StringReplace(valor, '.', '', [rfReplaceAll]);
                valor := StringReplace(valor, ',', '', [rfReplaceAll]);

                valor := valor + TLabel(lbl).Text;

                lbl_valor.Text := FormatFloat('#,##0.00', StrToFloat(valor) / 100);
        end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        TabControl1.TabPosition := TTabPosition.None;
end;

procedure TForm1.img_backspaceClick(Sender: TObject);
begin
        Tecla_Backspace();
end;

procedure TForm1.img_limparClick(Sender: TObject);
begin
        lbl_valor.Text := '0,00';
end;

procedure TForm1.img_salvarClick(Sender: TObject);
begin
        Label1.Text := lbl_valor.Text;
        ChangeTabAction1.ExecuteTarget(sender);
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
        lbl_valor.Text := Label1.Text;
        ChangeTabAction2.ExecuteTarget(sender);
end;

procedure TForm1.lbl_tecla0Click(Sender: TObject);
begin
        Tecla_Numero(sender);
end;

end.
