unit UnitDetalheEmpresa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, System.JSON;

type
  TFrmDetalheEmpresa = class(TForm)
    img_foto: TImage;
    lbl_nome: TLabel;
    lbl_endereco: TLabel;
    Line2: TLine;
    Label1: TLabel;
    Line1: TLine;
    lb_servico: TListBox;
    img_no_foto: TImage;
    img_voltar: TImage;
    procedure FormShow(Sender: TObject);
    procedure lb_servicoItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure img_voltarClick(Sender: TObject);
  private
    procedure CarregarServicos(id_empresa: integer);
    { Private declarations }
  public
    { Public declarations }
    id_emp : integer;
  end;

var
  FrmDetalheEmpresa: TFrmDetalheEmpresa;

implementation

{$R *.fmx}

uses UnitFrameServico, UnitAgenda, UnitDM, UnitPrincipal;

procedure TFrmDetalheEmpresa.CarregarServicos(id_empresa: integer);
var
    i : integer;
    item : TListBoxItem;
    frame : TFrameServico;
    jsonArray : TJSONArray;
    erro: string;
begin
    lb_servico.Items.Clear;

    // Acessar o servidor e buscar os servicos...
    if NOT dm.ListarServico(id_empresa, jsonArray, erro) then
    begin
        showmessage(erro);
        exit;
    end;

    for i := 0 to jsonArray.Size - 1 do
    begin
        item := TListBoxItem.Create(lb_servico);
        item.Text := '';
        item.Height := 60;
        item.Selectable := false;
        item.Tag := jsonArray.Get(i).GetValue<integer>('ID_SERVICO', 0);
        item.TagString := jsonArray.Get(i).GetValue<string>('DESCRICAO', '');
        item.TagFloat := jsonArray.Get(i).GetValue<double>('VALOR', 0);

        frame := TFrameServico.Create(item);
        frame.Parent := item;
        frame.Align := TAlignLayout.Client;
        frame.lbl_servico.Text := jsonArray.Get(i).GetValue<string>('DESCRICAO', '');
        frame.lbl_valor.Text := FormatFloat('#,##0.00', jsonArray.Get(i).GetValue<double>('VALOR', 0));

        lb_servico.AddObject(item);
    end;

    jsonArray.DisposeOf;
end;

procedure TFrmDetalheEmpresa.FormShow(Sender: TObject);
begin
    CarregarServicos(id_emp);
end;

procedure TFrmDetalheEmpresa.img_voltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmDetalheEmpresa.lb_servicoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    if NOT Assigned(FrmAgenda) then
        Application.CreateForm(TFrmAgenda, FrmAgenda);

    FrmAgenda.id_servico := Item.Tag;
    FrmAgenda.lbl_servico.Text := Item.TagString;
    FrmAgenda.lbl_valor.Text := 'R$ ' + FormatFloat('#,##0.00', Item.TagFloat);

    FrmAgenda.Showmodal(procedure(ModalResult: TModalResult)
    begin
        if FrmPrincipal.ind_fechar_telas then
            close;
    end);
end;

end.
