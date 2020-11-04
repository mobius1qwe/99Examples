unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.ListBox, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Ani, System.Actions, FMX.ActnList, UnitFrame, FMX.Edit,
  FMX.ScrollBox, FMX.Memo;

type
  TFrmPrincipal = class(TForm)
    rect_toolbar: TRectangle;
    img_logo: TImage;
    img_busca: TImage;
    img_tab1: TImage;
    layout_slide: TLayout;
    rect_selecao: TRectangle;
    Line1: TLine;
    img_tab2: TImage;
    img_tab3: TImage;
    img_tab4: TImage;
    layout_aba1: TLayout;
    layout_aba2: TLayout;
    layout_aba4: TLayout;
    layout_aba3: TLayout;
    TabControl: TTabControl;
    StyleBook1: TStyleBook;
    lb_favorito: TListBox;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    lbl_titulo: TLabel;
    AnimationSelecao: TFloatAnimation;
    rect_abas: TRectangle;
    ActionList1: TActionList;
    ActTab1: TChangeTabAction;
    ActTab2: TChangeTabAction;
    ActTab3: TChangeTabAction;
    ActTab4: TChangeTabAction;
    img_tab1_sel: TImage;
    img_tab2_sel: TImage;
    img_tab3_sel: TImage;
    img_tab4_sel: TImage;
    lb_password: TListBox;
    lb_card: TListBox;
    lb_note: TListBox;
    icone_password: TImage;
    icone_card: TImage;
    icone_note: TImage;
    TabDetalhe: TTabItem;
    ActTabDetalhe: TChangeTabAction;
    img_cancelar: TImage;
    rect_busca: TRectangle;
    edt_busca: TEdit;
    img_cancel_busca: TImage;
    AnimationBusca: TFloatAnimation;
    RoundRect1: TRoundRect;
    layout_cad_senha: TLayout;
    Edit1: TEdit;
    Layout3: TLayout;
    Line3: TLine;
    Label3: TLabel;
    Layout4: TLayout;
    edt_senha: TEdit;
    Line7: TLine;
    Label4: TLabel;
    Layout5: TLayout;
    img_exibir: TImage;
    img_esconder: TImage;
    Layout6: TLayout;
    Edit3: TEdit;
    Line8: TLine;
    Label7: TLabel;
    img_salvar: TImage;
    Layout7: TLayout;
    lbl_gerar_senha: TLabel;
    layout_gerar_senha: TLayout;
    lbl_texto_tamanho: TLabel;
    track_tamanho: TTrackBar;
    sw_upper: TSwitch;
    Label13: TLabel;
    sw_special: TSwitch;
    Label14: TLabel;
    sw_digits: TSwitch;
    Label23: TLabel;
    img_refresh_senha: TImage;
    Layout8: TLayout;
    img_favorito: TImage;
    layout_cad_cartao: TLayout;
    Layout9: TLayout;
    Edit2: TEdit;
    Line13: TLine;
    Label12: TLabel;
    Layout13: TLayout;
    Edit5: TEdit;
    Line20: TLine;
    Label30: TLabel;
    Layout1: TLayout;
    Layout10: TLayout;
    Edit4: TEdit;
    Line16: TLine;
    Label24: TLabel;
    Layout11: TLayout;
    Edit6: TEdit;
    Line21: TLine;
    Label29: TLabel;
    layout_cad_nota: TLayout;
    Layout14: TLayout;
    Edit7: TEdit;
    Line22: TLine;
    Label37: TLabel;
    Layout15: TLayout;
    Label38: TLabel;
    Memo1: TMemo;
    img_sem_senha: TImage;
    img_sem_cartao: TImage;
    img_sem_notas: TImage;
    img_sem_favorito: TImage;
    img_add: TImage;
    layout_aba5: TLayout;
    img_tab5_sel: TImage;
    img_tab5: TImage;
    ActTab5: TChangeTabAction;
    TabItem5: TTabItem;
    Rectangle3: TRectangle;
    Label16: TLabel;
    Rectangle1: TRectangle;
    Label1: TLabel;
    procedure layout_aba1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure img_cancelarClick(Sender: TObject);
    procedure img_buscaClick(Sender: TObject);
    procedure img_cancel_buscaClick(Sender: TObject);
    procedure AnimationBuscaFinish(Sender: TObject);
    procedure track_tamanhoChange(Sender: TObject);
    procedure lbl_gerar_senhaClick(Sender: TObject);
    procedure sw_upperClick(Sender: TObject);
    procedure img_refresh_senhaClick(Sender: TObject);
    procedure img_addClick(Sender: TObject);
  private
    procedure SelecionaAba(Sender: TObject);
    procedure ListarFavorito;
    procedure AddFrame(lb : TListBox; icone : TTipoItem;
                       cod_item, titulo, descricao : string);
    procedure ListarPassword;
    procedure ListarCard;
    procedure ListarNote;
    procedure DetalheItem(const Sender: TCustomListBox;
                          const Item: TListBoxItem);
    procedure FecharBusca;
    function RandomPassword(Size: integer; Upper, Digits, SpecialChar: boolean): string;
    procedure GerarSenha;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

