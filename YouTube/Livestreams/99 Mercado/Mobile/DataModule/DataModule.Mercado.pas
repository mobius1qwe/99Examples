unit DataModule.Mercado;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RESTRequest4D, DataSet.Serialize.Config, uConsts, FireDAC.Stan.Async,
  FireDAC.DApt, Math, System.JSON;

type
  TDmMercado = class(TDataModule)
    TabMercado: TFDMemTable;
    TabCategoria: TFDMemTable;
    TabProduto: TFDMemTable;
    TabProdDetalhe: TFDMemTable;
    QryMercado: TFDQuery;
    QryCarrinho: TFDQuery;
    QryCarrinhoItem: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ListarMercado(busca, ind_entrega, ind_retira: string);
    procedure ListarMercadoId(id_mercado: integer);
    procedure ListarCategoria(id_mercado: integer);
    procedure ListarProduto(id_mercado, id_categoria: integer; busca: string);
    procedure ListarProdutoId(id_produto: integer);
    function ExistePedidoLocal(id_mercado: integer): boolean;
    procedure LimparCarrinhoLocal;
    procedure AdicionarCarrinhoLocal(id_mercado: integer; Nome_mercado,
                            Endereco: string; Taxa_entrega: double);
    procedure AdicionarItemCarrinhoLocal(Id_produto: integer; url_foto, nome,
                          unidade: string; qtd, valor_unitario: double);
    procedure ListarCarrinhoLocal;
    procedure ListarItemCarrinhoLocal;
    function JsonPedido(vl_subtotal, vl_entrega, vl_total: double): TJsonObject;
    function JsonPedidoItem: TJsonArray;
    procedure InserirPedido(jsonPed: TJsonObject);
  end;

var
  DmMercado: TDmMercado;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses DataModule.Usuario;

{$R *.dfm}

procedure TDmMercado.DataModuleCreate(Sender: TObject);
begin
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
end;

procedure TDmMercado.ListarMercado(busca, ind_entrega, ind_retira: string);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .DataSetAdapter(TabMercado)
            .AddParam('busca', busca)
            .AddParam('ind_entrega', ind_entrega)
            .AddParam('ind_retira', ind_retira)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

procedure TDmMercado.ListarMercadoId(id_mercado: integer);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .ResourceSuffix(id_mercado.ToString)
            .DataSetAdapter(TabMercado)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

procedure TDmMercado.ListarCategoria(id_mercado: integer);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .ResourceSuffix(id_mercado.ToString + '/categorias')
            .DataSetAdapter(TabCategoria)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

procedure TDmMercado.ListarProduto(id_mercado, id_categoria: integer; busca: string);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('mercados')
            .ResourceSuffix(id_mercado.ToString + '/produtos')
            .AddParam('id_categoria', id_categoria.ToString)
            .AddParam('busca', busca)
            .DataSetAdapter(TabProduto)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

procedure TDmMercado.ListarProdutoId(id_produto: integer);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('produtos')
            .ResourceSuffix(id_produto.ToString)
            .DataSetAdapter(TabProdDetalhe)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Get;

    if (resp.StatusCode <> 200) then
        raise Exception.Create(resp.Content);
end;

function TDmMercado.ExistePedidoLocal(id_mercado: integer): boolean;
begin
    with QryMercado do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_CARRINHO WHERE ID_MERCADO <> :ID_MERCADO');
        ParamByName('ID_MERCADO').Value := id_mercado;
        Active := true;

        Result := RecordCount > 0;
    end;
end;

procedure TDmMercado.LimparCarrinhoLocal;
begin
    with QryCarrinho do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('DELETE FROM TAB_CARRINHO');
        ExecSQL;

        Active := false;
        SQL.Clear;
        SQL.Add('DELETE FROM TAB_CARRINHO_ITEM');
        ExecSQL;
    end;
end;

procedure TDmMercado.AdicionarCarrinhoLocal(id_mercado: integer;
                                       Nome_mercado, Endereco: string;
                                       Taxa_entrega: double);
begin
    with QryCarrinho do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_CARRINHO');
        Active := true;

        if RecordCount = 0 then
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('INSERT INTO TAB_CARRINHO(ID_MERCADO, NOME_MERCADO, ENDERECO_MERCADO, TAXA_ENTREGA)');
            SQL.Add('VALUES(:ID_MERCADO, :NOME_MERCADO, :ENDERECO_MERCADO, :TAXA_ENTREGA)');
            ParamByName('ID_MERCADO').Value := id_mercado;
            ParamByName('NOME_MERCADO').Value := Nome_mercado;
            ParamByName('ENDERECO_MERCADO').Value := Endereco;
            ParamByName('TAXA_ENTREGA').Value := roundto(Taxa_entrega, -2);
            ExecSQL;
        end;
    end;
