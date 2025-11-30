unit uInvoiceEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzSplit, Vcl.ExtCtrls, RzPanel, Data.DB,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.AppEvnts, Vcl.Menus, Vcl.StdCtrls, Vcl.DBCtrls,
  RzButton, RzRadChk, RzDBChk, Vcl.ComCtrls, RzEdit, RzDBEdit, Vcl.Mask,
  System.JSON, System.IOUtils, RzLabel, RzDBLbl;

type
  TfrmInvoiceEdit = class(TForm)
    dsInvoice: TDataSource;
    FDInvoice: TFDQuery;
    FDInvoiceDetail: TFDQuery;
    dsInvoiceItems: TDataSource;
    Panel1: TPanel;
    pnl_invoice_detail: TPanel;
    Panel2: TPanel;
    lbl_invoice_no: TLabel;
    dbEdit_Invoice_No: TDBEdit;
    Panel3: TPanel;
    lbl_invoice_date: TLabel;
    dbdateedit_invoice_date: TRzDBDateTimeEdit;
    Panel4: TPanel;
    Label1: TLabel;
    dbeditdate_PURCHASE_ORDER_DATE: TRzDBDateTimeEdit;
    Panel5: TPanel;
    Label2: TLabel;
    DBEdit_PURCHASE_ORDER_REF: TDBEdit;
    pnl_billing: TPanel;
    Panel6: TPanel;
    dblookupcombo_CUSTOMER_ID: TDBLookupComboBox;
    btnOK: TButton;
    lbldb_Invoice_No_display: TRzDBLabel;
    dblookupcombo_INVOICETYPEID: TDBLookupComboBox;
    chkManualInvoiceNo: TCheckBox;
    dblookupcombo_TRANSPORTER_ID: TDBLookupComboBox;
    RzSizePanel1: TRzSizePanel;
    RzPanel1: TRzPanel;
    Label3: TLabel;
    DBEdit_Netdays: TDBEdit;
    RzPanel2: TRzPanel;
    dbgridInvoiceItems: TDBGrid;
    procedure btnOKClick(Sender: TObject);
    procedure dblookupcombo_CUSTOMER_IDCloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  public
    procedure CreateNewInvoice(ATypeID: Integer; const APrefix, ASuffix: string);
    procedure LoadInvoice(Source: TDataSource);
    procedure LoadInvoiceByID(const AInvoiceID: Integer);
    procedure LoadInvoiceItems(const AInvoiceID: Integer);
    procedure BindInvoiceFields;
  private
    FGridConfigPath: string;
    procedure HandleCustomerCloseUp(Sender: TObject);
    procedure ApplyGridConfig(Grid: TDBGrid; const FilePath: string);
    procedure InitializeComponents;
    procedure CleanupComponents;
    function GetNextInvoiceNumber(ATypeID: Integer): Integer;
    function GetCustomerNetDays(CustomerID: Integer): Integer;
    procedure UpdateInvoiceNumberDisplay;
    procedure ValidateInvoiceData;
    procedure SetupQueryParameters;
  end;

var
  frmInvoiceEdit: TfrmInvoiceEdit;

implementation

uses uDMmain;

{$R *.dfm}

procedure TfrmInvoiceEdit.FormCreate(Sender: TObject);
begin
  InitializeComponents;
end;

procedure TfrmInvoiceEdit.FormDestroy(Sender: TObject);
begin
  CleanupComponents;
end;

procedure TfrmInvoiceEdit.InitializeComponents;
begin
  SetupQueryParameters;
  // Set grid config path - adjust as needed
  FGridConfigPath := ExtractFilePath(ParamStr(0)) + 'configs\InvoiceItemGridConfig.json';
end;

procedure TfrmInvoiceEdit.CleanupComponents;
begin
  if FDInvoice.Active then
    FDInvoice.Close;
  if FDInvoiceDetail.Active then
    FDInvoiceDetail.Close;
end;

