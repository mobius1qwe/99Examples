unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, System.Actions, FMX.ActnList, FMX.Gestures,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Soap.EncdDecd, FMX.ScrollBox, FMX.Memo, System.json, FMX.TextLayout,
  System.Permissions, FMX.MediaLibrary.Actions, FMX.StdActns;

type
  TFrm_Principal = class(TForm)
    StyleBook1: TStyleBook;
    TabControl: TTabControl;
    TabCamera: TTabItem;
    TabTimeline: TTabItem;
    TabMensagem: TTabItem;
    layout_abas: TLayout;
    layout_aba_home: TLayout;
    Image1: TImage;
    Layout1: TLayout;
    Image2: TImage;
    Layout2: TLayout;
    img_btn_foto: TImage;
    Layout3: TLayout;
    Image4: TImage;
    Layout4: TLayout;
    Image5: TImage;
    rect_toolbar: TRectangle;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    ActTabLeft: TChangeTabAction;
    Label1: TLabel;
    Label2: TLabel;
    ActTabRight: TChangeTabAction;
    lv_foto: TListView;
    img_icone_fav: TImage;
    img_icone_fav2: TImage;
    img_icone_comentario: TImage;
    img_icone_msg: TImage;
    img_icone_save: TImage;
    img_icone_save2: TImage;
    img_icone_opcoes: TImage;
    img_foto: TImage;
    Memo1: TMemo;
    Memo2: TMemo;
    img_borda: TImage;
    ActPhotoLibrary: TTakePhotoFromLibraryAction;
    ActPhotoCamera: TTakePhotoFromCameraAction;
    procedure FormCreate(Sender: TObject);
    procedure ActTabLeftUpdate(Sender: TObject);
    procedure ActTabRightUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lv_fotoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lv_fotoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure img_btn_fotoClick(Sender: TObject);
  private
    { Private declarations }

    {$IFDEF ANDROID}
    PermissaoCamera, PermissaoReadStorage, PermissaoWriteStorage : string;
    procedure TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
    procedure DisplayMessageCamera(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
    procedure LibraryPermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
    procedure DisplayMessageLibrary(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
    {$ENDIF}

  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;

implementation

{$R *.fmx}

uses FMX.DialogService

{$IFDEF ANDROID}
,Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
{$ENDIF}

;


{$IFDEF ANDROID}
procedure TFrm_Principal.TakePicturePermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 3 Permissoes: CAMERA, READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 3) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) and
           (AGrantResults[2] = TPermissionStatus.Granted) then
                ActPhotoCamera.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para tirar fotos');
end;

procedure TFrm_Principal.LibraryPermissionRequestResult(
        Sender: TObject; const APermissions: TArray<string>;
        const AGrantResults: TArray<TPermissionStatus>);
begin
        // 2 Permissoes: READ_EXTERNAL_STORAGE e WRITE_EXTERNAL_STORAGE

        if (Length(AGrantResults) = 2) and
           (AGrantResults[0] = TPermissionStatus.Granted) and
           (AGrantResults[1] = TPermissionStatus.Granted) then
                ActPhotoLibrary.Execute
        else
                TDialogService.ShowMessage('Você não tem permissão para acessar as fotos');
end;

