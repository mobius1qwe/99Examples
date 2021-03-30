unit UnitClassificacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TFrmClassificar = class(TForm)
    rect_avaliar: TRectangle;
    Label11: TLabel;
    lbl_titulo: TLabel;
    Layout7: TLayout;
    img1: TImage;
    Img4: TImage;
    Img3: TImage;
    Img2: TImage;
    Img5: TImage;
    img_vazia: TImage;
    img_cheia: TImage;
    procedure img1Click(Sender: TObject);
    procedure rect_avaliarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    avaliacao : integer;
    procedure Avaliar(nota: integer);
    function DesenharEstrela(indCheia: boolean): TBitmap;
  public
    id_pedido: integer;
  end;

var
  FrmClassificar: TFrmClassificar;

implementation

{$R *.fmx}

uses UnitDM, UnitPrincipal, System.JSON;

function TFrmClassificar.DesenharEstrela(indCheia : boolean): TBitmap;
begin
    if indCheia then
        Result := img_cheia.Bitmap
    else
        Result := img_vazia.Bitmap;
end;

procedure TFrmClassificar.FormShow(Sender: TObject);
begin
    Avaliar(0);
end;

procedure TFrmClassificar.Avaliar(nota: integer);
begin
    avaliacao := nota;
    img1.Bitmap := DesenharEstrela(nota >= 1);
    img2.Bitmap := DesenharEstrela(nota >= 2);
    img3.Bitmap := DesenharEstrela(nota >= 3);
    img4.Bitmap := DesenharEstrela(nota >= 4);
    img5.Bitmap := DesenharEstrela(nota >= 5);
end;

procedure TFrmClassificar.img1Click(Sender: TObject);
begin
    Avaliar(TImage(Sender).Tag);
end;

procedure TFrmClassificar.rect_avaliarClick(Sender: TObject);
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    // tipo_avaliacao: C=Enviada pelo cliente | P=Enviada pelo prestador

    dm.RequestPedidoAvaliar.Params.Clear;
    dm.RequestPedidoAvaliar.AddParameter('id', '');
    dm.RequestPedidoAvaliar.AddParameter('id_usuario', FrmPrincipal.id_usuario_logado.ToString);
    dm.RequestPedidoAvaliar.AddParameter('id_pedido', id_pedido.ToString);
    dm.RequestPedidoAvaliar.AddParameter('tipo_avaliacao', 'C');
    dm.RequestPedidoAvaliar.AddParameter('avaliacao', avaliacao.ToString);
    dm.RequestPedidoAvaliar.Execute;

     try
        json := dm.RequestPedidoAvaliar.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        retorno := jsonObj.GetValue('retorno').Value;

        // Se deu erro...
        if dm.RequestPedidoAvaliar.Response.StatusCode <> 200 then
        begin
            showmessage(retorno);
            exit;
        end;

    finally
        jsonObj.DisposeOf;
    end;

    close;
end;

end.
