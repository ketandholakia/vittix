unit uInvoiceTypeSelectForm;

interface

uses
  System.JSON, System.IOUtils,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, Vcl.Grids,
  Vcl.DBGrids, RzPanel, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfrmInvoiceTypeSelect = class(TForm)
    FDQueryInvoiceTypes: TFDQuery;
    dsInvoiceTypes: TDataSource;
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    RzPanel1: TRzPanel;
    grdInvoiceTypes: TDBGrid;

    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure grdInvoiceTypesDblClick(Sender: TObject);
    procedure ConfigureGridFromJSON(const JSONText: string);
    procedure FormShow(Sender: TObject);
  private
   FSelectedInvoiceTypeID: Integer;
  FSelectedPrefix: string;
  FSelectedSuffix: string;

  public
  property SelectedInvoiceTypeID: Integer read FSelectedInvoiceTypeID;
  property SelectedPrefix: string read FSelectedPrefix;
  property SelectedSuffix: string read FSelectedSuffix;

  end;

var
  frmInvoiceTypeSelect: TfrmInvoiceTypeSelect;

implementation

{$R *.dfm}

uses uDMmain;

procedure TfrmInvoiceTypeSelect.FormCreate(Sender: TObject);
var
  JSONText: string;
  ConfigPath: string;
  RootObj: TJSONObject;
  FormObj: TJSONObject;
begin
  FDQueryInvoiceTypes := TFDQuery.Create(Self);
  FDQueryInvoiceTypes.Connection := DMmain.FDConnectionMain;
  FDQueryInvoiceTypes.SQL.Text := 'SELECT * FROM INVOICETYPE ORDER BY Description';
  FDQueryInvoiceTypes.Open;

  dsInvoiceTypes := TDataSource.Create(Self);
  dsInvoiceTypes.DataSet := FDQueryInvoiceTypes;
  grdInvoiceTypes.DataSource := dsInvoiceTypes;

  // Load grid and form config
  ConfigPath := ExtractFilePath(Application.ExeName) + 'configs\InvoiceTypeGridConfig.json';
  if TFile.Exists(ConfigPath) then
  begin
    JSONText := TFile.ReadAllText(ConfigPath, TEncoding.UTF8);
    RootObj := TJSONObject.ParseJSONValue(JSONText) as TJSONObject;

    if Assigned(RootObj) then
    begin
      // Apply form size
      FormObj := RootObj.Values['form'] as TJSONObject;
      if Assigned(FormObj) then
      begin
        Width := StrToIntDef(FormObj.Values['width'].Value, 600);
        Height := StrToIntDef(FormObj.Values['height'].Value, 400);
      end;

      // Configure grid
      if RootObj.Values['columns'] <> nil then
        ConfigureGridFromJSON(RootObj.Values['columns'].ToJSON);
    end;
  end;

  Position := poScreenCenter;
  BorderStyle := bsDialog;
  grdInvoiceTypes.OnDblClick := grdInvoiceTypesDblClick;
end;

procedure TfrmInvoiceTypeSelect.FormShow(Sender: TObject);
begin
   grdInvoiceTypes.SetFocus;

end;

procedure TfrmInvoiceTypeSelect.btnOKClick(Sender: TObject);
begin
  if not FDQueryInvoiceTypes.IsEmpty then
  begin
    FSelectedInvoiceTypeID := FDQueryInvoiceTypes.FieldByName('InvoiceTypeID').AsInteger;
    FSelectedPrefix := FDQueryInvoiceTypes.FieldByName('SeriesPrefix').AsString;
    FSelectedSuffix := FDQueryInvoiceTypes.FieldByName('SeriesSuffix').AsString;
    ModalResult := mrOk;

  end
  else
    ModalResult := mrCancel;
end;

procedure TfrmInvoiceTypeSelect.grdInvoiceTypesDblClick(Sender: TObject);
begin
  btnOKClick(Sender);
end;

procedure TfrmInvoiceTypeSelect.ConfigureGridFromJSON(const JSONText: string);
var
  JSONArray: TJSONArray;
  Obj: TJSONObject;
  i: Integer;
  Value: TJSONValue;
begin
  JSONArray := TJSONObject.ParseJSONValue(JSONText) as TJSONArray;
  if not Assigned(JSONArray) then
    raise Exception.Create('Invalid JSON format in grid config.');

  grdInvoiceTypes.Columns.Clear;

  for i := 0 to JSONArray.Count - 1 do
  begin
    Obj := JSONArray.Items[i] as TJSONObject;
    Value := Obj.Values['visible'];
    if Assigned(Value) and SameText(Value.Value, 'true') then
    begin
      with grdInvoiceTypes.Columns.Add do
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

end.
