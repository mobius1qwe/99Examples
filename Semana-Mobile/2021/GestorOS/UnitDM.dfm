object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 377
  Width = 331
  object conn: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 64
    Top = 32
  end
  object qryConsOS: TFDQuery
    Connection = conn
    Left = 144
    Top = 32
  end
  object qryConsCliente: TFDQuery
    Connection = conn
    Left = 240
    Top = 32
  end
  object qryGeral: TFDQuery
    Connection = conn
    Left = 64
    Top = 104
  end
  object qryFoto: TFDQuery
    Connection = conn
    Left = 144
    Top = 104
  end
end
