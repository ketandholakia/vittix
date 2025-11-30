unit uInvoicesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
System.UITypes,  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
System.Generics.Collections,   FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,
  System.JSON, System.IOUtils, Vcl.Buttons;

type
  TfrmInvoices = class(TForm)
    pnlTop: TPanel;
    DBNavigator1: TDBNavigator;
    grdInvoices: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    qryInvoices: TFDQuery;
    dsInvoices: TDataSource;

    procedure SetupQuery;
    procedure LoadGridConfig;
    procedure ConfigureGridFromJSON(const JSONText: string);
  public
  end;

var
  frmInvoices: TfrmInvoices;

implementation

uses uDMmain, uInvoiceEditForm, uInvoiceTypeSelectForm, uInvoiceUtils;


{$R *.dfm}

procedure TfrmInvoices.FormCreate(Sender: TObject);
begin
  qryInvoices := TFDQuery.Create(Self);
  dsInvoices := TDataSource.Create(Self);
  dsInvoices.DataSet := qryInvoices;
  grdInvoices.DataSource := dsInvoices;
  DBNavigator1.DataSource := dsInvoices;

  try
    SetupQuery;
    LoadGridConfig;
  except
    on E: Exception do
    begin
      MessageDlg('Failed to load invoices: ' + E.Message, mtError, [mbOK], 0);
      Close;
    end;
  end;
end;

procedure TfrmInvoices.FormDestroy(Sender: TObject);
begin
  qryInvoices.Close;
end;

procedure TfrmInvoices.SetupQuery;
begin
  qryInvoices.Connection := DMmain.FDConnectionMain;
  qryInvoices.SQL.Text :=
    'SELECT *  FROM INVOICE I ' +
    'JOIN CUSTOMERS C ON C.CUSTOMER_ID = I.CUSTOMER_ID ' +
    'ORDER BY I.INVOICE_DATE DESC';
  qryInvoices.Open;
end;

procedure TfrmInvoices.LoadGridConfig;
var
  JSONText: string;
  ConfigPath: string;
begin
  ConfigPath := ExtractFilePath(Application.ExeName) + 'configs\InvoiceGridConfig.json';
  if not TFile.Exists(ConfigPath) then
    raise Exception.Create('Grid config file not found: ' + ConfigPath);

  JSONText := TFile.ReadAllText(ConfigPath, TEncoding.UTF8);
  ConfigureGridFromJSON(JSONText);
end;

procedure TfrmInvoices.ConfigureGridFromJSON(const JSONText: string);
var
  JSONArray: TJSONArray;
  Obj: TJSONObject;
  i: Integer;
  Value: TJSONValue;
begin
  JSONArray := TJSONObject.ParseJSONValue(JSONText) as TJSONArray;
  if not Assigned(JSONArray) then
    raise Exception.Create('Invalid JSON format in grid config.');

  grdInvoices.Columns.Clear;

  for i := 0 to JSONArray.Count - 1 do
  begin
    Obj := JSONArray.Items[i] as TJSONObject;
    Value := Obj.Values['visible'];
    if Assigned(Value) and SameText(Value.Value, 'true') then
    begin
      with grdInvoices.Columns.Add do
      begin
        FieldName := Obj.Values['field'].Value;
        Title.Caption := Obj.Values['title'].Value;
        Width := StrToIntDef(Obj.Values['width'].Value, 100);
        if Obj.TryGetValue('readonly', Value) and SameText(Value.Value, 'true') then
          ReadOnly := True;
      end;
    end;
  end;
end;

procedure TfrmInvoices.btnAddClick(Sender: TObject);
var
  SelectedTypeID: Integer;
  InvoiceNo: string;
begin
  frmInvoiceTypeSelect := TfrmInvoiceTypeSelect.Create(Self);
  try
    if frmInvoiceTypeSelect.ShowModal = mrOk then
    begin
      SelectedTypeID := frmInvoiceTypeSelect.SelectedInvoiceTypeID;
      InvoiceNo := GenerateInvoiceNumber(SelectedTypeID, DMmain.FDConnectionMain);

      frmInvoiceEdit := TfrmInvoiceEdit.Create(Self);
      frmInvoiceEdit.FDInvoice := TFDQuery.Create(frmInvoiceEdit);
      frmInvoiceEdit.FDInvoice.Connection := DMmain.FDConnectionMain;
      frmInvoiceEdit.FDInvoice.SQL.Text := 'SELECT * FROM INVOICE WHERE 1=0';
      frmInvoiceEdit.FDInvoice.Open;
      frmInvoiceEdit.FDInvoice.Append;

      frmInvoiceEdit.FDInvoice.FieldByName('INVOICE_NO').AsString := InvoiceNo;
      frmInvoiceEdit.FDInvoice.FieldByName('INVOICETYPEID').AsInteger := SelectedTypeID;
      frmInvoiceEdit.FDInvoice.FieldByName('INVOICE_DATE').AsDateTime := Date;

      frmInvoiceEdit.dsInvoice := TDataSource.Create(frmInvoiceEdit);
      frmInvoiceEdit.dsInvoice.DataSet := frmInvoiceEdit.FDInvoice;
      frmInvoiceEdit.BindInvoiceFields;

      if frmInvoiceEdit.ShowModal = mrOk then
        qryInvoices.Refresh;

      frmInvoiceEdit.Free;
    end;
  finally
    frmInvoiceTypeSelect.Free;
  end;
end;



procedure TfrmInvoices.btnEditClick(Sender: TObject);
var
  InvoiceID: Integer;
begin
  if qryInvoices.IsEmpty then Exit;

  InvoiceID := qryInvoices.FieldByName('INVOICE_ID').AsInteger;

  frmInvoiceEdit := TfrmInvoiceEdit.Create(Self);
  try
    frmInvoiceEdit.LoadInvoiceByID(InvoiceID);
    frmInvoiceEdit.LoadInvoiceItems(InvoiceID);
    frmInvoiceEdit.BindInvoiceFields;
    if frmInvoiceEdit.ShowModal = mrOk then
      qryInvoices.Refresh;
  finally
    frmInvoiceEdit.Free;
  end;
end;

procedure TfrmInvoices.btnDeleteClick(Sender: TObject);
begin
  if not qryInvoices.IsEmpty then
    if MessageDlg('Delete this invoice?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      qryInvoices.Delete;
end;

end.
