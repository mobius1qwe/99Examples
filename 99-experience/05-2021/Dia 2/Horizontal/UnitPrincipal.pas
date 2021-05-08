unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    rect_fundo: TRectangle;
    Rectangle2: TRectangle;
    Edit1: TEdit;
    Image1: TImage;
    Layout1: TLayout;
    c_foto: TCircle;
    Label1: TLabel;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Line1: TLine;
    ListBox: TListBox;
    img_mascara_top: TImage;
    img_loading: TImage;
    AnimationSkeleton: TFloatAnimation;
    img_skeleton_lista: TImage;
    procedure FormShow(Sender: TObject);
    procedure c_fotoClick(Sender: TObject);
  private
    procedure AddItem;
    procedure Load;
    procedure AddItemSkeleton;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitFrame;

procedure TFrmPrincipal.AddItemSkeleton;
var
    item : TListBoxItem;
    img : TImage;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 95;
    item.Align := TAlignLayout.Client;
    item.Selectable := false;

    // Imagem Skeleton
    img := TImage.Create(item);
    img.Parent := item;
    img.Align := TAlignLayout.Contents;
    img.Bitmap := img_skeleton_lista.Bitmap;
    img.WrapMode := TImageWrapMode.Stretch;
    item.AddObject(img);
    //-----------------


    ListBox.AddObject(item);
end;


procedure TFrmPrincipal.c_fotoClick(Sender: TObject);
begin
    Load;
end;

procedure TFrmPrincipal.AddItem;
var
    f : TFrameItem;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 95;
    item.Align := TAlignLayout.Client;
    item.Selectable := false;

    f := TFrameItem.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    ListBox.AddObject(item);
end;

procedure TFrmPrincipal.Load;
begin
    AnimationSkeleton.StopValue := FrmPrincipal.Width + 100;

    img_loading.BringToFront;
    img_mascara_top.Visible := true;
    ListBox.Items.Clear;
    AnimationSkeleton.Start;


    AddItemSkeleton;
    AddItemSkeleton;
    AddItemSkeleton;

    TThread.CreateAnonymousThread(procedure
    begin
        // Request no seu server...
        // Select no banco...
        sleep(6000);

        TThread.Queue(nil, procedure
        begin
            img_mascara_top.Visible := false;
            rect_fundo.BringToFront;
        end);

        // Request no seu server...
        // Select no banco...
        sleep(6000);

        TThread.Queue(nil, procedure
        var
            x : integer;
        begin
            ListBox.Items.Clear;
            ListBox.BringToFront;
            AnimationSkeleton.Stop;

            for x := 1 to 3 do
                AddItem;
        end);


    end).Start;


end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    Load;
end;

end.