procedure TfrmInvoiceEdit.SetupQueryParameters;
begin
  // Common query setup
  FDInvoice.Connection := DMmain.FDConnectionMain;
  FDInvoice.UpdateOptions.AutoIncFields := 'INVOICE_ID';
  FDInvoice.CachedUpdates := True;

  FDInvoiceDetail.Connection := DMmain.FDConnectionMain;
  FDInvoiceDetail.CachedUpdates := True;
end;

procedure TfrmInvoiceEdit.ApplyGridConfig(Grid: TDBGrid; const FilePath: string);
var
  JSONArray: TJSONArray;
  JSONText: string;
  i: Integer;
  Col: TColumn;
  FieldName, Title: string;
  Width: Integer;
begin
  if not TFile.Exists(FilePath) then
    Exit; // Silently exit if config file doesn't exist

  try
    JSONText := TFile.ReadAllText(FilePath, TEncoding.UTF8);
    JSONArray := TJSONObject.ParseJSONValue(JSONText) as TJSONArray;

    if not Assigned(JSONArray) then
      Exit;

    try
      Grid.Columns.BeginUpdate;
      Grid.Columns.Clear;

      for i := 0 to JSONArray.Count - 1 do
      begin
        with JSONArray.Items[i] as TJSONObject do
        begin
          FieldName := GetValue('field').Value;
          Title := GetValue('title').Value;
          Width := StrToIntDef(GetValue('width').Value, 100);

          Col := Grid.Columns.Add;
          Col.FieldName := FieldName;
          Col.Title.Caption := Title;
          Col.Width := Width;
        end;
      end;
    finally
      Grid.Columns.EndUpdate;
      JSONArray.Free;
    end;
  except
    on E: Exception do
    begin
      // Log error instead of showing message for configuration issues
      OutputDebugString(PChar('Grid config error: ' + E.Message));
    end;
  end;
end;

procedure TfrmInvoiceEdit.HandleCustomerCloseUp(Sender: TObject);
var
  CustomerID: Integer;
begin
  if FDInvoice.State = dsBrowse then
    FDInvoice.Edit;

  CustomerID := FDInvoice.FieldByName('CUSTOMER_ID').AsInteger;
  if CustomerID > 0 then
  begin
    FDInvoice.FieldByName('NetDays').AsInteger := GetCustomerNetDays(CustomerID);
  end;
end;

function TfrmInvoiceEdit.GetCustomerNetDays(CustomerID: Integer): Integer;
var
  CustomerNetDays: Variant;
begin
  Result := 0;
  CustomerNetDays := DMmain.FDCustomers.Lookup('CUSTOMER_ID', CustomerID, 'NetDays');
  if not VarIsNull(CustomerNetDays) then
    Result := CustomerNetDays;
end;

function TfrmInvoiceEdit.GetNextInvoiceNumber(ATypeID: Integer): Integer;
var
  NextNum: Variant;
begin
  NextNum := DMmain.FDInvoiceType.Lookup('INVOICETYPEID', ATypeID, 'NEXTNUMBER');
  if VarIsNull(NextNum) or (NextNum = 0) then
    raise Exception.Create('NEXTNUMBER not defined for selected invoice type.');

  Result := NextNum;
end;

procedure TfrmInvoiceEdit.CreateNewInvoice(ATypeID: Integer; const APrefix, ASuffix: string);
var
  CustomerID: Integer;
begin
  FDInvoice.Append;

  FDInvoice.FieldByName('INVOICETYPEID').AsInteger := ATypeID;
  FDInvoice.FieldByName('INVOICE_PREFIX').AsString := APrefix;
  FDInvoice.FieldByName('INVOICE_SUFFIX').AsString := ASuffix;

  // Assign invoice number
  if not chkManualInvoiceNo.Checked then
  begin
    FDInvoice.FieldByName('INVOICE_NO').AsInteger := GetNextInvoiceNumber(ATypeID);
  end;

  // Assign NetDays from selected customer
  CustomerID := FDInvoice.FieldByName('CUSTOMER_ID').AsInteger;
  if CustomerID > 0 then
  begin
    FDInvoice.FieldByName('NetDays').AsInteger := GetCustomerNetDays(CustomerID);
  end;

  BindInvoiceFields;
