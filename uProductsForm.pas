unit uProductsForm;

interface
uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client,
 vcl.Dialogs, FireDAC.Comp.DataSet, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt;
type
  TfrmProducts = class(TForm)
    pnlMain: TPanel;
    lblName: TLabel;
    lblHSN: TLabel;
    lblUnitPrice: TLabel;
    lblGST: TLabel;
    lblStock: TLabel;
    lblDescription: TLabel;
    edtName: TEdit;
    edtHSN: TEdit;
    edtUnitPrice: TEdit;
    edtGST: TEdit;
    edtStock: TEdit;
    memDescription: TMemo;
    btnAdd: TButton;
    btnUpdate: TButton;
    btnDelete: TButton;
    dbgProducts: TDBGrid;
    dsProducts: TDataSource;
    qryProducts: TFDQuery;
    qryProductsPRODUCT_ID: TIntegerField;
    qryProductsNAME: TWideStringField;
    qryProductsDESCRIPTION: TMemoField;
    qryProductsHSN_SAC_CODE: TWideStringField;
    qryProductsUNIT_PRICE: TFMTBCDField;
    qryProductsGST_RATE: TCurrencyField;
    qryProductsSTOCK_QUANTITY: TFMTBCDField;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    procedure LoadProducts;
    procedure LogAction(const Action: string);
  public
    { Public declarations }
  end;
var
  frmProducts: TfrmProducts;
implementation
{$R *.dfm}
uses
  uDMMain, Winapi.Windows;
procedure TfrmProducts.FormCreate(Sender: TObject);
begin
  qryProducts.Connection := dmMain.FDConnectionmain;
  LoadProducts;
end;
procedure TfrmProducts.LoadProducts;
begin
  qryProducts.Close;
  qryProducts.SQL.Text := 'SELECT * FROM PRODUCTS ORDER BY PRODUCT_ID';
  qryProducts.Open;
end;
procedure TfrmProducts.btnAddClick(Sender: TObject);
begin
  qryProducts.Append;
  qryProducts.FieldByName('NAME').AsString := edtName.Text;
  qryProducts.FieldByName('HSN_SAC_CODE').AsString := edtHSN.Text;
  qryProducts.FieldByName('UNIT_PRICE').AsFloat := StrToFloatDef(edtUnitPrice.Text, 0);
  qryProducts.FieldByName('GST_RATE').AsFloat := StrToFloatDef(edtGST.Text, 0);
  qryProducts.FieldByName('STOCK_QUANTITY').AsFloat := StrToFloatDef(edtStock.Text, 0);
  qryProducts.FieldByName('DESCRIPTION').AsString := memDescription.Text;
  qryProducts.Post;
  LoadProducts;
  LogAction('Added product: ' + edtName.Text);
end;
procedure TfrmProducts.btnUpdateClick(Sender: TObject);
begin
  if not qryProducts.IsEmpty then
  begin
    qryProducts.Edit;
    qryProducts.FieldByName('NAME').AsString := edtName.Text;
    qryProducts.FieldByName('HSN_SAC_CODE').AsString := edtHSN.Text;
    qryProducts.FieldByName('UNIT_PRICE').AsFloat := StrToFloatDef(edtUnitPrice.Text, 0);
    qryProducts.FieldByName('GST_RATE').AsFloat := StrToFloatDef(edtGST.Text, 0);
    qryProducts.FieldByName('STOCK_QUANTITY').AsFloat := StrToFloatDef(edtStock.Text, 0);
    qryProducts.FieldByName('DESCRIPTION').AsString := memDescription.Text;
    qryProducts.Post;
    LoadProducts;
    LogAction('Updated product: ' + edtName.Text);
  end;
end;
procedure TfrmProducts.btnDeleteClick(Sender: TObject);
begin
  if not qryProducts.IsEmpty then
  begin
    if MessageDlg('Delete this product?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      LogAction('Deleted product: ' + qryProducts.FieldByName('NAME').AsString);
      qryProducts.Delete;
      LoadProducts;
    end;
  end;
end;
procedure TfrmProducts.LogAction(const Action: string);
begin
  OutputDebugString(PChar('[ProductsForm] ' + Action));
end;
end.