procedure TFrm_Principal.DisplayMessageCamera(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
begin
        TDialogService.ShowMessage('O app precisa acessar a câmera e as fotos do seu dispositivo',
                procedure(const AResult: TModalResult)
                begin
                        APostProc;
                end);
end;

procedure TFrm_Principal.DisplayMessageLibrary(Sender: TObject;
                const APermissions: TArray<string>;
                const APostProc: TProc);
begin
        TDialogService.ShowMessage('O app precisa acessar as fotos do seu dispositivo',
                procedure(const AResult: TModalResult)
                begin
                        APostProc;
                end);
end;
{$ENDIF}


function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
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

function Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                        Soap.EncdDecd.EncodeStream(Input, Output);
                        Result := Output.DataString;
                finally
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;

function BitmapFromBase64(const base64: string): TBitmap;
var
        Input: TStringStream;
        Output: TBytesStream;
begin
        Input := TStringStream.Create(base64, TEncoding.ASCII);
        try
                Output := TBytesStream.Create;
                try
                        Soap.EncdDecd.DecodeStream(Input, Output);
                        Output.Position := 0;
                        Result := TBitmap.Create;
                        try
                                Result.LoadFromStream(Output);
                        except
                                Result.Free;
                                raise;
                        end;
                finally
                        Output.Free;
                end;
        finally
                Input.Free;
        end;
end;

procedure Add_Foto(icone_usuario64, nome_usuario, localizacao, foto64,
                   descricao : string; qtd_curtida : integer; ind_curtir : boolean);
var
        item : TListViewItem;
        txt : TListItemText;
        img : TListItemImage;
        foto : TBitmap;
begin
        with Frm_Principal do
        begin
                item := lv_foto.Items.Add;

                with item do
                begin
                        // Icone do usuario...
                        try
                                foto := TBitmap.Create;
                                foto := BitmapFromBase64(icone_usuario64);

                                img := TListItemImage(Objects.FindDrawable('Image3'));
                                img.OwnsBitmap := true;
                                img.Bitmap := foto;
                        except
                        end;


                        // Borda redonda...
                        img := TListItemImage(Objects.FindDrawable('Image12'));
                        img.OwnsBitmap := true;
                        img.Bitmap := img_borda.Bitmap;


                        // Nome do usuario...
                        txt := TListItemText(Objects.FindDrawable('Text1'));
                        txt.Text := nome_usuario;
                        txt.Font.Size := 11;
                        txt.Font.Style := [TFontStyle.fsBold];


                        // Localizacao...
                        txt := TListItemText(Objects.FindDrawable('Text2'));
                        txt.Text := localizacao;
                        txt.Font.Size := 11;

                        // Icone de opcoes...
                        img := TListItemImage(Objects.FindDrawable('Image4'));
                        img.OwnsBitmap := true;
                        img.Bitmap := img_icone_opcoes.Bitmap;

                        // Foto...
                        try
                                foto := TBitmap.Create;
                                foto := BitmapFromBase64(foto64);

                                img := TListItemImage(Objects.FindDrawable('Image5'));
                                img.OwnsBitmap := true;
                                img.Bitmap := foto;
                        except
                        end;



                        // Icone curtir...
                        img := TListItemImage(Objects.FindDrawable('Image6'));
                        img.OwnsBitmap := true;

                        if ind_curtir then
                        begin
                                img.TagFloat := 1;
                                img.Bitmap := img_icone_fav2.Bitmap;
                        end
                        else
                        begin
                                img.TagFloat := 0;
                                img.Bitmap := img_icone_fav.Bitmap;
                        end;


                        // Icone comentarios...
                        img := TListItemImage(Objects.FindDrawable('Image7'));
                        img.OwnsBitmap := true;
                        img.Bitmap := img_icone_comentario.Bitmap;

                        // Icone mensagens...
                        img := TListItemImage(Objects.FindDrawable('Image8'));
                        img.OwnsBitmap := true;
                        img.Bitmap := img_icone_msg.Bitmap;

                        // Icone salvar...
                        img := TListItemImage(Objects.FindDrawable('Image9'));
                        img.OwnsBitmap := true;
                        img.Bitmap := img_icone_save.Bitmap;

                        // Qtd curtidas...
                        txt := TListItemText(Objects.FindDrawable('Text10'));
                        txt.Font.Size := 11;
                        
                        if qtd_curtida = 0 then
                                txt.Text := 'Nenhuma curtida'
                        else if qtd_curtida = 1 then
                                txt.Text := 'Curtido por 1 pessoa'
                        else
                                txt.Text := 'Curtido por ' + qtd_curtida.ToString + ' pessoas';


                        // Descricao da foto...
                        txt := TListItemText(Objects.FindDrawable('Text11'));
                        txt.Font.Size := 11;
                        txt.Text := descricao;
                        txt.WordWrap := true;
                        txt.Width := Frm_Principal.Width - 10;
                        txt.Height := GetTextHeight(txt, txt.Width, descricao) + 3;
                end;
        end;
end;

procedure Busca_Foto_Servidor();
var
        json : string;
        array_foto : TJsonArray;
        x : integer;
        icone_usuario64, nome_usuario, localizacao, foto64, descricao, qtd_curtida : string;
        ind_curtir : boolean;
begin
        // Busca json no servidor...
        json := '[' + Frm_Principal.Memo1.Lines.Text + ',';
        json := json + Frm_Principal.Memo2.Lines.Text + ']';
        json := StringReplace(json, char(13), '', [rfReplaceAll]);
        json := StringReplace(json, char(10), '', [rfReplaceAll]);
        json := StringReplace(json, char(09), '', [rfReplaceAll]);
        //--------------------------


        // Cria array com json retornado...
        array_foto := TJSONArray.Create;
        array_foto := TJSONObject.ParseJSONValue(tencoding.UTF8.GetBytes(json), 0) as TJSONArray;


        // Loop nas fotos recebidas...
        for x := 0 to array_foto.size - 1 do
        begin
                icone_usuario64 := array_foto.Get(x).GetValue<string>('foto_avatar');
                nome_usuario := array_foto.Get(x).GetValue<string>('nome');
                localizacao := array_foto.Get(x).GetValue<string>('local');
                foto64 := array_foto.Get(x).GetValue<string>('foto');
                descricao := array_foto.Get(x).GetValue<string>('descricao');
                qtd_curtida := array_foto.Get(x).GetValue<string>('qtd_like');

                if x = 0 then
                        ind_curtir := true
                else
                        ind_curtir := false;

                Add_Foto(icone_usuario64, nome_usuario, localizacao, foto64,
                   descricao, strtoint(qtd_curtida), ind_curtir);
        end;
end;

procedure TFrm_Principal.ActTabLeftUpdate(Sender: TObject);
begin
        if TabControl.ActiveTab = TabMensagem then
                ActTabLeft.Tab := nil
        else
        begin
                if TabControl.ActiveTab = TabCamera then
                        ActTabLeft.Tab := TabTimeline
                else
                        ActTabLeft.Tab := TabMensagem;
        end;
end;

procedure TFrm_Principal.ActTabRightUpdate(Sender: TObject);
begin
        if TabControl.ActiveTab = TabCamera then
                ActTabRight.Tab := nil
        else
        begin
                if TabControl.ActiveTab = TabMensagem then
                        ActTabRight.Tab := TabTimeline
                else
                        ActTabRight.Tab := TabCamera;
        end;
end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
        TabControl.TabPosition := TTabPosition.None;
        TabControl.ActiveTab := TabTimeline;

        // Esconder os icones...
        img_icone_fav.Visible := false;
        img_icone_fav2.Visible := false;
        img_icone_comentario.Visible := false;
        img_icone_msg.Visible := false;
        img_icone_save.Visible := false;
        img_icone_save2.Visible := false;
        img_icone_opcoes.Visible := false;
        img_foto.Visible := false;
        img_borda.Visible := false;

        {$IFDEF ANDROID}
        PermissaoCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
        PermissaoReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
        PermissaoWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
        {$ENDIF}
end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
        {
        Add_Foto('', '99 Coders', 'São Paulo', '', 'Convite para meus amigos...', 37);
        Add_Foto('', '99 Coders', 'São Paulo', '', 'Vida de programador...', 1);
        Add_Foto('', '99 Coders', 'São Paulo', '', 'Acessem o blog', 0);
        }
        Busca_Foto_Servidor();
end;

procedure TFrm_Principal.img_btn_fotoClick(Sender: TObject);
begin
        {$IFDEF ANDROID}
        PermissionsService.RequestPermissions([PermissaoCamera,
                                               PermissaoReadStorage,
                                               PermissaoWriteStorage],
                                               TakePicturePermissionRequestResult,
                                               DisplayMessageCamera
                                               );
        {$ENDIF}

        {$IFDEF IOS}
        ActPhotoCamera.Execute;
        {$ENDIF}
end;

procedure TFrm_Principal.lv_fotoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
        img : TListItemImage;
begin
        if TListView(sender).Selected <> nil then
        begin
                // clique em uma imagem...
                if ItemObject is TListItemImage then
                begin
                        // icone curtir / descurtir...
                        if TListItemImage(ItemObject).Name = 'Image6' then
                        begin
                                if TListItemImage(ItemObject).TagFloat = 0 then
                                begin
                                        TListItemImage(ItemObject).Bitmap := img_icone_fav2.Bitmap;
                                        TListItemImage(ItemObject).TagFloat := 1;
                                end
                                else
                                begin
                                        TListItemImage(ItemObject).Bitmap := img_icone_fav.Bitmap;
                                        TListItemImage(ItemObject).TagFloat := 0;
                                end;
                        end;


                end;
        end;
end;

procedure TFrm_Principal.lv_fotoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
        img, img_icone : TListItemImage;
        txt : TListItemText;
begin
        with AItem do
        begin
                // Foto da timeline...
                img := TListItemImage(Objects.FindDrawable('Image5'));
                img.OwnsBitmap := true;
                img.Width := Frm_Principal.Width;
                img.Height := img.Width;

                AItem.Height := trunc(img.PlaceOffset.Y + img.Height);


                // Icone curtir...
                img_icone := TListItemImage(Objects.FindDrawable('Image6'));
                img_icone.OwnsBitmap := true;
                if img_icone.TagFloat = 0 then
                        img_icone.Bitmap := img_icone_fav.Bitmap
                else
                        img_icone.Bitmap := img_icone_fav2.Bitmap;

                img_icone.PlaceOffset.Y := trunc(img.PlaceOffset.Y + img.Height + 2);

                // Icone comentarios...
                img_icone := TListItemImage(Objects.FindDrawable('Image7'));
                img_icone.OwnsBitmap := true;
                img_icone.Bitmap := img_icone_comentario.Bitmap;
                img_icone.PlaceOffset.Y := trunc(img.PlaceOffset.Y + img.Height + 2);

                // Icone mensagens...
                img_icone := TListItemImage(Objects.FindDrawable('Image8'));
                img_icone.OwnsBitmap := true;
                img_icone.Bitmap := img_icone_msg.Bitmap;
                img_icone.PlaceOffset.Y := trunc(img.PlaceOffset.Y + img.Height + 2);

                // Icone salvar...
                img_icone := TListItemImage(Objects.FindDrawable('Image9'));
                img_icone.OwnsBitmap := true;
                img_icone.Bitmap := img_icone_save.Bitmap;
                img_icone.PlaceOffset.Y := trunc(img.PlaceOffset.Y + img.Height + 2);

                // Qtd curtidas...
                txt := TListItemText(Objects.FindDrawable('Text10'));
                txt.Font.Size := 11;
                txt.PlaceOffset.Y := trunc(img.PlaceOffset.Y + img.Height + 42);


                // Descricao da foto...
                txt := TListItemText(Objects.FindDrawable('Text11'));
                txt.Font.Size := 11;
                txt.WordWrap := true;
                txt.PlaceOffset.Y := trunc(img.PlaceOffset.Y + img.Height + 82);
                txt.Width := Frm_Principal.Width - 10;
                txt.Height := GetTextHeight(txt, txt.Width, txt.Text) + 3;


                AItem.Height := trunc(txt.PlaceOffset.Y + txt.Height + 20);
        end;
end;

end.
