program Clubhouse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitFrameSugestao in 'UnitFrameSugestao.pas' {FrameSugestao: TFrame},
  UnitFrameSala in 'UnitFrameSala.pas' {FrameSala: TFrame},
  UnitFrameExplorar in 'UnitFrameExplorar.pas' {FrameExplorar: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
