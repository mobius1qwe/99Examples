unit UnitCategoria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.JSON, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TFrmCategoria = class(TForm)
    rect_tb_cat: TRectangle;
    Label7: TLabel;
    rect_fechar: TImage;
    TabControl: TTabControl;
    TabCategoria: TTabItem;
    TabGrupo: TTabItem;
    Rectangle1: TRectangle;
    Label1: TLabel;
    img_voltar: TImage;
    lv_categoria: TListView;
    img_selecionar: TImage;
    img_mais: TImage;
    lv_grupo: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lv_categoriaItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure img_voltarClick(Sender: TObject);
    procedure lv_grupoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure rect_fecharClick(Sender: TObject);
  private
    procedure AddCategoria(categoria, descricao: string);
    procedure ListarCategoria;
    procedure ProcessarCategoria;
    procedure ProcessarCategoriaErro(Sender: TObject);
    procedure AddGrupo(grupo, descricao: string);
    procedure ProcessarGrupo;
    procedure ListarGrupo(cat: string);
  public
    categoria, grupo : string;
    request_categoria, request_grupo : TRESTRequest;
  end;

var
  FrmCategoria: TFrmCategoria;

implementation

{$R *.fmx}

procedure TFrmCategoria.AddCategoria(categoria, descricao : string);
begin
    with lv_categoria.Items.Add do
    begin
        TagString := categoria;
        Height := 80;

        TListItemText(Objects.FindDrawable('TxtNome')).Text := categoria;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemImage(Objects.FindDrawable('ImgBotao')).Bitmap := img_mais.Bitmap;
    end;
end;

procedure TFrmCategoria.AddGrupo(grupo, descricao : string);
begin
    with lv_grupo.Items.Add do
    begin
        TagString := grupo;
        Height := 120;

        TListItemText(Objects.FindDrawable('TxtNome')).Text := grupo;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemImage(Objects.FindDrawable('ImgBotao')).Bitmap := img_selecionar.Bitmap;
    end;
end;

procedure TFrmCategoria.ProcessarCategoria;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin

    try
        json := request_categoria.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        // Se deu erro...
        if request_categoria.Response.StatusCode <> 200 then
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
        // Popular listview das categorias...
        lv_categoria.Items.Clear;
        lv_categoria.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddCategoria(jsonArray.Get(i).GetValue<string>('CATEGORIA', ''),
                         jsonArray.Get(i).GetValue<string>('DESCRICAO', ''));
        end;

        jsonArray.DisposeOf;

    finally
        lv_categoria.EndUpdate;
        lv_categoria.RecalcSize;
    end;

end;

procedure TFrmCategoria.ProcessarGrupo;
var
    jsonArray : TJsonArray;
    json, retorno, id_usuario, nome: string;
    i : integer;
begin

    try
        json := request_grupo.Response.JSONValue.ToString;
        jsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONArray;

        // Se deu erro...
        if request_grupo.Response.StatusCode <> 200 then
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
        lv_grupo.Items.Clear;
        lv_grupo.BeginUpdate;

        for i := 0 to jsonArray.Size - 1 do
        begin
            AddGrupo(jsonArray.Get(i).GetValue<string>('GRUPO', ''),
                     jsonArray.Get(i).GetValue<string>('DESCRICAO', ''));
        end;

        jsonArray.DisposeOf;

    finally
        lv_grupo.EndUpdate;
        lv_grupo.RecalcSize;
    end;

end;

procedure TFrmCategoria.rect_fecharClick(Sender: TObject);
begin
    categoria := '';
    grupo := '';
    close;
end;

procedure TFrmCategoria.ProcessarCategoriaErro(Sender: TObject);
begin
    if Assigned(Sender) and (Sender is Exception) then
        ShowMessage(Exception(Sender).Message);
end;

procedure TFrmCategoria.ListarCategoria;
begin
    // Buscar categorias no servidor...
    request_categoria.Params.Clear;
    request_categoria.ExecuteAsync(ProcessarCategoria, true, true, ProcessarCategoriaErro);
end;

procedure TFrmCategoria.ListarGrupo(cat: string);
begin
    // Buscar categorias no servidor...
    request_grupo.Params.Clear;
    request_grupo.AddParameter('categoria', categoria);
    request_grupo.ExecuteAsync(ProcessarGrupo, true, true, ProcessarCategoriaErro);
end;


procedure TFrmCategoria.lv_categoriaItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    categoria := Aitem.TagString;
    TabControl.GotoVisibleTab(1, TTabTransition.Slide);

    ListarGrupo(categoria);
end;

procedure TFrmCategoria.lv_grupoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    grupo := Aitem.TagString;
    close;
end;

procedure TFrmCategoria.FormCreate(Sender: TObject);
begin
    img_selecionar.Visible := false;
    img_mais.Visible := false;
end;

procedure TFrmCategoria.FormShow(Sender: TObject);
begin
    categoria := '';
    grupo := '';
    TabControl.ActiveTab := TabCategoria;
    ListarCategoria;
end;

procedure TFrmCategoria.img_voltarClick(Sender: TObject);
begin
    categoria := '';
    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

end.
