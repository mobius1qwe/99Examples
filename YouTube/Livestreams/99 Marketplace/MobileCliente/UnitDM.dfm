object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 566
  Width = 360
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=D:\99Coders\CursoMarketplace\Fontes\MobileCliente\DB\ba' +
        'nco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 72
    Top = 40
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://192.168.0.103:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 56
    Top = 128
  end
  object RequestLogin: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'usuarios/usuario'
    SynchronizedEvents = False
    Left = 56
    Top = 224
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'admin'
    Password = 'admin'
    Left = 176
    Top = 128
  end
  object RequestLoginCad: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'usuarios/usuario'
    SynchronizedEvents = False
    Left = 168
    Top = 224
  end
  object RequestPedido: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'pedidos/pedido'
    SynchronizedEvents = False
    Left = 56
    Top = 288
  end
  object RequestAceito: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'pedidos/pedido'
    SynchronizedEvents = False
    Left = 168
    Top = 288
  end
  object RequestRealizado: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'pedidos/pedido'
    SynchronizedEvents = False
    Left = 56
    Top = 352
  end
  object RequestNotif: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'notificacoes/notificacao'
    SynchronizedEvents = False
    Left = 272
    Top = 288
  end
  object RequestNotifDelete: TRESTRequest
    Client = RESTClient
    Method = rmDELETE
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'notificacoes/notificacao'
    SynchronizedEvents = False
    Left = 272
    Top = 224
  end
  object RequestPedidoCad: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'pedidos/pedido'
    SynchronizedEvents = False
    Left = 168
    Top = 352
  end
  object RequestCategoria: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'categorias/categoria'
    SynchronizedEvents = False
    Left = 272
    Top = 352
  end
  object RequestGrupo: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'categorias/grupo'
    SynchronizedEvents = False
    Left = 56
    Top = 416
  end
  object RequestPedidoDados: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'pedidos/pedido'
    SynchronizedEvents = False
    Left = 168
    Top = 416
  end
  object RequestOrcamento: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'joao3@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '12345'
      end>
    Resource = 'orcamentos/orcamento'
    SynchronizedEvents = False
    Left = 272
    Top = 416
  end
end
