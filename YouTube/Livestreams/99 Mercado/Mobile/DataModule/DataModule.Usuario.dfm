object DmUsuario: TDmUsuario
  OnCreate = DataModuleCreate
  Height = 278
  Width = 392
  object TabUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 56
    Top = 32
  end
  object conn: TFDConnection
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 48
    Top = 144
  end
  object QryGeral: TFDQuery
    Connection = conn
    Left = 176
    Top = 144
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 280
    Top = 144
  end
  object QryUsuario: TFDQuery
    Connection = conn
    Left = 176
    Top = 208
  end
  object TabPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 32
  end
end
