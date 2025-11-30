unit uPermissionMatrix;

interface
function HasPermission(const ARole, AAction: string): Boolean;
implementation
uses   System.SysUtils, StrUtils;


function HasPermission(const ARole, AAction: string): Boolean;
begin
  if ARole = 'admin' then
    Result := True
  else if ARole = 'manager' then
    Result := IndexText(AAction, ['ViewReports', 'EditOrders']) >= 0
  else if ARole = 'viewer' then
    Result := SameText(AAction, 'ViewReports')
  else
    Result := False;
end;


end.
