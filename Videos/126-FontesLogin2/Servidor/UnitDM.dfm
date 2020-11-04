object dm: Tdm
  OldCreateOrder = False
  Encoding = esASCII
  Height = 598
  Width = 366
  object DWEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'hora'
        OnReplyEvent = DWEventsEventshoraReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'usuario'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'senha'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'ValidaLogin'
        OnReplyEvent = DWEventsEventsValidaLoginReplyEvent
      end>
    Left = 72
    Top = 88
  end
end
