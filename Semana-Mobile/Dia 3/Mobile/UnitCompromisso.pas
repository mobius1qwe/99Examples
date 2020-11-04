unit UnitCompromisso;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Edit, FMX.ListBox, FMX.TabControl, System.Actions, FMX.ActnList,
  UnitCompromissoUsuarioDados;

type
  TFrmCompromisso = class(TForm)
    Layout1: TLayout;
    lbl_titulo: TLabel;
    img_fechar: TImage;
    Layout3: TLayout;
    edt_usuario_login: TEdit;
    Layout2: TLayout;
    DateEdit1: TDateEdit;
    TimeEdit1: TTimeEdit;
    Label4: TLabel;
    btn_sair: TSpeedButton;
    Label1: TLabel;
    img_cad_partic: TImage;
    lb_convite: TListBox;
    TabControl: TTabControl;
    TabCompromisso: TTabItem;
    TabBusca: TTabItem;
    ActionList1: TActionList;
    ActCompromisso: TChangeTabAction;
    ActBusca: TChangeTabAction;
    Layout4: TLayout;
    Label2: TLabel;
    img_voltar: TImage;
    edt_busca: TEdit;
    lb_busca: TListBox;
    Layout5: TLayout;
    btn_busca: TSpeedButton;
    procedure img_fecharClick(Sender: TObject);
    procedure img_cad_particClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btn_buscaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCompromisso: TFrmCompromisso;

implementation

{$R *.fmx}

uses UnitCompromissoUsuarioFrame;


procedure CriaFrameBusca(n : TCompromissoUsuario);
var
    f : TFrameCompromissoUsuario;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 46;
    item.Align := TAlignLayout.Client;
    item.TagString := n.cod_usuario;

    f := TFrameCompromissoUsuario.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.c_icone.Fill.Bitmap.Bitmap := n.icone;
    f.lbl_usuario.Text := n.cod_usuario;

    FrmCompromisso.lb_busca.AddObject(item);
end;

procedure ListarBusca();
var
    n : TCompromissoUsuario;
    x : integer;
begin
    FrmCompromisso.lb_busca.Items.Clear;

    for x := 1 to 15 do
    begin
        n.seq_compromisso := x;
        n.icone := FrmCompromisso.img_cad_partic.Bitmap;
        n.cod_usuario := 'Joao';

        CriaFrameBusca(n);
    end;
end;


procedure CriaFrameConvite(n : TCompromissoUsuario);
var
    f : TFrameCompromissoUsuario;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 46;
    item.Align := TAlignLayout.Client;
    item.TagString := n.cod_usuario;

    f := TFrameCompromissoUsuario.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.c_icone.Fill.Bitmap.Bitmap := n.icone;
    f.lbl_usuario.Text := n.cod_usuario;

    FrmCompromisso.lb_convite.AddObject(item);
end;

procedure ListarConvites();
var
    n : TCompromissoUsuario;
    x : integer;
begin
    FrmCompromisso.lb_convite.Items.Clear;

    for x := 1 to 3 do
    begin
        n.seq_compromisso := x;
        n.icone := FrmCompromisso.img_cad_partic.Bitmap;
        n.cod_usuario := 'Joao';

        CriaFrameConvite(n);
    end;
end;


procedure TFrmCompromisso.btn_buscaClick(Sender: TObject);
begin
    ListarBusca;
end;

procedure TFrmCompromisso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmCompromisso := nil;
end;

procedure TFrmCompromisso.FormCreate(Sender: TObject);
begin
    TabControl.TabPosition := TTabPosition.None;
    TabControl.ActiveTab := TabCompromisso;
end;

procedure TFrmCompromisso.FormShow(Sender: TObject);
begin
    ListarConvites;
end;

procedure TFrmCompromisso.img_cad_particClick(Sender: TObject);
begin
    ActBusca.Execute;
end;

procedure TFrmCompromisso.img_fecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmCompromisso.img_voltarClick(Sender: TObject);
begin
    ActCompromisso.Execute;
end;

end.
