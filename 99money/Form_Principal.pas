unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.MultiView, FMX.ListBox, DataModule,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.ScrollBox,
  FMX.Memo, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, DB, MultiDetailAppearanceU,
  System.ImageList, FMX.ImgList, System.DateUtils, FGX.ActionSheet,
  FMX.MediaLibrary.Actions, FMX.StdActns, FMX.DateTimeCtrls;

type
  TFrm_Principal = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabMain: TTabItem;
    Rectangle1: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    edt_email: TEdit;
    Label2: TLabel;
    edt_senha: TEdit;
    btn_acessar: TButton;
    StyleBook1: TStyleBook;
    ActionList1: TActionList;
    ActMain: TChangeTabAction;
    ToolBar1: TToolBar;
    btn_menu: TSpeedButton;
    Rectangle2: TRectangle;
    lbl_painel_saldo: TLabel;
    lbl_painel_saldogeral: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    lbl_painel_rec: TLabel;
    lbl_painel_receitas: TLabel;
    Layout4: TLayout;
    lbl_painel_desp: TLabel;
    lbl_painel_despesas: TLabel;
    Layout5: TLayout;
    img_receita: TImage;
    img_despesa: TImage;
    MultiView: TMultiView;
    Rectangle3: TRectangle;
    Image2: TImage;
    ListBox1: TListBox;
    item_menu_painel: TListBoxItem;
    item_menu_lanc: TListBoxItem;
    item_menu_cat: TListBoxItem;
    item_menu_perfil: TListBoxItem;
    TabLancamentos: TTabItem;
    ToolBar2: TToolBar;
    btn_lanc_voltar: TSpeedButton;
    Label9: TLabel;
    Rectangle4: TRectangle;
    lbl_data: TLabel;
    btn_voltar_mes: TSpeedButton;
    btn_prox_mes: TSpeedButton;
    Rectangle5: TRectangle;
    Layout6: TLayout;
    lbl_tot_rec: TLabel;
    Label12: TLabel;
    Layout7: TLayout;
    lbl_tot_desp: TLabel;
    Label14: TLabel;
    ActLancamentos: TChangeTabAction;
    TabCategoria: TTabItem;
    ToolBar3: TToolBar;
    Label15: TLabel;
    btn_categoria_voltar: TSpeedButton;
    btn_categoria_adicionar: TSpeedButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    TabCategoriaCad: TTabItem;
    ActCategoriaCad: TChangeTabAction;
    ToolBar4: TToolBar;
    Label16: TLabel;
    btn_categoriacad_voltar: TSpeedButton;
    Label17: TLabel;
    edt_categoria: TEdit;
    ActCategoria: TChangeTabAction;
    LinkControlToField1: TLinkControlToField;
    ListView1: TListView;
    LinkListControlToField2: TLinkListControlToField;
    ListLancamentos: TListView;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    ImageList: TImageList;
    btn_categoriacad_salvar: TSpeedButton;
    ImageListBtn: TImageList;
    btn_excluir_cat: TSpeedButton;
    TabPerfil: TTabItem;
    ToolBar5: TToolBar;
    btn_perfil_voltar: TSpeedButton;
    Rectangle6: TRectangle;
    rect_foto: TRectangle;
    Label18: TLabel;
    ListBox2: TListBox;
    ListBoxItem5: TListBoxItem;
    item_senha: TListBoxItem;
    btn_senha: TButton;
    btn_logout: TSpeedButton;
    ActPerfil: TChangeTabAction;
    TabIdioma: TTabItem;
    ToolBar6: TToolBar;
    Label19: TLabel;
    btn_idioma_voltar: TSpeedButton;
    list_idioma: TListBox;
    item_portugues: TListBoxItem;
    item_ingles: TListBoxItem;
    ToolBar7: TToolBar;
    Label20: TLabel;
    list_moeda: TListBox;
    item_real: TListBoxItem;
    item_dolar: TListBoxItem;
    btn_idioma_salvar: TSpeedButton;
    TabLancamentoCad: TTabItem;
    ToolBar8: TToolBar;
    Label21: TLabel;
    btn_cad_voltar: TSpeedButton;
    btn_cad_salvar: TSpeedButton;
    ListBox5: TListBox;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    btn_cad_hoje: TButton;
    btn_cad_ontem: TButton;
    btn_cad_personalizar: TButton;
    edt_cad_valor: TEdit;
    cmb_cad_categoria: TComboBox;
    edt_cad_descricao: TEdit;
    ActIdioma: TChangeTabAction;
    ActLancamentoCad: TChangeTabAction;
    Label10: TLabel;
    rect_cad_conta: TRectangle;
    Label11: TLabel;
    edt_email_cad: TEdit;
    Label13: TLabel;
    edt_senha_cad: TEdit;
    btn_criar_conta: TButton;
    edt_nome_cad: TEdit;
    Label22: TLabel;
    ToolBar9: TToolBar;
    Label3: TLabel;
    btn_canc_conta: TSpeedButton;
    Layout8: TLayout;
    ActLogin: TChangeTabAction;
    fgAction: TfgActionSheet;
    ActFoto: TTakePhotoFromCameraAction;
    ActFotoLib: TTakePhotoFromLibraryAction;
    item_nome: TListBoxItem;
    btn_nome: TButton;
    edt_perfil_nome: TEdit;
    edt_perfil_senha: TEdit;
    rect_data: TRectangle;
    edt_cad_data: TDateEdit;
    LinkListControlToField3: TLinkListControlToField;
    btn_lanc_cad: TSpeedButton;
    fgActionCad: TfgActionSheet;
    btn_cad_excluir: TSpeedButton;
    procedure btn_acessarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure item_menu_lancClick(Sender: TObject);
    procedure btn_categoriacad_voltarClick(Sender: TObject);
    procedure item_menu_catClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btn_categoria_adicionarClick(Sender: TObject);
    procedure btn_categoria_voltarClick(Sender: TObject);
    procedure btn_lanc_voltarClick(Sender: TObject);
    procedure btn_categoriacad_salvarClick(Sender: TObject);
    procedure btn_excluir_catClick(Sender: TObject);
    procedure item_menu_perfilClick(Sender: TObject);
    procedure btn_voltar_mesClick(Sender: TObject);
    procedure btn_prox_mesClick(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure btn_criar_contaClick(Sender: TObject);
    procedure btn_canc_contaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_logoutClick(Sender: TObject);
    procedure ActFotoDidFinishTaking(Image: TBitmap);
    procedure ActFotoLibDidFinishTaking(Image: TBitmap);
    procedure btn_nomeClick(Sender: TObject);
    procedure btn_senhaClick(Sender: TObject);
    procedure btn_perfil_voltarClick(Sender: TObject);
    procedure rect_fotoClick(Sender: TObject);
    procedure ListBoxItem5Click(Sender: TObject);
    procedure btn_idioma_voltarClick(Sender: TObject);
    procedure item_portuguesClick(Sender: TObject);
    procedure item_inglesClick(Sender: TObject);
    procedure item_realClick(Sender: TObject);
    procedure item_dolarClick(Sender: TObject);
    procedure btn_idioma_salvarClick(Sender: TObject);
    procedure btn_cad_hojeClick(Sender: TObject);
    procedure btn_cad_ontemClick(Sender: TObject);
    procedure btn_cad_personalizarClick(Sender: TObject);
    procedure ListLancamentosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btn_cad_voltarClick(Sender: TObject);
    procedure btn_cad_salvarClick(Sender: TObject);
    procedure edt_cad_valorKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure img_receitaClick(Sender: TObject);
    procedure img_despesaClick(Sender: TObject);
    procedure btn_lanc_cadClick(Sender: TObject);
    procedure btn_cad_excluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;
  mes, ano : integer;
  simb_moeda, moeda, idioma : string;
  tipo_lancamento : string;
  operacao : string;

implementation

{$R *.fmx}


Procedure FormatarMoeda( Componente : TObject; var Key: Char );
var
   valor_str  : String;
   valor  : double;
begin

        if Componente is TEdit then
        begin
                // Se tecla pressionada é um numero, backspace ou delete...
                if ( Key in ['0'..'9', #8, #9] ) then
                begin
                         // Salva valor do edit...
                         valor_str := TEdit( Componente ).Text;

                         // Valida vazio...
                         if valor_str = EmptyStr then
                                valor_str := '0,00';

                         // Se valor numerico, insere na string...
                         if Key in ['0'..'9'] then
                                valor_str := Concat( valor_str, Key ) ;

                         // Retira pontos e virgulas...
                         valor_str := Trim( StringReplace( valor_str, '.', '', [rfReplaceAll, rfIgnoreCase] ) ) ;
                         valor_str := Trim( StringReplace( valor_str, ',', '', [rfReplaceAll, rfIgnoreCase] ) ) ;

                         // Inserindo 2 casas decimais...
                         valor := StrToFloat( valor_str ) ;
                         valor := ( valor / 100 ) ;

                         // Retornando valor tratado ao edit...
                         TEdit( Componente ).Text := FormatFloat( '###,##0.00', valor ) ;

                         // Reposiciona cursor...
                         TEdit( Componente ).SelStart := Length( TEdit( Componente ).Text );
                end;

                // Se nao é key importante, reseta...
                if Not( Key in [#8, #9] ) then
                        key := #0;
        end;

end;

function Nome_Mes() : string;
begin
        if idioma = 'INGLÊS' then
        begin
                case mes of
                        1 : Result := 'January';
                        2 : Result := 'February';
                        3 : Result := 'March';
                        4 : Result := 'April';
                        5 : Result := 'May';
                        6 : Result := 'June';
                        7 : Result := 'July';
                        8 : Result := 'August';
                        9 : Result := 'September';
                        10 : Result := 'October';
                        11 : Result := 'November';
                        12 : Result := 'December';
                end;
        end
        else
        begin
                case mes of
                        1 : Result := 'Janeiro';
                        2 : Result := 'Fevereiro';
                        3 : Result := 'Março';
                        4 : Result := 'Abril';
                        5 : Result := 'Maio';
                        6 : Result := 'Junho';
                        7 : Result := 'Julho';
                        8 : Result := 'Agosto';
                        9 : Result := 'Setembro';
                        10 : Result := 'Outubro';
                        11 : Result := 'Novembro';
                        12 : Result := 'Dezembro';
                end;
        end;
end;

procedure Trata_Moeda_Idioma();
begin
        dm.qry_perfil.Active := false;
        dm.qry_perfil.Active := true;

        moeda := dm.qry_perfil.FieldByName('MOEDA').AsString;
        idioma := dm.qry_perfil.FieldByName('IDIOMA').AsString;

        // Trata idioma nos campos da tela...
        if idioma = 'INGLÊS' then
        begin
                Frm_Principal.lbl_painel_despesas.Text := 'PAYABLE';
                Frm_Principal.lbl_painel_receitas.Text := 'RECEIVABLE';
                Frm_Principal.lbl_painel_saldogeral.Text := 'BALANCE';

                Frm_Principal.item_menu_painel.Text := 'DASHBOARD';
                Frm_Principal.item_menu_lanc.Text := 'FINANCIAL POSTINGS';
                Frm_Principal.item_menu_cat.Text := 'CATEGORIES';
                Frm_Principal.item_menu_perfil.Text := 'PROFILE';
        end
        else
        begin
                Frm_Principal.lbl_painel_despesas.Text := 'DESPESAS';
                Frm_Principal.lbl_painel_receitas.Text := 'RECEITAS';
                Frm_Principal.lbl_painel_saldogeral.Text := 'SALDO GERAL';

                Frm_Principal.item_menu_painel.Text := 'PAINEL GERENCIAL';
                Frm_Principal.item_menu_lanc.Text := 'LANÇAMENTOS';
                Frm_Principal.item_menu_cat.Text := 'CATEGORIAS';
                Frm_Principal.item_menu_perfil.Text := 'PERFIL';
        end;

        if moeda = 'DÓLAR' then
                simb_moeda := 'US$'
        else
                simb_moeda := 'R$';

end;

procedure Calcula_Painel();
var
        saldo : double;
begin
        // Soma as receitas e despesas do mes...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('SELECT IFNULL(SUM(CASE WHEN TIPO_LANCAMENTO = ''C'' THEN VALOR ELSE 0 END), 0) AS VALOR_REC, ');
        dm.qry_geral.sql.Add('       IFNULL(SUM(CASE WHEN TIPO_LANCAMENTO = ''D'' THEN VALOR ELSE 0 END), 0) AS VALOR_DESP ');
        dm.qry_geral.sql.Add('FROM TAB_LANCAMENTO L ');
        dm.qry_geral.sql.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)');
        dm.qry_geral.sql.Add('WHERE strftime(''%m'', L.DATA) = :MES');
        dm.qry_geral.sql.Add('AND strftime(''%Y'', L.DATA) = :ANO');
        dm.qry_geral.ParamByName('MES').Value := FormatFloat('00', MonthOf(now));
        dm.qry_geral.ParamByName('ANO').Value := FormatFloat('0000', YearOf(now));
        dm.qry_geral.Active := true;

        saldo := dm.qry_geral.FieldByName('VALOR_REC').AsFloat - dm.qry_geral.FieldByName('VALOR_DESP').AsFloat;

        frm_principal.lbl_painel_rec.Text := simb_moeda + FormatFloat('#,##0.00', dm.qry_geral.FieldByName('VALOR_REC').AsFloat);
        frm_principal.lbl_painel_desp.Text := simb_moeda + FormatFloat('#,##0.00', dm.qry_geral.FieldByName('VALOR_DESP').AsFloat);
        frm_principal.lbl_painel_saldo.Text := simb_moeda + FormatFloat('#,##0.00', saldo);

        if saldo < 0 then
                frm_principal.lbl_painel_saldo.Text := '- ' + frm_principal.lbl_painel_saldo.Text;

        dm.qry_geral.Active := false;
end;

procedure Lista_Lancamentos(mes, ano : string);
begin
        try
                // Lista os lancamentos...
                dm.qry_lancamento.Active := false;
                dm.qry_lancamento.sql.Clear;
                dm.qry_lancamento.sql.Add('SELECT L.*, C.DESCRICAO AS CATEGORIA ');
                //dm.qry_lancamento.sql.Add('CASE WHEN L.TIPO_LANCAMENTO = ''C'' THEN 0 ELSE 1 END AS ICONE ');
                dm.qry_lancamento.sql.Add('FROM TAB_LANCAMENTO L ');
                dm.qry_lancamento.sql.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)');
                dm.qry_lancamento.sql.Add('WHERE strftime(''%m'', L.DATA) = :MES');
                dm.qry_lancamento.sql.Add('AND strftime(''%Y'', L.DATA) = :ANO');

                dm.qry_lancamento.ParamByName('MES').Value := mes;
                dm.qry_lancamento.ParamByName('ANO').Value := ano;

                dm.qry_lancamento.Active := true;


                // Soma as receitas e despesas do mes...
                dm.qry_geral.Active := false;
                dm.qry_geral.sql.Clear;
                dm.qry_geral.sql.Add('SELECT IFNULL(SUM(CASE WHEN TIPO_LANCAMENTO = ''C'' THEN VALOR ELSE 0 END), 0) AS VALOR_REC, ');
                dm.qry_geral.sql.Add('       IFNULL(SUM(CASE WHEN TIPO_LANCAMENTO = ''D'' THEN VALOR ELSE 0 END), 0) AS VALOR_DESP ');
                dm.qry_geral.sql.Add('FROM TAB_LANCAMENTO L ');
                dm.qry_geral.sql.Add('JOIN TAB_CATEGORIA C ON (C.ID_CATEGORIA = L.ID_CATEGORIA)');
                dm.qry_geral.sql.Add('WHERE strftime(''%m'', L.DATA) = :MES');
                dm.qry_geral.sql.Add('AND strftime(''%Y'', L.DATA) = :ANO');
                dm.qry_geral.ParamByName('MES').Value := mes;
                dm.qry_geral.ParamByName('ANO').Value := ano;
                dm.qry_geral.Active := true;

                frm_principal.lbl_tot_rec.Text := simb_moeda + FormatFloat('#,##0.00', dm.qry_geral.FieldByName('VALOR_REC').AsFloat);
                frm_principal.lbl_tot_desp.Text := simb_moeda + FormatFloat('#,##0.00', dm.qry_geral.FieldByName('VALOR_DESP').AsFloat);
                dm.qry_geral.Active := false;
        except
                frm_principal.lbl_tot_rec.Text := simb_moeda + FormatFloat('#,##0.00', 0);
                frm_principal.lbl_tot_desp.Text := simb_moeda + FormatFloat('#,##0.00', 0);
        end;

        // Acerta texto do mes / ano...
        Frm_Principal.lbl_data.Text := Nome_Mes() + ' ' + ano;
end;

procedure TFrm_Principal.ActFotoDidFinishTaking(Image: TBitmap);
begin
        // Atualizar perfil do usuario...
        rect_foto.Fill.Bitmap.Bitmap := Image;

        if not (dm.qry_perfil.State in dsEditModes) then
                dm.qry_perfil.Edit;

        dm.qry_perfil.FieldByName('FOTO').Assign(Image);
        dm.qry_perfil.Post;
end;

procedure TFrm_Principal.ActFotoLibDidFinishTaking(Image: TBitmap);
begin
        // Atualizar perfil do usuario...
        rect_foto.Fill.Bitmap.Bitmap := Image;

        if not (dm.qry_perfil.State in dsEditModes) then
                dm.qry_perfil.Edit;

        dm.qry_perfil.FieldByName('FOTO').Assign(Image);
        dm.qry_perfil.Post;
end;

procedure TFrm_Principal.btn_acessarClick(Sender: TObject);
begin
        // Trata login...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('select * from tab_config where email = :email and senha = :senha');
        dm.qry_geral.ParamByName('email').Value := edt_email.Text;
        dm.qry_geral.ParamByName('senha').Value := edt_senha.Text;
        dm.qry_geral.Active := true;

        if dm.qry_geral.RecordCount = 0 then
        begin
                showmessage('Email ou senha inválida');
                exit;
        end;

        // Atualiza informacoes de login...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('update tab_config set ind_login = ''S'' ');
        dm.qry_geral.ExecSQL;


        Trata_Moeda_Idioma();

        Calcula_Painel();
        ActMain.ExecuteTarget(self);
end;

procedure TFrm_Principal.btn_cad_excluirClick(Sender: TObject);
begin
        MessageDlg('Confirma exclusão?', System.UITypes.TMsgDlgType.mtConfirmation,
    [
      System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
                dm.qry_lancamento.Delete;

                Lista_Lancamentos(FormatFloat('00', mes), FormatFloat('0000', ano));
                Calcula_Painel();


                ActLancamentos.ExecuteTarget(sender);
          end;
      end;
    end);

end;

procedure TFrm_Principal.btn_cad_hojeClick(Sender: TObject);
begin
        btn_cad_ontem.TextSettings.FontColor := $FF060606;
        btn_cad_personalizar.TextSettings.FontColor := $FF060606;
        rect_data.Visible := false;
        edt_cad_data.Date := date();

        if btn_cad_hoje.TextSettings.FontColor <> $FF0C61A7 then
                btn_cad_hoje.TextSettings.FontColor := $FF0C61A7
        else
                btn_cad_hoje.TextSettings.FontColor := $FF060606;
end;

procedure TFrm_Principal.btn_cad_ontemClick(Sender: TObject);
begin
        btn_cad_hoje.TextSettings.FontColor := $FF060606;
        btn_cad_personalizar.TextSettings.FontColor := $FF060606;
        rect_data.Visible := false;
        edt_cad_data.Date := date() - 1;

        if btn_cad_ontem.TextSettings.FontColor <> $FF0C61A7 then
                btn_cad_ontem.TextSettings.FontColor := $FF0C61A7
        else
                btn_cad_ontem.TextSettings.FontColor := $FF060606;
end;

procedure TFrm_Principal.btn_cad_personalizarClick(Sender: TObject);
begin
        btn_cad_hoje.TextSettings.FontColor := $FF060606;
        btn_cad_ontem.TextSettings.FontColor := $FF060606;
        rect_data.Visible := true;
        //edt_cad_data.Date := date();

        if btn_cad_personalizar.TextSettings.FontColor <> $FF0C61A7 then
                btn_cad_personalizar.TextSettings.FontColor := $FF0C61A7
        else
                btn_cad_personalizar.TextSettings.FontColor := $FF060606;
end;

procedure TFrm_Principal.btn_cad_salvarClick(Sender: TObject);
begin
        if edt_cad_valor.Text = '' then
        begin
                showmessage('Informe o valor');
                exit;
        end;

        // Salva dados na base...
        if (dm.qry_lancamento.State in dsEditModes) then
        begin
                // Se for novo registro, calcular chave...
                if operacao = 'I' then
                begin
                        dm.qry_geral.Active := false;
                        dm.qry_geral.sql.Clear;
                        dm.qry_geral.sql.Add('SELECT IFNULL(MAX(ID_LANCAMENTO), 0) AS ID_LANCAMENTO FROM TAB_LANCAMENTO');
                        dm.qry_geral.Active := true;

                        dm.qry_lancamento.FieldByName('ID_LANCAMENTO').Value := dm.qry_geral.FieldByName('ID_LANCAMENTO').AsInteger + 1;
                end;

                dm.qry_lancamento.FieldByName('VALOR').Value := StringReplace(edt_cad_valor.Text, '.', '', [rfReplaceAll]);
                dm.qry_lancamento.FieldByName('ID_CATEGORIA').Value := dm.qry_categoria.FieldByName('ID_CATEGORIA').AsInteger;
                dm.qry_lancamento.FieldByName('DESCRICAO').Value := edt_cad_descricao.Text;
                dm.qry_lancamento.FieldByName('DATA').Value := edt_cad_data.Date;
                dm.qry_lancamento.FieldByName('TIPO_LANCAMENTO').Value := tipo_lancamento;

                dm.qry_lancamento.Post;
        end;

        Lista_Lancamentos(FormatFloat('00', mes), FormatFloat('0000', ano));
        Calcula_Painel();

        ActLancamentos.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_cad_voltarClick(Sender: TObject);
begin
        if (dm.qry_lancamento.State in dsEditModes) then
                dm.qry_lancamento.Cancel;

        ActLancamentos.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_canc_contaClick(Sender: TObject);
begin
        rect_cad_conta.Visible := false;
end;

procedure TFrm_Principal.btn_categoriacad_salvarClick(Sender: TObject);
begin
        if  edt_categoria.Text = '' then
        begin
                showmessage('Informe o nome da categoria.');
                exit;
        end;

        if dm.qry_categoria.State in dsEditModes  then
        begin
                // Se for novo registro, calcular chave...
                if operacao = 'I' then
                begin
                        dm.qry_geral.Active := false;
                        dm.qry_geral.sql.Clear;
                        dm.qry_geral.sql.Add('SELECT IFNULL(MAX(ID_CATEGORIA), 0) AS ID_CATEGORIA FROM TAB_CATEGORIA');
                        dm.qry_geral.Active := true;

                        dm.qry_categoria.FieldByName('ID_CATEGORIA').Value := dm.qry_geral.FieldByName('ID_CATEGORIA').AsInteger + 1;
                end;

                dm.qry_categoria.Post;
        end;

        ActCategoria.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_categoriacad_voltarClick(Sender: TObject);
begin
        if dm.qry_categoria.State in dsEditModes  then
                dm.qry_categoria.Cancel;

        ActCategoria.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_categoria_adicionarClick(Sender: TObject);
begin
        dm.qry_categoria.Append;
        operacao := 'I';

        btn_excluir_cat.Visible := false;
        ActCategoriaCad.ExecuteTarget(sender);
        edt_categoria.SetFocus;
end;

procedure TFrm_Principal.btn_categoria_voltarClick(Sender: TObject);
begin
         ActMain.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_criar_contaClick(Sender: TObject);
begin
        if edt_nome_cad.Text = '' then
        begin
                showmessage('Informe o nome');
                exit;
        end;

        if edt_email_cad.Text = '' then
        begin
                showmessage('Informe o email');
                exit;
        end;

        if edt_senha_cad.Text = '' then
        begin
                showmessage('Informe a senha');
                exit;
        end;

        // Exclui usuario (se existir)...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('delete from tab_config');
        dm.qry_geral.ExecSQL;

        // Insere novo usuário...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('insert into tab_config(email, senha, ind_login, nome, idioma, moeda)');
        dm.qry_geral.sql.Add('values(:email, :senha, :ind_login, :nome, :idioma, :moeda)');
        dm.qry_geral.ParamByName('email').Value := edt_email_cad.Text;
        dm.qry_geral.ParamByName('senha').Value := edt_senha_cad.Text;
        dm.qry_geral.ParamByName('ind_login').Value := 'S';
        dm.qry_geral.ParamByName('nome').Value := edt_nome_cad.Text;
        dm.qry_geral.ParamByName('idioma').Value := 'PORTUGUÊS';
        dm.qry_geral.ParamByName('moeda').Value := 'REAL';
        dm.qry_geral.ExecSQL;

        Trata_Moeda_Idioma();

        Calcula_Painel();
        ActMain.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_excluir_catClick(Sender: TObject);
begin
        MessageDlg('Confirma exclusão?', System.UITypes.TMsgDlgType.mtConfirmation,
    [
      System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
          begin
                dm.qry_categoria.Delete;
                ActCategoria.ExecuteTarget(sender);
          end;
      end;
    end);
end;



procedure TFrm_Principal.btn_idioma_salvarClick(Sender: TObject);
begin
        if not (dm.qry_perfil.State in dsEditModes) then
                dm.qry_perfil.Edit;

        if item_ingles.ItemData.Accessory = TListBoxItemData.TAccessory.aCheckmark then
                dm.qry_perfil.FieldByName('IDIOMA').Value := 'INGLÊS'
        else
                dm.qry_perfil.FieldByName('IDIOMA').Value := 'PORTUGUÊS';

        if item_dolar.ItemData.Accessory = TListBoxItemData.TAccessory.aCheckmark then
                dm.qry_perfil.FieldByName('MOEDA').Value := 'DÓLAR'
        else
                dm.qry_perfil.FieldByName('MOEDA').Value := 'REAL';

        dm.qry_perfil.Post;


        // Trata lingua e moeda do app...
        Trata_Moeda_Idioma();


        ActPerfil.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_idioma_voltarClick(Sender: TObject);
begin
        ActPerfil.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_lanc_cadClick(Sender: TObject);
begin
        fgActionCad.Show;
end;

procedure TFrm_Principal.btn_lanc_voltarClick(Sender: TObject);
begin
        ActMain.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_logoutClick(Sender: TObject);
begin
        // Faz logout do sistema...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('update tab_config set ind_login = ''N'' ');
        dm.qry_geral.ExecSQL;

        ActLogin.ExecuteTarget(sender);

end;

procedure TFrm_Principal.btn_nomeClick(Sender: TObject);
begin
        if btn_nome.Text = 'Alterar' then
        begin
                edt_perfil_nome.Visible := true;
                edt_perfil_nome.Text := item_nome.Text;
                btn_nome.Text := 'Salvar';
                item_nome.Text := '';
                edt_perfil_nome.SetFocus;
        end
        else
        begin
                edt_perfil_nome.Visible := false;
                btn_nome.Text := 'Alterar';
                item_nome.Text := edt_perfil_nome.Text;

                // Salva nome dna base...
                if not (dm.qry_perfil.State in dsEditModes) then
                        dm.qry_perfil.Edit;

                dm.qry_perfil.FieldByName('NOME').Value := edt_perfil_nome.Text;
                dm.qry_perfil.Post;
        end;
end;

procedure TFrm_Principal.btn_perfil_voltarClick(Sender: TObject);
begin
        ActMain.ExecuteTarget(sender);
end;

procedure TFrm_Principal.btn_prox_mesClick(Sender: TObject);
begin
        // Atualiza lista de lancamentos...
        mes := mes + 1;

        if mes > 12 then
        begin
                mes := 1;
                ano := ano + 1;
        end;

        Lista_Lancamentos(FormatFloat('00', mes), FormatFloat('0000', ano));
end;

procedure TFrm_Principal.btn_senhaClick(Sender: TObject);
begin
        if btn_senha.Text = 'Alterar' then
        begin
                edt_perfil_senha.Visible := true;
                btn_senha.Text := 'Salvar';
                item_senha.Text := '';
                edt_perfil_senha.SetFocus;
        end
        else
        begin
                edt_perfil_senha.Visible := false;
                btn_senha.Text := 'Alterar';
                item_senha.Text := edt_perfil_senha.Text;

                // Salva nome dna base...
                if not (dm.qry_perfil.State in dsEditModes) then
                        dm.qry_perfil.Edit;

                dm.qry_perfil.FieldByName('SENHA').Value := edt_perfil_senha.Text;
                dm.qry_perfil.Post;
        end;
end;

procedure TFrm_Principal.btn_voltar_mesClick(Sender: TObject);
begin
        // Atualiza lista de lancamentos...
        mes := mes - 1;

        if mes = 0 then
        begin
                mes := 12;
                ano := ano -1;
        end;

        Lista_Lancamentos(FormatFloat('00', mes), FormatFloat('0000', ano));
end;

procedure TFrm_Principal.edt_cad_valorKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
        FormatarMoeda(edt_cad_valor, KeyChar);
end;

procedure TFrm_Principal.FormCreate(Sender: TObject);
begin
        TabControl.ActiveTab := TabLogin;
        TabControl.TabPosition := TTabPosition.None;
end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
        // Trata login...
        dm.qry_geral.Active := false;
        dm.qry_geral.sql.Clear;
        dm.qry_geral.sql.Add('select * from tab_config where ind_login = ''S'' ');
        dm.qry_geral.Active := true;

        if dm.qry_geral.RecordCount > 0 then
        begin
                Calcula_Painel();
                ActMain.ExecuteTarget(sender);
        end;

        // Abre query lancamentos...
        mes :=  MonthOf(now);
        ano :=  YearOf(now);
        Lista_Lancamentos(FormatFloat('00', mes), FormatFloat('0000', ano));
        Calcula_Painel();
end;

procedure TFrm_Principal.img_despesaClick(Sender: TObject);
begin
        dm.qry_categoria.Active := false;
        dm.qry_categoria.Active := true;

        // Limpa campos...
        edt_cad_valor.Text := '';
        edt_cad_descricao.Text := '';
        edt_cad_data.date := date();
        rect_data.Visible := false;
        edt_cad_data.Date := date();

        btn_cad_hoje.TextSettings.FontColor := $FF0C61A7;
        btn_cad_ontem.TextSettings.FontColor := $FF060606;
        btn_cad_personalizar.TextSettings.FontColor := $FF060606;


        // Colocar em modo de edicao...
        dm.qry_lancamento.Append;
        operacao := 'I';
        tipo_lancamento := 'D';

        btn_cad_excluir.Visible := false;

        ActLancamentoCad.ExecuteTarget(sender);
end;

procedure TFrm_Principal.img_receitaClick(Sender: TObject);
begin
        dm.qry_categoria.Active := false;
        dm.qry_categoria.Active := true;

        // Limpa campos...
        edt_cad_valor.Text := '';
        edt_cad_descricao.Text := '';
        edt_cad_data.date := date();
        rect_data.Visible := false;
        edt_cad_data.Date := date();

        btn_cad_hoje.TextSettings.FontColor := $FF0C61A7;
        btn_cad_ontem.TextSettings.FontColor := $FF060606;
        btn_cad_personalizar.TextSettings.FontColor := $FF060606;


        // Colocar em modo de edicao...
        dm.qry_lancamento.Append;
        operacao := 'I';
        tipo_lancamento := 'C';

        btn_cad_excluir.Visible := false;

        ActLancamentoCad.ExecuteTarget(sender);
end;

procedure TFrm_Principal.item_dolarClick(Sender: TObject);
begin
        item_real.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
        item_dolar.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;
end;

procedure TFrm_Principal.item_inglesClick(Sender: TObject);
begin
        item_portugues.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
        item_ingles.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;
end;

procedure TFrm_Principal.item_portuguesClick(Sender: TObject);
begin
        item_portugues.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;
        item_ingles.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
end;

procedure TFrm_Principal.item_realClick(Sender: TObject);
begin
        item_real.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;
        item_dolar.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
end;

procedure TFrm_Principal.Label10Click(Sender: TObject);
begin
        rect_cad_conta.Visible := true;
        edt_nome_cad.SetFocus;
end;

procedure TFrm_Principal.item_menu_lancClick(Sender: TObject);
begin
        // Atualiza lista de lancamentos...
        mes :=  MonthOf(now);
        ano :=  YearOf(now);
        Lista_Lancamentos(FormatFloat('00', mes), FormatFloat('0000', ano));

        // Esconde o menu...
        MultiView.HideMaster;

        // Muda para a aba de lancamentos...
        ActLancamentos.ExecuteTarget(self);
end;

procedure TFrm_Principal.item_menu_catClick(Sender: TObject);
begin
        // Atualiza lista de categorias...
        dm.qry_categoria.Active := false;
        dm.qry_categoria.Active := true;

        // Esconde menu...
        MultiView.HideMaster;

        // Muda para aba Categoria...
        ActCategoria.ExecuteTarget(sender);
end;

procedure TFrm_Principal.item_menu_perfilClick(Sender: TObject);
var
        img : TStream;
begin
        // Busca dados do usuario...
        dm.qry_perfil.Active := false;
        dm.qry_perfil.Active := true;

        if dm.qry_perfil.FieldValues['FOTO'] <> null then
        begin
                img := dm.qry_perfil.CreateBlobStream(dm.qry_perfil.FieldByName('FOTO'), TBlobStreamMode.bmRead);
                rect_foto.Fill.Bitmap.Bitmap.LoadFromStream(img);
        end;

        // Tratamento de nome...
        btn_nome.Text := 'Alterar';
        edt_perfil_nome.Visible := false;
        item_nome.Text := dm.qry_perfil.FieldByName('NOME').AsString;

        // Tratamento da senha...
        btn_senha.Text := 'Alterar';
        edt_perfil_senha.Visible := false;
        item_senha.Text := 'Alterar Senha';

        ActPerfil.ExecuteTarget(sender);
        MultiView.HideMaster;
end;

procedure TFrm_Principal.ListBoxItem5Click(Sender: TObject);
begin
        // Trata idioma...
        item_portugues.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
        item_ingles.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;

        if dm.qry_perfil.FieldByName('IDIOMA').AsString = 'INGLÊS' then
                item_ingles.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark
        else
                item_portugues.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;

        // Trata moeda...
        item_real.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;
        item_dolar.ItemData.Accessory := TListBoxItemData.TAccessory.aNone;

        if dm.qry_perfil.FieldByName('MOEDA').AsString = 'DÓLAR' then
                item_dolar.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark
        else
                item_real.ItemData.Accessory := TListBoxItemData.TAccessory.aCheckmark;

        ActIdioma.ExecuteTarget(sender);
end;

procedure TFrm_Principal.ListLancamentosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
        x : integer;
begin
        dm.qry_categoria.Active := false;
        dm.qry_categoria.Active := true;

        // Preenche campo valor...
        edt_cad_valor.Text := FormatFloat('#,##0.00', dm.qry_lancamento.FieldByName('VALOR').AsFloat);

        // Preenche o campo categoria...
        for x := 1 to dm.qry_categoria.RecordCount do
        begin
                if dm.qry_categoria.FieldByName('DESCRICAO').AsString = dm.qry_lancamento.FieldByName('CATEGORIA').AsString then
                        break;

                dm.qry_categoria.Next;
        end;

        // Preenche campo descricao...
        edt_cad_descricao.Text := dm.qry_lancamento.FieldByName('DESCRICAO').AsString;

        // Preenche campo data...
        edt_cad_data.date := dm.qry_lancamento.FieldByName('DATA').AsDateTime;

        rect_data.Visible := true;
        btn_cad_hoje.TextSettings.FontColor := $FF060606;
        btn_cad_ontem.TextSettings.FontColor := $FF060606;
        btn_cad_personalizar.TextSettings.FontColor := $FF0C61A7;

        btn_cad_excluir.Visible := true;

        // Colocar em modo de edicao...
        operacao := 'A';
        dm.qry_lancamento.Edit;

        tipo_lancamento := dm.qry_lancamento.FieldByName('TIPO_LANCAMENTO').AsString;

        ActLancamentoCad.ExecuteTarget(sender);
end;

procedure TFrm_Principal.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
        dm.qry_categoria.Edit;
        operacao := 'A';

        btn_excluir_cat.Visible := true;
        ActCategoriaCad.ExecuteTarget(sender);
        edt_categoria.SetFocus;
end;

procedure TFrm_Principal.rect_fotoClick(Sender: TObject);
begin
        fgAction.Show;
end;

end.
