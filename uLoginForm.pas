unit uLoginForm;

interface
uses
  Vcl.Forms, Vcl.StdCtrls, FireDAC.Comp.Client, Vcl.Controls, Vcl.Dialogs,
  uAuthManager, System.IniFiles, Vcl.Graphics, System.Classes, SysUtils, uMainForm,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage;
type
  TfrmLogin = class(TForm)
    lblDBStatus: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    cmbUsername: TComboBox;
    Panel3: TPanel;
    edtPassword: TEdit;
    Panel4: TPanel;
    btnLogin: TButton;
    Image1: TImage;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FUserRole: string;
    procedure LoadUsernames;
    procedure LoadLastUser;
  public
    property UserRole: string read FUserRole;
  end;
var
  frmLogin: TfrmLogin;
implementation

{$R *.dfm}

uses uDMmain, uUOMManager;
procedure SaveLastUser(const AUsername: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  try
    Ini.WriteString('Login', 'LastUser', AUsername);
  finally
    Ini.Free;
  end;
end;
procedure TfrmLogin.LoadLastUser;
var
  Ini: TIniFile;
  LastUser: string;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  try
    LastUser := Ini.ReadString('Login', 'LastUser', '');
    if LastUser <> '' then
      cmbUsername.ItemIndex := cmbUsername.Items.IndexOf(LastUser);
  finally
    Ini.Free;
  end;
end;
procedure TfrmLogin.Button1Click(Sender: TObject);
begin
close;
end;


procedure TfrmLogin.FormShow(Sender: TObject);
var
  dbPath, serverName: string;
begin
  LoadUsernames;
  LoadLastUser;
  if Assigned(DMmain.FDConnectionmain) and DMmain.FDConnectionmain.Connected then
  begin
    dbPath := DMmain.FDConnectionmain.Params.Values['Database'];
    serverName := DMmain.FDConnectionmain.Params.Values['Server'];
    lblDBStatus.Caption := Format('Connected to %s on %s', [dbPath, serverName]);
    lblDBStatus.Font.Color := clGreen;
  end
  else
  begin
    lblDBStatus.Caption := 'Database not connected';
    lblDBStatus.Font.Color := clRed;
  end;
end;
procedure TfrmLogin.LoadUsernames;
var
  Q: TFDQuery;
begin
  cmbUsername.Items.Clear;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DMmain.FDConnectionmain;
    Q.SQL.Text := 'SELECT USERNAME FROM USERS WHERE is_active = TRUE ORDER BY USERNAME';
    Q.Open;
    while not Q.Eof do
    begin
      cmbUsername.Items.Add(Q.FieldByName('USERNAME').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;
procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  LUsername, LPassword: string;
begin
  LUsername := Trim(cmbUsername.Text);
  LPassword := edtPassword.Text;

  if AuthenticateUser(LUsername, LPassword, FUserRole) then
  begin
    SaveLastUser(LUsername);

    if not DMMain.FDConnectionMain.Connected then
      DMMain.FDConnectionMain.Connected := True;

//    frmUOMManager.qryUOM.ResourceOptions.Persistent := False;
//    frmUOMManager.qryUQC.ResourceOptions.Persistent := False;

    ModalResult := mrOk;
  end
  else
    ShowMessage('Invalid credentials or inactive user.');
end;

end.
