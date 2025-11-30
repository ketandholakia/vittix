unit uInvoiceUtils;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

function GenerateInvoiceNumber(InvoiceTypeID: Integer; Conn: TFDConnection): string;

implementation

function GenerateInvoiceNumber(InvoiceTypeID: Integer; Conn: TFDConnection): string;
var
  Qry: TFDQuery;
  Prefix: string;
  NextNum: Integer;
  Separate: Boolean;
begin
  Result := ''; // Default fallback
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := Conn;
    Qry.SQL.Text :=
      'SELECT SEPARATENUMBERING, SeriesPrefix, NextNumber ' +
      'FROM INVOICETYPE WHERE InvoiceTypeID = :ID';
    Qry.ParamByName('ID').AsInteger := InvoiceTypeID;
    Qry.Open;

    if Qry.IsEmpty then
      raise Exception.Create('Invalid InvoiceTypeID: ' + IntToStr(InvoiceTypeID));

    Separate := Qry.FieldByName('SEPARATENUMBERING').AsBoolean;
    Prefix := Qry.FieldByName('SeriesPrefix').AsString;
    NextNum := Qry.FieldByName('NextNumber').AsInteger;

    if Separate then
      Result := Prefix + IntToStr(NextNum)
    else
      Result := 'INV-' + FormatDateTime('YYYYMMDD', Date) + '-' + IntToStr(NextNum);

    // Update NextNumber
    Qry.SQL.Text :=
      'UPDATE INVOICETYPE SET NextNumber = :Next WHERE InvoiceTypeID = :ID';
    Qry.ParamByName('Next').AsInteger := NextNum + 1;
    Qry.ParamByName('ID').AsInteger := InvoiceTypeID;
    Qry.ExecSQL;
  finally
    Qry.Free;
  end;
end;

end.
