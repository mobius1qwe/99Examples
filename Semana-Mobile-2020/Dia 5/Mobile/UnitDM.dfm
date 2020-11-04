object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 514
  Width = 448
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Comanda\Mobile\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 88
    Top = 32
  end
  object qry_config: TFDQuery
    Connection = conn
    Left = 184
    Top = 32
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 88
    Top = 120
  end
  object RequestLogin: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'ValidarLogin'
    SynchronizedEvents = False
    Left = 80
    Top = 184
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'testserver'
    Password = 'testserver'
    Left = 200
    Top = 120
  end
  object RequestListarComanda: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'ListarComanda'
    SynchronizedEvents = False
    Left = 304
    Top = 192
  end
  object RequestListarProduto: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'ListarProduto'
    SynchronizedEvents = False
    Left = 80
    Top = 248
  end
  object RequestListarCategoria: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'ListarCategoria'
    SynchronizedEvents = False
    Left = 309
    Top = 248
  end
  object RequestAdicionarProdutoComanda: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'AdicionarProdutoComanda'
    SynchronizedEvents = False
    Left = 85
    Top = 312
  end
  object RequestListarProdutoComanda: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'ListarProdutoComanda'
    SynchronizedEvents = False
    Left = 312
    Top = 304
  end
  object RequestExcluirProdutoComanda: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'ExcluirProdutoComanda'
    SynchronizedEvents = False
    Left = 85
    Top = 384
  end
  object RequestEncerrarComanda: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'HEBER'
      end>
    Resource = 'EncerrarComanda'
    SynchronizedEvents = False
    Left = 309
    Top = 376
  end
end
