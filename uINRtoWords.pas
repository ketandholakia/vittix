unit uINRtoWords;

interface

uses
  SysUtils, StrUtils, Variants;

function CurrencyToWord(const MyNumber: Variant): string;

implementation

const
  Place: array[0..4] of string = (' Thousand ', ' Lakh ', ' Crore ', ' Arab ', ' Kharab ');
  DigitWords: array[0..9] of string = ('', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine');
  TeenWords: array[10..19] of string = (
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen',
    'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
  );
  TensWords: array[2..9] of string = (
    'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  );

function ConvertDigit(D: Integer): string;
begin
  if (D >= 1) and (D <= 9) then
    Result := DigitWords[D]
  else
    Result := '';
end;

function ConvertTens(T: Integer): string;
begin
  if (T >= 10) and (T <= 19) then
    Result := TeenWords[T]
  else if T >= 20 then
    Result := TensWords[T div 10] + ' ' + ConvertDigit(T mod 10)
  else
    Result := ConvertDigit(T);
end;

function ConvertHundreds(const S: string): string;
var
  N: Integer;
begin
  N := StrToIntDef(S, 0);
  if N = 0 then Exit('');
  Result := '';
  if N >= 100 then
    Result := ConvertDigit(N div 100) + ' Hundred ';
  Result := Result + ConvertTens(N mod 100);
end;

function CurrencyToWord(const MyNumber: Variant): string;
var
  NumStr, Rupees, Paisa, Temp: string;
  DecimalPos, iCount, Chunk: Integer;
begin
  NumStr := Trim(VarToStr(MyNumber));
  if NumStr = '' then Exit('Zero');

  DecimalPos := Pos('.', NumStr);
  if DecimalPos > 0 then
  begin
    Temp := Copy(NumStr, DecimalPos + 1, 2);
    Temp := Temp + StringOfChar('0', 2 - Length(Temp));
    Paisa := ' and ' + ConvertTens(StrToIntDef(Temp, 0)) + ' Paisa';
    NumStr := Copy(NumStr, 1, DecimalPos - 1);
  end
  else
    Paisa := '';

  NumStr := StringOfChar('0', 3 - Length(NumStr)) + NumStr;
  Rupees := ConvertHundreds(Copy(NumStr, Length(NumStr) - 2, 3));
  Delete(NumStr, Length(NumStr) - 2, 3);

  iCount := 0;
  while Length(NumStr) > 0 do
  begin
    if Length(NumStr) = 1 then
    begin
      Chunk := StrToIntDef(NumStr, 0);
      Rupees := ConvertDigit(Chunk) + Place[iCount] + Rupees;
      NumStr := '';
    end
    else
    begin
      Chunk := StrToIntDef(Copy(NumStr, Length(NumStr) - 1, 2), 0);
      Rupees := ConvertTens(Chunk) + Place[iCount] + Rupees;
      Delete(NumStr, Length(NumStr) - 1, 2);
    end;
    Inc(iCount);
  end;

  Result := Trim(Rupees + Paisa);
end;

end.
