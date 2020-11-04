unit uHorizontalMenu;

interface

uses FMX.Layouts, FMX.Objects, FMX.Types, FMX.Graphics, System.UITypes,
     System.Classes, System.Types, System.SysUtils, FMX.Forms, FMX.StdCtrls,
     FMX.Ani, System.Actions, FMX.ActnList, System.JSON, System.Net.HttpClient,
     FMX.Dialogs, IdHTTP ;

type
  TExecutaClickWin = procedure(Sender: TObject) of Object;
  TExecutaClickMobile = procedure(Sender: TObject; const Point: TPointF) of Object;

  THorizontalMenu = class
  private
    FMarginPadrao : integer;
    FHorizBox : THorzScrollBox;
    MoverObj : boolean;
    Offset : TPointF;
    ViewPort : Single;
    QtdItem : integer;
    Rect : TRectangle;
    Lyt: TLayout;
    lbl: TLabel;
    ContDownload : integer;
  protected

  public
    constructor Create(Owner : TComponent);

    procedure AddItem( codItem: string = '';
                       bgImage : TBitmap = nil;
                       urlImage : string = '';
                       itemWidth : Integer = 100;
                       bgColor : cardinal = $FFFFFFFF;
                       borderRadius : integer = 0;
                       fontColor : cardinal = $FFCCCCCC;
                       itemText : string = '';

                       {$IFDEF MSWINDOWS}
                       ACallBack: TExecutaClickWin = nil
                       {$ELSE}
                       ACallBack: TExecutaClickMobile = nil
                       {$ENDIF}
                       );
    procedure LoadFromJSON(strJson : string;
                           {$IFDEF MSWINDOWS}
                           ACallBack: TExecutaClickWin = nil
                           {$ELSE}
                           ACallBack: TExecutaClickMobile = nil
                           {$ENDIF});

    procedure LoadFromWS(urlWS : string;
                         {$IFDEF MSWINDOWS}
                         ACallBack: TExecutaClickWin = nil
                         {$ELSE}
                         ACallBack: TExecutaClickMobile = nil
                         {$ENDIF});

    procedure DeleteAll();
    procedure DeleteItem(index: integer);
  published
    property MarginPadrao: integer read FMarginPadrao write FMarginPadrao;
  end;


implementation

constructor THorizontalMenu.Create(Owner : TComponent);
begin
    FHorizBox := Owner as THorzScrollBox;

    // Margin direita do ultimo item...
    lyt := TLayout.Create(FHorizBox);
    lyt.Parent := FHorizBox;
    lyt.Width := 20;
    lyt.Align := TAlignLayout.Left;
    lyt.Tag := -1;

end;


function LoadStreamFromURL1(url : string): TMemoryStream;
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


procedure THorizontalMenu.AddItem( codItem: string = '';
                                   bgImage : TBitmap = nil;
                                   urlImage : string = '';
                                   itemWidth : Integer = 100;
                                   bgColor : cardinal = $FFFFFFFF;
                                   borderRadius : integer = 0;
                                   fontColor : cardinal = $FFCCCCCC;
                                   itemText : string = '';
                                   {$IFDEF MSWINDOWS}
                                   ACallBack: TExecutaClickWin = nil
                                   {$ELSE}
                                   ACallBack: TExecutaClickMobile = nil
                                   {$ENDIF}
                                   );
var
    rect : TRectangle;
    stream : TMemoryStream;
    bmp : TBitmap;
