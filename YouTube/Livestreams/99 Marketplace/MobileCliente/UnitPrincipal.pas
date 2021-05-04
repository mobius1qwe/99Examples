unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, System.NetEncoding, FMX.TextLayout, u99Permissions,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.Edit,
  uFunctions;

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
    c_foto: TCircle;
    Label1: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    lbl_avaliacoes: TLabel;
    img1: TImage;
    img4: TImage;
    img3: TImage;
    img2: TImage;
    img5: TImage;
    ListBox1: TListBox;
    lbi_endereco: TListBoxItem;
    Label4: TLabel;
    lbl_endereco: TLabel;
    Image9: TImage;
    Layout2: TLayout;
    lbi_nome: TListBoxItem;
    Image11: TImage;
    Layout4: TLayout;
    Label8: TLabel;
    lbl_nome: TLabel;
    lbi_email: TListBoxItem;
    Image12: TImage;
    Layout5: TLayout;
    Label10: TLabel;
    lbl_email: TLabel;
    lbi_fone: TListBoxItem;
    Image13: TImage;
    Layout6: TLayout;
    Label12: TLabel;
    lbl_fone: TLabel;
    lbi_senha: TListBoxItem;
    Image10: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    lbl_senha: TLabel;
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
    img_realizar: TImage;
    img_cheia: TImage;
    img_vazia: TImage;
    OpenDialog: TOpenDialog;
    ActionList1: TActionList;
    ActLibrary: TTakePhotoFromLibraryAction;
    layout_cad: TLayout;
    rect_cad: TRectangle;
    lbl_cad_titulo: TLabel;
    rect_cad_salvar: TRectangle;
    Label25: TLabel;
    edt_cad_texto: TEdit;
    img_cad_fechar: TImage;
    rect_cad_fundo: TRectangle;
    procedure img_notificacaoClick(Sender: TObject);
    procedure img_add_pedidoClick(Sender: TObject);
    procedure img_aba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_pedidosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure lv_aceitosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_realizadosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_pedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_aceitosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure c_fotoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure lbi_enderecoClick(Sender: TObject);
    procedure img_cad_fecharClick(Sender: TObject);
    procedure rect_cad_fundoClick(Sender: TObject);
    procedure rect_cad_salvarClick(Sender: TObject);
    procedure lbi_nomeClick(Sender: TObject);
    procedure lbi_emailClick(Sender: TObject);
    procedure lbi_foneClick(Sender: TObject);
    procedure lbi_senhaClick(Sender: TObject);
  private
    permissao : T99Permissions;
    lbl : TLabel;
    procedure MudarAba(img: TImage);
    procedure AddPedido(seq_pedido, seq_usuario, max_orcamentos,
      qtd_orc_enviada: integer; categoria, dt, pedido, descricao: string);
    procedure AddAceito(seq_pedido, seq_usuario : integer;
                        nome, categoria, dt, pedido, descricao: string;
                        valor: double);
    procedure AddRealizado(seq_pedido, seq_usuario: integer; nome, categoria,
      dt, pedido, descricao: string; valor: double);
    procedure ListarRealizados;
    procedure ProcessarPedidoAberto;
    procedure ProcessarPedidoErro(Sender: TObject);
    procedure ProcessarPedidoAceito;
    procedure ProcessarPedidoRealizado;
    function DesenharEstrela(indCheia: boolean): TBitmap;
    procedure AbrirEdicaoItem(titulo: string; lbl_edicao: TLabel;
                              ind_senha : Boolean = false);
    procedure FecharEdicaoItem(ind_cancelar: Boolean);
    procedure EditarFotoUsuario(foto: TBitmap);
    { Private declarations }
  public
    id_usuario_logado : Integer;
    procedure ListarPendente;
    procedure ListarAceito;
    function Base64FromBitmap(Bitmap: TBitmap): string;
    function BitmapFromBase64(const base64: string): TBitmap;
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
    procedure Avaliar(nota: integer);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitNotificacao, UnitPedido, UnitChat, System.JSON, UnitDM,
  FMX.DialogService, UnitClassificacao, REST.Types;

procedure TFrmPrincipal.AbrirEdicaoItem(titulo : string; lbl_edicao : TLabel;
                                        ind_senha : Boolean = false);
