
unit uIDValidators;

interface

function IsValidGSTIN(const GSTIN: string): Boolean;
function IsValidPAN(const PAN: string): Boolean;
function IsGSTINMatchingPANAndState(const GSTIN, PAN, StateName: string): Boolean;

implementation

uses
  System.SysUtils, System.RegularExpressions, uStateUtils;

function IsValidGSTIN(const GSTIN: string): Boolean;
begin
  Result := TRegEx.IsMatch(GSTIN, '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
end;

function IsValidPAN(const PAN: string): Boolean;
begin
  Result := TRegEx.IsMatch(PAN, '^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
end;

function IsGSTINMatchingPANAndState(const GSTIN, PAN, StateName: string): Boolean;
var
  StateCode, PANInGSTIN: string;
begin
  Result := False;
  if Length(GSTIN) <> 15 then Exit;

  StateCode := GetStateCodeFromDB(StateName); // from uStateUtils
  PANInGSTIN := Copy(GSTIN, 3, 10);            // PAN is embedded in GSTIN

  Result := (Copy(GSTIN, 1, 2) = StateCode) and (PANInGSTIN = PAN);
end;

end.