function TFrmPrincipal.RandomPassword(Size : integer; Upper, Digits, SpecialChar : boolean): string;

{max length of generated password}
const
  intMAX_PW_LEN = 10;
var
  i: Byte;
  s: string;
begin
    if Upper then
        s := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    else
        s := '';

    //if Lower then
    s := s + 'abcdefghijklmnopqrstuvwxyz';

    if Digits then
        s := s + '0123456789';

    if SpecialChar then
        s := s + '()@#$%*+';

    if s = '' then
        exit;

    Result := '';

    for i := 0 to Size - 1 do
        Result := Result + s[Random(Length(s)-1)+1];
end;

procedure TFrmPrincipal.GerarSenha();
begin
    edt_senha.text := RandomPassword(FormatFloat('00', track_tamanho.Value).ToInteger,
                                     sw_upper.IsChecked,
                                     sw_digits.IsChecked,
                                     sw_special.IsChecked);
end;

procedure TFrmPrincipal.FecharBusca;
begin
    if AnimationBusca.Inverse then
        AnimationBusca.Start;
end;

procedure TFrmPrincipal.DetalheItem(const Sender: TCustomListBox;
                                    const Item: TListBoxItem);
var
    tipo : TTipoItem;
begin
    // Aguarda aba que estava selecionada...
    ActTabDetalhe.Tag := TabControl.TabIndex + 1; // Soma +1 porque o index comeca em zero

    // Esconde a busca caso esteja aberta...
    FecharBusca;

    // Esconde painel de gerar senha aleatoria...
    layout_gerar_senha.Visible := false;
    lbl_gerar_senha.Text := 'Gerar Nova';


    img_logo.Visible := false;
    img_cancelar.Visible := true;
    img_salvar.Visible := true;
    img_favorito.Align := TAlignLayout.None;
    img_favorito.Align := TAlignLayout.Right;
    img_favorito.Visible := true;
    img_busca.Visible := false;
    img_add.Visible := false;

    layout_cad_senha.Visible := false;
    layout_cad_cartao.Visible := false;
    layout_cad_nota.Visible := false;

    if item.Tag = 1 then
    begin
        lbl_titulo.Text := 'Editar Senha';
        layout_cad_senha.Visible := true;
    end
    else if item.Tag = 2 then
    begin
        lbl_titulo.Text := 'Editar Cartão';
        layout_cad_cartao.Visible := true;
    end
    else
    begin
        lbl_titulo.Text := 'Editar Nota';
        layout_cad_nota.Visible := true;
    end;

    {$IFDEF ANDROID}
    TAnimator.AnimateFloat(rect_abas, 'Margins.Top', -51, 0.2, TAnimationType.&In, TInterpolationType.Circular);
    {$ELSE}
    TAnimator.AnimateFloat(rect_abas, 'Margins.Bottom', -60, 0.2, TAnimationType.&In, TInterpolationType.Circular);
    {$ENDIF]}
    ActTabDetalhe.Execute;
end;

procedure TFrmPrincipal.AnimationBuscaFinish(Sender: TObject);
begin
    AnimationBusca.Inverse := NOT AnimationBusca.Inverse;
    rect_busca.Visible := AnimationBusca.Inverse;
end;

procedure TFrmPrincipal.img_cancelarClick(Sender: TObject);
begin
    img_cancelar.Visible := false;
    img_favorito.Visible := false;
    img_salvar.Visible := false;
    img_logo.Visible := true;
    img_busca.Visible := true;

    {$IFDEF ANDROID}
    TAnimator.AnimateFloat(rect_abas, 'Margins.Top', 0, 0.2, TAnimationType.&In, TInterpolationType.Circular);
    {$ELSE}
    TAnimator.AnimateFloat(rect_abas, 'Margins.Bottom', 0, 0.2, TAnimationType.&In, TInterpolationType.Circular);
    {$ENDIF}

    case ActTabDetalhe.Tag of
        1: SelecionaAba(layout_aba1);
        2: SelecionaAba(layout_aba2);
        3: SelecionaAba(layout_aba3);
        4: SelecionaAba(layout_aba4);
    end;

    img_add.Visible := true;
