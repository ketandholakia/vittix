unit uTaxCalcForm;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
System.UITypes,  Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Mask;

type
  TfrmTaxCalc = class(TForm)
    pnlValue: TPanel;
    pnlVatAmount: TPanel;
//    pnlGross: TPanel;
//    pnlGrossFromVat: TPanel;
//    pnlNet: TPanel;
//    pnlNetFromVat: TPanel;
//    pnlVatFromGross: TPanel;
//    Panel1: TPanel;
//    Panel2: TPanel;
//    Panel3: TPanel;
    edValue: TEdit;
    edVat: TEdit;
    btnCalculate: TButton;
    Label1: TLabel;
    Label2: TLabel;
   // Label3: TLabel;
    ledVat: TLabeledEdit;
    ledGross: TLabeledEdit;
    ledNet: TLabeledEdit;
    ledVatFromGross: TLabeledEdit;
    ledNetFromVat: TLabeledEdit;
    ledGrossFromVat: TLabeledEdit;

    procedure FormShow(Sender: TObject);
    procedure edValueChange(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
  private
    fVatRate: Double;
    function Vat(const netValue: Double): Double;
    function Gross(const netValue: Double): Double;
    function Net(const grossValue: Double): Double;
    function VatFromGross(const grossValue: Double): Double;
    function NetFromVat(const vatValue: Double): Double;
    function GrossFromVat(const vatValue: Double): Double;
  public
    property VatRate: Double read fVatRate write fVatRate;
  end;

var
  frmTaxCalc: TfrmTaxCalc;

implementation

{$R *.dfm}

procedure TfrmTaxCalc.FormShow(Sender: TObject);
begin
  edValue.SetFocus;
end;

procedure TfrmTaxCalc.edValueChange(Sender: TObject);
begin
  if (Trim(edVat.Text) <> '') and (Trim(edValue.Text) <> '') then
    btnCalculate.Click;
end;

procedure TfrmTaxCalc.btnCalculateClick(Sender: TObject);
var
  valueIn: Double;
begin
  try
    fVatRate := StrToFloat(edVat.Text);
    valueIn := StrToFloat(edValue.Text);

    ledVat.Text := FormatFloat('0.00', Vat(valueIn));
    ledGross.Text := FormatFloat('0.00', Gross(valueIn));
    ledNet.Text := FormatFloat('0.00', Net(valueIn));
    ledVatFromGross.Text := FormatFloat('0.00', VatFromGross(valueIn));
    ledNetFromVat.Text := FormatFloat('0.00', NetFromVat(valueIn));
    ledGrossFromVat.Text := FormatFloat('0.00', GrossFromVat(valueIn));
  except
    on E: Exception do
      MessageDlg('Calculation error: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

function TfrmTaxCalc.Vat(const netValue: Double): Double;
begin
  Result := VatRate * netValue / 100;
end;

function TfrmTaxCalc.Gross(const netValue: Double): Double;
begin
  Result := netValue + Vat(netValue);
end;

function TfrmTaxCalc.Net(const grossValue: Double): Double;
begin
  Result := 100 / (100 + VatRate) * grossValue;
end;

function TfrmTaxCalc.VatFromGross(const grossValue: Double): Double;
begin
  Result := grossValue - Net(grossValue);
end;

function TfrmTaxCalc.NetFromVat(const vatValue: Double): Double;
begin
  Result := vatValue * 100 / VatRate;
end;

function TfrmTaxCalc.GrossFromVat(const vatValue: Double): Double;
begin
  Result := vatValue + NetFromVat(vatValue);
end;

end.