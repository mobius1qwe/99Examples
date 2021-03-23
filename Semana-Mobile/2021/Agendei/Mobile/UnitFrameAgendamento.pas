unit UnitFrameAgendamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.DialogService;

type
  TFrameAgendamento = class(TFrame)
    lbl_servico: TLabel;
    lbl_nome: TLabel;
    Layout1: TLayout;
    Image1: TImage;
    lbl_data: TLabel;
    lbl_hora: TLabel;
    Image2: TImage;
    Image3: TImage;
    lbl_valor: TLabel;
    Layout2: TLayout;
    Image4: TImage;
    lbl_endereco: TLabel;
    Layout3: TLayout;
    rect_excluir: TRectangle;
    Label7: TLabel;
    Line1: TLine;
    procedure rect_excluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses UnitDM, UnitPrincipal;

procedure TFrameAgendamento.rect_excluirClick(Sender: TObject);
var
    erro : string;
begin
    TDialogService.MessageDialog('Confirma exclusão?',
                                 TMsgDlgType.mtConfirmation,
                                 [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                 TMsgDlgBtn.mbNo,
                                 0,
     procedure(const AResult: TModalResult)
     var
        erro: string;
     begin
        if AResult = mrYes then
        begin

            if NOT dm.ExcluirReserva(TRectangle(Sender).Tag, erro) then
            begin
                showmessage(erro);
                exit;
            end;

            FrmPrincipal.CarregarAgendamentos;

        end;
     end);



end;

end.