end;

procedure TFrmPrincipal.AddFrame(lb : TListBox;
                                 icone : TTipoItem;
                                 cod_item, titulo, descricao : string);
var
    item : TListBoxItem;
    f : TFrmFrame;
begin
    item := TListBoxItem.Create(nil);
    item.Text := '';
    item.Height := 77;
    item.Align := TAlignLayout.Client;
    item.TagString := cod_item;
    item.Selectable := false;

    f := TFrmFrame.Create(item);
    f.Parent := item;
    f.Align := TAlignLayout.Client;

    f.lbl_titulo.Text := titulo;
    f.lbl_subtitulo.Text := descricao;

    // Monta icone...
    if icone = TTipoItem.Password then
    begin
        f.img_icone.Bitmap := icone_password.Bitmap;
        item.Tag := 1; // Armazena o tipo do tem na TAG
    end
    else if icone = TTipoItem.Card then
    begin
        f.img_icone.Bitmap := icone_card.Bitmap;
        item.Tag := 2; // Armazena o tipo do tem na TAG
    end
    else
    begin
        f.img_icone.Bitmap := icone_note.Bitmap;
        item.Tag := 3; // Armazena o tipo do tem na TAG
    end;

    lb.AddObject(item);
end;

procedure TFrmPrincipal.ListarFavorito();
begin
    img_sem_favorito.Visible := false;
    lb_favorito.Items.Clear;
    lb_favorito.OnItemClick := DetalheItem;

    AddFrame(lb_favorito, TTipoItem.Password, '001', 'Gmail', 'heber@99coders.com.br');
    AddFrame(lb_favorito, TTipoItem.Password, '002', 'Hotmail', 'teste@hotmail.com');
    AddFrame(lb_favorito, TTipoItem.Password, '003', 'Yahoo', 'heber@yahoo.com.br');
    AddFrame(lb_favorito, TTipoItem.Card, '004', 'Nubank', 'XXXX-XXXX-XXXX-5242');
    AddFrame(lb_favorito, TTipoItem.Card, '005', 'Visa', 'XXXX-XXXX-XXXX-6855');
    AddFrame(lb_favorito, TTipoItem.Note, '006', 'Nota', 'Lista de compras');
    AddFrame(lb_favorito, TTipoItem.Note, '006', 'Nota', 'Minhas anotações');
    AddFrame(lb_favorito, TTipoItem.Note, '006', 'Nota', 'Notas Gerais');
end;

procedure TFrmPrincipal.ListarPassword();
begin
    img_sem_senha.Visible := false;
    lb_password.Items.Clear;
    lb_password.OnItemClick := DetalheItem;

    AddFrame(lb_password, TTipoItem.Password, '001', 'Gmail', 'heber@99coders.com.br');
    AddFrame(lb_password, TTipoItem.Password, '002', 'Hotmail', 'teste@hotmail.com');
    AddFrame(lb_password, TTipoItem.Password, '003', 'Yahoo', 'heber@yahoo.com.br');
    AddFrame(lb_password, TTipoItem.Password, '009', 'Yahoo', 'heber@yahoo.com.br');
end;

procedure TFrmPrincipal.ListarCard();
begin
    img_sem_cartao.Visible := false;
    lb_card.Items.Clear;
    lb_card.OnItemClick := DetalheItem;

    AddFrame(lb_card, TTipoItem.Card, '004', 'Nubank', 'XXXX-XXXX-XXXX-5242');
    AddFrame(lb_card, TTipoItem.Card, '005', 'Visa', 'XXXX-XXXX-XXXX-6855');
    AddFrame(lb_card, TTipoItem.Card, '008', 'Mastercard', 'XXXX-XXXX-XXXX-4952');
end;

procedure TFrmPrincipal.ListarNote();
begin
    img_sem_notas.Visible := false;
    lb_note.Items.Clear;
    lb_note.OnItemClick := DetalheItem;

    AddFrame(lb_note, TTipoItem.Note, '006', 'Nota', 'Lista de compras');
    AddFrame(lb_note, TTipoItem.Note, '006', 'Nota', 'Minhas anotações');
    AddFrame(lb_note, TTipoItem.Note, '006', 'Nota', 'Notas Gerais');
    AddFrame(lb_note, TTipoItem.Note, '007', 'Nota', 'Atividades');
end;

