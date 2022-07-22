unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, uLoading, uFunctions,
  FMX.DialogService;

type
  TFrmProduto = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytFoto: TLayout;
    imgFoto: TImage;
    lblNome: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    lblUnidade: TLabel;
    lblValor: TLabel;
    lblDescricao: TLabel;
    rectRodape: TRectangle;
    Layout3: TLayout;
    imgMenos: TImage;
    imgMais: TImage;
    lblQtd: TLabel;
    btnAdicionar: TButton;
    lytFundo: TLayout;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure imgMenosClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
  private
    FId_produto: integer;
    FId_Mercado: integer;
    FEndereco: string;
    FNome_mercado: string;
    FTaxa_entrega: double;
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure Opacity(op: integer);
    procedure Qtd(valor: integer);
    { Private declarations }
  public
    { Public declarations }
    property Id_produto: integer read FId_produto write FId_produto;
    property Id_mercado: integer read FId_Mercado write FId_mercado;
    property Nome_mercado: string read FNome_mercado write FNome_mercado;
    property Endereco: string read FEndereco write FEndereco;
    property Taxa_entrega: double read FTaxa_entrega write FTaxa_entrega;
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Mercado;

procedure TFrmProduto.Qtd(valor: integer);
begin
    try
        if valor = 0 then
            lblQtd.Tag := 1
        else
            lblQtd.Tag := lblQtd.Tag + valor;

        if lblQtd.Tag <= 0 then
            lblQtd.Tag := 1;
    except
        lblQtd.Tag := 1;
    end;

    lblQtd.Text := FormatFloat('00', lblQtd.Tag);
end;

procedure TFrmProduto.FormResize(Sender: TObject);
begin
    if (FrmProduto.Width > 600) and (FrmProduto.Height > 600) then
    begin
        lytFundo.Align := TAlignLayout.Center;
        lytFundo.Height := 350;
    end
    else
        lytFundo.Align := TAlignLayout.Client;
end;

procedure TFrmProduto.ThreadDadosTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    Opacity(1);
end;

procedure TFrmProduto.Opacity(op: integer);
begin
    imgFoto.Opacity := op;
    lblNome.Opacity := op;
    lblUnidade.Opacity := op;
    lblValor.Opacity := op;
    lblDescricao.Opacity := op;
end;

procedure TFrmProduto.btnAdicionarClick(Sender: TObject);
begin
    // Consiste se possui pedido de outro mercado em aberto...
    if DmMercado.ExistePedidoLocal(Id_mercado) then
    begin
        TDialogService.MessageDialog('Você só pode adicionar itens de um mercado por vez. Deseja esvaziar a sacola e adicionar esse item?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
         procedure(const AResult: TModalResult)
         begin
            if AResult = mrYes then
            begin
                DmMercado.LimparCarrinhoLocal;
                DmMercado.AdicionarCarrinhoLocal(id_mercado, Nome_mercado, Endereco, Taxa_entrega);
                DmMercado.AdicionarItemCarrinhoLocal(Id_produto, imgFoto.TagString, lblNome.Text, lblUnidade.Text,
                                                lblQtd.Tag, lblValor.TagFloat);
            end;
         end);
    end
    else
    begin
        DmMercado.AdicionarCarrinhoLocal(id_mercado, Nome_mercado, Endereco, Taxa_entrega);
        DmMercado.AdicionarItemCarrinhoLocal(Id_produto, imgFoto.TagString, lblNome.Text, lblUnidade.Text,
                                        lblQtd.Tag, lblValor.TagFloat);
    end;

    close;
end;

procedure TFrmProduto.CarregarDados;
var
    t : TThread;
begin
    Qtd(0);
    Opacity(0);
    TLoading.Show(FrmProduto, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        //sleep(2000);

        // Buscar dados do produto...
        DmMercado.ListarProdutoId(Id_produto);

        with DmMercado.TabProdDetalhe do
        begin
            TThread.Synchronize(TThread.CurrentThread, procedure
            begin
                lblNome.Text := fieldbyname('nome').asstring;
                lblUnidade.Text := fieldbyname('unidade').asstring;
                lblValor.Text := FormatFloat('R$#,##0.00', fieldbyname('preco').asfloat);
                lblValor.TagFloat := fieldbyname('preco').asfloat;
                lblDescricao.Text := fieldbyname('descricao').asstring;
            end);

            // Carregar foto do produto...
            imgFoto.TagString := fieldbyname('url_foto').asstring;
            LoadImageFromURL(imgFoto.Bitmap, fieldbyname('url_foto').asstring);
        end;
    end);

    t.OnTerminate := ThreadDadosTerminate;
    t.Start;
end;


procedure TFrmProduto.FormShow(Sender: TObject);
begin
    CarregarDados;
end;

procedure TFrmProduto.imgMenosClick(Sender: TObject);
begin
    Qtd(TImage(Sender).Tag);
end;

procedure TFrmProduto.imgVoltarClick(Sender: TObject);
begin
    close;
end;

end.
