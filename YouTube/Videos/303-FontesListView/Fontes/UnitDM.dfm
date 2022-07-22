object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 254
  Width = 327
  object conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 88
    Top = 80
  end
  object qryGeral: TFDQuery
    Connection = conn
    Left = 184
    Top = 80
  end
end
