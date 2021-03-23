unit UnitCompromissoDados;

interface

uses FMX.Graphics;

type
    TCompromisso = record
        seq_compromisso : integer;
        cod_usuario : string;
        data : string;
        hora : string;
        descricao : string;
        ind_concluido : string; // S ou N
        qtd_partic : integer;
    end;

implementation

end.

