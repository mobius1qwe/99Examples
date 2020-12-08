object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 566
  Width = 360
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=D:\99Coders\CursoMarketplace\Fontes\MobileCliente\DB\ba' +
        'nco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 72
    Top = 40
  end
end
