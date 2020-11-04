unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Gestures, System.Actions,
  FMX.ActnList, FMX.Layouts;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    img_borda: TImage;
    rect_menu: TRectangle;
    GestureManager1: TGestureManager;
    ActionList: TActionList;
    ActUp: TAction;
    ActDown: TAction;
    Layout1: TLayout;
    Arc1: TArc;
    Label2: TLabel;
    Arc2: TArc;
    Label3: TLabel;
    Arc3: TArc;
    Label4: TLabel;
    Arc4: TArc;
    Label5: TLabel;
    Layout2: TLayout;
    RoundRect1: TRoundRect;
    RoundRect2: TRoundRect;
    RoundRect3: TRoundRect;
    RoundRect4: TRoundRect;
    RoundRect5: TRoundRect;
    RoundRect6: TRoundRect;
    RoundRect7: TRoundRect;
    RoundRect8: TRoundRect;
    layout_menu: TLayout;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Rectangle1: TRectangle;
    Image1: TImage;
    RoundRect9: TRoundRect;
    Label14: TLabel;
    RoundRect10: TRoundRect;
    Label15: TLabel;
    RoundRect11: TRoundRect;
    Label16: TLabel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActUpExecute(Sender: TObject);
    procedure ActDownExecute(Sender: TObject);
    procedure img_bordaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ActDownExecute(Sender: TObject);
begin
        rect_menu.AnimateFloat('Margins.Bottom', -290, 0.2,
                                TAnimationType.InOut,
                                TInterpolationType.Circular);
        rect_menu.Tag := 0;
end;

procedure TForm1.ActUpExecute(Sender: TObject);
begin
        rect_menu.AnimateFloat('Margins.Bottom', -70, 0.2,
                                TAnimationType.InOut,
                                TInterpolationType.Circular);
        rect_menu.Tag := 1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        Arc2.EndAngle := -90;
        Arc4.EndAngle := -90;
        rect_menu.Margins.Bottom := -290;
        layout_menu.Visible := true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
        Arc2.AnimateFloat('EndAngle', 270, 1.5);
        Arc4.AnimateFloat('EndAngle', 200, 1.5);
end;

procedure TForm1.img_bordaClick(Sender: TObject);
begin
        if rect_menu.Tag = 0 then
                ActUp.Execute
        else
                ActDown.Execute;
end;

end.
