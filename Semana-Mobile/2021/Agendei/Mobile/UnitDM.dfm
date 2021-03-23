object dm: Tdm
  OldCreateOrder = False
  Height = 564
  Width = 364
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 56
    Top = 32
  end
  object ReqLogin: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'usuario/login'
    SynchronizedEvents = False
    Left = 56
    Top = 112
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'testserver'
    Password = 'testserver'
    Left = 184
    Top = 32
  end
  object ReqCategoria: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'categoria/listar'
    SynchronizedEvents = False
    Left = 136
    Top = 112
  end
  object ReqEmpresa: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'empresa/listar'
    SynchronizedEvents = False
    Left = 224
    Top = 112
  end
  object ReqServico: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'servico/listar'
    SynchronizedEvents = False
    Left = 56
    Top = 184
  end
  object ReqHorario: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'servico/horario'
    SynchronizedEvents = False
    Left = 136
    Top = 184
  end
  object ReqAgendar: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'servico/agendar'
    SynchronizedEvents = False
    Left = 224
    Top = 184
  end
  object ReqReserva: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'reserva/listar'
    SynchronizedEvents = False
    Left = 56
    Top = 256
  end
  object ReqExcluir: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'reserva/excluir'
    SynchronizedEvents = False
    Left = 136
    Top = 256
  end
end
