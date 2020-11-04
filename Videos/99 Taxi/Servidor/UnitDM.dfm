object dm: Tdm
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esASCII
  Height = 598
  Width = 366
  object DWEvents: TDWServerEvents
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
        Name = 'ValidaLogin'
        EventName = 'ValidaLogin'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsValidaLoginReplyEvent
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
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'foto'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'CriarConta'
        EventName = 'CriarConta'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsCriarContaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'ListarCategoria'
        EventName = 'ListarCategoria'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsListarCategoriaReplyEvent
      end>
    Left = 48
    Top = 96
  end
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=D:\99Coders\Posts\127 - Login completo - Backend REST F' +
        'ull - Parte 3\Fontes\Servidor\DB\DATABASE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 48
    Top = 24
  end
  object QryGeral: TFDQuery
    Connection = conn
    Left = 144
    Top = 24
  end
end