begin
    lbl_cad_titulo.Text := titulo;

    if ind_senha then
        edt_cad_texto.Text := ''
    else
        edt_cad_texto.Text := trim(lbl_edicao.Text);

    edt_cad_texto.Password := ind_senha;
    lbl := lbl_edicao;

    rect_cad.Margins.Top := -rect_cad.Height;
    layout_cad.Visible := true;

    rect_cad.AnimateFloat('Margins.Top', 0, 0.3, TAnimationType.InOut,
                           TInterpolationType.Circular);
end;

procedure TFrmPrincipal.FecharEdicaoItem(ind_cancelar : Boolean);
begin
    if NOT ind_cancelar then
        lbl.Text := edt_cad_texto.Text;

    rect_cad.AnimateFloat('Margins.Top', -rect_cad.Height, 0.3,
                          TAnimationType.InOut,
                          TInterpolationType.Circular);

    TThread.CreateAnonymousThread(procedure
    begin
        Sleep(320);

        TThread.Synchronize(nil, procedure
        begin
            layout_cad.Visible := false;
        end);
    end).Start;

end;

function TFrmPrincipal.DesenharEstrela(indCheia : boolean): TBitmap;
begin
    if indCheia then
        Result := img_cheia.Bitmap
    else
        Result := img_vazia.Bitmap;
end;

procedure TFrmPrincipal.Avaliar(nota: integer);
begin
    img1.Bitmap := DesenharEstrela(nota >= 1);
    img2.Bitmap := DesenharEstrela(nota >= 2);
    img3.Bitmap := DesenharEstrela(nota >= 3);
    img4.Bitmap := DesenharEstrela(nota >= 4);
    img5.Bitmap := DesenharEstrela(nota >= 5);
end;

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

