unit UnitCatalogoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Layouts,
  uFunctions, System.JSON, FMX.DialogService;

type
  TFrmCatalogoCad = class(TForm)
    rect_toolbar: TRectangle;
    img_close: TImage;
    img_excluir: TImage;
    lbl_titulo: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    edt_nome: TEdit;
    Rectangle1: TRectangle;
    btn_salvar: TSpeedButton;
    c_foto: TCircle;
    Label3: TLabel;
    OpenDialog: TOpenDialog;
    procedure btn_salvarClick(Sender: TObject);
    procedure img_closeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure img_excluirClick(Sender: TObject);
    procedure c_fotoClick(Sender: TObject);
  private
    procedure ProcessarCatalogo;
    procedure ProcessarCatalogoErro(Sender: TObject);
    function ExcluirCatalogo(id_catalogo: integer): boolean;
    { Private declarations }
  public
    { Public declarations }
    modo : string;
    id_catalogo: integer;
  end;

var
  FrmCatalogoCad: TFrmCatalogoCad;

implementation

{$R *.fmx}

uses UnitDM, UnitPrincipal, REST.Types;

procedure TFrmCatalogoCad.FormShow(Sender: TObject);
begin
    img_excluir.Visible := modo = 'A';
end;

procedure TFrmCatalogoCad.img_closeClick(Sender: TObject);
begin
    close;
end;

procedure TFrmCatalogoCad.c_fotoClick(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    if OpenDialog.Execute then
        c_foto.Fill.Bitmap.Bitmap.LoadFromFile(OpenDialog.FileName);
    {$ELSE}

    {$ENDIF}
end;

function TFrmCatalogoCad.ExcluirCatalogo(id_catalogo: integer): boolean;
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    try
        Result := false;

        // Buscar produtos no servidor...
        dm.ReqCatalogoCad.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
        dm.ReqCatalogoCad.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
        dm.ReqCatalogoCad.Method := rmDELETE;
        dm.ReqCatalogoCad.Execute;


        // Se deu erro...
        if (dm.ReqCatalogoCad.Response.StatusCode <> 200) then
            exit;

        try
            json := dm.ReqCatalogoCad.Response.JSONValue.ToString;
            jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

            retorno := jsonObj.GetValue('retorno').Value;

            if retorno <> 'OK' then
                ShowMessage(retorno)
            else
                close;

        finally
            jsonObj.DisposeOf;
        end;

    except on ex:exception do
        showmessage(ex.Message);
    end;
end;

procedure TFrmCatalogoCad.img_excluirClick(Sender: TObject);
begin
    TDialogService.MessageDialog('Confirma exclusão?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
            procedure(const AResult: TModalResult)
            var
                erro: string;
            begin
                if AResult = mrYes then
                    ExcluirCatalogo(id_catalogo);
            end);
end;

procedure TFrmCatalogoCad.ProcessarCatalogo;
var
    jsonObj : TJSONObject;
    json, retorno : string;
    i : integer;
begin
    try
        // Se deu erro...
        if (dm.ReqCatalogoCad.Response.StatusCode <> 200) and
           (dm.ReqCatalogoCad.Response.StatusCode <> 201) then
        begin
            showmessage('Erro ao enviar dados do catálogo');
            exit;
        end;

        try
            json := dm.ReqCatalogoCad.Response.JSONValue.ToString;
            jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

            retorno := jsonObj.GetValue('retorno').Value;

            if retorno <> 'OK' then
                ShowMessage(retorno)
            else
                close;

        finally
            jsonObj.DisposeOf;
        end;

    except on ex:exception do
            showmessage(ex.Message);
    end;
end;

procedure TFrmCatalogoCad.ProcessarCatalogoErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmCatalogoCad.btn_salvarClick(Sender: TObject);
var
    foto : TBitmap;
begin
    try
        foto := c_foto.MakeScreenshot;

        // Envia catalogo para o server...
        dm.ReqCatalogoCad.Params.ParameterByName('id_usuario').Value := FrmPrincipal.id_usuario.ToString;
        dm.ReqCatalogoCad.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
        dm.ReqCatalogoCad.Params.ParameterByName('nome').Value := edt_nome.Text;
        dm.ReqCatalogoCad.Params.ParameterByName('foto').Value := TFunctions.Base64FromBitmap(foto);

        if modo = 'I' then
            dm.ReqCatalogoCad.Method := rmPOST
        else
            dm.ReqCatalogoCad.Method := rmPATCH;

        dm.ReqCatalogoCad.ExecuteAsync(ProcessarCatalogo, true, true, ProcessarCatalogoErro);
    finally
        foto.DisposeOf;
    end;
end;

end.
