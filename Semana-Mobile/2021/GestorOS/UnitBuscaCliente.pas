unit UnitBuscaCliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TCallbackCliente = procedure(codCliente: string) of Object;

  TFrmBuscaCliente = class(TForm)
    rectOSToolbar: TRectangle;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    Rectangle2: TRectangle;
    edtBuscaCliente: TEdit;
    rectBuscaCliente: TRectangle;
    Label4: TLabel;
    lvCliente: TListView;
    procedure rectBuscaClienteClick(Sender: TObject);
    procedure lvClienteItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddCliente(codCliente, nome, endereco, cidade, uf: string);
    procedure ConsultarCliente(filtro: string);
    { Private declarations }
  public
    executeOnClose: TCallbackCliente;
  end;

var
  FrmBuscaCliente: TFrmBuscaCliente;

implementation

{$R *.fmx}

uses UnitDM;

procedure TFrmBuscaCliente.AddCliente(codCliente, nome, endereco, cidade, uf: string);
var
    item : TListViewItem;
begin
    item := lvCliente.Items.Add;

    with item do
    begin
        Height := 70;
        TagString := codCliente;

        TListItemText(Objects.FindDrawable('txtNome')).Text := nome;
        TListItemText(Objects.FindDrawable('txtEndereco')).Text := endereco;
        TListItemText(Objects.FindDrawable('txtCidade')).Text := cidade + ' - ' + uf;
    end;
end;

procedure TFrmBuscaCliente.ConsultarCliente(filtro: string);
begin
    lvCliente.Items.Clear;

    dm.qryConsCliente.Active := false;
    dm.qryConsCliente.SQL.Clear;
    dm.qryConsCliente.SQL.Add('SELECT C.*');
    dm.qryConsCliente.SQL.Add('FROM TAB_CLIENTE C');

    if filtro <> '' then
    begin
        dm.qryConsCliente.SQL.Add('WHERE C.NOME LIKE :NOME');
        dm.qryConsCliente.ParamByName('NOME').Value := '%' + filtro + '%';
    end;

    dm.qryConsCliente.SQL.Add('ORDER BY C.NOME');
    dm.qryConsCliente.Active := true;

    while NOT dm.qryConsCliente.Eof do
    begin
        AddCliente(dm.qryConsCliente.FieldByName('COD_CLIENTE').AsString,
                   dm.qryConsCliente.FieldByName('NOME').AsString,
                   dm.qryConsCliente.FieldByName('ENDERECO').AsString,
                   dm.qryConsCliente.FieldByName('CIDADE').AsString,
                   dm.qryConsCliente.FieldByName('UF').AsString);

        dm.qryConsCliente.Next;
    end;

end;

procedure TFrmBuscaCliente.lvClienteItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if Assigned(executeOnClose) then
    begin
        executeOnClose(AItem.TagString);
        close;
    end;
end;

procedure TFrmBuscaCliente.rectBuscaClienteClick(Sender: TObject);
begin
    ConsultarCliente(edtBuscaCliente.Text);
end;

end.
