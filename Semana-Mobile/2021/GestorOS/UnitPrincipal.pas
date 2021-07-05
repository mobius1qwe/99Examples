unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFrmPrincipal = class(TForm)
    rectAbas: TRectangle;
    imgAbaOS: TImage;
    imgAdd: TImage;
    imgAbaCliente: TImage;
    TabControl: TTabControl;
    TabOS: TTabItem;
    TabCliente: TTabItem;
    rectOSToolbar: TRectangle;
    Label1: TLabel;
    rectOSBusca: TRectangle;
    edtBuscaOS: TEdit;
    rectBuscaOS: TRectangle;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Label3: TLabel;
    Rectangle2: TRectangle;
    edtBuscaCliente: TEdit;
    rectBuscaCliente: TRectangle;
    Label4: TLabel;
    lvCliente: TListView;
    lvOS: TListView;
    imgData: TImage;
    imgHora: TImage;
    imgOpcao: TImage;
    imgAberta: TImage;
    imgFechada: TImage;
    procedure imgAbaOSClick(Sender: TObject);
    procedure rectBuscaOSClick(Sender: TObject);
    procedure rectBuscaClienteClick(Sender: TObject);
  private
    procedure MudarAba(Image: TImage);
    procedure ConsultarOS(filtro: string);
    procedure AddOS(codOS, cliente, dt, hora, status, assunto: string);
    procedure ConsultarCliente(filtro: string);
    procedure AddCliente(codCliente, nome, endereco, cidade, uf: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

procedure TFrmPrincipal.imgAbaOSClick(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

procedure TFrmPrincipal.MudarAba(Image: TImage);
begin
    imgAbaOS.Opacity := 0.4;
    imgAbaCliente.Opacity := 0.4;

    Image.Opacity := 1;
    TabControl.GotoVisibleTab(Image.Tag);
end;

procedure TFrmPrincipal.AddOS(codOS, cliente, dt, hora, status, assunto: string);
var
    item : TListViewItem;
begin
    item := lvOS.Items.Add;

    with item do
    begin
        Height := 125;
        TagString := codOS;

        TListItemText(Objects.FindDrawable('txtOS')).Text := codOS;
        TListItemText(Objects.FindDrawable('txtCliente')).Text := cliente;
        TListItemText(Objects.FindDrawable('txtData')).Text := dt;
        TListItemText(Objects.FindDrawable('txtHora')).Text := hora;
        TListItemText(Objects.FindDrawable('txtAssunto')).Text := assunto;

        TListItemImage(Objects.FindDrawable('imgData')).Bitmap := imgData.Bitmap;
        TListItemImage(Objects.FindDrawable('imgHora')).Bitmap := imgHora.Bitmap;
        TListItemImage(Objects.FindDrawable('imgOpcoes')).Bitmap := imgOpcao.Bitmap;

        if status = 'F' then
            TListItemImage(Objects.FindDrawable('imgStatus')).Bitmap := imgFechada.Bitmap
        else
            TListItemImage(Objects.FindDrawable('imgStatus')).Bitmap := imgAberta.Bitmap
    end;
end;

procedure TFrmPrincipal.ConsultarOS(filtro: string);
begin
    lvOS.Items.Clear;

    // Montar a query (select)...

    AddOS('001', '99 Coders', '15/10/2021', '15:00', 'A',
          'Impressora não está imprimindo corretamente');
    AddOS('002', '99 Coders', '15/10/2021', '15:00', 'F',
          'Impressora não está imprimindo corretamente');
    AddOS('003', '99 Coders', '15/10/2021', '15:00', 'F',
          'Impressora não está imprimindo corretamente');
end;

procedure TFrmPrincipal.AddCliente(codCliente, nome, endereco, cidade, uf: string);
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

procedure TFrmPrincipal.ConsultarCliente(filtro: string);
begin
    lvCliente.Items.Clear;

    // Montar a query (select)...

    AddCliente('001', '99 Coders', 'Av. Paulista, 9000 - CJ 123', 'São Paulo', 'SP');
    AddCliente('001', 'Walmart Brasil', 'Av. Paulista, 9000 - CJ 123', 'São Paulo', 'SP');
    AddCliente('001', 'Facebook', 'Av. Paulista, 9000 - CJ 123', 'São Paulo', 'SP');

end;

procedure TFrmPrincipal.rectBuscaClienteClick(Sender: TObject);
begin
    ConsultarCliente(edtBuscaCliente.Text);
end;

procedure TFrmPrincipal.rectBuscaOSClick(Sender: TObject);
begin
    ConsultarOS(edtBuscaOS.Text);
end;

end.