end;

procedure TfrmInvoiceEdit.dblookupcombo_CUSTOMER_IDCloseUp(Sender: TObject);
begin
  HandleCustomerCloseUp(Sender);
end;

procedure TfrmInvoiceEdit.LoadInvoiceByID(const AInvoiceID: Integer);
begin
  if AInvoiceID <= 0 then
    raise Exception.Create('Invalid Invoice ID');

  FDInvoice.Close;
  FDInvoice.SQL.Text :=
    'SELECT I.*, T.SERIESPREFIX, T.SERIESSUFFIX ' +
    'FROM INVOICE I ' +
    'LEFT JOIN INVOICETYPE T ON T.INVOICETYPEID = I.INVOICETYPEID ' +
    'WHERE I.INVOICE_ID = :ID';
  FDInvoice.ParamByName('ID').AsInteger := AInvoiceID;
  FDInvoice.Open;

  if FDInvoice.IsEmpty then
    raise Exception.CreateFmt('Invoice not found: %d', [AInvoiceID]);

  UpdateInvoiceNumberDisplay;
end;

procedure TfrmInvoiceEdit.UpdateInvoiceNumberDisplay;
var
  Prefix, Suffix, InvoiceNoPadded: string;
begin
  if FDInvoice.IsEmpty then Exit;

  Prefix := FDInvoice.FieldByName('SERIESPREFIX').AsString;
  Suffix := FDInvoice.FieldByName('SERIESSUFFIX').AsString;
  InvoiceNoPadded := Format('%.3d', [FDInvoice.FieldByName('INVOICE_NO').AsInteger]);

  if FDInvoice.State = dsBrowse then
    FDInvoice.Edit;

  FDInvoice.FieldByName('INVOICE_PREFIX').AsString := Prefix;
  FDInvoice.FieldByName('INVOICE_SUFFIX').AsString := Suffix;
  FDInvoice.FieldByName('INVOICE_NUMBER_DISPLAY').AsString := Prefix + InvoiceNoPadded + Suffix;
end;

procedure TfrmInvoiceEdit.ValidateInvoiceData;
begin
  if FDInvoice.FieldByName('INVOICE_NO').AsInteger <= 0 then
    raise Exception.Create('Invoice number must be greater than 0');

  if FDInvoice.FieldByName('CUSTOMER_ID').AsInteger <= 0 then
    raise Exception.Create('Customer must be selected');

  if FDInvoice.FieldByName('INVOICETYPEID').AsInteger <= 0 then
    raise Exception.Create('Invoice type must be selected');
end;

procedure TfrmInvoiceEdit.btnOKClick(Sender: TObject);
var
  TypeID, CurrentNext, EnteredNo: Integer;
begin
  try
    ValidateInvoiceData;

    if FDInvoice.State in [dsEdit, dsInsert] then
    begin
      UpdateInvoiceNumberDisplay;
      FDInvoice.Post;

      // Update NEXTNUMBER only if not manual and entered number >= current NEXTNUMBER
      if not chkManualInvoiceNo.Checked then
      begin
        TypeID := FDInvoice.FieldByName('INVOICETYPEID').AsInteger;
        EnteredNo := FDInvoice.FieldByName('INVOICE_NO').AsInteger;

        if DMmain.FDInvoiceType.Locate('INVOICETYPEID', TypeID, []) then
        begin
          CurrentNext := DMmain.FDInvoiceType.FieldByName('NEXTNUMBER').AsInteger;
          if EnteredNo >= CurrentNext then
          begin
            DMmain.FDInvoiceType.Edit;
            DMmain.FDInvoiceType.FieldByName('NEXTNUMBER').AsInteger := EnteredNo + 1;
            DMmain.FDInvoiceType.Post;
          end;
        end;
      end;
    end;

    if FDInvoiceDetail.State in [dsEdit, dsInsert] then
      FDInvoiceDetail.Post;

    FDInvoice.ApplyUpdates(0);
    FDInvoiceDetail.ApplyUpdates(0);

    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      ModalResult := mrNone;
      raise; // Re-raise exception for caller to handle
    end;
  end;
