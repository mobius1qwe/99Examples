unit UnitNotificacaoDados;

interface

uses FMX.Graphics;

type
    TNotificacao = record
        id : integer;
        icone : TBitmap;
        cod_usuario : string;
        data : string;
        texto : string;
        tipo : string; // T = Texto  C = Convite
    end;

implementation

end.
