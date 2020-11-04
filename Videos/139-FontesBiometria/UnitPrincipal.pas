unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects;

type
  TFrmPrincipal = class(TForm)
    rect_login: TRoundRect;
    Label3: TLabel;
    img_erro: TImage;
    img_sucesso: TImage;
    lbl_msg: TLabel;
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmPrincipal := nil;
end;

procedure TFrmPrincipal.rect_loginClick(Sender: TObject);
begin
    close;
end;

end.
