unit Form_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.ListBox, FMX.Edit,
  FMX.AddressBook.Types, FMX.AddressBook;

type
  TFrm_Principal = class(TForm)
    ToolBar1: TToolBar;
    ListBox1: TListBox;
    Line1: TLine;
    Layout1: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    rect_cad: TRectangle;
    edt_nome: TEdit;
    edt_sobrenome: TEdit;
    edt_email: TEdit;
    btn_salvar: TSpeedButton;
    AddressBook: TAddressBook;
    procedure FormShow(Sender: TObject);
    procedure AddressBookPermissionRequest(ASender: TObject;
      const AMessage: string; const AAccessGranted: Boolean);
    procedure AddressBookExternalChange(ASender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Principal: TFrm_Principal;

implementation

{$R *.fmx}

procedure Lista_Contatos();
var
        contatos : TAddressBookContacts;
        x : integer;
        item : TListBoxItem;
begin
        contatos := TAddressBookContacts.Create;

        with Frm_Principal do
        begin
                try
                        AddressBook.AllContacts(AddressBook.DefaultSource, contatos);

                        ListBox1.Items.Clear;

                        // Inserir os contatos na lista...
                        for x := 0 to contatos.Count - 1 do
                        begin
                                item := TListBoxItem.Create(nil);
                                item.Text := contatos[x].DisplayName;
                                item.Tag := contatos[x].ID;
                                ListBox1.AddObject(item);

                                item.Free;
                        end;
                finally
                        contatos.Free;
                end;
        end;
end;

procedure TFrm_Principal.AddressBookExternalChange(ASender: TObject);
begin
        AddressBook.RevertCurrentChangesAndUpdate;
        Lista_Contatos;
end;

procedure TFrm_Principal.AddressBookPermissionRequest(ASender: TObject;
  const AMessage: string; const AAccessGranted: Boolean);
begin
        if AAccessGranted then
                Lista_Contatos
        else
                showmessage('Você não tem acesso a lista de contatos: ' + AMessage);
end;

procedure TFrm_Principal.btn_salvarClick(Sender: TObject);
var
        contato : TAddressBookContact;
        email : TContactEmails;
        endereco : TContactAddresses;
begin
        contato := AddressBook.CreateContact(AddressBook.DefaultSource);

        contato.FirstName := edt_nome.Text;
        contato.LastName := edt_sobrenome.Text;

        email := TContactEmails.Create;
        email.AddEmail(TContactEmail.TLabelKind.Work, edt_email.Text);

        contato.EMails := email;

        email.Free;

        AddressBook.SaveContact(contato);

        // Atualiza listagem...
        Lista_Contatos;

        rect_cad.Visible := false;
end;

procedure TFrm_Principal.FormShow(Sender: TObject);
begin
        if AddressBook.Supported then
        begin
                AddressBook.RequestPermission;
        end;
end;

procedure TFrm_Principal.Image1Click(Sender: TObject);
begin
        Lista_Contatos;
end;

procedure TFrm_Principal.Image2Click(Sender: TObject);
begin
        edt_nome.Text := '';
        edt_sobrenome.Text := '';
        edt_email.Text := '';
        rect_cad.Visible := true;
end;

procedure TFrm_Principal.Image3Click(Sender: TObject);
var
      indice, contato_id : Integer;
      contato : TAddressBookContact;
begin
        indice := ListBox1.ItemIndex;

        if indice >= 0 then
        begin
                contato_id := ListBox1.ListItems[indice].Tag;
                contato := AddressBook.ContactByID(contato_id);

                if contato <> nil then
                begin
                        AddressBook.RemoveContact(contato);
                        ListBox1.Items.Delete(indice);
                end;

                contato.Free;

        end;


end;

end.
