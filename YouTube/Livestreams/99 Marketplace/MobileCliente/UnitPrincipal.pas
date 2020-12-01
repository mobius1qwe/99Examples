unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, System.NetEncoding, FMX.TextLayout;

type
  TFrmPrincipal = class(TForm)
    layout_abas: TLayout;
    img_aba1: TImage;
    img_aba2: TImage;
    img_aba3: TImage;
    img_aba4: TImage;
    layout_toolbar: TLayout;
    lbl_titulo: TLabel;
    img_notificacao: TImage;
    img_add_pedido: TImage;
    TabControl1: TTabControl;
    TabPedidos: TTabItem;
    TabAceitos: TTabItem;
    TabRealizados: TTabItem;
    TabPerfil: TTabItem;
    lv_pedidos: TListView;
    Line1: TLine;
    Rectangle1: TRectangle;
    Circle1: TCircle;
    Label1: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    ListBox1: TListBox;
    lbi_endereco: TListBoxItem;
    Label4: TLabel;
    Label5: TLabel;
    Image9: TImage;
    Layout2: TLayout;
    ListBoxItem2: TListBoxItem;
    Image11: TImage;
    Layout4: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    ListBoxItem3: TListBoxItem;
    Image12: TImage;
    Layout5: TLayout;
    Label10: TLabel;
    Label11: TLabel;
    ListBoxItem4: TListBoxItem;
    Image13: TImage;
    Layout6: TLayout;
    Label12: TLabel;
    Label13: TLabel;
    ListBoxItem1: TListBoxItem;
    Image10: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    Label7: TLabel;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    Line5: TLine;
    Layout7: TLayout;
    img_barra_fundo: TImage;
    img_barra_progresso: TImage;
    lv_aceitos: TListView;
    img_user: TImage;
    img_money: TImage;
    lv_realizados: TListView;
    StyleBook: TStyleBook;
    procedure img_notificacaoClick(Sender: TObject);
    procedure img_add_pedidoClick(Sender: TObject);
    procedure img_aba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_pedidosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
    procedure lv_aceitosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_realizadosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure MudarAba(img: TImage);
    procedure AddPedido(seq_pedido, seq_usuario, max_orcamentos,
      qtd_orc_enviada: integer; categoria, dt, pedido, descricao: string);
    procedure ListarPedido;
    procedure AddAceito(seq_pedido, seq_usuario : integer;
                        nome, categoria, dt, pedido, descricao: string;
                        valor: double);
    procedure ListarAceito;
    procedure AddRealizado(seq_pedido, seq_usuario: integer; nome, categoria,
      dt, pedido, descricao: string; valor: double);
    procedure ListarRealizados;
    { Private declarations }
  public
    function Base64FromBitmap(Bitmap: TBitmap): string;
    function BitmapFromBase64(const base64: string): TBitmap;
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitNotificacao, UnitPedido, UnitChat;

function TFrmPrincipal.Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
  Encoding: TBase64Encoding;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                    Encoding := TBase64Encoding.Create(0);
                    Encoding.Encode(Input, Output);
                    Result := Output.DataString;
                finally
                        Encoding.Free;
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;

function TFrmPrincipal.BitmapFromBase64(const base64: string): TBitmap;
var
  Input: TStringStream;
  Output: TBytesStream;
  Encoding: TBase64Encoding;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Encoding := TBase64Encoding.Create(0);
      Encoding.Decode(Input, Output);

      Output.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    finally
      Encoding.DisposeOf;
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

procedure TFrmPrincipal.Circle1Click(Sender: TObject);
begin
    if NOT Assigned(FrmChat) then
        Application.CreateForm(TFrmChat, FrmChat);

    FrmChat.Show;
end;

function TFrmPrincipal.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
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
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    MudarAba(img_aba1);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarPedido;
    ListarAceito;
    ListarRealizados;
end;

procedure TFrmPrincipal.AddPedido(seq_pedido, seq_usuario, max_orcamentos, qtd_orc_enviada : integer;
                                  categoria, dt, pedido, descricao: string);
