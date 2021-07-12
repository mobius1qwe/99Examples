unit UnitOS;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, UnitFunctions, Data.DB, FMX.Edit,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions,
  u99Permissions, FMX.DialogService;

type
  TCallbackOS = procedure of Object;

  TFrmOS = class(TForm)
    rectOSToolbar: TRectangle;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    imgSalvar: TImage;
    rectDados: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    lblOS: TLabel;
    lblStatus: TLabel;
    Label4: TLabel;
    Layout2: TLayout;
    imgWhats: TImage;
    imgEmail: TImage;
    rectAbas: TRectangle;
    imgAbaOS: TImage;
    imgAbaFoto: TImage;
    imgAbaAssinatura: TImage;
    TabControl: TTabControl;
    TabOS: TTabItem;
    TabFoto: TTabItem;
    TabAssinatura: TTabItem;
    ListBox1: TListBox;
    lbiCliente: TListBoxItem;
    Image1: TImage;
    Layout3: TLayout;
    Image5: TImage;
    Label5: TLabel;
    lblCliente: TLabel;
    lbiEndereco: TListBoxItem;
    Image6: TImage;
    Image7: TImage;
    Line2: TLine;
    Layout4: TLayout;
    Label7: TLabel;
    lblEndereco: TLabel;
    Line1: TLine;
    lbiData: TListBoxItem;
    Image8: TImage;
    Image9: TImage;
    Line3: TLine;
    Layout5: TLayout;
    Label9: TLabel;
    lblData: TLabel;
    lbiAssunto: TListBoxItem;
    Image10: TImage;
    Image11: TImage;
    Line4: TLine;
    Layout6: TLayout;
    Label11: TLabel;
    lblAssunto: TLabel;
    lbiProblema: TListBoxItem;
    Image12: TImage;
    Image13: TImage;
    Line5: TLine;
    Layout7: TLayout;
    Label13: TLabel;
    lblProblema: TLabel;
    lvFoto: TListView;
    imgCapturarFoto: TImage;
    Label3: TLabel;
    imgAssinatura: TImage;
    imgExcluir: TImage;
    lytCampos: TLayout;
    rectFundoCampos: TRectangle;
    rectCampos: TRectangle;
    lblTituloCad: TLabel;
    edtCadTexto: TEdit;
    rectSavar: TRectangle;
    Label6: TLabel;
    imgCadVoltar: TImage;
    rectFoto: TRectangle;
    Rectangle1: TRectangle;
    Label2: TLabel;
    imgFotoSalvar: TImage;
    imgFotoFechar: TImage;
    edtFoto: TEdit;
    imgFoto: TImage;
    ActionList1: TActionList;
    ActCamera: TTakePhotoFromCameraAction;
    OpenDialog: TOpenDialog;
    procedure imgAbaOSClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbiEnderecoClick(Sender: TObject);
    procedure rectSavarClick(Sender: TObject);
    procedure imgCadVoltarClick(Sender: TObject);
    procedure imgWhatsClick(Sender: TObject);
    procedure imgEmailClick(Sender: TObject);
    procedure imgFotoFecharClick(Sender: TObject);
    procedure imgFotoSalvarClick(Sender: TObject);
    procedure ActCameraDidFinishTaking(Image: TBitmap);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgCapturarFotoClick(Sender: TObject);
    procedure lvFotoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure imgSalvarClick(Sender: TObject);
    procedure lbiDataClick(Sender: TObject);
    procedure lbiAssuntoClick(Sender: TObject);
    procedure lbiProblemaClick(Sender: TObject);
    procedure lbiClienteClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    lbl : TLabel;
    permissao: T99Permissions;
    procedure MudarAba(Image: TImage);
    procedure CarregarFotos;
    procedure AddFoto(codFoto, descricao: string; foto: TBItmap);
    procedure AbrirEdicaoItem(tipoCampo, titulo: string; lblEdicao: TLabel);
    procedure FecharEdicaoItem(indCancelar: boolean);
    procedure ErroPermissao(Sender: TObject);
    procedure SelecionarCliente(codCliente: string);
    { Private declarations }
  public
    codOS: string;
    executeOnClose: TCallbackOS;
  end;

