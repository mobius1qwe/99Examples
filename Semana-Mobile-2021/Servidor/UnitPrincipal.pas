unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDWAbout, uRESTDWBase, FMX.TabControl, FMX.Objects,
  FMX.Edit;

type
  TFrmPrincipal = class(TForm)
    Label1: TLabel;
    Switch1: TSwitch;
    ServicePooler: TRESTServicePooler;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    edt_empresa_id: TEdit;
    img_empresa: TImage;
    btn_foto_empresa: TButton;
    OpenDialog: TOpenDialog;
    btn_empresa_update: TButton;
    Rectangle1: TRectangle;
    TabItem2: TTabItem;
    Rectangle2: TRectangle;
    img_categoria: TImage;
    edt_categoria_id: TEdit;
    btn_foto_cat: TButton;
    btn_cat_update: TButton;
    procedure Switch1Switch(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_foto_empresaClick(Sender: TObject);
    procedure btn_empresa_updateClick(Sender: TObject);
    procedure btn_foto_catClick(Sender: TObject);
    procedure btn_cat_updateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitDM;

procedure TFrmPrincipal.btn_cat_updateClick(Sender: TObject);
begin
    try
        dm.QryEmpresa.Active := false;
        dm.QryEmpresa.SQL.Clear;
        dm.QryEmpresa.SQL.Add('UPDATE TAB_CATEGORIA SET ICONE=:ICONE WHERE ID_CATEGORIA=:ID_CATEGORIA');
        dm.QryEmpresa.ParamByName('ICONE').Assign(img_categoria.Bitmap);
        dm.QryEmpresa.ParamByName('ID_CATEGORIA').Value := edt_categoria_id.text.ToInteger;
        dm.QryEmpresa.ExecSQL;
    except on ex:exception do
        showmessage('Erro ao atualizar categoria: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.btn_empresa_updateClick(Sender: TObject);
begin
    try
        dm.QryEmpresa.Active := false;
        dm.QryEmpresa.SQL.Clear;
        dm.QryEmpresa.SQL.Add('UPDATE TAB_EMPRESA SET FOTO=:FOTO WHERE ID_EMPRESA=:ID_EMPRESA');
        dm.QryEmpresa.ParamByName('FOTO').Assign(img_empresa.Bitmap);
        dm.QryEmpresa.ParamByName('ID_EMPRESA').Value := edt_empresa_id.Text.ToInteger;
        dm.QryEmpresa.ExecSQL;
    except on ex:exception do
        showmessage('Erro ao atualizar empresa: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.btn_foto_catClick(Sender: TObject);
begin
    if OpenDialog.Execute then
        img_categoria.Bitmap.LoadFromFile(OpenDialog.FileName);
end;

procedure TFrmPrincipal.btn_foto_empresaClick(Sender: TObject);
begin
    if OpenDialog.Execute then
        img_empresa.Bitmap.LoadFromFile(OpenDialog.FileName);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ServicePooler.ServerMethodClass := TDm;
    ServicePooler.Active := Switch1.IsChecked;
end;

procedure TFrmPrincipal.Switch1Switch(Sender: TObject);
begin
    ServicePooler.Active := Switch1.IsChecked;
end;

end.
