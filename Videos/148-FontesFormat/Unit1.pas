unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, uFormat, FMX.Objects;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Image1: TImage;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Edit1Typing(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


procedure TForm1.Edit1Typing(Sender: TObject);
begin
    Formatar(edit1, TFormato.TelefoneFixo); // Telefone Fixo...
    Formatar(edit2, TFormato.Celular); // Celular...
    Formatar(edit3, TFormato.CNPJ); // CNPJ...
    //Formatar(edit1, TFormato.CPF); // CPF...
    //Formatar(edit2, TFormato.InscricaoEstadual, 'SP'); // Inscricao Estadual (IE)...
    //Formatar(edit3, TFormato.CNPJorCPF); // CNPJ ou CPF...
    //Formatar(edit1, TFormato.Personalizado, '##-#-####'); // Personalizado...
    //Formatar(edit2, TFormato.Valor); // Valor...
    //Formatar(edit3, TFormato.Money, 'US$'); // Money (com simbolo da moeda)...
    //Formatar(edit1, TFormato.CEP); // CEP...
    //Formatar(edit2, TFormato.Dt); // Data...
    //Formatar(edit3, TFormato.Peso); // Peso...

end;

end.
