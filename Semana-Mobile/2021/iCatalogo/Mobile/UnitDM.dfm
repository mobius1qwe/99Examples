object dm: Tdm
  OldCreateOrder = False
  Height = 371
  Width = 460
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 64
    Top = 64
  end
  object ReqProdutoCons: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'id'
        Value = '0'
      end
      item
        Name = 'id_catalogo'
        Value = '2'
      end
      item
        Name = 'pagina'
        Value = '1'
      end
      item
        Name = 'id_usuario'
        Value = '1'
      end
      item
        Name = 'busca'
      end
      item
        Name = 'id_produto'
        Value = '0'
      end
      item
        Name = 'ind_destaque'
      end>
    Resource = 'produtos'
    SynchronizedEvents = False
    Left = 56
    Top = 192
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'testserver'
    Password = 'testserver'
    Left = 176
    Top = 64
  end
  object ReqProdutoDetalhe: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'id_catalogo'
        Value = '2'
      end
      item
        Name = 'pagina'
        Value = '1'
      end
      item
        Name = 'id_usuario'
        Value = '1'
      end
      item
        Name = 'busca'
      end
      item
        Name = 'id_produto'
        Value = '0'
      end
      item
        Name = 'ind_destaque'
      end>
    Resource = 'produtos'
    SynchronizedEvents = False
    Left = 176
    Top = 192
  end
  object ReqProdutoCad: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'id'
        Value = '0'
      end
      item
        Name = 'id_catalogo'
        Value = '2'
      end
      item
        Kind = pkREQUESTBODY
        Name = 'foto'
        Value = 
          'iVBORw0KGgoAAAANSUhEUgAAAB8AAAAdCAYAAABSZrcyAAAAAXNSR0IArs4c6QAA' +
          'AARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABSSURBVEhLxcix' +
          'DQAwCMAw/n+acoDnNJKXzLUfcVY4K5wVzgpnhbPCWeGscFY4K5wVzgpnhbPCWeGs' +
          'cFY4K5wVzgpnhbPCWeGscFY4K5wVzsDsA2Kwf6sNTgcDAAAAAElFTkSuQmCC'
      end
      item
        Name = 'preco'
        Value = '99'
      end
      item
        Name = 'preco_promocao'
        Value = '50'
      end
      item
        Name = 'ind_destaque'
        Value = 'N'
      end
      item
        Name = 'nome'
        Value = 'Perfume 2'
      end
      item
        Name = 'id_produto'
        Value = '0'
      end>
    Resource = 'produtos'
    SynchronizedEvents = False
    Left = 288
    Top = 192
  end
  object ReqCatalogoCons: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'id'
        Value = '0'
      end
      item
        Name = 'id_usuario'
        Value = '0'
      end
      item
        Name = 'id_catalogo'
      end>
    Resource = 'catalogos'
    SynchronizedEvents = False
    Left = 56
    Top = 128
  end
  object ReqCatalogoCad: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'id'
        Value = '0'
      end
      item
        Name = 'id_usuario'
        Value = '0'
      end
      item
        Name = 'nome'
      end
      item
        Kind = pkREQUESTBODY
        Name = 'foto'
      end
      item
        Name = 'id_catalogo'
      end>
    Resource = 'catalogos'
    SynchronizedEvents = False
    Left = 288
    Top = 128
  end
  object ReqCatalogoDetalhe: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'id'
        Value = '0'
      end
      item
        Name = 'id_usuario'
        Value = '0'
      end
      item
        Name = 'id_catalogo'
      end>
    Resource = 'catalogos'
    SynchronizedEvents = False
    Left = 176
    Top = 128
  end
  object ReqProdutoFoto: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'id'
        Value = '0'
      end
      item
        Name = 'id_usuario'
        Value = '0'
      end
      item
        Name = 'id_produto'
        Value = '0'
      end>
    Resource = 'foto'
    SynchronizedEvents = False
    Left = 56
    Top = 256
  end
end
