object dm: Tdm
  OldCreateOrder = False
  Encoding = esASCII
  Height = 410
  Width = 547
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=Tarefas'
      'User_Name=heber'
      'Password=12345'
      'LoginTimeout=999999'
      'Server=localhost'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 216
    Top = 24
  end
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 72
    Top = 24
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConn
    Left = 72
    Top = 104
  end
  object DWEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'Hora'
        OnReplyEvent = DWEventsEventsHoraReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'ListarCompromissos'
        OnReplyEvent = DWEventsEventsListarCompromissosReplyEvent
      end>
    Left = 72
    Top = 176
  end
  object qry_compromisso: TFDQuery
    Connection = FDConn
    Left = 216
    Top = 104
  end
end
