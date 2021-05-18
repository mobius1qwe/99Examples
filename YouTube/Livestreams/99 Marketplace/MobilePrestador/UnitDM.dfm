object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 613
  Width = 564
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=D:\99Coders\CursoMarketplace\Fontes\MobileCliente\DB\ba' +
        'nco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 56
    Top = 48
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8082'
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
    Resource = 'prestadores/prestador'
    SynchronizedEvents = False
    Left = 56
    Top = 224
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'admin'
    Password = 'admin'
    Left = 200
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
    Resource = 'prestadores/prestador'
    SynchronizedEvents = False
    Left = 200
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
    Resource = 'prestadores/pedido'
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
    Resource = 'prestadores/pedido'
    SynchronizedEvents = False
    Left = 200
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
    Resource = 'prestadores/pedido'
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
    Left = 344
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
    Left = 344
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
    Left = 200
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
    Left = 344
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
    Left = 200
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
    Left = 344
    Top = 416
  end
  object RequestOrcamentoAprov: TRESTRequest
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
    Resource = 'orcamentos/aprovacao'
    SynchronizedEvents = False
    Left = 56
    Top = 472
  end
  object RequestOrcamentoChat: TRESTRequest
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
    Resource = 'orcamentos/chat'
    SynchronizedEvents = False
    Left = 200
    Top = 472
  end
  object RequestOrcamentoChatEnv: TRESTRequest
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
    Resource = 'orcamentos/chat'
    SynchronizedEvents = False
    Left = 344
    Top = 472
  end
  object RequestPedidoAprovar: TRESTRequest
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
    Resource = 'pedidos/aprovar'
    SynchronizedEvents = False
    Left = 56
    Top = 528
  end
  object RequestPedidoAvaliar: TRESTRequest
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
    Resource = 'pedidos/avaliar'
    SynchronizedEvents = False
    Left = 200
    Top = 528
  end
  object RequestPerfilCad: TRESTRequest
    Client = RESTClient
    Method = rmPATCH
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
    Left = 344
    Top = 528
  end
  object RequestOrcamentoCad: TRESTRequest
    Client = RESTClient
    Method = rmPATCH
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
    Left = 464
    Top = 416
  end
end