var
  FrmOS: TFrmOS;

implementation

{$R *.fmx}

uses UnitDM, UnitBuscaCliente;

procedure TFrmOS.MudarAba(Image: TImage);
begin
    imgAbaOS.Opacity := 0.4;
    imgAbaFoto.Opacity := 0.4;
    imgAbaAssinatura.Opacity := 0.4;

    Image.Opacity := 1;
    TabControl.GotoVisibleTab(Image.Tag);
end;

procedure TFrmOS.FecharEdicaoItem(indCancelar: boolean);
begin
    if NOT indCancelar then
        lbl.Text := edtCadTexto.Text;

    lytCampos.Visible := false;
end;

procedure TFrmOS.rectSavarClick(Sender: TObject);
begin
    FecharEdicaoItem(false);
end;

procedure TFrmOS.ActCameraDidFinishTaking(Image: TBitmap);
begin
    imgFoto.Bitmap := Image;
    edtFoto.Text := '';
    rectFoto.Visible := true;
end;

procedure TFrmOS.AddFoto(codFoto, descricao: string;
                         foto: TBItmap);
var
    item : TListViewItem;
begin
    item := lvFoto.Items.Add;

    with item do
    begin
        Height := 90;
        TagString := codFoto;

        TListItemText(Objects.FindDrawable('txtDescricao')).Text := descricao;
        TListItemImage(Objects.FindDrawable('imgExcluir')).Bitmap := imgExcluir.Bitmap;

        if Assigned(foto) then
        begin
            TListItemImage(Objects.FindDrawable('imgFoto')).OwnsBitmap := true;
            TListItemImage(Objects.FindDrawable('imgFoto')).Bitmap := foto;
        end;
    end;
end;

procedure TFrmOS.CarregarFotos;
var
    foto : TBitmap;
begin
    lvFoto.Items.Clear;

    with dm.qryFoto do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_OS_FOTO');
        SQL.Add('WHERE COD_OS = :COD_OS');
        ParamByName('COD_OS').Value := codOS;
        Active := true;

        while NOT Eof do
        begin
            foto := TBitmap.Create;
            LoadBitmapFromBlob(foto, TBlobField(FieldByName('FOTO')));

            AddFoto(FieldByName('COD_FOTO').AsString,
                    FieldByName('DESCRICAO').AsString,
                    foto);

            Next;
        end;

        Active := false;
    end;
end;

procedure TFrmOS.FormCreate(Sender: TObject);
begin
    permissao := T99Permissions.Create;
end;

procedure TFrmOS.FormDestroy(Sender: TObject);
begin
    permissao.DisposeOf;
end;

procedure TFrmOS.FormShow(Sender: TObject);
begin
    FecharEdicaoItem(true);

    lblCliente.Text := '';
    lblCliente.TagString := '';
    lblEndereco.Text := '';
    lblData.Text := FormatDateTime('dd/mm/yyyy HH:nn', now);
    lblAssunto.Text := '';
    lblProblema.Text := '';
    lblOS.Text := '----';
    lblStatus.Text := 'Aberta';
    imgWhats.TagString := '';
    imgEmail.TagString := '';

    // Edicao da OS...
    if codOS <> '' then
    begin
        with dm do
        begin
            qryGeral.Active := false;
            qryGeral.SQL.Clear;
            qryGeral.SQL.Add('SELECT O.*, C.NOME, C.FONE, C.EMAIL');
            qryGeral.SQL.Add('FROM TAB_OS O');
            qryGeral.SQL.Add('JOIN TAB_CLIENTE C ON (C.COD_CLIENTE = O.COD_CLIENTE)');
            qryGeral.SQL.Add('WHERE O.COD_OS = :COD_OS');
            qryGeral.ParamByName('COD_OS').Value := codOS;
            qryGeral.Active := true;

            lblCliente.Text := qryGeral.FieldByName('NOME').AsString;
            lblCliente.TagString := qryGeral.FieldByName('COD_CLIENTE').AsString;
            lblEndereco.Text := qryGeral.FieldByName('ENDERECO').AsString;
            lblData.Text := FormatDateTime('dd/mm/yyyy HH:nn', qryGeral.FieldByName('DT_OS').AsDateTime);
            lblAssunto.Text := qryGeral.FieldByName('ASSUNTO').AsString;
            lblProblema.Text := qryGeral.FieldByName('PROBLEMA').AsString;
            lblOS.Text := codOS;

            if qryGeral.FieldByName('STATUS').AsString = 'F' then
                lblStatus.Text := 'Fechada';

            imgWhats.TagString := qryGeral.FieldByName('FONE').AsString;
            imgEmail.TagString := qryGeral.FieldByName('EMAIL').AsString;

            // Assinatura...
            LoadBitmapFromBlob(imgAssinatura.Bitmap,
                               TBlobField(qryGeral.FieldByName('ASSINATURA')));
        end;
    end;

    MudarAba(imgAbaOS);
    CarregarFotos;
