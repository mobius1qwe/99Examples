unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Objects, FMX.StdCtrls, FMX.Controls, FMX.Controls.Presentation, FMX.Types,
  FMX.Layouts, FMX.Forms, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Graphics, Data.DB, FMX.Dialogs;

type
  TFrmPrincipal = class(TForm)
    lytToolbar: TLayout;
    btnRefresh: TSpeedButton;
    Label1: TLabel;
    imgFoto: TImage;
    imgFundo: TImage;
    imgBarra: TImage;
    btnAdd: TSpeedButton;
    lvMetas: TListView;
    imgDelete: TImage;
    procedure btnAddClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure lvMetasUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvMetasItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    procedure ListarMetas;
    procedure AddVendedorListView(id_usuario: integer; nome, email: string;
      foto: TBitmap; porc: double);
    procedure LayoutListview(AItem: TListViewItem);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitDM;

procedure TFrmPrincipal.btnAddClick(Sender: TObject);
begin
    // Limpa a tabela...
    with dm.qryGeral do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('delete from tab_usuario');
        ExecSQL;
    end;


    // Insere Usuarios...
    with dm.qryGeral do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('insert into tab_usuario(id_usuario, nome, email, foto, porc)');
        SQL.Add('values(:id_usuario, :nome, :email, :foto, :porc)');


        ParamByName('id_usuario').Value := 1;
        ParamByName('nome').Value := 'Heber Mazutti';
        ParamByName('email').Value := 'heber@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 60;
        ExecSQL;

        ParamByName('id_usuario').Value := 2;
        ParamByName('nome').Value := 'Danilo Santos';
        ParamByName('email').Value := 'danilo@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 35;
        ExecSQL;

        ParamByName('id_usuario').Value := 3;
        ParamByName('nome').Value := 'Ana Beatriz';
        ParamByName('email').Value := 'ana@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 18;
        ExecSQL;

        ParamByName('id_usuario').Value := 4;
        ParamByName('nome').Value := 'Jorge Nobrega';
        ParamByName('email').Value := 'jorge@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 85;
        ExecSQL;

        ParamByName('id_usuario').Value := 5;
        ParamByName('nome').Value := 'Joana Soares';
        ParamByName('email').Value := 'joana@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 40;
        ExecSQL;

        ParamByName('id_usuario').Value := 6;
        ParamByName('nome').Value := 'Marcos Almeida';
        ParamByName('email').Value := 'marcos@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 73;
        ExecSQL;

        ParamByName('id_usuario').Value := 7;
        ParamByName('nome').Value := 'Rogério Santos';
        ParamByName('email').Value := 'roger@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 61;
        ExecSQL;

        ParamByName('id_usuario').Value := 8;
        ParamByName('nome').Value := 'Márcio Rezende';
        ParamByName('email').Value := 'marcio@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 86;
        ExecSQL;

        ParamByName('id_usuario').Value := 9;
        ParamByName('nome').Value := 'Bianca Maia';
        ParamByName('email').Value := 'bianca@teste.com';
        ParamByName('foto').Assign(imgFoto.Bitmap);
        ParamByName('porc').Value := 37;
        ExecSQL;
    end;
end;

procedure TFrmPrincipal.AddVendedorListView(id_usuario: integer;
                                            nome, email: string;
                                            foto: TBitmap;
                                            porc: double);
var
    item: TListViewItem;
begin
    item := lvMetas.Items.Add;
    item.Height := 90;
    item.Tag := id_usuario;

    // Foto
    if foto <> nil then
    begin
        TListItemImage(item.Objects.FindDrawable('imgVendedor')).Bitmap := foto;
        TListItemImage(item.Objects.FindDrawable('imgVendedor')).OwnsBitmap := true;
    end;

    // Nome
    TListItemText(item.Objects.FindDrawable('txtNome')).Text := nome;

    // Email
    TListItemText(item.Objects.FindDrawable('txtEmail')).Text := email;

    // Porcentagem
    TListItemText(item.Objects.FindDrawable('txtPorc')).Text := FormatFloat('0%', porc);

    // Fundo da barra
    TListItemImage(item.Objects.FindDrawable('imgFundoBarra')).Bitmap := imgFundo.Bitmap;

    // Barra
    TListItemImage(item.Objects.FindDrawable('imgBarra')).Bitmap := imgBarra.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgBarra')).TagFloat := porc;

    // Delete
    TListItemImage(item.Objects.FindDrawable('imgDelete')).Bitmap := imgDelete.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgDelete')).TagFloat := id_usuario;

    LayoutListview(item);
end;

procedure TFrmPrincipal.ListarMetas;
var
    foto: TBitmap;
    foto_stream: TStream;
begin
    lvMetas.BeginUpdate;
    lvMetas.Items.Clear;

    with dm.qryGeral do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('select * from tab_usuario order by id_usuario');
        Active := true;

        while NOT eof do
        begin
            if FieldByName('foto').AsString <> '' then
            begin
                foto_stream := CreateBlobStream(FieldByName('foto'), TBlobStreamMode.bmRead);

                foto := TBitmap.Create;
                foto.LoadFromStream(foto_stream);

                foto_stream.DisposeOf;
            end
            else
                foto := nil;

            AddVendedorListView(FieldByName('id_usuario').AsInteger,
                                FieldByName('nome').AsString,
                                FieldByName('email').AsString,
                                foto,
                                FieldByName('porc').AsFloat);

            Next;
        end;
    end;

    lvMetas.EndUpdate;
end;

procedure TFrmPrincipal.LayoutListview(AItem: TListViewItem);
var
    img_fundo, img_barra: TListItemImage;
    txt: TListItemText;
    porc: double;
begin
    img_fundo := TListItemImage(AItem.Objects.FindDrawable('imgFundoBarra'));
    img_barra := TListItemImage(AItem.Objects.FindDrawable('imgBarra'));
    porc := img_barra.TagFloat;

    img_barra.Width := porc;
    img_barra.PlaceOffset.X := img_fundo.PlaceOffset.X - (100 - porc);


    txt := TListItemText(AItem.Objects.FindDrawable('txtEmail'));
    txt.Width := lvMetas.Width - 120 - 100;

    // Esconde as barras para o id_usuario = 2
    if AItem.Tag = 2 then
    begin
        img_fundo.Visible := false;
        img_barra.Visible := false;
    end;
end;

procedure TFrmPrincipal.lvMetasItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if (ItemObject <> nil) and (ItemObject.Name = 'imgDelete') then
    begin
        dm.qryGeral.Active := false;
        dm.qryGeral.SQL.Clear;
        dm.qryGeral.SQL.Add('delete from tab_usuario where id_usuario = :id_usuario');
        dm.qryGeral.ParamByName('id_usuario').Value := ItemObject.TagFloat;
        dm.qryGeral.ExecSQL;

        lvMetas.Items.Delete(ItemIndex);
    end
    else
    begin
        showmessage(TListItemText(lvMetas.Items[ItemIndex].Objects.FindDrawable('txtEmail')).Text);
        showmessage('Abrir um form com os dados do usuário');
    end;
end;

procedure TFrmPrincipal.lvMetasUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
    LayoutListview(AItem);
end;

procedure TFrmPrincipal.btnRefreshClick(Sender: TObject);
begin
    ListarMetas;
end;

end.