procedure TFrmPrincipal.SelecionaAba(Sender: TObject);
begin
    rect_selecao.Width := layout_aba1.Width;

    img_tab1_sel.Visible := false;
    img_tab2_sel.Visible := false;
    img_tab3_sel.Visible := false;
    img_tab4_sel.Visible := false;
    img_tab5_sel.Visible := false;

    img_tab1.Visible := true;
    img_tab2.Visible := true;
    img_tab3.Visible := true;
    img_tab4.Visible := true;
    img_tab5.Visible := true;

    img_add.Visible := true;

    AnimationSelecao.StopValue := TLayout(Sender).Position.X;
    AnimationSelecao.Start;


    if TLayout(Sender).tag = 1 then
    begin
        lbl_titulo.Text := 'Favoritos';
        img_tab1_sel.Visible := true;
        img_tab1.Visible := false;
        ActTab1.Execute;
    end;

    if TLayout(Sender).tag = 2 then
    begin
        lbl_titulo.Text := 'Senhas';
        img_tab2_sel.Visible := true;
        img_tab2.Visible := false;
        ActTab2.Execute;
    end;

    if TLayout(Sender).tag = 3 then
    begin
        lbl_titulo.Text := 'Cartões';
        img_tab3_sel.Visible := true;
        img_tab3.Visible := false;
        ActTab3.Execute;
    end;

    if TLayout(Sender).tag = 4 then
    begin
        lbl_titulo.Text := 'Notas';
        img_tab4_sel.Visible := true;
        img_tab4.Visible := false;
        ActTab4.Execute;
    end;

    if TLayout(Sender).tag = 5 then
    begin
        img_add.Visible := false;
        lbl_titulo.Text := 'Configurações';
        img_tab5_sel.Visible := true;
        img_tab5.Visible := false;
        ActTab5.Execute;
    end;

end;

procedure TFrmPrincipal.sw_upperClick(Sender: TObject);
begin
    GerarSenha;
end;

procedure TFrmPrincipal.track_tamanhoChange(Sender: TObject);
begin
    lbl_texto_tamanho.Text := 'Número de caracteres: ' + FormatFloat('00', track_tamanho.Value);
    GerarSenha;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    // Esconde icones...
    icone_password.Visible := false;
    icone_card.Visible := false;
    icone_note.Visible := false;
    img_cancelar.Visible := false;
    img_favorito.Visible := false;
    img_salvar.Visible := false;
    rect_busca.Visible := false;

    // Acerta tab selecionada...
    TabControl.ActiveTab := TabItem1;

    // Ajusta largura do retangulo de selecao...
    rect_selecao.Width := layout_aba1.Width - 10;
    SelecionaAba(layout_aba1);

    {$IFDEF ANDROID}
    rect_abas.Align := TAlignLayout.Top;
    layout_slide.Align := TAlignLayout.Bottom;
    img_add.Position.Y := img_add.Position.Y + 50;
    {$ELSE}
    rect_abas.Align := TAlignLayout.Bottom;
    layout_slide.Align := TAlignLayout.Top;
    {$ENDIF}
end;

procedure TFrmPrincipal.img_addClick(Sender: TObject);
begin
    ListarFavorito;
    ListarPassword;
    ListarCard;
    ListarNote;
end;

procedure TFrmPrincipal.img_buscaClick(Sender: TObject);
begin
    rect_busca.Width := rect_toolbar.Width;
    rect_busca.Position.Y := 0;
    rect_busca.Position.X := rect_toolbar.Width;
    rect_busca.Visible := true;

    edt_busca.Text := '';
    AnimationBusca.StartValue := rect_busca.Position.X;
    AnimationBusca.StopValue := 0;
    AnimationBusca.Start;
end;

procedure TFrmPrincipal.img_cancel_buscaClick(Sender: TObject);
begin
    FecharBusca;
end;

procedure TFrmPrincipal.img_refresh_senhaClick(Sender: TObject);
begin
    GerarSenha;
end;

procedure TFrmPrincipal.layout_aba1Click(Sender: TObject);
begin
    SelecionaAba(Sender);
end;

procedure TFrmPrincipal.lbl_gerar_senhaClick(Sender: TObject);
begin
    if lbl_gerar_senha.Text = 'Gerar Nova' then
    begin
        lbl_gerar_senha.Text := 'Fechar';
        layout_gerar_senha.Visible := true;
    end
    else
    begin
        lbl_gerar_senha.Text := 'Gerar Nova';
        layout_gerar_senha.Visible := false;
    end;

end;

end.