end;

procedure TFrmOS.imgAbaOSClick(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmOS.imgCadVoltarClick(Sender: TObject);
begin
    FecharEdicaoItem(true);
end;

procedure TFrmOS.ErroPermissao(Sender: TObject);
begin
    showmessage('Você não possui acesso ao recurso de fotos do aparelho');
end;

procedure TFrmOS.imgCapturarFotoClick(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    if OpenDialog.Execute then
    begin
        imgFoto.Bitmap.LoadFromFile(OpenDialog.FileName);
        edtFoto.Text := '';
        rectFoto.Visible := true;
    end;
    {$ELSE}
    permissao.Camera(ActCamera, ErroPermissao);
    {$ENDIF}
end;

procedure TFrmOS.imgEmailClick(Sender: TObject);
begin
    showmessage('Enviar email para: ' + imgEmail.TagString);
end;

procedure TFrmOS.imgFotoFecharClick(Sender: TObject);
begin
    rectFoto.Visible := false;
end;

procedure TFrmOS.imgFotoSalvarClick(Sender: TObject);
var
    foto : TBitmap;
begin
    foto := TBitmap.Create;
    foto.Assign(imgFoto.Bitmap);

    AddFoto(GeraCodFoto, edtFoto.Text, foto);

    rectFoto.Visible := false;
end;

procedure TFrmOS.imgSalvarClick(Sender: TObject);
var
    i : integer;
begin
    with dm.qryGeral do
    begin
        // Salvar a OS...
        Active := false;
        SQL.Clear;

        if codOS = '' then
        begin
            SQL.Add('INSERT INTO TAB_OS(COD_OS, COD_CLIENTE, ENDERECO, DT_OS, ASSUNTO, PROBLEMA, STATUS)');
            SQL.Add('VALUES(:COD_OS, :COD_CLIENTE, :ENDERECO, :DT_OS, :ASSUNTO, :PROBLEMA, :STATUS)');

            codOS := GeraCodOS;
        end
        else
        begin
            SQL.Add('UPDATE TAB_OS SET COD_CLIENTE=:COD_CLIENTE, ENDERECO=:ENDERECO, DT_OS=:DT_OS,');
            SQL.Add('ASSUNTO=:ASSUNTO, PROBLEMA=:PROBLEMA, STATUS=:STATUS WHERE COD_OS=:COD_OS');
        end;

        ParamByName('COD_OS').Value := codOS;
        ParamByName('COD_CLIENTE').Value := lblCliente.TagString;
        ParamByName('ENDERECO').Value := lblEndereco.Text;
        ParamByName('DT_OS').Value := FormataData(lblData.Text);
        ParamByName('ASSUNTO').Value := lblAssunto.Text;
        ParamByName('PROBLEMA').Value := lblProblema.Text;

        if lblStatus.Text = 'Aberta' then
            ParamByName('STATUS').Value := 'A'
        else
            ParamByName('STATUS').Value := 'F';

        ExecSQL;


        // Tratamento das fotos...
        Active := false;
        SQL.Clear;
        SQL.Add('DELETE FROM TAB_OS_FOTO WHERE COD_OS=:COD_OS');
        ParamByName('COD_OS').Value := codOS;
        ExecSQL;

        for i := 0 to lvFoto.ItemCount - 1 do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('INSERT INTO TAB_OS_FOTO(COD_FOTO, COD_OS, FOTO, DESCRICAO, DT_FOTO)');
            SQL.Add('VALUES(:COD_FOTO, :COD_OS, :FOTO, :DESCRICAO, current_timestamp)');
            ParamByName('COD_FOTO').Value := GeraCodFoto;
            ParamByName('COD_OS').Value := codOS;
            ParamByName('FOTO').Assign(TListItemImage(lvFoto.Items[i].Objects.FindDrawable('imgFoto')).Bitmap);
            ParamByName('DESCRICAO').Value := TListItemText(lvFoto.Items[i].Objects.FindDrawable('txtDescricao')).Text;
            ExecSQL;
        end;
    end;


    // Atualizar a listagem das OSs no form principal...
    if Assigned(executeOnClose) then
        executeOnClose;

    close;
end;

procedure TFrmOS.imgVoltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmOS.imgWhatsClick(Sender: TObject);
begin
    showmessage('Abrir whatsapp no fone: ' + imgWhats.TagString);
end;

procedure TFrmOS.AbrirEdicaoItem(tipoCampo, titulo: string;
                                 lblEdicao : TLabel);
begin
    lblTituloCad.Text := titulo;
    edtCadTexto.Text := lblEdicao.Text;
    lbl := lblEdicao;

    //if tipoCampo = 'edit' then
    //    edtCadTexto.Visible := true;

    lytCampos.Visible := true;
end;

procedure TFrmOS.lbiAssuntoClick(Sender: TObject);
begin
    AbrirEdicaoItem('edit', 'Assunto', lblAssunto);
end;

procedure TFrmOS.SelecionarCliente(codCliente: string);
begin
    if codCliente.IsEmpty then
        exit;

    try
        with dm.qryConsCliente do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT * FROM TAB_CLIENTE WHERE COD_CLIENTE = :COD_CLIENTE');
            ParamByName('COD_CLIENTE').Value := codCliente;
            Active := true;

            lblCliente.Text := FieldByName('NOME').AsString;
            lblCliente.TagString := FieldByName('COD_CLIENTE').AsString;
            lblEndereco.Text := FieldByName('ENDERECO').AsString;
            imgWhats.TagString := FieldByName('FONE').AsString;
            imgEmail.TagString := FieldByName('EMAIL').AsString;

            Active := false;
        end;
    except
        showmessage('Erro ao buscar dados do cliente');
    end;
end;

procedure TFrmOS.lbiClienteClick(Sender: TObject);
begin
    // Abrir busca de clientes...
    if NOT Assigned(FrmBuscaCliente) then
        Application.CreateForm(TFrmBuscaCliente, FrmBuscaCliente);

    FrmBuscaCliente.executeOnClose := SelecionarCliente;
    FrmBuscaCliente.Show;
end;

procedure TFrmOS.lbiDataClick(Sender: TObject);
begin
    AbrirEdicaoItem('edit', 'Data da OS', lblData);
end;

procedure TFrmOS.lbiEnderecoClick(Sender: TObject);
begin
    AbrirEdicaoItem('edit', 'Endereço', lblEndereco);
end;

procedure TFrmOS.lbiProblemaClick(Sender: TObject);
begin
    AbrirEdicaoItem('edit', 'Problema', lblProblema);
end;

procedure TFrmOS.lvFotoItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
    if Assigned(ItemObject) then
        if ItemObject.Name = 'imgExcluir' then
        begin
            TDialogService.MessageDialog('Confirma exclusão da foto?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
                     procedure(const AResult: TModalResult)
                     begin
                        if AResult = mrYes then
                            lvFoto.Items.Delete(ItemIndex);
                     end);

        end;
end;

end.
