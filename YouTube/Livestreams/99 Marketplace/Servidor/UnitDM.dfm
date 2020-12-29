object dm: Tdm
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 586
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
    Left = 56
    Top = 32
  end
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
        Name = 'usuario'
        EventName = 'usuario'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsEventsusuarioReplyEventByType
      end>
    ContextName = 'usuarios'
    Left = 160
    Top = 32
  end
end
