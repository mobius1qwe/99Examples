unit Form_Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.TabControl, System.Actions, FMX.ActnList, FMX.Edit,
  FMX.MediaLibrary.Actions, FMX.StdActns, FGX.ActionSheet;

type
  TFrm_login = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Layout6: TLayout;
    Rectangle2: TRectangle;
    SpeedButton1: TSpeedButton;
    Path1: TPath;
    Layout3: TLayout;
    Layout7: TLayout;
    Label2: TLabel;
    Line1: TLine;
    Line2: TLine;
    Label3: TLabel;
    Layout5: TLayout;
    Line3: TLine;
    Label4: TLabel;
    lbl_entrar: TLabel;
    Layout4: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItemLogin: TTabItem;
    ActionList1: TActionList;
    ActTabItem2: TChangeTabAction;
    ActTabItem3: TChangeTabAction;
    ActTabItem1: TChangeTabAction;
    ActTabLogin: TChangeTabAction;
    Layout8: TLayout;
    Line4: TLine;
    Label6: TLabel;
    Layout9: TLayout;
    Label7: TLabel;
    Line5: TLine;
    Layout10: TLayout;
    Layout11: TLayout;
    Rectangle3: TRectangle;
    Label8: TLabel;
    Line6: TLine;
    edt_fone: TEdit;
    Layout12: TLayout;
    Layout13: TLayout;
    Rectangle4: TRectangle;
    btn_avancar2: TSpeedButton;
    Label9: TLabel;
    Layout14: TLayout;
    Layout15: TLayout;
    Label10: TLabel;
    Label11: TLabel;
    Line7: TLine;
    Line8: TLine;
    Layout16: TLayout;
    Layout17: TLayout;
    Rectangle5: TRectangle;
    edt_email: TEdit;
    Layout18: TLayout;
    Layout19: TLayout;
    Rectangle6: TRectangle;
    btn_avancar3: TSpeedButton;
    TabItemFoto: TTabItem;
    ActTabFoto: TChangeTabAction;
    Layout20: TLayout;
    c_foto: TCircle;
    Label12: TLabel;
    Layout21: TLayout;
    Layout22: TLayout;
    Rectangle7: TRectangle;
    SpeedButton2: TSpeedButton;
    fgActionFoto: TfgActionSheet;
    ActFotoLibrary: TTakePhotoFromLibraryAction;
    ActFotoCamera: TTakePhotoFromCameraAction;
    StyleBook1: TStyleBook;
    Layout23: TLayout;
    Image2: TImage;
    Layout24: TLayout;
    Layout25: TLayout;
    Rectangle8: TRectangle;
    Edit1: TEdit;
    Layout26: TLayout;
    Layout27: TLayout;
    Rectangle9: TRectangle;
    Edit2: TEdit;
    Layout28: TLayout;
    Line9: TLine;
    Layout29: TLayout;
    Label13: TLabel;
    Layout30: TLayout;
    Label15: TLabel;
    Layout31: TLayout;
    Layout32: TLayout;
    Layout33: TLayout;
    Rectangle10: TRectangle;
    SpeedButton3: TSpeedButton;
    Layout34: TLayout;
    Layout35: TLayout;
    Label16: TLabel;
    Line10: TLine;
    Line11: TLine;
    Layout36: TLayout;
    Line12: TLine;
    Layout37: TLayout;
    Label17: TLabel;
    lbl_cadastre: TLabel;
    Path2: TPath;
    Layout38: TLayout;
    Line13: TLine;
    Layout39: TLayout;
    Label5: TLabel;
    Label14: TLabel;
    Layout40: TLayout;
    Line14: TLine;
    Layout41: TLayout;
    Label18: TLabel;
    Label19: TLabel;
    Layout42: TLayout;
    Line15: TLine;
    Layout43: TLayout;
    Label20: TLabel;
    Label21: TLabel;
    procedure Label3Click(Sender: TObject);
    procedure btn_avancar2Click(Sender: TObject);
    procedure btn_avancar3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure c_fotoClick(Sender: TObject);
    procedure ActFotoLibraryDidFinishTaking(Image: TBitmap);
    procedure ActFotoCameraDidFinishTaking(Image: TBitmap);
    procedure lbl_entrarClick(Sender: TObject);
    procedure lbl_cadastreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_login: TFrm_login;

implementation

{$R *.fmx}

procedure TFrm_login.ActFotoCameraDidFinishTaking(Image: TBitmap);
begin
        c_foto.Fill.Bitmap.Bitmap := Image;
end;

procedure TFrm_login.ActFotoLibraryDidFinishTaking(Image: TBitmap);
begin
        c_foto.Fill.Bitmap.Bitmap := Image;
end;

procedure TFrm_login.btn_avancar2Click(Sender: TObject);
begin
        ActTabItem3.ExecuteTarget(Sender);
end;

procedure TFrm_login.btn_avancar3Click(Sender: TObject);
begin
        ActTabFoto.ExecuteTarget(Sender);
end;

procedure TFrm_login.c_fotoClick(Sender: TObject);
begin
        fgActionFoto.Show;
end;

procedure TFrm_login.FormCreate(Sender: TObject);
begin
        TabControl1.TabPosition := TTabPosition.None;
        TabControl1.ActiveTab := TabItem1;
end;

procedure TFrm_login.Label3Click(Sender: TObject);
begin
        ActTabItem2.ExecuteTarget(Sender);
end;

procedure TFrm_login.lbl_cadastreClick(Sender: TObject);
begin
        ActTabItem2.ExecuteTarget(sender);
end;

procedure TFrm_login.lbl_entrarClick(Sender: TObject);
begin
        ActTabLogin.ExecuteTarget(sender);
end;

end.