procedure TFrmPrincipal.c_fotoClick(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    if OpenDialog.Execute then
    begin
        c_foto.Fill.Bitmap.Bitmap.LoadFromFile(OpenDialog.FileName);
        EditarFotoUsuario(c_foto.Fill.Bitmap.Bitmap);
    end;
    {$ELSE}
        permissao.PhotoLibrary(ActLibrary);
    {$ENDIF}
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
    permissao := T99Permissions.Create;
    MudarAba(img_aba1);
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
    permissao.DisposeOf;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarPendente;
    //ListarAceito;
    //ListarRealizados;
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
        TListItemText(Objects.FindDrawable('TxtData')).Text := Copy(dt, 1, 5) + ' - ' + Copy(dt, 12, 5) + 'h'; // DD/MM/YYYY HH:NN:SS
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

procedure TFrmPrincipal.EditarFotoUsuario(foto: TBitmap);
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    // Salvar item...
    dm.RequestPerfilCad.Params.Clear;
    dm.RequestPerfilCad.AddParameter('id', '');
    dm.RequestPerfilCad.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
    dm.RequestPerfilCad.AddParameter('campo', 'foto');
    dm.RequestPerfilCad.AddParameter('valor', TFunctions.Base64FromBitmap(foto), pkREQUESTBODY);
    dm.RequestPerfilCad.Execute;

    try
        json := dm.RequestPerfilCad.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if dm.RequestPerfilCad.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;
end;

procedure TFrmPrincipal.ActLibraryDidFinishTaking(Image: TBitmap);
begin
    c_foto.Fill.Bitmap.Bitmap := Image;
    EditarFotoUsuario(Image);
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
        TListItemText(Objects.FindDrawable('TxtData')).Text := Copy(dt, 1, 5);
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := Format('%.2m', [valor]);

        TListItemImage(Objects.FindDrawable('ImgNome')).Bitmap := img_user.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgValor')).Bitmap := img_money.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgRealizar')).Bitmap := img_realizar.Bitmap;
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
        TListItemText(Objects.FindDrawable('TxtData')).Text := Copy(dt, 1, 5);
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemText(Objects.FindDrawable('TxtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('TxtValor')).Text := Format('%.2m', [valor]);

        TListItemImage(Objects.FindDrawable('ImgNome')).Bitmap := img_user.Bitmap;
        TListItemImage(Objects.FindDrawable('ImgValor')).Bitmap := img_money.Bitmap;
    end;
end;

procedure TFrmPrincipal.ProcessarPedidoAberto;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin
    try
        try
            json := dm.RequestPedido.Response.JSONValue.ToString;
            jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

            // Se deu erro...
            if dm.RequestPedido.Response.StatusCode <> 200 then
            begin
                showmessage(retorno);
                exit;
            end;

        except on ex:exception do
            begin
                showmessage(ex.Message);
                exit;
            end;
        end;

        try
            // Popular listview dos pedidos...
            lv_pedidos.Items.Clear;
            lv_pedidos.BeginUpdate;

            for i := 0 to jsonArray.Size - 1 do
            begin
                AddPedido(jsonArray.Get(i).GetValue<integer>('ID_PEDIDO', 0),
                          jsonArray.Get(i).GetValue<integer>('ID_USUARIO', 0),
                          jsonArray.Get(i).GetValue<integer>('QTD_MAX_ORC', 0),
                          jsonArray.Get(i).GetValue<integer>('QTD_ORCAMENTO', 0),
                          jsonArray.Get(i).GetValue<string>('CATEGORIA', '') + ' - ' +
                          jsonArray.Get(i).GetValue<string>('GRUPO', ''),
                          jsonArray.Get(i).GetValue<string>('DT_SERVICO', '01/01/2000 00:00:00'),
                          jsonArray.Get(i).GetValue<string>('ID_PEDIDO', ''),
                          jsonArray.Get(i).GetValue<string>('DETALHE', '')
                          );
            end;

            jsonArray.DisposeOf;

        finally
            lv_pedidos.EndUpdate;
            lv_pedidos.RecalcSize;
        end;

    finally
        ListarAceito;
    end;
end;


procedure TFrmPrincipal.ProcessarPedidoAceito;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin
    try
        try
            json := dm.RequestAceito.Response.JSONValue.ToString;
            jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

            // Se deu erro...
            if dm.RequestAceito.Response.StatusCode <> 200 then
            begin
                showmessage(retorno);
                exit;
            end;

        except on ex:exception do
            begin
                showmessage(ex.Message);
                exit;
            end;
        end;

        try
            // Popular listview dos pedidos...
            lv_aceitos.Items.Clear;
            lv_aceitos.BeginUpdate;

            for i := 0 to jsonArray.Size - 1 do
            begin
                AddAceito(jsonArray.Get(i).GetValue<integer>('ID_PEDIDO', 0),
                          jsonArray.Get(i).GetValue<integer>('ID_USUARIO', 0),
                          jsonArray.Get(i).GetValue<string>('NOME', '') + ' - ' +
                                 jsonArray.Get(i).GetValue<string>('FONE', ''),
                          jsonArray.Get(i).GetValue<string>('CATEGORIA', '') + ' - ' +
                                 jsonArray.Get(i).GetValue<string>('GRUPO', ''),
                          jsonArray.Get(i).GetValue<string>('DT_SERVICO', '01/01/2000 00:00:00'),
                          jsonArray.Get(i).GetValue<string>('ID_PEDIDO', ''),
                          jsonArray.Get(i).GetValue<string>('DETALHE', ''),
                          jsonArray.Get(i).GetValue<double>('VALOR_TOTAL', 0)
                          );
            end;

            jsonArray.DisposeOf;

        finally
            lv_aceitos.EndUpdate;
            lv_aceitos.RecalcSize;
        end;

    finally
        ListarRealizados;
    end;
end;

procedure TFrmPrincipal.ProcessarPedidoRealizado;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin
    try
        json := dm.RequestRealizado.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        // Se deu erro...
        if dm.RequestRealizado.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

    except on ex:exception do
        begin
            showmessage(ex.Message);
            exit;
        end;
    end;

    try
        // Popular listview dos pedidos...
        lv_realizados.Items.Clear;
        lv_realizados.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddRealizado(jsonArray.Get(i).GetValue<integer>('ID_PEDIDO', 0),
                      jsonArray.Get(i).GetValue<integer>('ID_USUARIO', 0),
                      jsonArray.Get(i).GetValue<string>('NOME', '') + ' - ' +
                             jsonArray.Get(i).GetValue<string>('FONE', ''),
                      jsonArray.Get(i).GetValue<string>('CATEGORIA', '') + ' - ' +
                             jsonArray.Get(i).GetValue<string>('GRUPO', ''),
                      jsonArray.Get(i).GetValue<string>('DT_SERVICO', '01/01/2000 00:00:00'),
                      jsonArray.Get(i).GetValue<string>('ID_PEDIDO', ''),
                      jsonArray.Get(i).GetValue<string>('DETALHE', ''),
                      jsonArray.Get(i).GetValue<double>('VALOR_TOTAL', 0)
                      );
        end;

        jsonArray.DisposeOf;

    finally
        lv_realizados.EndUpdate;
        lv_realizados.RecalcSize;
    end;
end;

procedure TFrmPrincipal.rect_cad_fundoClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmPrincipal.rect_cad_salvarClick(Sender: TObject);
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    // Salvar item...
    dm.RequestPerfilCad.Params.Clear;
    dm.RequestPerfilCad.AddParameter('id', '');
    dm.RequestPerfilCad.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
    dm.RequestPerfilCad.AddParameter('campo', lbl.TagString);
    dm.RequestPerfilCad.AddParameter('valor', edt_cad_texto.Text);
    dm.RequestPerfilCad.Execute;

    try
        json := dm.RequestPerfilCad.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;


        // Se deu erro...
        if dm.RequestPerfilCad.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;

    if NOT edt_cad_texto.Password then
        lbl.Text := edt_cad_texto.Text;

    FecharEdicaoItem(true);
end;

procedure TFrmPrincipal.ProcessarPedidoErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmPrincipal.ListarPendente;
begin
    // Buscar pedidos no servidor...
    dm.RequestPedido.Params.Clear;
    dm.RequestPedido.AddParameter('id', '');
    dm.RequestPedido.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
    dm.RequestPedido.AddParameter('status', 'P');
    dm.RequestPedido.AddParameter('categoria', '');
    dm.RequestPedido.AddParameter('grupo', '');
    dm.RequestPedido.ExecuteAsync(ProcessarPedidoAberto, true, true, ProcessarPedidoErro);
end;

procedure TFrmPrincipal.ListarAceito;
begin
    // Buscar pedidos no servidor...
    dm.RequestAceito.Params.Clear;
    dm.RequestAceito.AddParameter('id', '');
    dm.RequestAceito.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
    dm.RequestAceito.AddParameter('status', 'A');
    dm.RequestAceito.AddParameter('categoria', '');
    dm.RequestAceito.AddParameter('grupo', '');
    dm.RequestAceito.ExecuteAsync(ProcessarPedidoAceito, true, true, ProcessarPedidoErro);
end;

procedure TFrmPrincipal.ListarRealizados;
begin
    // Buscar pedidos no servidor...
    dm.RequestRealizado.Params.Clear;
    dm.RequestRealizado.AddParameter('id', '');
    dm.RequestRealizado.AddParameter('id_usuario', '1');
    dm.RequestRealizado.AddParameter('status', 'R');
    dm.RequestRealizado.AddParameter('categoria', '');
    dm.RequestRealizado.AddParameter('grupo', '');
    dm.RequestRealizado.ExecuteAsync(ProcessarPedidoRealizado, true, true, ProcessarPedidoErro);
end;

procedure TFrmPrincipal.lv_aceitosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    if ItemObject is TListItemImage then
    begin
        if ItemObject.Name = 'ImgRealizar' then
        begin
            TDialogService.MessageDialog('Confirma realização do serviço?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
            procedure(const AResult: TModalResult)
            var
                erro: string;
            begin
                if AResult = mrYes then
                begin
                    dm.RequestPedidoAprovar.Params.Clear;
                    dm.RequestPedidoAprovar.AddParameter('id', '');
                    dm.RequestPedidoAprovar.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
                    dm.RequestPedidoAprovar.AddParameter('id_pedido', TListView(Sender).Items[ItemIndex].Tag.ToString);
                    dm.RequestPedidoAprovar.Execute;

                     try
                        json := dm.RequestPedidoAprovar.Response.JSONValue.ToString;
                        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

                        retorno := jsonObj.GetValue('retorno').Value;

                        // Se deu erro...
                        if dm.RequestPedidoAprovar.Response.StatusCode <> 200 then
                        begin
                            showmessage(retorno);
                            exit;
                        end;

                    finally
                        jsonObj.DisposeOf;
                    end;

                    if NOT Assigned(FrmClassificar) then
                        Application.CreateForm(TFrmClassificar, FrmClassificar);

                    FrmClassificar.id_pedido := TListView(Sender).Items[ItemIndex].Tag;
                    FrmClassificar.ShowModal(procedure (ModalResult: TModalResult)
                    begin
                        ListarPendente;
                    end);
                end;
            end);
        end;
    end;
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

    Aitem.Height := Trunc(img.PlaceOffset.Y + img.Height + 30);

    // Botao realizar...
    img := TListItemImage(AItem.Objects.FindDrawable('ImgRealizar'));
    img.PlaceOffset.Y := AItem.Height - 55;
end;

procedure TFrmPrincipal.lv_pedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmPedido) then
        Application.CreateForm(TFrmPedido, FrmPedido);

    FrmPedido.id_pedido := AItem.Tag;
    FrmPedido.lbl_titulo.Text := 'Detalhes Pedido #' + AItem.Tag.ToString;
    FrmPedido.TabControl.ActiveTab := FrmPedido.TabPedido;
    FrmPedido.Show;
end;

procedure TFrmPrincipal.lv_pedidosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
    max_orcamentos, qtd_orc_enviada, progresso: double;
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

    // Calcula objeto texto do orcamento...
    txt_orc := TListItemText(AItem.Objects.FindDrawable('TxtOrcamentos'));
    txt_orc.PlaceOffset.Y := txt.PlaceOffset.Y + txt.Height + 10;

    if lv_pedidos.Width < 250 then
        txt_orc.Text := 'Orç. Receb ('
    else
        txt_orc.Text := 'Orçamentos Recebidos (';
    txt_orc.Text := txt_orc.Text + qtd_orc_enviada.ToString + ' / ' + max_orcamentos.ToString + ')';


    // Calcula tamanho da barra de progressao...
    progresso := (qtd_orc_enviada / max_orcamentos) * TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).Width;

    TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).PlaceOffset.Y := txt_orc.PlaceOffset.Y + txt_orc.Height + 10;
    TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).Width := lv_pedidos.Width - 30;
    TListItemImage(AItem.Objects.FindDrawable('ImgProgresso')).Width := progresso;
    TListItemImage(AItem.Objects.FindDrawable('ImgProgresso')).PlaceOffset.Y := TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).PlaceOffset.Y;
    TListItemImage(AItem.Objects.FindDrawable('ImgProgresso')).Visible := progresso > 0;

    Aitem.Height := Trunc(TListItemImage(AItem.Objects.FindDrawable('ImgFundo')).PlaceOffset.Y + 35);
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
    if img.Tag = 0 then
        lbl_titulo.Text := 'Pedidos em Aberto'
    else if img.Tag = 1 then
        lbl_titulo.Text := 'Pedidos Aceitos'
    else if img.Tag = 2 then
        lbl_titulo.Text := 'Pedidos Realizados'
    else
        lbl_titulo.Text := 'Meu Perfil';

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

    FrmPedido.id_pedido := 0;
    FrmPedido.lbl_titulo.Text := 'Novo Pedido';
    FrmPedido.TabControl.ActiveTab := FrmPedido.TabPedido;
    FrmPedido.Show;
