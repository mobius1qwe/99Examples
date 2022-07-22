unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Ani, uLoading;

type
  TFrmPrincipal = class(TForm)
    lytToolbar: TLayout;
    imgMenu: TImage;
    imgCarrinho: TImage;
    Label1: TLabel;
    lytPesquisa: TLayout;
    StyleBook: TStyleBook;
    rectPesquisa: TRectangle;
    edtBusca: TEdit;
    Image3: TImage;
    btnBuscar: TButton;
    lytSwitch: TLayout;
    rectSwitch: TRectangle;
    rectSelecao: TRectangle;
    lblCasa: TLabel;
    lblRetira: TLabel;
    lvMercado: TListView;
    imgShop: TImage;
    imgTaxa: TImage;
    imgPedidoMin: TImage;
    AnimationFiltro: TFloatAnimation;
    rectMenu: TRectangle;
    Image2: TImage;
    imgFecharMenu: TImage;
    lblMenuEmail: TLabel;
    lblMenuNome: TLabel;
    rectMenuPedido: TRectangle;
    Label4: TLabel;
    rectMenuPerfil: TRectangle;
    Label5: TLabel;
    rectMenuLogout: TRectangle;
    Label6: TLabel;
    AnimationMenu: TFloatAnimation;
    procedure FormShow(Sender: TObject);
    procedure lvMercadoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lblCasaClick(Sender: TObject);
    procedure imgCarrinhoClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure imgFecharMenuClick(Sender: TObject);
    procedure rectMenuPedidoClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure rectMenuLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AnimationMenuFinish(Sender: TObject);
    procedure rectMenuPerfilClick(Sender: TObject);
  private
    FInd_Retira: string;
    FInd_Entrega: string;
    procedure AddMercadoLv(id_mercado: integer; nome, endereco: string;
                            tx_entrega, vl_min_ped: double);
    procedure ListarMercados;
    procedure SelecionarEntrega(lbl: TLabel);
    procedure OpenMenu(ind: boolean);
    procedure ThreadMercadosTerminate(Sender: TObject);
    { Private declarations }
  public
    property Ind_Entrega : string read FInd_Entrega write FInd_Entrega;
    property Ind_Retira : string read FInd_Retira write FInd_Retira;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitMercado, UnitCarrinho, UnitPedido, DataModule.Mercado,
  DataModule.Usuario, UniLogin, UnitPerfil;

procedure TFrmPrincipal.AddMercadoLv(id_mercado: integer;
                                     nome, endereco: string;
                                     tx_entrega, vl_min_ped: double);
var
    img: TListItemImage;
    txt: TListItemText;
    //item: TListViewItem;
begin
    //item := lvMercado.Items.Add;
    //with item do

    with lvMercado.Items.Add do
    begin
        Height := 115;
        Tag := id_mercado;

        img := TListItemImage(Objects.FindDrawable('imgShop'));
        img.Bitmap := imgShop.Bitmap;

        img := TListItemImage(Objects.FindDrawable('imgTaxa'));
        img.Bitmap := imgTaxa.Bitmap;

        img := TListItemImage(Objects.FindDrawable('imgCompraMin'));
        img.Bitmap := imgPedidoMin.Bitmap;

        txt := TListItemText(Objects.FindDrawable('txtNome'));
        txt.Text := nome;

        txt := TListItemText(Objects.FindDrawable('txtEndereco'));
        txt.Text := endereco;

        txt := TListItemText(Objects.FindDrawable('txtTaxa'));
        txt.Text := 'Taxa de entrega: ' + FormatFloat('R$ #,##0.00', tx_entrega);

        txt := TListItemText(Objects.FindDrawable('txtCompraMin'));
        txt.Text := 'Compra mínima: ' + FormatFloat('R$ #,##0.00', vl_min_ped);
    end;
end;

procedure TFrmPrincipal.ThreadMercadosTerminate(Sender: TObject);
begin
    TLoading.Hide;
    lvMercado.EndUpdate;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;
end;

procedure TFrmPrincipal.ListarMercados;
var
    t : TThread;
