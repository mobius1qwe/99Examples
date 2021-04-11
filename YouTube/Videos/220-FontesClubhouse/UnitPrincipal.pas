unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    lyt_toolbar: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Rectangle1: TRectangle;
    lb_salas: TListBox;
    Layout1: TLayout;
    Rectangle2: TRectangle;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitFrameSugestao, UnitFrameSala, UnitFrameExplorar;

procedure AddSugestao(lb: TListBox);
var
    f : TFrameSugestao;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 220;
    item.Align := TAlignLayout.Client;
    item.Selectable := false;

    f := TFrameSugestao.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    lb.AddObject(item);
end;

procedure AddSala(lb: TListBox);
var
    f : TFrameSala;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 220;
    item.Align := TAlignLayout.Client;
    item.Selectable := false;

    f := TFrameSala.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    lb.AddObject(item);
end;

procedure AddExplorar(lb: TListBox);
var
    f : TFrameExplorar;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 170;
    item.Align := TAlignLayout.Client;
    item.Selectable := false;

    f := TFrameExplorar.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    lb.AddObject(item);
end;


procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    AddSugestao(lb_salas);
    AddSala(lb_salas);
    AddSala(lb_salas);
    AddSala(lb_salas);
    AddExplorar(lb_salas);
end;

end.
