unit uUsersForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Hash,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.ExtCtrls;

type
  TfrmUsers = class(TForm)
    dsUsers: TDataSource;
    qryUsers: TFDQuery;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    grdUsers: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnSave: TButton;
    edtUsername: TEdit;
    edtPassword: TEdit;
    cmbRole: TComboBox;
    qryRoles: TFDQuery;
    chkActive: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject); // NEW: btnEditClick handler
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure grdUsersCellClick(Column: TColumn);
  private
    FIsEditing: Boolean;   // <-- MOVED HERE
    FCurrentUserID: Integer; // <-- MOVED HERE
    procedure LoadRoles;
    procedure LoadUsers;
    procedure ClearForm;
    function SelectedRoleID: Integer;



    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUsers: TfrmUsers;

implementation
uses uAuthManager, uDMmain;

{$R *.dfm}

procedure TfrmUsers.LoadRoles;
begin
  cmbRole.Items.Clear;
  qryRoles.SQL.Text := 'SELECT ROLE_ID, ROLE_NAME FROM ROLES ORDER BY ROLE_NAME';
  qryRoles.Open;
  while not qryRoles.Eof do
  begin
    cmbRole.Items.AddObject(qryRoles.FieldByName('ROLE_NAME').AsString,
                            TObject(qryRoles.FieldByName('ROLE_ID').AsInteger));
    qryRoles.Next;
  end;
end;

procedure TfrmUsers.LoadUsers;
begin
  qryUsers.Close;
  qryUsers.SQL.Text :=
    'SELECT u.USER_ID, u.USERNAME, u.IS_ACTIVE, r.ROLE_NAME ' +
    'FROM USERS u JOIN ROLES r ON u.ROLE_ID = r.ROLE_ID ' +
    'ORDER BY u.USERNAME';
  qryUsers.Open;
end;

procedure TfrmUsers.ClearForm;
begin
  edtUsername.Clear;
  edtPassword.Clear; // Clear password field
  cmbRole.ItemIndex := -1;
  chkActive.Checked := True;
  FCurrentUserID := -1; // Reset the current user ID
  FIsEditing := False;  // Reset editing state
end;

function TfrmUsers.SelectedRoleID: Integer;
begin
  if cmbRole.ItemIndex >= 0 then
    Result := Integer(cmbRole.Items.Objects[cmbRole.ItemIndex])
  else
    Result := -1;
end;

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  qryUsers.Connection := DMmain.FDConnectionmain;
  qryRoles.Connection := DMmain.FDConnectionmain;

  // Initialize state
  FIsEditing := False;
  FCurrentUserID := -1;

  LoadRoles;
  LoadUsers;

  // --- NEW: Permission Check to disable controls if user is not authorized ---
  if not HasPermission('manage_users') then
  begin
    btnAdd.Enabled := False;
    btnEdit.Enabled := False;
    btnDelete.Enabled := False;
    btnSave.Enabled := False;
    Panel4.Enabled := False; // Assuming Panel4 contains the edit fields
  end;
end;

procedure TfrmUsers.btnAddClick(Sender: TObject);
begin
  ClearForm;
  FIsEditing := False;
  edtUsername.SetFocus;
end;

procedure TfrmUsers.btnEditClick(Sender: TObject);
begin
  // Permission Check
  if not HasPermission('manage_users') then
    Exit;

  if not qryUsers.Active or qryUsers.IsEmpty then
    raise Exception.Create('Please select a user to edit.');

  // Set the state for editing
  FIsEditing := True;
  FCurrentUserID := qryUsers.FieldByName('USER_ID').AsInteger;

  // Clear password field to force a new password entry or leave blank for no change
  edtPassword.Clear;
  edtPassword.SetFocus;
end;

