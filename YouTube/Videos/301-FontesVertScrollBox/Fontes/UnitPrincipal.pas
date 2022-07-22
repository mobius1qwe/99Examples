unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    lytToolbar: TLayout;
    btnRefresh: TSpeedButton;
    VertScrollBox: TVertScrollBox;
    imgFotoCliente: TImage;
    btnLimpar: TSpeedButton;
    Animation: TFloatAnimation;
    procedure btnRefreshClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure AnimationFinish(Sender: TObject);
  private
    procedure AddCliente(id_cliente: integer;
                                   nome, cidade, status: string;
                                   foto: TBitmap);

    {$IFDEF MSWINDOWS}
    procedure OnClickEditar(Sender: TObject);
    {$ELSE}
    procedure OnTapEditar(Sender: TObject; const Point: TPointF);
    {$ENDIF}


    {$IFDEF MSWINDOWS}
    procedure OnClickFrame(Sender: TObject);
    {$ELSE}
    procedure OnTapframe(Sender: TObject; const Point: TPointF);
    {$ENDIF}



    {$IFDEF MSWINDOWS}
    procedure OnClickDelete(Sender: TObject);
    {$ELSE}
    procedure OnTapDelete(Sender: TObject; const Point: TPointF);
    {$ENDIF}

    procedure ClearVertScrollBox(VSBox: TVertScrollBox; Index: integer = -1);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Frame.Cliente;


{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.OnClickEditar(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.OnTapEditar(Sender: TObject; const Point: TPointF);
{$ENDIF}
begin
    showmessage('Editando o cliente: ' + TImage(Sender).tag.ToString);
end;



{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.OnClickFrame(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.OnTapframe(Sender: TObject; const Point: TPointF);
{$ENDIF}
begin
    showmessage('Clicou no frame do cliente: ' + TFrameCliente(Sender).id_cliente.ToString +
                        ' - ' + TFrameCliente(Sender).nome);
end;




{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.OnClickDelete(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.OnTapDelete(Sender: TObject; const Point: TPointF);
{$ENDIF}
var
    rect: TRectangle;
    frame: TFrame;
    imgDelete: TImage;
begin
    // Obter a imagem da lixeira clicada...
    imgDelete := TImage(Sender);

    // Obter o retangulo de fundo ao qual pertence a lixeira...
    //rect := TRectangle(imgDelete.Parent);
    rect := imgDelete.Parent as TRectangle;

    // Cqaptura o frame dono do retabgulo acima...
    frame := rect.Parent as TFrame;

    Animation.Parent := frame;
    Animation.Start;

    // Excluindo somente aquele frame clicado...
    //ClearVertScrollBox(VertScrollBox, frame.Index);


end;

procedure TFrmPrincipal.ClearVertScrollBox(VSBox: TVertScrollBox; Index: integer = -1);
var
    i: integer;
    frame: TFrame;
begin
    try
        VSBox.BeginUpdate;

        if Index >= 0 then
            TFrame(VSBox.Content.Children[Index]).DisposeOf
        else
        for i := VSBox.Content.ChildrenCount - 1 downto 0 do
            if VSBox.Content.Children[i] is TFrame then
                //frame := VSBox.Content.Children[i] as TFrame;
                //frame := TFrame(VSBox.Content.Children[i]);
                //frame.DisposeOf;
                TFrame(VSBox.Content.Children[i]).DisposeOf;

    finally
        VSBox.EndUpdate;
    end;
end;

procedure TFrmPrincipal.AddCliente(id_cliente: integer;
                                   nome, cidade, status: string;
                                   foto: TBitmap);
var
    frame: TFrameCliente;
begin
    frame := TFrameCliente.create(nil);

    frame.id_cliente := id_cliente;
    frame.nome := nome;
    frame.position.Y := 9999999999;
    frame.align := TAlignLayout.Top;
    frame.imgFoto.bitmap := foto;
    frame.lblNome.text := nome;
    frame.lblCidade.text := cidade;
    frame.imgEditar.Tag := id_cliente;

    {$IFDEF MSWINDOWS}
    frame.onClick := OnClickFrame;
    {$ELSE}
    frame.onTap := OnTapFrame;
    {$ENDIF}


    {$IFDEF MSWINDOWS}
    frame.imgDelete.onClick := OnClickDelete;
    {$ELSE}
    frame.imgDelete.onTap := OnTapDelete;
    {$ENDIF}


    {$IFDEF MSWINDOWS}
    frame.imgEditar.onClick := OnClickEditar;
    {$ELSE}
    frame.imgEditar.onTap := OnTapEditar;
    {$ENDIF}

    if status <> 'A' then
        frame.lblNome.FontColor := $FFCCCCCC;

    VertScrollBox.AddObject(frame);

    // Efeito zebrado...
    {
    if Odd(frame.Index) then
        frame.rectFundo.Fill.Color := $FFededed;
    }
end;

procedure TFrmPrincipal.AnimationFinish(Sender: TObject);
var
    frame: TFrame;
begin
    frame := TFloatAnimation(Sender).Parent as Tframe;

    Animation.Parent := nil;
    ClearVertScrollBox(VertScrollBox, frame.Index);
end;

procedure TFrmPrincipal.btnLimparClick(Sender: TObject);
begin
    ClearVertScrollBox(VertScrollBox);
end;

procedure TFrmPrincipal.btnRefreshClick(Sender: TObject);
var
    i: integer;
begin
    ClearVertScrollBox(VertScrollBox);

    VertScrollBox.BeginUpdate;

    for i := 1 to 100 do
        AddCliente(i,
                   'Nome do cliente ' + i.ToString,
                   'São Paulo',
                   'A',
                   imgFotoCliente.Bitmap);

    AddCliente(16,
               '99 Coders',
               'São Paulo',
               'I',
               imgFotoCliente.Bitmap);

    VertScrollBox.EndUpdate;
end;

end.
