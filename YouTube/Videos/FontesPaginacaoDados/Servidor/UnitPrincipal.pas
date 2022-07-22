unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, System.JSON,

  Horse,
  Horse.CORS,
  Horse.Jhonson,
  UnitDM;

type
  TFrmPrincipal = class(TForm)
    memo: TMemo;
    procedure FormShow(Sender: TObject);
  private
    procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    busca: string;
    pagina, tamanho_pagina: integer;
begin
    try
        try
            busca := req.Query.Items['busca'];
        except
            busca := '';
        end;

        try
            pagina := req.Query.Items['pagina'].ToInteger;
        except
            pagina := 1;
        end;

        try
            tamanho_pagina := req.Query.Items['tamanho_pagina'].ToInteger;
        except
            tamanho_pagina := 30;
        end;

        memo.Lines.Add('GET  /produtos  pagina=' + pagina.ToString + '  busca=' + busca);

        Res.Send<TJsonArray>(dm.ListarProduto(pagina, tamanho_pagina, busca));

    except on ex:exception do
        Res.Send(ex.Message).Status(500);
    end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    THorse.Use(Jhonson());
    THorse.Use(CORS);


    // Registro das Rotas...
    THorse.Get('/produtos', ListarProdutos);


    THorse.Listen(9000, procedure(Horse: THorse)
    begin
        Memo.lines.Add('Servidor executando na porta: ' + Horse.Port.ToString);
    end);
end;

end.
