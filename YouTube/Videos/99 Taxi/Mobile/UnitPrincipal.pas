unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Objects,
  FMX.Layouts, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls,
  System.JSON, System.NetEncoding, REST.Authenticator.Basic;

type
  TFrmPrincipal = class(TForm)
    RESTClient: TRESTClient;
    RequestCategoria: TRESTRequest;
    Image1: TImage;
    Rectangle1: TRectangle;
    Label1: TLabel;
    lb_categoria: TListBox;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    IndicatorCategoria: TAniIndicator;
    procedure FormShow(Sender: TObject);
    procedure lb_categoriaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure ListarCategoria;
    procedure AddCategoria(codigo, descricao: string; icone: TBitmap);
    function BitmapFromBase64(const base64: string): TBitmap;
    { Private declarations }
  public
    { Public declarations }
    cod_usuario : string;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitFrameCategoria;

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

procedure TFrmPrincipal.AddCategoria(codigo, descricao: string; icone: TBitmap);
var
    f : TFrameCategoria;
    item : TListBoxItem;
begin
    item := TListBoxItem.Create(lb_categoria);
    item.Text := '';
    item.Height := 135;
    //item.Align := TAlignLayout.Client;
    item.TagString := codigo;
    item.Selectable := false;
    item.Width := 210;

    f := TFrameCategoria.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;
    f.img_carro.Bitmap := icone;
    f.lbl_categoria.Text := codigo;
    f.lbl_descricao.Text := descricao;

    lb_categoria.AddObject(item);
end;

procedure TFrmPrincipal.ListarCategoria;
var
    codigo, descricao: string;
    icone: TBitmap;
begin
    lb_categoria.Visible := false;
    IndicatorCategoria.Enabled := true;
    IndicatorCategoria.Visible := true;

    lb_categoria.BeginUpdate;
    lb_categoria.Items.Clear;

    // Acessar o servidor...
    TThread.CreateAnonymousThread(procedure
    var
        jsonArray : TJsonArray;
        x : integer;
    begin
        RequestCategoria.Params.Clear;
        RequestCategoria.Execute;

        sleep(4000);

        if RequestCategoria.Response.StatusCode = 200 then
        begin
            jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(RequestCategoria.Response.JSONText), 0) as TJSONArray;

            for x := 0 to jsonArray.Size - 1 do
            begin
                codigo := jsonArray.Get(x).GetValue<string>('COD_CATEGORIA');
                descricao := jsonArray.Get(x).GetValue<string>('DESCRICAO');

                TThread.Synchronize(nil, procedure
                begin
                    icone := BitmapFromBase64(jsonArray.Get(x).GetValue<string>('ICONE'));
                    AddCategoria(codigo, descricao, icone);
                end);

                icone.DisposeOf;
            end;

            jsonArray.DisposeOf;
        end;

        TThread.Synchronize(nil, procedure
        begin
            lb_categoria.Visible := true;
            IndicatorCategoria.Enabled := false;
            IndicatorCategoria.Visible := false;

            lb_categoria.EndUpdate;
        end);

    end).Start;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    ListarCategoria;
end;

procedure TFrmPrincipal.lb_categoriaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    ShowMessage('Categoria: ' + Item.TagString);
end;

end.
