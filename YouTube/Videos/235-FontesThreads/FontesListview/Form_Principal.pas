unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, Data.DB, FMX.TextLayout, FMX.Ani, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IOUtils;

type
  TFrm_Principal = class(TForm)
    ToolBar1: TToolBar;
    ListView: TListView;
    btn_refresh: TSpeedButton;
    img_detalhe: TImage;
    conn: TFDConnection;
    qry_geral: TFDQuery;
    AniIndicator1: TAniIndicator;
    procedure btn_refreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure Add_Tarefa(cod_tarefa: integer; descricao, categoria, status,
                         data_tarefa, hora: string; icone: TStream);
    procedure Carrega_Tarefas(indClear : boolean);
    procedure ThreadFim(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;

implementation

{$R *.fmx}

procedure TFrm_Principal.Add_Tarefa(cod_tarefa : integer; descricao, categoria, status,
                        data_tarefa, hora : string; icone : TStream);
var
    img : TListItemImage;
    bmp : TBitmap;
begin
    with ListView.Items.Add do
    begin
        // Icone...
        if icone <> nil then
        begin
            bmp := TBitmap.Create;
            bmp.LoadFromStream(icone);

            img := TListItemImage(Objects.FindDrawable('Image3'));
            img.Bitmap := bmp;
            img.OwnsBitmap := true;
        end;


        // Descricao...
        TListItemText(Objects.FindDrawable('Text1')).Text := descricao;

        // Data e Hora...
        TListItemText(Objects.FindDrawable('Text2')).Text := data_tarefa + ' - ' + hora;

        // Icone detalhes...
        TListItemImage(Objects.FindDrawable('Image5')).Bitmap := img_detalhe.Bitmap;

    end;
end;

procedure TFrm_Principal.ThreadFim(Sender: TObject);
begin
    AniIndicator1.Enabled := false;
    ListView.EndUpdate;

    if Assigned(TThread(Sender).FatalException) then
        showmessage(Exception(TThread(Sender).FatalException).Message);
end;

procedure TFrm_Principal.Carrega_Tarefas(indClear : boolean);
var
    t : TThread;
begin
    if indClear then
        ListView.Items.Clear;


    AniIndicator1.Enabled := true;
    ListView.BeginUpdate;

    t := TThread.CreateAnonymousThread(
    procedure
    var
        x, cod_tarefa : integer;
        icone : TStream;
    begin
        // Busca um icone qualquer...
        qry_geral.Active := false;
        qry_geral.sql.Clear;
        qry_geral.sql.Add('SELECT * FROM TAB_TAREFA ORDER BY COD_TAREFA');
        qry_geral.Active := true;

        sleep(3000);

        qry_geral.First;
        while NOT qry_geral.Eof do
        begin
            cod_tarefa := x;
            icone := qry_geral.CreateBlobStream(qry_geral.FieldByName('ICONE'), TBlobStreamMode.bmRead);

            TThread.Synchronize(nil, procedure
            begin
                Add_Tarefa(qry_geral.FieldByName('COD_TAREFA').AsInteger,
                           qry_geral.FieldByName('DESCRICAO').AsString,
                           qry_geral.FieldByName('CATEGORIA').AsString,
                           'A',
                           '15/08/2019',
                           '08:00',
                           icone);
            end);

            qry_geral.Next;
            icone.DisposeOf;
        end;

    end);

    t.OnTerminate := ThreadFim;
    t.Start;


end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
    with Conn do
    begin
        {$IFDEF MSWINDOWS}
        try
            Params.Values['Database'] := 'D:\99Coders\Posts\235 - Como trabalhar com threads no Delphi ------\FontesScroll\DB\banco.db';

            if NOT FileExists(Params.Values['Database']) then
            begin
                showmessage('Banco não encontrado: ' + Params.Values['Database']);
                exit;
            end;

            Connected := true;
        except on E:Exception do
                raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;
        {$ELSE}
        Params.Values['DriverID'] := 'SQLite';
        try
            Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
            Connected := true;
        except on E:Exception do
                raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;
        {$ENDIF}
    end;
end;

procedure TFrm_Principal.btn_refreshClick(Sender: TObject);
begin
    Carrega_Tarefas(true);
end;

end.
