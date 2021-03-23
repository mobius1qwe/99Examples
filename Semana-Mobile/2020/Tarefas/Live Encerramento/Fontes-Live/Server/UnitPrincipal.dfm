object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Servidor Rest DW'
  ClientHeight = 359
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RESTServicePooler1: TRESTServicePooler
    Active = False
    CORS = False
    CORS_CustomHeaders.Strings = (
      
        'Access-Control-Allow-Methods:GET, POST, PATCH, PUT, DELETE, OPTI' +
        'ONS'
      
        'Access-Control-Allow-Headers:Content-Type, Origin, Accept, Autho' +
        'rization, X-CUSTOM-HEADER')
    ServicePort = 8082
    ProxyOptions.Port = 8888
    ServerParams.HasAuthentication = True
    ServerParams.UserName = 'testserver'
    ServerParams.Password = 'testserver'
    SSLMethod = sslvSSLv2
    SSLVersions = []
    Encoding = esUtf8
    ServerContext = 'restdataware'
    RootPath = '/'
    SSLVerifyMode = []
    SSLVerifyDepth = 0
    ForceWelcomeAccess = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    MultiCORE = False
    Left = 56
    Top = 32
  end
end