begin
    with lv_pedidos.Items.Add do
    begin
        Tag := seq_pedido;
        TagString := seq_usuario.ToString;
        Height := 180;


        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtPedido')).Text := 'Pedido #' + pedido;
        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtOrcamentos')).Text := 'Orçamentos Recebidos (' +
                                                                     qtd_orc_enviada.ToString + ' / ' +
                                                                     max_orcamentos.ToString + ')';

        TListItemImage(Objects.FindDrawable('ImgFundo')).Width := lv_pedidos.Width - 30;
        TListItemImage(Objects.FindDrawable('ImgFundo')).Bitmap := img_barra_fundo.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgFundo')).TagFloat := max_orcamentos;

        TListItemImage(Objects.FindDrawable('ImgProgresso')).TagFloat := qtd_orc_enviada;
        TListItemImage(Objects.FindDrawable('ImgProgresso')).Bitmap := img_barra_progresso.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgProgresso')).Width := (qtd_orc_enviada / max_orcamentos) *
                                                              TListItemImage(Objects.FindDrawable('ImgFundo')).Width;
        TListItemImage(Objects.FindDrawable('ImgProgresso')).PlaceOffset.Y := TListItemImage(Objects.FindDrawable('ImgFundo')).PlaceOffset.Y;

    end;
end;

procedure TFrmPrincipal.AddAceito(seq_pedido, seq_usuario : integer;
                                  nome, categoria, dt, pedido, descricao: string;
                                  valor: double);
begin
    with lv_aceitos.Items.Add do
    begin
        Tag := seq_pedido;
        TagString := seq_usuario.ToString;
        Height := 200;

        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtPedido')).Text := 'Pedido #' + pedido;
        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := Format('%.2m', [valor]);

        TListItemImage(Objects.FindDrawable('ImgNome')).Bitmap := img_user.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgValor')).Bitmap := img_money.Bitmap;
    end;
end;

procedure TFrmPrincipal.AddRealizado(seq_pedido, seq_usuario : integer;
                                     nome, categoria, dt, pedido, descricao: string;
                                     valor: double);
begin
    with lv_realizados.Items.Add do
    begin
        Tag := seq_pedido;
        TagString := seq_usuario.ToString;
        Height := 200;

        TListItemText(Objects.FindDrawable('TxtCategoria')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtPedido')).Text := 'Pedido #' + pedido;
        TListItemText(Objects.FindDrawable('TxtData')).Text := dt;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := Format('%.2m', [valor]);

        TListItemImage(Objects.FindDrawable('ImgNome')).Bitmap := img_user.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgValor')).Bitmap := img_money.Bitmap;
    end;
end;


procedure TFrmPrincipal.ListarPedido;
var
    x : integer;
begin
    // Buscar pedidos no servidor...

    lv_pedidos.Items.Clear;

    lv_pedidos.BeginUpdate;
    for x := 1 to 10 do
        AddPedido(x, 0, 10, x, 'Serviços Domésticos - Limpeza',
                  '15/07', (10000 + x).ToString,
                  'Preciso de uma diarista para realizar limpeza na minha casa. Das 08:00 às 17:00. Ofereço refeição no local.'
                  );

    lv_pedidos.EndUpdate;
end;

procedure TFrmPrincipal.ListarAceito;
var
    x : integer;
begin
    // Buscar pedidos no servidor...

    lv_aceitos.Items.Clear;

    lv_aceitos.BeginUpdate;
    for x := 1 to 10 do
        AddAceito(x, 0, 'Heber Mazutti', 'Serviços Domésticos - Limpeza',
                  '15/07', (10000 + x).ToString,
                  'Preciso de uma diarista para realizar limpeza na minha casa. Das 08:00 às 17:00. Ofereço refeição no local.',
                  x * 15.25);

    lv_aceitos.EndUpdate;
end;

procedure TFrmPrincipal.ListarRealizados;
var
    x : integer;
begin
    // Buscar pedidos no servidor...

    lv_realizados.Items.Clear;

    lv_realizados.BeginUpdate;
    for x := 1 to 10 do
        AddRealizado(x, 0, 'João da Silva', 'Serviços Gerais - Pet',
                  '08/06', (9000 + x).ToString,
                  'Preciso de uma diarista para realizar limpeza na minha casa. Das 08:00 às 17:00. Ofereço refeição no local.',
                  x * 8.25);

    lv_realizados.EndUpdate;
end;


procedure TFrmPrincipal.lv_aceitosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt_nome: TListItemText;
    img: TListItemImage;
begin
    // Calcula tamanho da categoria...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtCategoria'));
    txt.Width := lv_pedidos.Width - 90;

    // Calcula tamanho da descricao...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtDescricao'));
    txt.Width := lv_pedidos.Width - 30;
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text);

    // Calcula obejto texto do nome...
    txt_nome := TListItemText(AItem.Objects.FindDrawable('TxtNome'));
    txt_nome.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height + 10;

    img := TListItemImage(AItem.Objects.FindDrawable('ImgNome'));
    img.PlaceOffset.Y := txt_nome.PlaceOffset.Y - 5;

    // Calcula obejto texto do valor...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtValor'));
    txt.PlaceOffset.Y := txt_nome.PlaceOffset.Y + txt_nome.Height + 15;

    img := TListItemImage(AItem.Objects.FindDrawable('ImgValor'));
    img.PlaceOffset.Y := txt.PlaceOffset.Y - 5;

    Aitem.Height := Trunc(img.PlaceOffset.Y + img.Height + 20);
end;

procedure TFrmPrincipal.lv_pedidosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    max_orcamentos, qtd_orc_enviada: double;
    txt, txt_orc: TListItemText;
begin
    max_orcamentos := TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).TagFloat;
    qtd_orc_enviada := TListItemImage(AItem.Objects.FindDrawable('ImgProgresso')).TagFloat;

    // Calcula tamanho da categoria...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtCategoria'));
    txt.Width := lv_pedidos.Width - 90;

    // Calcula tamanho da descricao...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtDescricao'));
    txt.Width := lv_pedidos.Width - 30;
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text);

    // Calcula obejto texto do orcamento...
    txt_orc := TListItemText(AItem.Objects.FindDrawable('TxtOrcamentos'));
    txt_orc.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height + 10;

    if lv_pedidos.Width < 250 then
        txt_orc.Text := 'Orç. Receb ('
    else
        txt_orc.Text := 'Orçamentos Recebidos (';
    txt_orc.Text := txt_orc.Text + qtd_orc_enviada.ToString + ' / ' + max_orcamentos.ToString + ')';


    // Calcula tamanho da barra de progressao...
    TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).PlaceOffset.Y := txt_orc.PlaceOffset.Y + txt_orc.Height + 10;
    TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).Width := lv_pedidos.Width - 30;
    TListItemImage(AItem.Objects.FindDrawable('ImgProgresso')).Width := (qtd_orc_enviada / max_orcamentos) *
                                                          TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).Width;
    TListItemImage(AItem.Objects.FindDrawable('ImgProgresso')).PlaceOffset.Y := TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).PlaceOffset.Y;

    Aitem.Height := Trunc(TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).PlaceOffset.Y + 25);
