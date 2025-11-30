unit uRoleManager;

interface
uses
  System.SysUtils, FireDAC.Comp.Client;
function GetRoleID(const ARoleName: string): Integer;

implementation
uses uDMmain;

function GetRoleID(const ARoleName: string): Integer;
var
  Q: TFDQuery;
begin
  Result := -1;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DMmain.FDConnectionmain;
 Q.SQL.Text := 'SELECT ROLE_ID FROM ROLES WHERE ROLE_NAME = :r';
   Q.ParamByName('r').AsString := ARoleName;
    Q.Open;
    if not Q.Eof then
      Result := Q.FieldByName('ROLE_ID').AsInteger;
  finally
    Q.Free;
  end;
end;
end.