end;

procedure TDmMercado.ListarCarrinhoLocal;
begin
    with QryCarrinho do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_CARRINHO');
        Active := true;
    end;
end;

procedure TDmMercado.AdicionarItemCarrinhoLocal(Id_produto: integer;
                                           url_foto, nome, unidade: string;
                                           qtd, valor_unitario: double);
begin
    with QryCarrinho do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('INSERT INTO TAB_CARRINHO_ITEM(ID_PRODUTO, URL_FOTO, NOME, UNIDADE, QTD, VALOR_UNITARIO, VALOR_TOTAL)');
        SQL.Add('VALUES(:ID_PRODUTO, :URL_FOTO, :NOME, :UNIDADE, :QTD, :VALOR_UNITARIO, :VALOR_TOTAL)');
        ParamByName('ID_PRODUTO').Value := Id_produto;
        ParamByName('URL_FOTO').Value := url_foto;
        ParamByName('NOME').Value := nome;
        ParamByName('UNIDADE').Value := unidade;
        ParamByName('QTD').Value := qtd;
        ParamByName('VALOR_UNITARIO').Value := roundto(valor_unitario, -2);
        ParamByName('VALOR_TOTAL').Value := roundto(valor_unitario * qtd, -2);
        ExecSQL;
    end;
end;

procedure TDmMercado.ListarItemCarrinhoLocal;
begin
    with QryCarrinhoItem do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT * FROM TAB_CARRINHO_ITEM');
        Active := true;
    end;
end;

function TDmMercado.JsonPedido(vl_subtotal, vl_entrega, vl_total: double): TJsonObject;
var
    jsonPed: TJSONObject;
begin
    ListarCarrinhoLocal;
    DmUsuario.ListarUsuarioLocal;

    jsonPed := TJSONObject.Create;

    jsonPed.AddPair('id_mercado', TJSONNumber.Create(QryCarrinho.FieldByName('id_mercado').AsInteger));
    jsonPed.AddPair('id_usuario', TJSONNumber.Create(DmUsuario.QryUsuario.FieldByName('id_usuario').AsInteger));
    jsonPed.AddPair('vl_subtotal', TJSONNumber.Create(vl_subtotal));
    jsonPed.AddPair('vl_entrega', TJSONNumber.Create(vl_entrega));
    jsonPed.AddPair('vl_total', TJSONNumber.Create(vl_total));
    jsonPed.AddPair('endereco', DmUsuario.QryUsuario.FieldByName('endereco').AsString);
    jsonPed.AddPair('bairro', DmUsuario.QryUsuario.FieldByName('bairro').AsString);
    jsonPed.AddPair('cidade', DmUsuario.QryUsuario.FieldByName('cidade').AsString);
    jsonPed.AddPair('uf', DmUsuario.QryUsuario.FieldByName('uf').AsString);
    jsonPed.AddPair('cep', DmUsuario.QryUsuario.FieldByName('cep').AsString);

    Result := jsonPed;
end;

function TDmMercado.JsonPedidoItem: TJsonArray;
var
    arrayItem: TJsonArray;
    objJSON: TJSONObject;
begin
    ListarItemCarrinhoLocal;

    arrayItem := TJsonArray.Create;

    with QryCarrinhoItem do
    begin
        while NOT Eof do
        begin
            objJSON := TJSONObject.Create;

            objJSON.AddPair('id_produto', TJSONNumber.Create(FieldByName('id_produto').AsInteger));
            objJSON.AddPair('qtd', TJSONNumber.Create(FieldByName('qtd').AsInteger));
            objJSON.AddPair('vl_unitario', TJSONNumber.Create(FieldByName('valor_unitario').AsFloat));
            objJSON.AddPair('vl_total', TJSONNumber.Create(FieldByName('valor_total').AsFloat));

            arrayItem.AddElement(objJSON);

            Next;
        end;
    end;

    Result := arrayItem;
end;

procedure TDmMercado.InserirPedido(jsonPed: TJsonObject);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('pedidos')
            .AddBody(jsonPed.ToJSON)
            .Accept('application/json')
            .BasicAuthentication(USER_NAME, PASSWORD)
            .Post;

    if (resp.StatusCode <> 201) then
        raise Exception.Create(resp.Content);
end;

end.
