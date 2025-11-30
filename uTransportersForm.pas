unit uTransportersForm;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, uTransporterEditDialog,
  System.IOUtils, System.JSON;

type
  TGridColumnConfig = record
    FieldName: string;
    Title: string;
    Width: Integer;
  end;

  TGridColumnConfigList = TArray<TGridColumnConfig>;

  TfrmTransporters = class(TForm)
    pnlMain: TPanel;
    dbgTransporters: TDBGrid;
    dsTransporters: TDataSource;
    qryTransporters: TFDQuery;
    qryTransportersTRANSPORTER_ID: TIntegerField;
    qryTransportersNAME: TWideStringField;
    qryTransportersADDRESS: TWideStringField;
    qryTransportersCITY: TWideStringField;
    qryTransportersSTATE: TWideStringField;
    qryTransportersCOUNTRY: TWideStringField;
    qryTransportersPIN_CODE: TWideStringField;
    qryTransportersGSTIN: TWideStringField;
    qryTransportersCONTACT_PERSON: TWideStringField;
    qryTransportersPHONE: TWideStringField;
    qryTransportersEMAIL: TWideStringField;
    Panel1: TPanel;
    btnAdd: TButton;
    btnUpdate: TButton;
    btnDelete: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure qryTransportersAfterScroll(DataSet: TDataSet);
  private
    procedure LoadTransporters;
    procedure LogAction(const Action: string);
    function GetDialogConfigPath: string;
    function GetGridConfigPath: string;
    function LoadGridConfig(const FileName: string): TGridColumnConfigList;
    procedure ConfigureGridFromJSON(const ConfigPath: string);
  public
  end;

var
  frmTransporters: TfrmTransporters;

implementation

{$R *.dfm}

uses uDMMain;

procedure TfrmTransporters.FormCreate(Sender: TObject);
begin
  qryTransporters.Connection := dmMain.FDConnectionmain;
  LoadTransporters;
end;

procedure TfrmTransporters.FormShow(Sender: TObject);
begin
  Caption := 'Transporter Manager';
end;

procedure TfrmTransporters.LoadTransporters;
begin
  qryTransporters.Close;
  qryTransporters.SQL.Text := 'SELECT * FROM TRANSPORTER ORDER BY TRANSPORTER_ID';
  qryTransporters.Open;
  ConfigureGridFromJSON(GetGridConfigPath);
end;

function TfrmTransporters.GetDialogConfigPath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'configs\Transporter.json');
end;

function TfrmTransporters.GetGridConfigPath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'configs\TransportGridConfig.json');
end;

procedure TfrmTransporters.qryTransportersAfterScroll(DataSet: TDataSet);
begin
  if qryTransporters.IsEmpty then
    Caption := 'Transporters: No Records'
  else
    Caption := 'Transporter: ' + qryTransportersNAME.AsString;
end;

procedure TfrmTransporters.btnAddClick(Sender: TObject);
begin
  qryTransporters.Append;
  if TFrmTransporterEditDialog.Execute(qryTransporters, GetDialogConfigPath) then
  begin
    qryTransporters.Post;
    qryTransporters.Refresh;
    LogAction('Added new transporter.');
  end
  else
    qryTransporters.Cancel;
end;

procedure TfrmTransporters.btnUpdateClick(Sender: TObject);
begin
  if not qryTransporters.IsEmpty then
  begin
    qryTransporters.Edit;
    if TFrmTransporterEditDialog.Execute(qryTransporters, GetDialogConfigPath) then
    begin
      qryTransporters.Post;
      qryTransporters.Refresh;
      LogAction('Updated transporter: ' + qryTransportersNAME.AsString);
    end
    else
      qryTransporters.Cancel;
  end;
end;

procedure TfrmTransporters.btnDeleteClick(Sender: TObject);
begin
  if not qryTransporters.IsEmpty then
  begin
    if MessageDlg('Are you sure you want to delete transporter: ' + qryTransportersNAME.AsString,
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      LogAction('Deleted: ' + qryTransportersNAME.AsString);
      qryTransporters.Delete;
      qryTransporters.Refresh;
    end;
  end;
end;

procedure TfrmTransporters.LogAction(const Action: string);
begin
  OutputDebugString(PChar('[TransportersForm] ' + Action));
end;

function TfrmTransporters.LoadGridConfig(const FileName: string): TGridColumnConfigList;
var
  JSONArr: TJSONArray;
  i: Integer;
begin
  JSONArr := TJSONObject.ParseJSONValue(TFile.ReadAllText(FileName)) as TJSONArray;
  SetLength(Result, JSONArr.Count);

  for i := 0 to JSONArr.Count - 1 do
  begin
    with Result[i], JSONArr.Items[i] as TJSONObject do
    begin
      FieldName := GetValue('field').Value;
      Title := GetValue('title').Value;
      Width := StrToIntDef(GetValue('width').Value, 100);
    end;
  end;
end;

procedure TfrmTransporters.ConfigureGridFromJSON(const ConfigPath: string);
var
  ConfigList: TGridColumnConfigList;
  i: Integer;
begin
  dbgTransporters.Columns.Clear;
  ConfigList := LoadGridConfig(ConfigPath);

  for i := 0 to High(ConfigList) do
  begin
    with dbgTransporters.Columns.Add do
    begin
      FieldName := ConfigList[i].FieldName;
      Title.Caption := ConfigList[i].Title;
      Width := ConfigList[i].Width;
    end;
  end;
end;

end.
