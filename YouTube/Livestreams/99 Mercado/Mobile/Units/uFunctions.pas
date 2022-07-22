unit uFunctions;

interface

uses FMX.Graphics, System.Net.HttpClientComponent, System.Classes,
  System.SysUtils, System.Net.HttpClient;

procedure LoadImageFromURL(img: TBitmap; url: string);
function Round2(aValue:double):double;
function UTCtoDateBR(dt: string): string;

implementation

procedure LoadImageFromURL(img: TBitmap; url: string);
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    try
        try
            http := TNetHTTPClient.Create(nil);
            vStream :=  TMemoryStream.Create;

            if (Pos('https', LowerCase(url)) > 0) then
                  HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                            THTTPSecureProtocol.TLS11,
                                            THTTPSecureProtocol.TLS12];

            http.Get(url, vStream);
            vStream.Position  :=  0;


            img.LoadFromStream(vStream);
        except
        end;

    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;
end;

function Round2(aValue:double):double;
begin
  Round2:=Round(aValue*100)/100;
end;

function UTCtoDateBR(dt: string): string;
	begin
	    // 2022-05-05 15:23:52.000
	    Result := Copy(dt, 9, 2) + '/' + Copy(dt, 6, 2) + '/' + Copy(dt, 1, 4) + ' ' + Copy(dt, 12, 8);
	end;

end.
