unit uRolesPermissionsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.CheckLst,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TfrmRolesPermissions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    lblRoles: TLabel;
    lblPermissions: TLabel;
    lstRoles: TListBox;         // To display and select roles (Master)
    chkListPermissions: TCheckListBox; // To display permissions with checkboxes (Detail)
    qryRoles: TFDQuery;         // To fetch the list of roles
    qryPermissions: TFDQuery;   // To fetch the list of all available permissions
    btnSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lstRolesClick(Sender: TObject);
    procedure chkListPermissionsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FSelectedRoleID: Integer;
    procedure LoadRoles;
    procedure LoadPermissionsList;
    procedure LoadPermissionsForSelectedRole;
    procedure SavePermissionsForRole(ARoleID: Integer);
  public
    { Public declarations }
  end;

var
  frmRolesPermissions: TfrmRolesPermissions;

implementation
uses uDMmain;

{$R *.dfm}

procedure TfrmRolesPermissions.FormCreate(Sender: TObject);
begin
  // Assign connections once
  qryRoles.Connection := DMmain.FDConnectionmain;
  qryPermissions.Connection := DMmain.FDConnectionmain;

  FSelectedRoleID := -1;

  LoadRoles;
  LoadPermissionsList;
end;

procedure TfrmRolesPermissions.LoadRoles;
begin
  lstRoles.Clear;

  if qryRoles.Active then
    qryRoles.Close;

  qryRoles.SQL.Text := 'SELECT ROLE_ID, ROLE_NAME FROM ROLES ORDER BY ROLE_NAME';
  qryRoles.Open;

  while not qryRoles.Eof do
  begin
    lstRoles.Items.AddObject(qryRoles.FieldByName('ROLE_NAME').AsString,
                             TObject(qryRoles.FieldByName('ROLE_ID').AsInteger));
    qryRoles.Next;
  end;
end;

procedure TfrmRolesPermissions.LoadPermissionsList;
begin
  chkListPermissions.Clear;

  if qryPermissions.Active then
    qryPermissions.Close;

  qryPermissions.SQL.Text := 'SELECT PERMISSION_ID, PERMISSION_NAME, DESCRIPTION FROM PERMISSIONS ORDER BY PERMISSION_NAME';
  qryPermissions.Open;

  while not qryPermissions.Eof do
  begin
    // Display name and description, store ID as object
    chkListPermissions.Items.AddObject(
      Format('%s (%s)', [qryPermissions.FieldByName('PERMISSION_NAME').AsString, qryPermissions.FieldByName('DESCRIPTION').AsString]),
      TObject(qryPermissions.FieldByName('PERMISSION_ID').AsInteger)
    );
    qryPermissions.Next;
  end;
end;

procedure TfrmRolesPermissions.lstRolesClick(Sender: TObject);
begin
  if lstRoles.ItemIndex >= 0 then
  begin
    // Store the selected Role ID
    FSelectedRoleID := Integer(lstRoles.Items.Objects[lstRoles.ItemIndex]);

    // Load the checkbox states for this role
    LoadPermissionsForSelectedRole;
  end
  else
  begin
    FSelectedRoleID := -1;
    // Clear permissions list if no role is selected
    for var I := 0 to chkListPermissions.Items.Count - 1 do
      chkListPermissions.Checked[I] := False;
  end;
end;

procedure TfrmRolesPermissions.LoadPermissionsForSelectedRole;
var
  qryCheck: TFDQuery;
  i: Integer;
  PermissionID: Integer;
begin
  if FSelectedRoleID = -1 then
    Exit;

  // Create a temporary query to fetch existing permissions for the selected role
  qryCheck := TFDQuery.Create(nil);
  try
    qryCheck.Connection := DMmain.FDConnectionmain;
    qryCheck.SQL.Text := 'SELECT PERMISSION_ID FROM ROLE_PERMISSIONS WHERE ROLE_ID = :id';
    qryCheck.ParamByName('id').AsInteger := FSelectedRoleID;
    qryCheck.Open;

    // Check every permission in the list
    for i := 0 to chkListPermissions.Items.Count - 1 do
    begin
      PermissionID := Integer(chkListPermissions.Items.Objects[i]);

      // Use Locate to quickly check if this permission ID is in the role's set
      if qryCheck.Locate('PERMISSION_ID', PermissionID, [loCaseInsensitive]) then
        chkListPermissions.Checked[i] := True
      else
        chkListPermissions.Checked[i] := False;
    end;
  finally
    qryCheck.Free;
  end;
end;

procedure TfrmRolesPermissions.chkListPermissionsClick(Sender: TObject);
begin
  // Left empty, save logic deferred to btnSaveClick.
end;

procedure TfrmRolesPermissions.SavePermissionsForRole(ARoleID: Integer);
var
  i: Integer;
  PermissionID: Integer;
  IsChecked: Boolean;
  qryExec: TFDQuery;
begin
  if ARoleID = -1 then
    Exit;

  qryExec := TFDQuery.Create(nil);
  try
    qryExec.Connection := DMmain.FDConnectionmain;

    // 1. Delete all existing permissions for this role
    qryExec.SQL.Text := 'DELETE FROM ROLE_PERMISSIONS WHERE ROLE_ID = :role';
    qryExec.ParamByName('role').AsInteger := ARoleID;
    qryExec.ExecSQL;

    // 2. Insert only the checked permissions
    qryExec.SQL.Text := 'INSERT INTO ROLE_PERMISSIONS (ROLE_ID, PERMISSION_ID) VALUES (:role, :perm)';
    qryExec.ParamByName('role').AsInteger := ARoleID;

    for i := 0 to chkListPermissions.Items.Count - 1 do
    begin
      IsChecked := chkListPermissions.Checked[i];

      if IsChecked then
      begin
        PermissionID := Integer(chkListPermissions.Items.Objects[i]);
        qryExec.ParamByName('perm').AsInteger := PermissionID;
        qryExec.ExecSQL; // Execute INSERT for the checked permission
      end;
    end;

    // Commit the changes
    DMmain.FDConnectionmain.Commit;
    ShowMessage('Permissions saved successfully for the selected role.');
  finally
    qryExec.Free;
  end;
end;

procedure TfrmRolesPermissions.btnSaveClick(Sender: TObject);
begin
  if FSelectedRoleID = -1 then
  begin
    ShowMessage('Please select a role to save permissions.');
    Exit;
  end;

  // Call the saving routine
  SavePermissionsForRole(FSelectedRoleID);
end;

end.