begin
    TLoading.Show(FrmPrincipal, '');
    lvMercado.Items.Clear;
    lvMercado.BeginUpdate;

    t := TThread.CreateAnonymousThread(procedure
    var
        i: integer;
    begin
        //sleep(1500);
        DmMercado.ListarMercado(edtBusca.Text, Ind_Entrega, Ind_Retira);

        with DmMercado.TabMercado do
        begin
            for i := 0 to recordcount - 1 do
            begin
                TThread.Synchronize(TThread.CurrentThread, procedure
                begin
                    AddMercadoLv(fieldbyname('id_mercado').asinteger,
                                 fieldbyname('nome').asstring,
                                 fieldbyname('endereco').asstring,
                                 fieldbyname('vl_entrega').asfloat,
                                 fieldbyname('vl_compra_min').asfloat);
                end);

                Next;
            end;
        end;
    end);

    t.OnTerminate := ThreadMercadosTerminate;
    t.Start;
end;

procedure TFrmPrincipal.lvMercadoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmMercado) then
        Application.CreateForm(TFrmMercado, FrmMercado);

    FrmMercado.id_mercado := AItem.Tag;
    FrmMercado.Show;
end;

procedure TFrmPrincipal.AnimationMenuFinish(Sender: TObject);
begin
    AnimationMenu.Inverse := not AnimationMenu.Inverse;

    if rectMenu.Tag = 1 then
    begin
        rectMenu.Tag := 0;
        rectMenu.Visible := false;
    end
    else
        rectMenu.Tag := 1;
end;

procedure TFrmPrincipal.OpenMenu(ind: boolean);
begin
    if rectMenu.Tag = 0 then
        rectMenu.Visible := true;

    //AnimationMenu.StartValue := rectMenu.Width + 50;
    //AnimationMenu.StopValue := 0;
    AnimationMenu.Start;
end;

procedure TFrmPrincipal.btnBuscarClick(Sender: TObject);
begin
    ListarMercados;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //Action := TCloseAction.caFree;
    //FrmPrincipal := nil;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    rectMenu.Tag := 0;
    rectMenu.Margins.Right := rectMenu.Width + 50;
    rectMenu.Visible := false;

    SelecionarEntrega(lblCasa);
end;

procedure TFrmPrincipal.imgCarrinhoClick(Sender: TObject);
begin
    if NOT Assigned(FrmCarrinho) then
        Application.CreateForm(TFrmCarrinho, FrmCarrinho);

    FrmCarrinho.Show;
end;

procedure TFrmPrincipal.imgFecharMenuClick(Sender: TObject);
begin
    OpenMenu(false);
end;

procedure TFrmPrincipal.rectMenuLogoutClick(Sender: TObject);
begin
    DmUsuario.Logout;

    if NOT Assigned(FrmLogin) then
        Application.CreateForm(TFrmLogin, FrmLogin);

    Application.MainForm := FrmLogin;
    FrmLogin.Show;
    FrmPrincipal.Close;
end;

procedure TFrmPrincipal.rectMenuPedidoClick(Sender: TObject);
begin
    if NOT Assigned(FrmPedido) then
        application.CreateForm(TFrmPedido, FrmPedido);

    OpenMenu(false);
    FrmPedido.Show;
end;

procedure TFrmPrincipal.rectMenuPerfilClick(Sender: TObject);
begin
    if NOT Assigned(FrmPerfil) then
        Application.CreateForm(TFrmPerfil, FrmPerfil);

    OpenMenu(false);
    FrmPerfil.Show;
end;

procedure TFrmPrincipal.imgMenuClick(Sender: TObject);
begin
    OpenMenu(true);
end;

procedure TFrmPrincipal.SelecionarEntrega(lbl: TLabel);
begin
    lblCasa.FontColor := $FF8F8F8F;
    lblRetira.FontColor := $FF8F8F8F;

    lbl.FontColor := $FFFFFFFF;
    Ind_Entrega := '';
    Ind_Retira := '';

    if lbl.Tag = 0 then
        Ind_Entrega := 'S'
    else
        Ind_Retira := 'S';

    ListarMercados;

    AnimationFiltro.StopValue := lbl.Position.x;
    AnimationFiltro.Start;
end;

procedure TFrmPrincipal.lblCasaClick(Sender: TObject);
begin
    SelecionarEntrega(TLabel(Sender));
end;

end.
