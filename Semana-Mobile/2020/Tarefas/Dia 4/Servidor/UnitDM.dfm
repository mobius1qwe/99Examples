object DM: TDM
  OldCreateOrder = False
  Encoding = esASCII
  Height = 594
  Width = 365
  object conn: TFDConnection
    Params.Strings = (
      'Database=Tarefas'
      'User_Name=heber'
      'Password=12345'
      'Server=localhost'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 64
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
    Left = 192
    Top = 24
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = conn
    Left = 192
    Top = 88
  end
end
