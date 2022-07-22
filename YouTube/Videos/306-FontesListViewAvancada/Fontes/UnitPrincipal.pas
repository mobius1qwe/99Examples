unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, FMX.Edit, FMX.TextLayout, uLoading;

type
  TFrmPrincipal = class(TForm)
    btnRefresh: TSpeedButton;
    Label1: TLabel;
    lvClientes: TListView;
    imgFoto: TImage;
    edtBusca: TEdit;
    rectBusca: TRectangle;
    lytLista: TLayout;
    rectToolbar: TRectangle;
    btnNotificacao: TSpeedButton;
    procedure lvClientesUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnRefreshClick(Sender: TObject);
    procedure lvClientesPullRefresh(Sender: TObject);
    procedure lvClientesScrollViewChange(Sender: TObject);
    procedure btnNotificacaoClick(Sender: TObject);
  private
    procedure LayoutListview(AItem: TListViewItem);
    procedure AddClienteListview(id_vendedor: integer;
                                           vendedor, email, endereco: string;
                                           foto: TBitmap);
    procedure ListarMetas;
    procedure threadTerminate(Sender: TObject);
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

function TFrmPrincipal.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    Result := Round(Layout.Height);
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrmPrincipal.LayoutListview(AItem: TListViewItem);
var
    txt: TListItemText;
begin
    // Ajustar o layout...
    //txt := TListItemText(AItem.Objects.FindDrawable('txtEndereco'));
    txt := AItem.Objects.FindDrawable('txtEndereco') as TListItemText;

    txt.Width := lvClientes.Width - 70 - 25;

    // Calcular a altura do obj de endereco...
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 5;

    // Calcula a altura do item da LV...
    AItem.Height := Trunc(txt.PlaceOffset.Y + txt.Height);
end;

procedure TFrmPrincipal.AddClienteListview(id_vendedor: integer;
                                           vendedor, email, endereco: string;
                                           foto: TBitmap);
var
    item: TListViewItem;
begin
    // Item vazio no inicio....
    if lvClientes.Items.Count = 0 then
    begin
        item := lvClientes.Items.Add;
        item.Height := 50;
        item.Objects.Clear;
    end;

    item := lvClientes.Items.Add;

    with item do
    begin
        Height := 120;

        Tag := id_vendedor;

        // Foto
        if foto <> nil then
            TListItemImage(Objects.FindDrawable('imgVendedor')).Bitmap := foto;

        // Nome
        TListItemText(Objects.FindDrawable('txtNome')).Text := vendedor;

        // Email
        TListItemText(Objects.FindDrawable('txtEmail')).Text := email;

        // Endereco
        TListItemText(Objects.FindDrawable('txtEndereco')).Text := endereco;

        LayoutListview(item);

    end;
end;

procedure TFrmPrincipal.ThreadTerminate(Sender: TObject);
begin
    TLoading.Hide;
    lvClientes.EndUpdate;
end;

procedure TFrmPrincipal.ListarMetas;
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    lvClientes.ScrollTo(0);
    lvClientes.BeginUpdate;
    lvClientes.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    var
        i: integer;
    begin
        for i := 1 to 10 do
        begin
            //sleep(500);

            TThread.Synchronize(TThread.CurrentThread, procedure
            begin
                AddClienteListview(5214,
                                   'Heber Stein Mazutti',
                                   'heber@teste.com',
                                   'Avenida Engenheiro José Nelson Machado, 1790 - Cj 20 - Centro - São Paulo - SP - CEP: 00000-000',
                                   imgFoto.Bitmap);

                AddClienteListview(5214, 'Danilo Santos', 'heber@teste.com', 'Av. Paulista, 1500', imgFoto.Bitmap);
                AddClienteListview(5214, 'Ana Beatriz', 'heber@teste.com', 'Rua Rui Barbosa, 50', imgFoto.Bitmap);
                AddClienteListview(5214, 'Jorge Nobrega', 'heber@teste.com', 'Av. Pacaembú, 652', imgFoto.Bitmap);
                AddClienteListview(5214, 'Joana Soares', 'heber@teste.com', 'Rua Ipiranga, 8452', imgFoto.Bitmap);
                AddClienteListview(5214, 'Marcos Almeida', 'heber@teste.com', 'Avenida 23 de maio, 8450 - Cj 52', imgFoto.Bitmap);
                AddClienteListview(5214, 'Rogério Santos', 'heber@teste.com', 'Rua Colômbia, 410', imgFoto.Bitmap);
                AddClienteListview(5214, 'Márcio Rezende', 'heber@teste.com', 'Av. Sâo Vicente, 6000', imgFoto.Bitmap);
                AddClienteListview(5214, 'Bianca Maia', 'heber@teste.com', 'Alameda Santos, 1025', imgFoto.Bitmap);
            end);
        end;
    end);

    t.OnTerminate := ThreadTerminate;
    t.Start;
end;

procedure TFrmPrincipal.lvClientesPullRefresh(Sender: TObject);
begin
    ListarMetas;
end;

procedure TFrmPrincipal.lvClientesScrollViewChange(Sender: TObject);
begin
    if lvClientes.GetItemRect(0).Bottom > 0 then
    begin
        rectBusca.Margins.Top := lvClientes.GetItemRect(0).Top;
        rectToolbar.Sides := [];
    end
    else
    begin
        rectBusca.Margins.Top := -50;
        rectToolbar.Sides := [TSide.Bottom];
    end;
end;

procedure TFrmPrincipal.lvClientesUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if Aitem.Index > 0 then
        LayoutListview(Aitem);
end;

procedure TFrmPrincipal.btnNotificacaoClick(Sender: TObject);
var
    item: TListViewItem;
    txt: TListItemText;
begin
    item := lvClientes.Items[1];
    txt := TListItemText(item.Objects.FindDrawable('txtNome'));

    txt.Text := txt.Text + ' (!)';
end;

procedure TFrmPrincipal.btnRefreshClick(Sender: TObject);
begin
    ListarMetas;
end;

end.