begin
    Inc(QtdItem);

    lyt := TLayout.Create(FHorizBox);
    lyt.Margins.Left := FMarginPadrao;
    lyt.Align := TAlignLayout.MostLeft;
    lyt.Width := itemWidth;
    lyt.Parent := FHorizBox;
    lyt.Opacity := 0;
    lyt.HitTest := true;
    lyt.TagString := codItem;
    lyt.Tag := QtdItem;

    {$IFDEF MSWINDOWS}
    lyt.OnClick := ACallBack;
    {$ELSE}
    lyt.OnTap := ACallBack;
    {$ENDIF}


    // Adiciona texto...
    lbl := TLabel.Create(lyt);
    lbl.Text := itemText;
    lbl.Align := TAlignLayout.Bottom;
    lbl.TextAlign := TTextAlign.Center;
    lbl.VertTextAlign := TTextAlign.Center;
    lbl.FontColor := fontColor;
    lbl.Height := 20;
    lbl.Margins.Top := 5;
    lbl.Visible := true;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size];
    lbl.Font.Size := 13;
    lbl.HitTest := false;
    Lyt.AddObject(lbl);

    // Adiciona rect...
    rect := TRectangle.Create(lyt);
    rect.Align := TAlignLayout.Client;
    rect.Fill.Color := bgColor;
    rect.Fill.Kind := TBrushKind.Solid;
    rect.Stroke.Kind := TBrushKind.None;
    rect.XRadius := borderRadius;
    rect.YRadius := borderRadius;
    rect.Visible := true;
    rect.Tag := QtdItem - 1;
    rect.Width := itemWidth;
    rect.HitTest := false;

    if bgImage <> nil then
    begin
        rect.Fill.Kind := TBrushKind.Bitmap;
        rect.Fill.Bitmap.Bitmap := bgImage;
        rect.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    end
    else
    if urlImage <> '' then
    begin
        rect.Fill.Color := $FFF6F6F6;

        //TThread.CreateAnonymousThread(procedure
        //var
        //    stream : TMemoryStream;
        //    bmp : TBitmap;
        //begin
            stream := LoadStreamFromURL1(urlImage);
            bmp := TBitmap.CreateFromStream(stream);

            //TThread.Synchronize(TThread.CurrentThread, procedure
            //begin
                rect.Fill.Kind := TBrushKind.Bitmap;
                rect.Fill.Bitmap.Bitmap := bmp;
                rect.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
                rect.Repaint;

                bmp.DisposeOf;
                stream.DisposeOf;
            //end);

        //end).Start;
    end;

    lyt.AddObject(rect);


    // Exibe o item...
    TAnimator.AnimateFloat(lyt, 'Opacity', 1, 0.3);
end;


procedure THorizontalMenu.LoadFromJSON(strJson : string;
                                       {$IFDEF MSWINDOWS}
                                       ACallBack: TExecutaClickWin = nil
                                       {$ELSE}
                                       ACallBack: TExecutaClickMobile = nil
                                       {$ENDIF});
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
                            JsonObj.Get('itemWidth').JsonValue.Value.ToInteger,
                            JsonObj.Get('bgColor').JsonValue.Value.ToInteger,
                            JsonObj.Get('borderRadius').JsonValue.Value.ToInteger,
                            JsonObj.Get('fontColor').JsonValue.Value.ToInteger,
                            JsonObj.Get('itemText').JsonValue.Value,
                            ACallBack
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



procedure THorizontalMenu.LoadFromWS(urlWS : string;
                                       {$IFDEF MSWINDOWS}
                                       ACallBack: TExecutaClickWin = nil
                                       {$ELSE}
                                       ACallBack: TExecutaClickMobile = nil
                                       {$ENDIF});
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

            LoadFromJSON(strJson, ACallBack);

    finally
            http.DisposeOf;
    end;
end;







procedure THorizontalMenu.DeleteAll();
var
        i : integer;
        layout : TLayout;
begin
    try

        for i := FHorizBox.ComponentCount - 1 downto 0 do
        begin
            if (UpperCase(FHorizBox.Components[i].ClassName) = 'TLAYOUT') and
               (FHorizBox.Components[i].tag >= 0) then
            begin
                layout := TLayout(FHorizBox.Components[i]);
                layout.DisposeOf;
            end;
        end;

    finally
    end;
end;

procedure THorizontalMenu.DeleteItem(index: integer);
var
        i : integer;
        layout : TLayout;
begin
    try

        {
        for i := FHorizBox.ComponentCount - 1 downto 0 do
        begin
            if (UpperCase(FHorizBox.Components[i].ClassName) = 'TLAYOUT') then
            begin
                layout := TLayout(FHorizBox.Components[i]);

                // Esconde o item...
                TAnimator.AnimateFloat(layout, 'Opacity', 0, 0.5);

                TThread.CreateAnonymousThread(procedure
                begin
                    sleep(550);
                    layout.DisposeOf;
                end).Start;

            end;
        end;
        }
    finally
    end;
end;

end.
