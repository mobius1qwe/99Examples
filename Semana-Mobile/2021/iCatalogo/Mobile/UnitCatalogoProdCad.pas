unit UnitCatalogoProdCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation, REST.Types,
  REST.Client, REST.Authenticator.Basic, Data.Bind.Components,
  Data.Bind.ObjectScope, uFunctions, System.JSON, FMX.DialogService;

type
  TFrmCatalogoProdCad = class(TForm)
    rect_toolbar: TRectangle;
    img_voltar: TImage;
    img_excluir: TImage;
    lbl_titulo: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    edt_nome: TEdit;
    Layout2: TLayout;
    Label3: TLabel;
    edt_preco: TEdit;
    Layout3: TLayout;
    Label4: TLabel;
    edt_promocao: TEdit;
    Layout4: TLayout;
    Label5: TLabel;
    Rectangle1: TRectangle;
    btn_salvar: TSpeedButton;
    c_foto: TCircle;
    Label6: TLabel;
    Switch: TSwitch;
    OpenDialog: TOpenDialog;
    procedure btn_salvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure c_fotoClick(Sender: TObject);
    procedure img_excluirClick(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
  private
    procedure ProcessarProduto;
    procedure ProcessarProdutoErro(Sender: TObject);
    function ExcluirProduto: boolean;
    { Private declarations }
  public
    { Public declarations }
    id_catalogo, id_produto : integer;
    modo : string; // I=Inclusao / A=Alteracao
  end;

var
  FrmCatalogoProdCad: TFrmCatalogoProdCad;

implementation

{$R *.fmx}

uses UnitDM;

procedure TFrmCatalogoProdCad.c_fotoClick(Sender: TObject);
begin
    {$IFDEF MSWINDOWS}
    if OpenDialog.Execute then
        c_foto.Fill.Bitmap.Bitmap.LoadFromFile(OpenDialog.FileName);
    {$ELSE}

    {$ENDIF}
end;

procedure TFrmCatalogoProdCad.FormShow(Sender: TObject);
begin
    img_excluir.Visible := modo = 'A';
end;

function TFrmCatalogoProdCad.ExcluirProduto: boolean;
var
    json, retorno : string;
    jsonObj : TJSONObject;
begin
    try
        Result := false;

        // Buscar produtos no servidor...
        dm.ReqProdutoCad.Params.ParameterByName('id_produto').Value := id_produto.ToString;
        dm.ReqProdutoCad.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
        dm.ReqProdutoCad.Method := rmDELETE;
        dm.ReqProdutoCad.Execute;


        // Se deu erro...
        if (dm.ReqProdutoCad.Response.StatusCode <> 200) then
            exit;

        try
            json := dm.ReqProdutoCad.Response.JSONValue.ToString;
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

procedure TFrmCatalogoProdCad.img_excluirClick(Sender: TObject);
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
                    ExcluirProduto;
            end);
end;

procedure TFrmCatalogoProdCad.img_voltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmCatalogoProdCad.ProcessarProduto;
var
    jsonObj : TJSONObject;
    json, retorno : string;
    i : integer;
begin
    try
        // Se deu erro...
        if (dm.ReqProdutoCad.Response.StatusCode <> 200) and
           (dm.ReqProdutoCad.Response.StatusCode <> 201) then
        begin
            showmessage('Erro ao enviar dados do produto');
            exit;
        end;

        try
            json := dm.ReqProdutoCad.Response.JSONValue.ToString;
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

procedure TFrmCatalogoProdCad.ProcessarProdutoErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmCatalogoProdCad.btn_salvarClick(Sender: TObject);
begin
    // Envia produto para o server...
    dm.ReqProdutoCad.Params.ParameterByName('id_catalogo').Value := id_catalogo.ToString;
    dm.ReqProdutoCad.Params.ParameterByName('foto').Value := TFunctions.Base64FromBitmap(c_foto.Fill.Bitmap.Bitmap);
    dm.ReqProdutoCad.Params.ParameterByName('preco').Value := edt_preco.Text;
    dm.ReqProdutoCad.Params.ParameterByName('preco_promocao').Value := edt_promocao.Text;
    dm.ReqProdutoCad.Params.ParameterByName('ind_destaque').Value := TFunctions.iifs(Switch.IsChecked, 'S', 'N');
    dm.ReqProdutoCad.Params.ParameterByName('nome').Value := edt_nome.Text;
    dm.ReqProdutoCad.Params.ParameterByName('id_produto').Value := id_produto.ToString;

    if modo = 'I' then
        dm.ReqProdutoCad.Method := rmPOST
    else
        dm.ReqProdutoCad.Method := rmPATCH;

    dm.ReqProdutoCad.ExecuteAsync(ProcessarProduto, true, true, ProcessarProdutoErro);
end;

end.
