unit UnitCarrinho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, uFunctions,
  uLoading, System.JSON;

type
  TFrmCarrinho = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lytEndereco: TLayout;
    lblNome: TLabel;
    lblENdereco: TLabel;
    btnFinalizar: TButton;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label2: TLabel;
    lblSubTotal: TLabel;
    Layout2: TLayout;
    Label4: TLabel;
    lblTaxa: TLabel;
    Layout3: TLayout;
    Label6: TLabel;
    lblTotal: TLabel;
    Label8: TLabel;
    lblEndEntrega: TLabel;
    lbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
  private
    procedure AddProduto(id_produto: integer;
                          descricao, url_foto: string;
                          qtd, valor_unit: double);
    procedure CarregarCarrinho;
    procedure DownloadFoto(lb: TListBox);
    procedure ThreadPedidoTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCarrinho: TFrmCarrinho;

implementation

{$R *.fmx}

uses UnitPrincipal, Frame.ProdutoLista, DataModule.Mercado, DataModule.Usuario;

procedure TFrmCarrinho.DownloadFoto(lb: TListBox);
var
    t: TThread;
    frame: TFrameProdutoLista;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := 0 to lb.Items.Count - 1 do
        begin
            //sleep(1000);
            frame := TFrameProdutoLista(lb.ItemByIndex(i).Components[0]);

            if frame.imgFoto.TagString <> '' then
                LoadImageFromURL(frame.imgFoto.Bitmap, frame.imgFoto.TagString);
        end;

    end);

    t.Start;
end;

procedure TFrmCarrinho.AddProduto(id_produto: integer;
                                  descricao, url_foto: string;
                                  qtd, valor_unit: double);
var
    item: TListBoxItem;
    frame: TFrameProdutoLista;
begin
    item := TListBoxItem.Create(lbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 80;
    item.Tag := id_produto;

    // Frame...
    frame := TFrameProdutoLista.Create(item);
    frame.imgFoto.TagString := url_foto;
    frame.lblDescricao.text := descricao;
    frame.lblQtd.text := qtd.ToString + ' x ' + FormatFloat('R$ #,##0.00', valor_unit);
    frame.lblValor.text := FormatFloat('R$ #,##0.00', qtd * valor_unit);

    item.AddObject(frame);

    lbProdutos.AddObject(item);
end;

procedure TFrmCarrinho.ThreadPedidoTerminate(Sender: TObject);
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

    DmMercado.LimparCarrinhoLocal;
    close;
end;

procedure TFrmCarrinho.btnFinalizarClick(Sender: TObject);
var
    t: TThread;
    jsonPedido: TJsonObject;
    arrayItem: TJSONArray;
begin
    TLoading.Show(FrmCarrinho, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        try
            jsonPedido := DmMercado.JsonPedido(lblSubTotal.TagFloat, lblTaxa.TagFloat, lblTotal.TagFloat);
            jsonPedido.AddPair('itens', DmMercado.JsonPedidoItem);

            DmMercado.InserirPedido(jsonPedido);
        finally
            jsonPedido.DisposeOf;
        end;
    end);

    t.OnTerminate := ThreadPedidoTerminate;
    t.Start;

end;

procedure TFrmCarrinho.CarregarCarrinho;
var
    subtotal: double;
begin
    try
        DmMercado.ListarCarrinhoLocal;
        DmMercado.ListarItemCarrinhoLocal;
        DmUsuario.ListarUsuarioLocal;

        // Dados Mercado...
        lblNome.Text := DmMercado.QryCarrinho.FieldByName('NOME_MERCADO').AsString;
        lblEndereco.Text := DmMercado.QryCarrinho.FieldByName('ENDERECO_MERCADO').AsString;
        lblTaxa.Text := FormatFloat('R$ #,##0.00', DmMercado.QryCarrinho.FieldByName('TAXA_ENTREGA').AsFloat);
        lblTaxa.TagFloat := DmMercado.QryCarrinho.FieldByName('TAXA_ENTREGA').AsFloat;


        // Dados Usuario...
        lblEndEntrega.Text := DmUsuario.QryUsuario.FieldByName('ENDERECO').AsString + ' - ' +
                              DmUsuario.QryUsuario.FieldByName('BAIRRO').AsString + ' - ' +
                              DmUsuario.QryUsuario.FieldByName('CIDADE').AsString + ' - ' +
                              DmUsuario.QryUsuario.FieldByName('UF').AsString;

        // Itens do carrinho...
        subtotal := 0;
        lbProdutos.Items.Clear;
        with DmMercado.QryCarrinhoItem do
        begin
            while NOT EOF do
            begin
                AddProduto(FieldByName('id_produto').AsInteger,
                           FieldByName('nome').AsString,
                           FieldByName('url_foto').AsString,
                           FieldByName('qtd').AsFloat,
                           FieldByName('valor_unitario').AsFloat);

                subtotal := subtotal + FieldByName('valor_total').AsFloat;

                Next;
            end;
        end;

        lblSubTotal.Text := FormatFloat('R$ #,##0.00', subtotal);
        lblSubTotal.TagFloat := subtotal;

        lblTotal.Text := FormatFloat('R$ #,##0.00', subtotal + lblTaxa.TagFloat);
        lblTotal.TagFloat := subtotal + lblTaxa.TagFloat;

        // Carrega as fotos...
        DownloadFoto(lbProdutos);

    except on ex:exception do
        showmessage('Erro ao carregar carrinho: ' + ex.Message);
    end;
end;

procedure TFrmCarrinho.FormShow(Sender: TObject);
begin
    CarregarCarrinho;
end;

end.