end;

procedure TFrmPrincipal.img_cad_fecharClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmPrincipal.img_notificacaoClick(Sender: TObject);
begin
    if NOT Assigned(FrmNotificacao) then
        Application.CreateForm(TFrmNotificacao, FrmNotificacao);

    FrmNotificacao.Show;
end;

procedure TFrmPrincipal.lbi_emailClick(Sender: TObject);
begin
    lbl_email.TagString := 'email';
    AbrirEdicaoItem('E-mail', lbl_email);
end;

procedure TFrmPrincipal.lbi_enderecoClick(Sender: TObject);
begin
    lbl_endereco.TagString := 'endereco';
    AbrirEdicaoItem('Endereço', lbl_endereco);
end;

procedure TFrmPrincipal.lbi_foneClick(Sender: TObject);
begin
    lbl_fone.TagString := 'fone';
    AbrirEdicaoItem('Telefone', lbl_fone);
end;

procedure TFrmPrincipal.lbi_nomeClick(Sender: TObject);
begin
    lbl_nome.TagString := 'nome';
    AbrirEdicaoItem('Nome', lbl_nome);
end;

procedure TFrmPrincipal.lbi_senhaClick(Sender: TObject);
begin
    lbl_senha.TagString := 'senha';
    AbrirEdicaoItem('Senha', lbl_senha, true);
end;

end.
