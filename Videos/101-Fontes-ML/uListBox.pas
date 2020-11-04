unit uListBox;

interface

uses FMX.Layouts, FMX.Objects, FMX.Types, FMX.Graphics, System.UITypes,
     System.Classes, System.Types, System.SysUtils, FMX.Forms, FMX.StdCtrls,
     FMX.Ani, System.Actions, FMX.ActnList, System.JSON, System.Net.HttpClient,
     FMX.Dialogs, IdHTTP, FMX.ListBox;

type
  TCustomListBox = class
  private
    FColumns : integer;
    FHeight : integer;
    FListBox : TListBox;

    Item : TListBoxItem;
    img : TImage;
    lbl: TLabel;
    ContDownload : integer;
  protected

  public
    constructor Create(Owner : TComponent);
    procedure Setup();

    procedure AddItem( codItem: string = '';
                       bgImage : TBitmap = nil;
                       urlImage : string = '';
                       itemPrice : double = 0;
                       itemDescr : string = ''
                       );
    procedure LoadFromJSON(strJson : string);

    procedure LoadFromWS(urlWS : string);

    procedure DeleteAll();
    procedure DeleteItem(index: integer);
  published
    property QtdColumns: integer read FColumns write FColumns;
    property ItemHeight: integer read FHeight write FHeight;
  end;


implementation

function LoadStreamFromURL(url : string): TMemoryStream;
var
        http : THTTPClient;
begin

    Result := TMemoryStream.Create;
    http := THTTPClient.Create;

    try

            try
                    // Evitar cache...
                    url := url + '?id=' + floattostr(Random);

                    http.Get(url, Result);

            except
            end;

            Result.Position := 0;
    finally
            http.DisposeOf;
    end;
end;

constructor TCustomListBox.Create(Owner : TComponent);
begin
    FListBox := Owner as TListBox;
end;

procedure TCustomListBox.Setup();
begin
    FListBox.Columns := FColumns;
    FListBox.ShowScrollBars := false;
end;

procedure TCustomListBox.AddItem( codItem: string = '';
                                   bgImage : TBitmap = nil;
                                   urlImage : string = '';
                                   itemPrice : double = 0;
                                   itemDescr : string = ''
                                   );
var
    stream : TMemoryStream;
    bmp : TBitmap;
begin
    Item := TListBoxItem.Create(FListBox);
    item.Text := '';
    Item.Height := FHeight;
    Item.TagString := codItem;

    // Adiciona descricao...
    lbl := TLabel.Create(Item);
    lbl.Text := itemDescr;
    lbl.Align := TAlignLayout.Bottom;
    lbl.TextAlign := TTextAlign.Leading;
    lbl.VertTextAlign := TTextAlign.Leading;
    lbl.Height := 30;
    lbl.Margins.Left := 10;
    lbl.Margins.Right := 10;
    lbl.Margins.Bottom := 35;
    lbl.Visible := true;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
    lbl.Font.Size := 11;
    lbl.FontColor := $FF8D8D8D;
    lbl.HitTest := false;
    Item.AddObject(lbl);



    // Adiciona preco...
    lbl := TLabel.Create(Item);
    lbl.Text := 'R$ ' + FormatFloat('#,##0.00', itemPrice);
    lbl.Align := TAlignLayout.Bottom;
    lbl.TextAlign := TTextAlign.Leading;
    lbl.VertTextAlign := TTextAlign.Leading;
    lbl.FontColor := $FF000000;
    lbl.Height := 20;
    lbl.Margins.Left := 10;
    lbl.Margins.Right := 10;
    lbl.Margins.Top := 5;
    lbl.Visible := true;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size];
    lbl.Font.Size := 16;
    lbl.HitTest := false;
    Item.AddObject(lbl);


    // Adiciona imagem...
    img := TImage.Create(Item);
    img.Align := TAlignLayout.Client;
    img.Visible := true;
    img.HitTest := false;
    img.WrapMode := TImageWrapMode.Fit;
    img.Margins.Left := 10;
    img.Margins.Right := 10;
    img.Margins.Top := 3;
    img.Margins.Bottom := 3;

    if bgImage <> nil then
        img.Bitmap := bgImage
    else
    if urlImage <> '' then
    begin
        //TThread.CreateAnonymousThread(procedure
        //var
        //    stream : TMemoryStream;
        //    bmp : TBitmap;
        //begin
            stream := LoadStreamFromURL(urlImage);
            bmp := TBitmap.CreateFromStream(stream);

        //    TThread.Synchronize(TThread.CurrentThread, procedure
        //    begin
                img.Bitmap := bmp;
                img.Repaint;

                bmp.DisposeOf;
                stream.DisposeOf;
        //    end);

        //end).Start;
    end;


    Item.AddObject(img);
    FListBox.AddObject(Item);

end;


procedure TCustomListBox.LoadFromJSON(strJson : string);
var
    JsonArray : TJSONArray;
    JsonObj : TJSONObject;
    i : integer;
begin
    try
        JsonArray := TJSONObject.ParseJSONValue(strJson) as TJSONArray;

        try
            if Assigned(JsonArray) then
            begin
                for i := 0 to JsonArray.Size - 1 do
                begin
                    JsonObj := JsonArray.Get(i) as TJSONObject;

                    AddItem(JsonObj.Get('codItem').JsonValue.Value,
                            nil, // bitmap...
                            JsonObj.Get('urlImage').JsonValue.Value,
                            JsonObj.Get('itemPrice').JsonValue.Value.ToDouble/100,
                            JsonObj.Get('itemDescr').JsonValue.Value
                            );

                end;
            end;
        finally
            JsonArray.DisposeOf;
        end;

    except
        showmessage('Json array inválido');
    end;

end;

procedure TCustomListBox.LoadFromWS(urlWS : string);
var
    http: TIdHTTP;
    strJson : string;
begin
    http := TIdHTTP.Create;

    try

            try
                    strJson := http.Get(urlWS);

            except
            end;

            LoadFromJSON(strJson);

    finally
            http.DisposeOf;
    end;
end;

procedure TCustomListBox.DeleteAll();
begin
    try
        FListBox.Items.Clear;
    finally
    end;
end;

procedure TCustomListBox.DeleteItem(index: integer);
var
        i : integer;
        layout : TLayout;
begin
    try
        FListBox.Items.Delete(index);
    finally
    end;
end;

end.
