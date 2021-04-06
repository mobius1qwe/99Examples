unit uFunctions;

interface

uses SysUtils, FMX.TextLayout, FMX.ListView.Types, System.Types, FMX.Graphics,
     System.Classes, Soap.EncdDecd, Data.DB, DateUtils;

type
    TFunctions = class
    private

    public
        class procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
        class function GerarChave(): string;
        class function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
        class function BitmapFromBase64(const base64: string): TBitmap;
        class function Base64FromBitmap(Bitmap: TBitmap): string;
        class function StrToAvaliacao(avaliacao: string): double; static;
        class function StrToMoney(vl: string): double; static;
        class function StrToData(dt, formato: string): TDateTime; static;
        class function OccurrencesOfChar(const S: string; const C: char): integer; static;
end;


implementation


class function TFunctions.OccurrencesOfChar(const S: string; const C: char): integer;
var
  i: Integer;
begin
    Result := 0;

    for i := 1 to Length(S) do
        if S[i] = C then
            inc(result);
end;

// Converte uma string base64 em um Bitmap...
class function TFunctions.BitmapFromBase64(const base64: string): TBitmap;
var
        Input: TStringStream;
        Output: TBytesStream;
begin
        Input := TStringStream.Create(base64, TEncoding.ASCII);
        try
                Output := TBytesStream.Create;
                try
                        Soap.EncdDecd.DecodeStream(Input, Output);
                        Output.Position := 0;
                        Result := TBitmap.Create;
                        try
                                Result.LoadFromStream(Output);
                        except
                                Result.Free;
                                raise;
                        end;
                finally
                        Output.Free;
                end;
        finally
                Input.Free;
        end;
end;

// Converte um Bitmap em uma string no formato base64...
class function TFunctions.Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                        Soap.EncdDecd.EncodeStream(Input, Output);
                        Result := Output.DataString;
                finally
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;

// Gera um código de 15 caracteres...
class function TFunctions.GerarChave(): string;
begin
    Result := FormatDateTime('yymmddhhnnsszzz', Now);
end;

// Trata conversao de string "4.5" para avaliacao Float
class function TFunctions.StrToAvaliacao(avaliacao: string): double;
begin
    try
        avaliacao := avaliacao.Replace('.', '');
        avaliacao := avaliacao.Replace(',', '');

        Result := StrToFloat(avaliacao) / 10;
    except
        Result := 0;
    end;
end;

// Trata conversao de string monetaria "1.500,25" para valor Float
class function TFunctions.StrToMoney(vl: string): double;
begin
    try
        vl := vl.Replace('.', '');
        vl := vl.Replace(',', '');

        Result := StrToFloat(vl) / 100;
    except
        Result := 0;
    end;
end;


// Trata conversao de string para data
class function TFunctions.StrToData(dt, formato: string): TDateTime;
var
    dia, mes, ano, hora, min, seg : Word;
    pos_d, pos_m, pos_y, pos_h, pos_n, pos_s : Integer;
begin
    try
        if formato = '' then
            formato := 'dd/mm/yyyy';

        pos_d := Pos('d', formato);
        pos_m := Pos('m', formato);
        pos_y := Pos('y', formato);

        pos_h := Pos('h', formato);
        pos_n := Pos('n', formato);
        pos_s := Pos('s', formato);

        dia := Copy(dt, pos_d, OccurrencesOfChar(formato, 'd')).ToInteger;
        mes := Copy(dt, pos_m, OccurrencesOfChar(formato, 'm')).ToInteger;
        ano := Copy(dt, pos_y, OccurrencesOfChar(formato, 'y')).ToInteger;

        hora := Copy(dt, pos_h, OccurrencesOfChar(formato, 'h')).ToInteger;
        min := Copy(dt, pos_n, OccurrencesOfChar(formato, 'n')).ToInteger;
        seg := Copy(dt, pos_s, OccurrencesOfChar(formato, 's')).ToInteger;

        if pos_h > 0 then
            Result := EncodeDateTime(ano, mes, dia, hora, min, seg, 0)
        else
            Result := EncodeDate(ano, mes, dia)
    except
        Result := date;
    end;
end;



// Calcula a altura de um item TListItemText
class function TFunctions.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

class procedure TFunctions.LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Blob.SaveToStream(ms);
    ms.Position := 0;
    Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;


end.
