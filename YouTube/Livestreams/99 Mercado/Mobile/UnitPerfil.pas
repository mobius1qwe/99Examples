unit UnitPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, uLoading,
  uSession;

type
  TFrmPerfil = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    imgSalvar: TImage;
    Layout3: TLayout;
    Layout4: TLayout;
    Rectangle8: TRectangle;
    edtUF: TEdit;
    Rectangle9: TRectangle;
    edtCidade: TEdit;
    Rectangle6: TRectangle;
    edtEndereco: TEdit;
    Rectangle7: TRectangle;
    edtCEP: TEdit;
    Rectangle10: TRectangle;
    edtBairro: TEdit;
    Rectangle1: TRectangle;
    edtNome: TEdit;
    Rectangle2: TRectangle;
    edtEmail: TEdit;
    Rectangle3: TRectangle;
    edtSenha: TEdit;
    procedure FormShow(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure ThreadSalvarTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfil: TFrmPerfil;

implementation

{$R *.fmx}

uses DataModule.Usuario, UnitPrincipal;

procedure TFrmPerfil.ThreadDadosTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;
end;

procedure TFrmPerfil.ThreadSalvarTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

    close;
end;

procedure TFrmPerfil.CarregarDados;
var
    t : TThread;
begin
    TLoading.Show(FrmPerfil, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        //sleep(2000);

        // Buscar dados do usuario...
        DmUsuario.ListarUsuarioId(TSession.ID_USUARIO);

        with DmUsuario.TabUsuario do
        begin
            TThread.Synchronize(TThread.CurrentThread, procedure
            begin
                edtNome.Text := fieldbyname('nome').asstring;
                edtEmail.Text := fieldbyname('email').asstring;
                edtSenha.Text := fieldbyname('senha').asstring;
                edtEndereco.Text := fieldbyname('endereco').asstring;
                edtBairro.Text := fieldbyname('bairro').asstring;
                edtCidade.Text := fieldbyname('cidade').asstring;
                edtUF.Text := fieldbyname('uf').asstring;
                edtCEP.Text := fieldbyname('cep').asstring;
            end);
        end;
    end);

    t.OnTerminate := ThreadDadosTerminate;
    t.Start;
end;

procedure TFrmPerfil.FormShow(Sender: TObject);
begin
    CarregarDados;
end;

procedure TFrmPerfil.imgSalvarClick(Sender: TObject);
var
    t : TThread;
begin
    TLoading.Show(FrmPerfil, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        //sleep(2000);

        // Salvar dados do usuario na API...
        DmUsuario.EditarUsuario(TSession.ID_USUARIO, edtNome.Text, edtEmail.Text, edtSenha.Text,
                               edtEndereco.Text, edtBairro.Text, edtCidade.Text, edtUF.Text, edtCEP.Text);

        // Salvar dados do usuario localmente...
        DmUsuario.SalvarUsuarioLocal(TSession.ID_USUARIO, edtEmail.Text, edtNome.Text,
                               edtEndereco.Text, edtBairro.Text, edtCidade.Text, edtUF.Text, edtCEP.Text);

        FrmPrincipal.lblMenuEmail.Text := edtEmail.Text;
        FrmPrincipal.lblMenuNome.Text := edtNome.Text;
    end);

    t.OnTerminate := ThreadSalvarTerminate;
    t.Start;
end;

procedure TFrmPerfil.imgVoltarClick(Sender: TObject);
begin
    close;
end;

end.
