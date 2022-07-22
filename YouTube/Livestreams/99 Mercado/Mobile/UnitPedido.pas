unit UnitPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, uLoading,
  uSession, uFunctions;

type
  TFrmPedido = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lvPedidos: TListView;
    imgShop: TImage;
    procedure FormShow(Sender: TObject);
    procedure lvPedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddPedidoLv(id_pedido, qtd_itens: integer;
                                 nome, endereco, dt_pedido: string;
                                 vl_pedido: double);
    procedure ListarPedidos;
    procedure ThreadDadosTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitPedidoDetalhe, DataModule.Usuario;

procedure TFrmPedido.ThreadDadosTerminate(Sender: TObject);
begin
    lvPedidos.EndUpdate;
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;
end;

procedure TFrmPedido.AddPedidoLv(id_pedido, qtd_itens: integer;
                                 nome, endereco, dt_pedido: string;
                                 vl_pedido: double);
var
    img: TListItemImage;
    txt: TListItemText;
begin
    with lvPedidos.Items.Add do
    begin
        Height := 115;
        Tag := id_pedido;

        img := TListItemImage(Objects.FindDrawable('imgShop'));
        img.Bitmap := imgShop.Bitmap;

        txt := TListItemText(Objects.FindDrawable('txtNome'));
        txt.Text := nome;

        txt := TListItemText(Objects.FindDrawable('txtPedido'));
        txt.Text := 'Pedido ' + id_pedido.ToString;

        txt := TListItemText(Objects.FindDrawable('txtEndereco'));
        txt.Text := endereco;

        txt := TListItemText(Objects.FindDrawable('txtValor'));
        txt.Text := FormatFloat('R$ #,##0.00', vl_pedido) + ' - ' + qtd_itens.ToString + ' itens';

        txt := TListItemText(Objects.FindDrawable('txtData'));
        txt.Text := Copy(dt_pedido, 1, 16);
    end;
end;

procedure TFrmPedido.ListarPedidos;
var
    t: TThread;
begin
    TLoading.Show(FrmPedido, '');
    lvPedidos.Items.Clear;
    lvPedidos.BeginUpdate;

    t := TThread.CreateAnonymousThread(procedure
    begin
        DmUsuario.ListarPedido(TSession.ID_USUARIO);

        with DmUsuario.TabPedido do
        begin
            while NOT Eof do
            begin
                TThread.Synchronize(TThread.CurrentThread, procedure
                begin
                    AddPedidoLv(fieldbyname('id_pedido').asinteger,
                               fieldbyname('qtd_itens').asinteger,
                               fieldbyname('nome').asstring,
                               fieldbyname('endereco').asstring,
                               UTCtoDateBR(fieldbyname('dt_pedido').asstring),
                               fieldbyname('vl_total').asfloat);
                end);

                Next;
            end;
        end;
    end);

    t.OnTerminate := ThreadDadosTerminate;
    t.Start;
end;

procedure TFrmPedido.lvPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmPedidoDetalhe) then
        Application.CreateForm(TFrmPedidoDetalhe, FrmPedidoDetalhe);

    FrmPedidoDetalhe.id_pedido := AItem.Tag;
    FrmPedidoDetalhe.Show;
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
    ListarPedidos;
end;

end.
