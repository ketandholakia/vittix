unit uCustomersForm;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Stan.Param,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.VCLUI.Wait, FireDAC.DatS, Vcl.Menus,
  System.JSON, System.IOUtils;

type
  TfrmCustomers = class(TForm)
    grdCustomers: TDBGrid;
    qryCustomers: TFDQuery;
    dsCustomers: TDataSource;
    PopupMenu1: TPopupMenu;
    Add2: TMenuItem;
    Edit1: TMenuItem;
    delete: TMenuItem;
    pnlTop: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;

    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    procedure LoadCustomers;
    procedure ApplyUpdates;
    procedure CancelUpdates;
    procedure ApplyGridConfig(const ConfigPath: string);
  public
    { Public declarations }
  end;

var
  frmCustomers: TfrmCustomers;

implementation

{$R *.dfm}

uses uCustomerEditDialog, uDMmain;

procedure TfrmCustomers.FormCreate(Sender: TObject);
var
  ConfigPath: string;
begin
  LoadCustomers;
  ConfigPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'configs\CustomerGridConfig.json');
  ApplyGridConfig(ConfigPath);
end;

procedure TfrmCustomers.LoadCustomers;
begin
  qryCustomers.Close;
  qryCustomers.SQL.Text :=
    'SELECT c.*, s.STATE_NAME ' +
    'FROM CUSTOMERS c ' +
    'LEFT JOIN STATES s ON c.STATE_ID = s.STATE_ID ' +
    'ORDER BY c.NAME';
  qryCustomers.Open;

  qryCustomers.FieldByName('CUSTOMER_ID').AutoGenerateValue := arAutoInc;
  qryCustomers.FieldByName('CUSTOMER_ID').Required := False;
end;

procedure TfrmCustomers.ApplyUpdates;
begin
  if qryCustomers.State in [dsEdit, dsInsert] then
    qryCustomers.Post;
  if qryCustomers.UpdatesPending then
    qryCustomers.ApplyUpdates(0);
end;

procedure TfrmCustomers.CancelUpdates;
begin
  if qryCustomers.State in [dsEdit, dsInsert] then
    qryCustomers.Cancel;
end;

procedure TfrmCustomers.btnAddClick(Sender: TObject);
var
  qryStates: TFDQuery;
  dsStates: TDataSource;
begin
  qryStates := TFDQuery.Create(nil);
  qryStates.Connection := DMmain.FDConnectionMain;
  qryStates.SQL.Text := 'SELECT STATE_ID, STATE_NAME FROM STATES ORDER BY STATE_NAME';
  qryStates.Open;

  dsStates := TDataSource.Create(nil);
  dsStates.DataSet := qryStates;

  qryCustomers.Append;
  if TfrmCustomerEdit.Execute(qryCustomers, dsStates) then
  begin
    ApplyUpdates;
    LoadCustomers;
  end
  else
    CancelUpdates;

  qryStates.Free;
  dsStates.Free;
end;

procedure TfrmCustomers.btnEditClick(Sender: TObject);
var
  dsStates: TDataSource;
  qryStates: TFDQuery;
begin
  if not qryCustomers.Active or qryCustomers.IsEmpty then Exit;

  qryStates := TFDQuery.Create(Self);
  qryStates.Connection := DMmain.FDConnectionMain;
  qryStates.SQL.Text := 'SELECT STATE_ID, STATE_NAME FROM STATES ORDER BY STATE_NAME';
  qryStates.Open;

  dsStates := TDataSource.Create(Self);
  dsStates.DataSet := qryStates;

  qryCustomers.Edit;
  if TfrmCustomerEdit.Execute(qryCustomers, dsStates) then
  begin
    ApplyUpdates;
    LoadCustomers;
  end
  else
    CancelUpdates;
end;

procedure TfrmCustomers.btnDeleteClick(Sender: TObject);
var
  CustomerName: string;
begin
  if not qryCustomers.Active or qryCustomers.IsEmpty then Exit;

  CustomerName := qryCustomers.FieldByName('NAME').AsString;

  if MessageDlg(Format('Are you sure you want to delete customer "%s"?', [CustomerName]),
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    qryCustomers.Delete;
    qryCustomers.Connection.Commit;
    LoadCustomers;
  end;
end;

procedure TfrmCustomers.ApplyGridConfig(const ConfigPath: string);
var
  JSONText: string;
  JSONObject: TJSONObject;
  ColumnsArray: TJSONArray;
  ColumnObj: TJSONObject;
  i: Integer;
  Col: TColumn;
  FieldName, Title, AlignStr: string;
  Visible: Boolean;
  Width: Integer;
begin
  if not FileExists(ConfigPath) then
  begin
    ShowMessage('Grid config file not found: ' + ConfigPath);
    Exit;
  end;

  JSONText := TFile.ReadAllText(ConfigPath, TEncoding.UTF8);
  JSONObject := TJSONObject.ParseJSONValue(JSONText) as TJSONObject;
  try
    ColumnsArray := JSONObject.GetValue<TJSONArray>('columns');
    if not Assigned(ColumnsArray) then Exit;

    grdCustomers.Columns.BeginUpdate;
    try
      grdCustomers.Columns.Clear;

      for i := 0 to ColumnsArray.Count - 1 do
      begin
        ColumnObj := ColumnsArray.Items[i] as TJSONObject;
        FieldName := ColumnObj.GetValue<string>('field');
        Visible := ColumnObj.GetValue<Boolean>('visible', True);
        if not Visible then Continue;

        Col := grdCustomers.Columns.Add;
        Col.FieldName := FieldName;
        Col.Title.Caption := ColumnObj.GetValue<string>('title', FieldName);
        Col.Width := ColumnObj.GetValue<Integer>('width', 100);

        AlignStr := ColumnObj.GetValue<string>('alignment', 'left').ToLower;
        if AlignStr = 'center' then
          Col.Alignment := taCenter
        else if AlignStr = 'right' then
          Col.Alignment := taRightJustify
        else
          Col.Alignment := taLeftJustify;
      end;
    finally
      grdCustomers.Columns.EndUpdate;
    end;
  finally
    JSONObject.Free;
  end;
end;

end.
