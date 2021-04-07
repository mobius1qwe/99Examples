object dm: Tdm
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 305
  Width = 353
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Catalogo\Fontes\Servidor\DB\CATALOGO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object ServerEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'catalogos'
        EventName = 'catalogos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = ServerEventsEventscatalogosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'produtos'
        EventName = 'produtos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = ServerEventsEventsprodutosReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'foto'
        EventName = 'foto'
        OnlyPreDefinedParams = False
        OnReplyEventByType = ServerEventsEventsfotoReplyEventByType
      end>
    Left = 112
    Top = 64
  end
end
