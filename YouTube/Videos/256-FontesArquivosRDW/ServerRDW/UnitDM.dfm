object dm: Tdm
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 255
  Width = 369
  object DWEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'getfile'
        EventName = 'getfile'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWEventsEventsgetfileReplyEventByType
      end>
    Left = 80
    Top = 40
  end
end
