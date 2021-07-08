unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Layouts;

type
  TFrmPrincipal = class(TForm)
    rectAbas: TRectangle;
    imgAbaOS: TImage;
    imgAdd: TImage;
    imgAbaCliente: TImage;
    TabControl: TTabControl;
    TabOS: TTabItem;
    TabCliente: TTabItem;
    rectOSToolbar: TRectangle;
    Label1: TLabel;
    rectOSBusca: TRectangle;
    edtBuscaOS: TEdit;
    rectBuscaOS: TRectangle;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Label3: TLabel;
    Rectangle2: TRectangle;
    edtBuscaCliente: TEdit;
    rectBuscaCliente: TRectangle;
    Label4: TLabel;
    lvCliente: TListView;
    lvOS: TListView;
    imgData: TImage;
    imgHora: TImage;
    imgOpcao: TImage;
    imgAberta: TImage;
    imgFechada: TImage;
    lytMenuOS: TLayout;
    rectFundoMenu: TRectangle;
    rectMenuFechar: TRectangle;
    lblMenuFechar: TLabel;
    rectMenu: TRectangle;
    lblMenuEncerrar: TLabel;
    lblMenuExcluir: TLabel;
    lblMenuAssinatura: TLabel;
    lblMenuReabrir: TLabel;
    procedure imgAbaOSClick(Sender: TObject);
    procedure rectBuscaOSClick(Sender: TObject);
    procedure rectBuscaClienteClick(Sender: TObject);
    procedure lvOSItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lblMenuFecharClick(Sender: TObject);
    procedure lblMenuReabrirClick(Sender: TObject);
    procedure lblMenuEncerrarClick(Sender: TObject);
    procedure lblMenuExcluirClick(Sender: TObject);
    procedure lblMenuAssinaturaClick(Sender: TObject);
  private
    procedure MudarAba(Image: TImage);
    procedure ConsultarOS(filtro: string);
    procedure AddOS(codOS, cliente, dt, hora, status, assunto: string);
    procedure ConsultarCliente(filtro: string);
    procedure AddCliente(codCliente, nome, endereco, cidade, uf: string);
    procedure AlterarStatusOS(codOS, status: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitDM, UnitAssinatura;

procedure TFrmPrincipal.imgAbaOSClick(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.lblMenuFecharClick(Sender: TObject);
begin
    lytMenuOS.Visible := false;
end;

procedure TFrmPrincipal.AlterarStatusOS(codOS, status: string);
begin
    try
        dm.qryGeral.Active := false;
        dm.qryGeral.SQL.Clear;
        dm.qryGeral.SQL.Add('UPDATE TAB_OS SET STATUS=:STATUS');
        dm.qryGeral.SQL.Add('WHERE COD_OS=:COD_OS');
        dm.qryGeral.ParamByName('STATUS').Value := status;
        dm.qryGeral.ParamByName('COD_OS').Value := codOS;
        dm.qryGeral.ExecSQL;

        lytMenuOS.Visible := false;
        ConsultarOS(edtBuscaOS.Text);

    except on ex:exception do
        showmessage('Erro alterar status da OS: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.lblMenuAssinaturaClick(Sender: TObject);
begin
    if NOT Assigned(FrmAssinatura) then
        Application.CreateForm(TFrmAssinatura, FrmAssinatura);

    FrmAssinatura.codOS := lytMenuOS.TagString;
    FrmAssinatura.Show;

    lytMenuOS.Visible := false;
end;

procedure TFrmPrincipal.lblMenuEncerrarClick(Sender: TObject);
begin
    AlterarStatusOS(lytMenuOS.TagString, 'F');
end;

procedure TFrmPrincipal.lblMenuExcluirClick(Sender: TObject);
begin
    try
        dm.qryGeral.Active := false;
        dm.qryGeral.SQL.Clear;
        dm.qryGeral.SQL.Add('DELETE TAB_OS_FOTO WHERE COD_OS=:COD_OS');
        dm.qryGeral.ParamByName('COD_OS').Value := lytMenuOS.TagString;
        dm.qryGeral.ExecSQL;

        dm.qryGeral.Active := false;
        dm.qryGeral.SQL.Clear;
        dm.qryGeral.SQL.Add('DELETE TAB_OS WHERE COD_OS=:COD_OS');
        dm.qryGeral.ParamByName('COD_OS').Value := lytMenuOS.TagString;
        dm.qryGeral.ExecSQL;

        lytMenuOS.Visible := false;
        ConsultarOS(edtBuscaOS.Text);

    except on ex:exception do
        showmessage('Erro ao excluir OS: ' + ex.Message);
    end;
end;

procedure TFrmPrincipal.lblMenuReabrirClick(Sender: TObject);
begin
    AlterarStatusOS(lytMenuOS.TagString, 'A');
end;

procedure TFrmPrincipal.lvOSItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
    codOS: string;
begin
    codOS := lvOS.Items[ItemIndex].TagString;

    if Assigned(ItemObject) then
        if ItemObject.Name = 'imgOpcoes' then
        begin
            lytMenuOS.TagString := codOS;
            lytMenuOS.Visible := true;
            exit;
        end;

     //OpenCadOS(codOS);
end;

procedure TFrmPrincipal.MudarAba(Image: TImage);
begin
    imgAbaOS.Opacity := 0.4;
    imgAbaCliente.Opacity := 0.4;

    Image.Opacity := 1;
    TabControl.GotoVisibleTab(Image.Tag);
end;

procedure TFrmPrincipal.AddOS(codOS, cliente, dt, hora, status, assunto: string);
var
    item : TListViewItem;
begin
    item := lvOS.Items.Add;

    with item do
    begin
        Height := 125;
        TagString := codOS;

        TListItemText(Objects.FindDrawable('txtOS')).Text := codOS;
        TListItemText(Objects.FindDrawable('txtCliente')).Text := cliente;
        TListItemText(Objects.FindDrawable('txtData')).Text := dt;
        TListItemText(Objects.FindDrawable('txtHora')).Text := hora;
        TListItemText(Objects.FindDrawable('txtAssunto')).Text := assunto;

        TListItemImage(Objects.FindDrawable('imgData')).Bitmap := imgData.Bitmap;
        TListItemImage(Objects.FindDrawable('imgHora')).Bitmap := imgHora.Bitmap;
        TListItemImage(Objects.FindDrawable('imgOpcoes')).Bitmap := imgOpcao.Bitmap;

        if status = 'F' then
            TListItemImage(Objects.FindDrawable('imgStatus')).Bitmap := imgFechada.Bitmap
        else
            TListItemImage(Objects.FindDrawable('imgStatus')).Bitmap := imgAberta.Bitmap
    end;
end;

procedure TFrmPrincipal.ConsultarOS(filtro: string);
begin
    lvOS.Items.Clear;

    dm.qryConsOS.Active := false;
    dm.qryConsOS.SQL.Clear;
    dm.qryConsOS.SQL.Add('SELECT O.*, C.NOME');
    dm.qryConsOS.SQL.Add('FROM TAB_OS O');
    dm.qryConsOS.SQL.Add('JOIN TAB_CLIENTE C ON (C.COD_CLIENTE = O.COD_CLIENTE)');

    if filtro <> '' then
    begin
        dm.qryConsOS.SQL.Add('WHERE C.NOME LIKE :NOME');
        dm.qryConsOS.ParamByName('NOME').Value := '%' + filtro + '%';
    end;

    dm.qryConsOS.SQL.Add('ORDER BY O.COD_OS DESC');
    dm.qryConsOS.Active := true;

    while NOT dm.qryConsOS.Eof do
    begin
        AddOS(dm.qryConsOS.FieldByName('COD_OS').AsString,
              dm.qryConsOS.FieldByName('NOME').AsString,
              FormatDateTime('dd/mm/yyyy', dm.qryConsOS.FieldByName('DT_OS').AsDateTime),
              FormatDateTime('HH:nn', dm.qryConsOS.FieldByName('DT_OS').AsDateTime),
              dm.qryConsOS.FieldByName('STATUS').AsString,
              dm.qryConsOS.FieldByName('ASSUNTO').AsString);

        dm.qryConsOS.Next;
    end;

end;

procedure TFrmPrincipal.AddCliente(codCliente, nome, endereco, cidade, uf: string);
var
    item : TListViewItem;
begin
    item := lvCliente.Items.Add;

    with item do
    begin
        Height := 70;
        TagString := codCliente;

        TListItemText(Objects.FindDrawable('txtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('txtEndereco')).Text := endereco;
        TListItemText(Objects.FindDrawable('txtCidade')).Text := cidade + ' - ' + uf;
    end;
end;

procedure TFrmPrincipal.ConsultarCliente(filtro: string);
begin
    lvCliente.Items.Clear;

    dm.qryConsCliente.Active := false;
    dm.qryConsCliente.SQL.Clear;
    dm.qryConsCliente.SQL.Add('SELECT C.*');
    dm.qryConsCliente.SQL.Add('FROM TAB_CLIENTE C');

    if filtro <> '' then
    begin
        dm.qryConsCliente.SQL.Add('WHERE C.NOME LIKE :NOME');
        dm.qryConsCliente.ParamByName('NOME').Value := '%' + filtro + '%';
    end;

    dm.qryConsCliente.SQL.Add('ORDER BY C.NOME');
    dm.qryConsCliente.Active := true;

    while NOT dm.qryConsCliente.Eof do
    begin
        AddCliente(dm.qryConsCliente.FieldByName('COD_CLIENTE').AsString,
                   dm.qryConsCliente.FieldByName('NOME').AsString,
                   dm.qryConsCliente.FieldByName('ENDERECO').AsString,
                   dm.qryConsCliente.FieldByName('CIDADE').AsString,
                   dm.qryConsCliente.FieldByName('UF').AsString);

        dm.qryConsCliente.Next;
    end;

end;

procedure TFrmPrincipal.rectBuscaClienteClick(Sender: TObject);
begin
    ConsultarCliente(edtBuscaCliente.Text);
end;

procedure TFrmPrincipal.rectBuscaOSClick(Sender: TObject);
begin
    ConsultarOS(edtBuscaOS.Text);
end;

end.
