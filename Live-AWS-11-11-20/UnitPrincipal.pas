unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Objects, FMX.Edit, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FMX.StdCtrls, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.Layouts,
  FMX.Memo;

type
  TFrmPrincipal = class(TForm)
    edt_buscar: TEdit;
    FDConn: TFDConnection;
    Button1: TButton;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    FDQry: TFDQuery;
    DataSource: TDataSource;
    Button2: TButton;
    ListView1: TListView;
    FDQryDESCRICAO: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Layout1: TLayout;
    Memo1: TMemo;
    Button3: TButton;
    lbl_regiao: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    hora_ini, hora_fim: TDateTime;
    function ConectarBanco(out erro: string): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses System.IniFiles, System.DateUtils;

procedure TFrmPrincipal.Button1Click(Sender: TObject);
var
    erro : string;
begin
    if NOT ConectarBanco(erro) then
        showmessage(erro);
end;

procedure TFrmPrincipal.Button2Click(Sender: TObject);
begin
    if NOT FDConn.Connected then
    begin
        showmessage('Sem conexão com o banco');
        exit;
    end;

    with FDQry do
    begin
        hora_ini := now;
        Active := false;
        SQL.Clear;
        SQL.Add('SELECT DESCRICAO FROM TAB_PRODUTO');

        if edt_buscar.Text <> '' then
        begin
            SQL.Add('WHERE DESCRICAO LIKE :DESCRICAO');
            ParamByName('DESCRICAO').Value := '%' + edt_buscar.Text + '%';
        end;

        Active := true;
        hora_fim := now;

        Label1.Text := recordcount.ToString + ' Registros';
        Memo1.Lines.Add(recordcount.ToString + ' Registros' + ': ' +
                     FormatFloat('0,000', MilliSecondsBetween(hora_ini, hora_fim)) + ' seg');
    end;

end;

procedure TFrmPrincipal.Button3Click(Sender: TObject);
begin
    Memo1.Lines.Clear;
end;

function TFrmPrincipal.ConectarBanco(out erro: string): boolean;
var
    arq_ini: string;
    ini : TIniFile;
begin
    try
        hora_ini := now;
        erro := '';
        arq_ini := System.SysUtils.GetCurrentDir + '\servidor.ini';

        if NOT FileExists(arq_ini) then
        begin
            Result := false;
            erro := 'Arquivo INI não encontrado: ' + arq_ini;
            exit;
        end;

        ini := TIniFile.Create(arq_ini);

        FDconn.Params.Values['DriverID'] := ini.ReadString('Banco de Dados', 'DriverID', '');
        FDconn.Params.Values['Database'] := ini.ReadString('Banco de Dados', 'Database', '');
        FDconn.Params.Values['User_Name'] := ini.ReadString('Banco de Dados', 'User_Name', '');
        FDconn.Params.Values['Password'] := ini.ReadString('Banco de Dados', 'Password', '');
        FDconn.Params.Values['Server'] := ini.ReadString('Banco de Dados', 'Server', '');
        lbl_regiao.Text := ini.ReadString('Banco de Dados', 'Region', '');



        try
            FDconn.Connected := true;
            Result := true;
            hora_fim := now;
            Memo1.Lines.Add('Conexão OK: ' + FormatFloat('0,000', MilliSecondsBetween(hora_ini, hora_fim)) + ' seg');
        except on ex:exception do
            begin
                Result := false;
                erro := 'Erro ao conectar com o banco de dados: ' + ex.Message;
                Memo1.Lines.Add(erro);
            end;
        end;
    finally
        ini.DisposeOf;
    end;
end;

end.
