object Dm: TDm
  OnCreate = DataModuleCreate
  Height = 270
  Width = 383
  object conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    ConnectedStoredUsage = []
    LoginPrompt = False
    BeforeConnect = connBeforeConnect
    Left = 48
    Top = 40
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 200
    Top = 40
  end
end
