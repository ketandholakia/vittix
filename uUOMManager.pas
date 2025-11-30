unit uUOMManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Stan.Async,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.DBCtrls, System.JSON, System.IOUtils;

type
  TfrmUOMManager = class(TForm)
    qryUOM: TFDQuery;
    qryUQC: TFDQuery;
    dsUOM: TDataSource;
    dsUQC: TDataSource;
    Panel1: TPanel;
    grdUOM: TDBGrid;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    qryUOMUOM_ID: TIntegerField;
    qryUOMUOM_CODE: TWideStringField;
    qryUOMUOM_NAME: TWideStringField;
    qryUOMIS_ACTIVE: TBooleanField;
    qryUOMUQC_CODE: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    procedure ApplyGridLayoutFromJSON(Grid: TDBGrid; const JSONFile: string);
  public
    procedure LoadUOM;
    procedure LoadUQC;
  end;

var
  frmUOMManager: TfrmUOMManager;

implementation

uses uDMMain, uUOMEditDialog;

{$R *.dfm}

procedure TfrmUOMManager.FormCreate(Sender: TObject);
begin
  qryUOM.Connection := DMMain.FDConnectionMain;
  qryUQC.Connection := DMMain.FDConnectionMain;

  qryUOM.ResourceOptions.Persistent := False;
  qryUQC.ResourceOptions.Persistent := False;

  LoadUOM;
  LoadUQC;

  ApplyGridLayoutFromJSON(grdUOM, 'configs\UOMGridConfig.json');
end;

procedure TfrmUOMManager.LoadUOM;
begin
  qryUOM.Close;
  qryUOM.SQL.Text := 'SELECT * FROM UOM ORDER BY UOM_CODE';
  qryUOM.Open;
end;

procedure TfrmUOMManager.LoadUQC;
begin
  qryUQC.Close;
  qryUQC.SQL.Text := 'SELECT UQC_CODE FROM UQC ORDER BY UQC_CODE';
  qryUQC.Open;
end;

procedure TfrmUOMManager.ApplyGridLayoutFromJSON(Grid: TDBGrid; const JSONFile: string);
var
  JSONText: string;
  JSONObject: TJSONObject;
  ColumnsArray: TJSONArray;
  i: Integer;
begin
  if not FileExists(JSONFile) then Exit;

  JSONText := TFile.ReadAllText(JSONFile);
  JSONObject := TJSONObject.ParseJSONValue(JSONText) as TJSONObject;
  try
    ColumnsArray := JSONObject.GetValue<TJSONArray>('columns');
    Grid.Columns.Clear;

    for i := 0 to ColumnsArray.Count - 1 do
    begin
      var ColDef := ColumnsArray.Items[i] as TJSONObject;
      with Grid.Columns.Add do
      begin
        FieldName := ColDef.GetValue<string>('field');
        Title.Caption := ColDef.GetValue<string>('title');
        Width := ColDef.GetValue<Integer>('width');
      end;
    end;
  finally
    JSONObject.Free;
  end;
end;

procedure TfrmUOMManager.btnAddClick(Sender: TObject);
begin
  qryUOM.Append;
  if TfrmUOMEditDialog.Execute(qryUOM, dsUQC) then
    qryUOM.Post
  else
    qryUOM.Cancel;
end;

procedure TfrmUOMManager.btnEditClick(Sender: TObject);
begin
  if not qryUOM.Active or qryUOM.IsEmpty then Exit;
  qryUOM.Edit;
  if TfrmUOMEditDialog.Execute(qryUOM, dsUQC) then
    qryUOM.Post
  else
    qryUOM.Cancel;
end;

procedure TfrmUOMManager.btnDeleteClick(Sender: TObject);
begin
  if not qryUOM.Active or qryUOM.IsEmpty then Exit;
  if MessageDlg('Delete selected UOM?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    qryUOM.Delete;
end;

procedure TfrmUOMManager.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
