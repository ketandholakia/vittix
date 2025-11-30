unit uStatesForm;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, System.IOUtils, System.JSON,
  uStateEditDialog, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.Dialogs, System.Generics.Collections;

type
  TGridColumnConfig = record
    FieldName: string;
    Title: string;
    Width: Integer;
  end;

  TGridColumnConfigList = TArray<TGridColumnConfig>;

  TfrmStates = class(TForm)
    pnlToolbar: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    grdStates: TDBGrid;
    dsStates: TDataSource;
    qryStates: TFDQuery;

    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    procedure LoadStates;
    procedure ConfigureGridFromJSON(const ConfigPath: string);
    function LoadGridConfig(const FileName: string): TGridColumnConfigList;
    function GetGridConfigPath: string;
    function GetDialogConfigPath: string;
  public
  end;

var
  frmStates: TfrmStates;

implementation

{$R *.dfm}

uses uDMMain;

procedure TfrmStates.FormCreate(Sender: TObject);
begin
  qryStates.Connection := dmMain.FDConnectionmain;
  LoadStates;
end;

procedure TfrmStates.LoadStates;
begin
  qryStates.Close;
  qryStates.SQL.Text := 'SELECT STATE_ID, STATE_NAME, STATE_CODE, ABBREVIATION FROM STATES ORDER BY STATE_NAME';
  qryStates.Open;
  ConfigureGridFromJSON(GetGridConfigPath);
end;

function TfrmStates.GetGridConfigPath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'configs\StateGridConfig.json');
end;

function TfrmStates.GetDialogConfigPath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'configs\State.json');
end;

procedure TfrmStates.ConfigureGridFromJSON(const ConfigPath: string);
var
  ConfigList: TGridColumnConfigList;
  i: Integer;
begin
  grdStates.Columns.Clear;
  ConfigList := LoadGridConfig(ConfigPath);

  for i := 0 to High(ConfigList) do
  begin
    with grdStates.Columns.Add do
    begin
      FieldName := ConfigList[i].FieldName;
      Title.Caption := ConfigList[i].Title;
      Width := ConfigList[i].Width;
    end;
  end;
end;

function TfrmStates.LoadGridConfig(const FileName: string): TGridColumnConfigList;
var
  JSONArr: TJSONArray;
  i: Integer;
begin
  JSONArr := TJSONObject.ParseJSONValue(TFile.ReadAllText(FileName)) as TJSONArray;
  if JSONArr = nil then
    raise Exception.Create('Invalid JSON format in StateGridConfig.json');

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
procedure TfrmStates.btnAddClick(Sender: TObject);
begin
  qryStates.Append;
  if TFrmStateEditDialog.Execute(qryStates, GetDialogConfigPath) then
  begin
    qryStates.Post;
    qryStates.Refresh;
  end
  else
    qryStates.Cancel;
end;

procedure TfrmStates.btnEditClick(Sender: TObject);
begin
  if not qryStates.IsEmpty then
  begin
    qryStates.Edit;
    if TFrmStateEditDialog.Execute(qryStates, GetDialogConfigPath) then
    begin
      qryStates.Post;
      qryStates.Refresh;
    end
    else
      qryStates.Cancel;
  end;
end;

procedure TfrmStates.btnDeleteClick(Sender: TObject);
begin
  if not qryStates.IsEmpty then
  begin
    if MessageDlg('Delete selected state?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      qryStates.Delete;
      qryStates.Refresh;
    end;
  end;
end;

end.
