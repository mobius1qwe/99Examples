object dm: Tdm
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 407
  Width = 372
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=D:\99Coders\CursoMarketplace\Fontes\Servidor\DB\MARKETP' +
        'LACE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 64
    Top = 24
  end
  object DWEventsUsuario: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'hora'
        EventName = 'hora'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventshoraReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'email'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'senha'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'usuario'
        EventName = 'usuario'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsEventsusuarioReplyEventByType
      end>
    ContextName = 'usuarios'
    Left = 64
    Top = 88
  end
  object DWEventsPedido: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'pedido'
        EventName = 'pedido'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsPedidoEventspedidoReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'aprovar'
        EventName = 'aprovar'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsPedidoEventsaprovarReplyEventByType
      end>
    ContextName = 'pedidos'
    Left = 64
    Top = 152
  end
  object DWEventsNotificacao: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'notificacao'
        EventName = 'notificacao'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsNotificacaoEventsnotificacaoReplyEventByType
      end>
    ContextName = 'notificacoes'
    Left = 192
    Top = 88
  end
  object DWEventsCategoria: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'categoria'
        EventName = 'categoria'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsCategoriaEventscategoriaReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'grupo'
        EventName = 'grupo'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsCategoriaEventsgrupoReplyEventByType
      end>
    ContextName = 'categorias'
    Left = 192
    Top = 152
  end
  object DWEventsOrcamento: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'orcamento'
        EventName = 'orcamento'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsorcamentoReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'aprovacao'
        EventName = 'aprovacao'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsOrcamentoEventsaprovacaoReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'chat'
        EventName = 'chat'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsOrcamentoEventschatReplyEventByType
      end>
    ContextName = 'orcamentos'
    Left = 64
    Top = 216
  end
end