end;

procedure TFrmPrincipal.lv_realizadosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    txt, txt_nome: TListItemText;
    img: TListItemImage;
begin
    // Calcula tamanho da categoria...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtCategoria'));
    txt.Width := lv_pedidos.Width - 90;

    // Calcula tamanho da descricao...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtDescricao'));
    txt.Width := lv_pedidos.Width - 30;
    txt.Height := GetTextHeight(txt, txt.Width, txt.Text);

    // Calcula obejto texto do nome...
    txt_nome := TListItemText(AItem.Objects.FindDrawable('TxtNome'));
    txt_nome.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height + 10;

    img := TListItemImage(AItem.Objects.FindDrawable('ImgNome'));
    img.PlaceOffset.Y := txt_nome.PlaceOffset.Y - 5;

    // Calcula obejto texto do valor...
    txt := TListItemText(AItem.Objects.FindDrawable('TxtValor'));
    txt.PlaceOffset.Y := txt_nome.PlaceOffset.Y + txt_nome.Height + 15;

    img := TListItemImage(AItem.Objects.FindDrawable('ImgValor'));
    img.PlaceOffset.Y := txt.PlaceOffset.Y - 5;

    Aitem.Height := Trunc(img.PlaceOffset.Y + img.Height + 20);
end;

procedure TFrmPrincipal.MudarAba(img: TImage);
begin
    img_aba1.Opacity := 0.3;
    img_aba2.Opacity := 0.3;
    img_aba3.Opacity := 0.3;
    img_aba4.Opacity := 0.3;

    img.Opacity := 1;
    TabControl1.GotoVisibleTab(img.Tag, TTabTransition.Slide);

end;

procedure TFrmPrincipal.img_aba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.img_add_pedidoClick(Sender: TObject);
begin
    if NOT Assigned(FrmPedido) then
        Application.CreateForm(TFrmPedido, FrmPedido);

    FrmPedido.Show;
end;

procedure TFrmPrincipal.img_notificacaoClick(Sender: TObject);
begin
    if NOT Assigned(FrmNotificacao) then
        Application.CreateForm(TFrmNotificacao, FrmNotificacao);

    FrmNotificacao.Show;
end;

end.
