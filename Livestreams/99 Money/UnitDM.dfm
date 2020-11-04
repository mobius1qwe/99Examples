object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 328
  Width = 354
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\99Coders\Curso99Money2\Fontes\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 32
  end
end
