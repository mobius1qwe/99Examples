object dm: Tdm
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esUtf8
  Height = 422
  Width = 372
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 200
    Top = 24
  end
  object EventsUsuario: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'email'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'senha'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'login'
        EventName = 'login'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsUsuarioEventsloginReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_usuario'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'nome'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'email'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'senha'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'cadastro'
        EventName = 'cadastro'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsUsuarioEventscadastroReplyEventByType
      end>
    ContextName = 'usuario'
    Left = 72
    Top = 120
  end
  object EventsCategoria: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'cidade'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'listar'
        EventName = 'listar'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsCategoriaEventslistarReplyEventByType
      end>
    ContextName = 'categoria'
    Left = 72
    Top = 192
  end
  object EventsEmpresa: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'cidade'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'busca'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'ind_foto'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_empresa'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'listar'
        EventName = 'listar'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsEmpresaEventslistarReplyEventByType
      end>
    ContextName = 'empresa'
    Left = 72
    Top = 256
  end
  object EventsServico: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_empresa'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'listar'
        EventName = 'listar'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsServicoEventslistarReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_servico'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'dt'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'horario'
        EventName = 'horario'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsServicoEventshorarioReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_usuario'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_servico'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'dt'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'hora'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'agendar'
        EventName = 'agendar'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsServicoEventsagendarReplyEventByType
      end>
    ContextName = 'servico'
    Left = 176
    Top = 256
  end
  object conn: TFDConnection
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 56
    Top = 24
  end
  object EventsReserva: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_usuario'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'listar'
        EventName = 'listar'
        OnlyPreDefinedParams = False
        OnReplyEventByType = EventsReservaEventslistarReplyEventByType
      end>
    ContextName = 'reserva'
    Left = 272
    Top = 256
  end
end
