unit UnitDetalheEmpresa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox;

type
  TFrmDetalheEmpresa = class(TForm)
    img_foto: TImage;
    lbl_servico: TLabel;
    lbl_nome: TLabel;
    Line2: TLine;
    Label1: TLabel;
    Line1: TLine;
    lb_servico: TListBox;
    procedure FormShow(Sender: TObject);
    procedure lb_servicoItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure CarregarServicos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDetalheEmpresa: TFrmDetalheEmpresa;

implementation

{$R *.fmx}

uses UnitFrameServico, UnitAgenda;

procedure TFrmDetalheEmpresa.CarregarServicos;
var
    i : integer;
    item : TListBoxItem;
    frame : TFrameServico;
begin
    lb_servico.Items.Clear;

    // Acessar o servidor e buscar os servicos...

    for i := 1 to 5 do
    begin
        item := TListBoxItem.Create(lb_servico);
        item.Text := '';
        item.Height := 60;

        frame := TFrameServico.Create(item);
        frame.Parent := item;
        frame.Align := TAlignLayout.Client;

        lb_servico.AddObject(item);
    end;
end;

procedure TFrmDetalheEmpresa.FormShow(Sender: TObject);
begin
    CarregarServicos;
end;

procedure TFrmDetalheEmpresa.lb_servicoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    FrmAgenda.Show;
end;

end.
