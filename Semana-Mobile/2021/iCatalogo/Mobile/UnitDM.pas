unit UnitDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope;

type
  Tdm = class(TDataModule)
    RESTClient: TRESTClient;
    ReqProdutoCons: TRESTRequest;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    ReqProdutoDetalhe: TRESTRequest;
    ReqProdutoCad: TRESTRequest;
    ReqCatalogoCons: TRESTRequest;
    ReqCatalogoCad: TRESTRequest;
    ReqCatalogoDetalhe: TRESTRequest;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
