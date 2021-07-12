unit UnitFunctions;

interface

uses
  FMX.ListView.Appearances, FMX.ListView, FMX.ListView.Types,
  FireDAC.Comp.Client, System.SysUtils, FMX.Graphics, Data.DB,
  System.Classes;

procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
function GeraCodFoto: String;
function GeraCodOS: String;
function FormataData(dt: string): string;

implementation

procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
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

function GeraCodFoto: String;
begin
    Result := FormatDateTime('yymmddHHnnsszzz', now);
end;

function GeraCodOS: String;
begin
    Result := FormatDateTime('yymmddHHnnsszzz', now);
end;

// Entrada: dd/mm/yyyy hh:nn
// Saida: yyyy-mm-dd hh:nn
function FormataData(dt: string): string;
begin
    Result := Copy(dt, 7, 4) + '-' + Copy(dt, 4, 2) + '-' + Copy(dt, 1, 2) + ' ' +
              Copy(dt, 12, 5) + ':00';
end;


end.
