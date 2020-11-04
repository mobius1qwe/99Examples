object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 454
  Width = 514
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 304
    Top = 32
  end
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=D:\GoogleDrive\99money\DB\database.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 80
    Top = 40
  end
  object qry_categoria: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT * FROM TAB_CATEGORIA')
    Left = 80
    Top = 112
    object qry_categoriaID_CATEGORIA: TIntegerField
      FieldName = 'ID_CATEGORIA'
      Origin = 'ID_CATEGORIA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qry_categoriaDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Size = 50
    end
  end
  object qry_lancamento: TFDQuery
    OnCalcFields = qry_lancamentoCalcFields
    Connection = FDConn
    SQL.Strings = (
      'SELECT L.*, C.DESCRICAO AS CATEGORIA'
      'FROM TAB_LANCAMENTO L'
      'JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)')
    Left = 80
    Top = 176
    object qry_lancamentoID_LANCAMENTO: TIntegerField
      FieldName = 'ID_LANCAMENTO'
      Origin = 'ID_LANCAMENTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qry_lancamentoVALOR: TBCDField
      FieldName = 'VALOR'
      Origin = 'VALOR'
      DisplayFormat = 'R$ #,##0.00'
      Precision = 8
      Size = 2
    end
    object qry_lancamentoDATA: TDateTimeField
      FieldName = 'DATA'
      Origin = 'DATA'
    end
    object qry_lancamentoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Size = 100
    end
    object qry_lancamentoID_CATEGORIA: TIntegerField
      FieldName = 'ID_CATEGORIA'
      Origin = 'ID_CATEGORIA'
    end
    object qry_lancamentoTIPO_LANCAMENTO: TStringField
      FieldName = 'TIPO_LANCAMENTO'
      Origin = 'TIPO_LANCAMENTO'
      Size = 1
    end
    object qry_lancamentoCATEGORIA: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'CATEGORIA'
      Origin = 'DESCRICAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object qry_lancamentoICONE: TLargeintField
      AutoGenerateValue = arDefault
      FieldKind = fkCalculated
      FieldName = 'ICONE'
      Origin = 'ICONE'
      ProviderFlags = []
      ReadOnly = True
      Calculated = True
    end
  end
  object qry_geral: TFDQuery
    Connection = FDConn
    Left = 80
    Top = 240
  end
  object qry_perfil: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT * FROM TAB_CONFIG')
    Left = 80
    Top = 304
  end
end
