unit uAuthManager;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

  function HasPermission(const APermissionName: string): Boolean;
  function AuthenticateUser(const AUsername, APassword: string; out ARole: string): Boolean;
  function HashPassword(const APassword: string): string;

implementation

uses
  uDMmain, System.Hash, Data.DB;
var
  FCurrentRoleID: Integer = 0; // Define the variable in the implementation section
function GetCurrentRoleID: Integer;
begin
  Result := FCurrentRoleID;
end;
function HashPassword(const APassword: string): string;
begin
  Result := THashSHA2.GetHashString(APassword);
end;
function AuthenticateUser(const AUsername, APassword: string; out ARole: string): Boolean;
var
  Q: TFDQuery;
begin
  Result := False;
  ARole := '';
  FCurrentRoleID := 0; // Reset role ID on new login attempt
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DMmain.FDConnectionmain;
    // MODIFIED SQL: Now selects ROLE_ID along with ROLE_NAME
    Q.SQL.Text :=
      'SELECT u.ROLE_ID, r.ROLE_NAME FROM USERS u ' +
      'JOIN ROLES r ON u.ROLE_ID = r.ROLE_ID ' +
      'WHERE u.USERNAME = :u AND u.PASSWORD_HASH = :p AND u.IS_ACTIVE = TRUE';
    Q.ParamByName('u').AsString := AUsername;
    Q.ParamByName('p').AsString := HashPassword(APassword);
    Q.Open;
    if not Q.Eof then
    begin
      // Store the Role ID for permission checks
      FCurrentRoleID := Q.FieldByName('ROLE_ID').AsInteger;
      ARole := Q.FieldByName('ROLE_NAME').AsString;
      Result := True;
    end;
  finally
    Q.Free;
  end;
end;

function HasPermission(const APermissionName: string): Boolean;
var
  RoleID: Integer;
  qryPerm: TFDQuery;
begin
  // 1. Get the current user's Role ID
  RoleID := GetCurrentRoleID;
  Result := False;

  if RoleID <= 0 then
    Exit;

  // 2. Query the ROLE_PERMISSIONS table, joining with PERMISSIONS to match the name.
  qryPerm := TFDQuery.Create(nil);
  try
    qryPerm.Connection := DMmain.FDConnectionmain;

    // CORRECTED SQL: Joins ROLE_PERMISSIONS (using its PERMISSION_ID) to PERMISSIONS
    // to match the string name (APermissionName).
    qryPerm.SQL.Text :=
      'SELECT 1 ' +
      'FROM ROLE_PERMISSIONS rp ' +
      'JOIN PERMISSIONS p ON rp.PERMISSION_ID = p.PERMISSION_ID ' +
      'WHERE rp.ROLE_ID = :role AND p.PERMISSION_NAME = :perm';

    qryPerm.ParamByName('role').AsInteger := RoleID;
    qryPerm.ParamByName('perm').AsString := APermissionName;

    qryPerm.Open;

    Result := not qryPerm.Eof;

  finally
    qryPerm.Free;
  end;
end;
end.
