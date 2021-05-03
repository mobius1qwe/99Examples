unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Actions, FMX.ActnList, FMX.Edit;

type
  TFrmInicial = class(TForm)
    layout_rodape: TLayout;
    TabControl1: TTabControl;
    StyleBook1: TStyleBook;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    line: TLine;
    Label3: TLabel;
    Image3: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Image4: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Image5: TImage;
    Layout2: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    Rectangle1: TRectangle;
    Label10: TLabel;
    ActionList1: TActionList;
    ActTab2: TChangeTabAction;
    ActTab3: TChangeTabAction;
    ActTab4: TChangeTabAction;
    TabItem5: TTabItem;
    ActTab5: TChangeTabAction;
    Layout1: TLayout;
    Label11: TLabel;
    Label12: TLabel;
    Rectangle2: TRectangle;
    Label13: TLabel;
    TabItem6: TTabItem;
    ActTab6: TChangeTabAction;
    Layout3: TLayout;
    Label14: TLabel;
    Label15: TLabel;
    Rectangle3: TRectangle;
    Label16: TLabel;
    Layout5: TLayout;
    Edit1: TEdit;
    Line1: TLine;
    Layout4: TLayout;
    Edit2: TEdit;
    Line2: TLine;
    procedure Image2Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmInicial: TFrmInicial;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmInicial.FormCreate(Sender: TObject);
begin
    TabControl1.ActiveTab := TabItem1;
end;

procedure TFrmInicial.Image2Click(Sender: TObject);
begin

    case TabControl1.TabIndex of
        0: ActTab2.Execute;
        1: ActTab3.Execute;
        2: begin
            line.Visible := false;
            layout_rodape.Visible := false;
            ActTab4.Execute;
        end;
    end;
end;

procedure TFrmInicial.Label3Click(Sender: TObject);
begin
    ActTab5.Execute;
end;

procedure TFrmInicial.Rectangle1Click(Sender: TObject);
begin
    ActTab5.Execute;
end;

procedure TFrmInicial.Rectangle2Click(Sender: TObject);
begin
    ActTab6.Execute;
end;

procedure TFrmInicial.Rectangle3Click(Sender: TObject);
begin
    FrmPrincipal.Show;
end;

end.
