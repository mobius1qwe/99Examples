object dm: Tdm
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 583
  Width = 358
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Comanda\Servidor\DB\BANCO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 56
    Top = 40
  end
  object DWEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'usuario'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'ValidarLogin'
        OnReplyEvent = DWEventsEventsValidarLoginReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'ListarComanda'
        OnReplyEvent = DWEventsEventsListarComandaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_categoria'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'termo_busca'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'pagina'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'ListarProduto'
        OnReplyEvent = DWEventsEventsListarProdutoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'ListarCategoria'
        OnReplyEvent = DWEventsEventsListarCategoriaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_produto'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'qtd'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'vl_total'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'AdicionarProdutoComanda'
        OnReplyEvent = DWEventsEventsAdicionarProdutoComandaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'ListarProdutoComanda'
        OnReplyEvent = DWEventsEventsListarProdutoComandaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_consumo'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'ExcluirProdutoComanda'
        OnReplyEvent = DWEventsEventsExcluirProdutoComandaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'EncerrarComanda'
        OnReplyEvent = DWEventsEventsEncerrarComandaReplyEvent
      end>
    Left = 64
    Top = 120
  end
  object QryLogin: TFDQuery
    Connection = conn
    Left = 168
    Top = 40
  end
end