procedure TfrmUsers.btnDeleteClick(Sender: TObject);
begin
  // Permission Check
  if not HasPermission('manage_users') then
    Exit;

  if qryUsers.Active and not qryUsers.IsEmpty then
  begin
    // Confirmation dialog would go here in a production app

    qryUsers.Close;
    qryUsers.SQL.Text := 'DELETE FROM USERS WHERE USER_ID = :id';
    qryUsers.ParamByName('id').AsInteger := qryUsers.FieldByName('USER_ID').AsInteger;
    qryUsers.ExecSQL;
    LoadUsers;
    ClearForm;
  end;
end;

procedure TfrmUsers.btnSaveClick(Sender: TObject);
var
  passwordHash: string;
begin
  // Permission Check
  if not HasPermission('manage_users') then
    Exit;

  // --- 1. Validation ---
  if Trim(edtUsername.Text) = '' then
    raise Exception.Create('Username is required.');
  if SelectedRoleID = -1 then
    raise Exception.Create('Please select a role.');

  // --- 2. Handle Password Hashing and Validation ---
  if FIsEditing then
  begin
    // During an edit, only update the password if the field isn't empty
    if Trim(edtPassword.Text) <> '' then
      passwordHash := HashPassword(edtPassword.Text)
    else
      passwordHash := ''; // Use empty string to skip password update
  end
  else
  begin
    // For a new user, password is required
    if Trim(edtPassword.Text) = '' then
      raise Exception.Create('Password is required for a new user.');
    passwordHash := HashPassword(edtPassword.Text);
  end;

  // --- 3. Determine and Execute SQL Query ---
  if FIsEditing then // *** UPDATE Logic ***
  begin
    qryUsers.Close;
    qryUsers.SQL.Clear;
    qryUsers.SQL.Add('UPDATE USERS SET USERNAME = :u, ROLE_ID = :r, IS_ACTIVE = :a');

    // Conditionally include password update
    if passwordHash <> '' then
      qryUsers.SQL.Add(', PASSWORD_HASH = :p');

    qryUsers.SQL.Add('WHERE USER_ID = :id');

    // Set parameters
    qryUsers.ParamByName('u').AsString := edtUsername.Text;
    qryUsers.ParamByName('r').AsInteger := SelectedRoleID;
    qryUsers.ParamByName('a').AsBoolean := chkActive.Checked;
    qryUsers.ParamByName('id').AsInteger := FCurrentUserID;

    if passwordHash <> '' then
      qryUsers.ParamByName('p').AsString := passwordHash;

  end
  else // *** INSERT Logic ***
  begin
    qryUsers.Close;
    qryUsers.SQL.Text :=
      'INSERT INTO USERS (USERNAME, PASSWORD_HASH, ROLE_ID, IS_ACTIVE) ' +
      'VALUES (:u, :p, :r, :a)';

    // Set parameters
    qryUsers.ParamByName('u').AsString := edtUsername.Text;
    qryUsers.ParamByName('p').AsString := passwordHash; // Must use the hashed password
    qryUsers.ParamByName('r').AsInteger := SelectedRoleID;
    qryUsers.ParamByName('a').AsBoolean := chkActive.Checked;
  end;

  // Execute the query
  qryUsers.ExecSQL;

  // --- 4. Finalize ---
  LoadUsers;
  ClearForm;
end;

procedure TfrmUsers.grdUsersCellClick(Column: TColumn);
var
  roleName: string;
begin
  // Ensure the dataset is active and not empty before accessing fields
  if not qryUsers.Active or qryUsers.IsEmpty then
    Exit;

  edtUsername.Text := qryUsers.FieldByName('USERNAME').AsString;
  chkActive.Checked := qryUsers.FieldByName('IS_ACTIVE').AsBoolean;
  roleName := qryUsers.FieldByName('ROLE_NAME').AsString;
  cmbRole.ItemIndex := cmbRole.Items.IndexOf(roleName);

  edtPassword.Clear; // Clear password on cell click
  FCurrentUserID := qryUsers.FieldByName('USER_ID').AsInteger;
  FIsEditing := False; // Reset state when browsing the grid
end;

end.
