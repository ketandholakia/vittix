unit uStateUtils;

interface

function GetStateCodeFromDB(const StateName: string): string;

implementation

uses
  FireDAC.Comp.Client, uDMMain, System.SysUtils;

function GetStateCodeFromDB(const StateName: string): string;
begin
  Result := '';
  with TFDQuery.Create(nil) do
  try
    Connection := uDMMain.DMmain.FDConnectionmain;
    SQL.Text := 'SELECT STATE_CODE FROM STATES WHERE UPPER(STATE_NAME) = :StateName';
    ParamByName('StateName').AsString := UpperCase(StateName);
    Open;
    if not Eof then
      Result := FieldByName('STATE_CODE').AsString;
  finally
    Free;
  end;
end;

end.