end;

procedure TfrmInvoiceEdit.LoadInvoice(Source: TDataSource);
begin
  if not Assigned(Source) or not Assigned(Source.DataSet) then
    raise Exception.Create('Invalid source dataset');

  LoadInvoiceByID(Source.DataSet.FieldByName('INVOICE_ID').AsInteger);
end;

procedure TfrmInvoiceEdit.LoadInvoiceItems(const AInvoiceID: Integer);
begin
  if AInvoiceID <= 0 then
    raise Exception.Create('Invalid Invoice ID');

  FDInvoiceDetail.Close;
  FDInvoiceDetail.SQL.Text := 'SELECT * FROM INVOICE_DETAIL WHERE INVOICE_ID = :ID';
  FDInvoiceDetail.ParamByName('ID').AsInteger := AInvoiceID;
  FDInvoiceDetail.Open;

  // Apply grid configuration after loading data
  if FileExists(FGridConfigPath) then
    ApplyGridConfig(dbgridInvoiceItems, FGridConfigPath);
end;

procedure TfrmInvoiceEdit.BindInvoiceFields;
begin
  // Main invoice fields
  dbEdit_Invoice_No.DataSource := dsInvoice;
  dbEdit_Invoice_No.DataField := 'INVOICE_NO';

  lbldb_Invoice_No_display.DataSource := dsInvoice;
  lbldb_Invoice_No_display.DataField := 'INVOICE_NUMBER_DISPLAY';

  dbdateedit_invoice_date.DataSource := dsInvoice;
  dbdateedit_invoice_date.DataField := 'INVOICE_DATE';

  DBEdit_PURCHASE_ORDER_REF.DataSource := dsInvoice;
  DBEdit_PURCHASE_ORDER_REF.DataField := 'PURCHASE_ORDER_REF';

  dbeditdate_PURCHASE_ORDER_DATE.DataSource := dsInvoice;
  dbeditdate_PURCHASE_ORDER_DATE.DataField := 'PURCHASE_ORDER_DATE';

  DBEdit_NetDays.DataSource := dsInvoice;
  DBEdit_NetDays.DataField := 'NetDays';

  // Lookup combos
  dblookupcombo_CUSTOMER_ID.DataSource := dsInvoice;
  dblookupcombo_CUSTOMER_ID.DataField := 'CUSTOMER_ID';
  dblookupcombo_CUSTOMER_ID.ListSource := DMmain.dsCustomers;
  dblookupcombo_CUSTOMER_ID.KeyField := 'CUSTOMER_ID';
  dblookupcombo_CUSTOMER_ID.ListField := 'NAME';

  dblookupcombo_INVOICETYPEID.DataSource := dsInvoice;
  dblookupcombo_INVOICETYPEID.DataField := 'INVOICETYPEID';
  dblookupcombo_INVOICETYPEID.ListSource := DMmain.dsInvoiceTypes;
  dblookupcombo_INVOICETYPEID.KeyField := 'InvoiceTypeID';
  dblookupcombo_INVOICETYPEID.ListField := 'Description';

  dblookupcombo_TRANSPORTER_ID.DataSource := dsInvoice;
  dblookupcombo_TRANSPORTER_ID.DataField := 'TRANSPORTER_ID';
  dblookupcombo_TRANSPORTER_ID.ListSource := DMmain.dsTransporters;
  dblookupcombo_TRANSPORTER_ID.KeyField := 'TRANSPORTER_ID';
  dblookupcombo_TRANSPORTER_ID.ListField := 'NAME';

  // Event handlers
  dblookupcombo_CUSTOMER_ID.OnCloseUp := HandleCustomerCloseUp;
end;

end.
