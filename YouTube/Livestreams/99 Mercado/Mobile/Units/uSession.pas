unit uSession;

interface

type
  TSession = class
  private
    class var FID_USUARIO: integer;

  public
    class property ID_USUARIO: integer read FID_USUARIO write FID_USUARIO;
  end;

implementation

end.
