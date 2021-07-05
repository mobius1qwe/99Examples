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
end
