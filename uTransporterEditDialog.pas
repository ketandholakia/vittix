unit uTransporterEditDialog;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB, System.JSON, System.IOUtils;

type
  TFieldConfig = record
    FieldName: string;
    LabelText: string;
    Width: Integer;
    MaxLength: Integer;
  end;

  TFieldConfigList = TArray<TFieldConfig>;

  TFrmTransporterEditDialog = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    dsDialog: TDataSource;

    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FDataSet: TDataSet;
    procedure BuildForm(const FieldList: TFieldConfigList);
    function LoadFieldConfigFromJSON(const FileName: string): TFieldConfigList;
  public
    class function Execute(DataSet: TDataSet; const ConfigPath: string): Boolean;
  end;

implementation

{$R *.dfm}

class function TFrmTransporterEditDialog.Execute(DataSet: TDataSet; const ConfigPath: string): Boolean;
var
  Dlg: TFrmTransporterEditDialog;
  FieldList: TFieldConfigList;
begin
  Result := False;
  Dlg := TFrmTransporterEditDialog.Create(Application);
  try
    Dlg.dsDialog.DataSet := DataSet;
    Dlg.FDataSet := DataSet;
    FieldList := Dlg.LoadFieldConfigFromJSON(ConfigPath);
    Dlg.BuildForm(FieldList);
    Result := Dlg.ShowModal = mrOK;
  finally
    Dlg.Free;
  end;
end;

procedure TFrmTransporterEditDialog.BuildForm(const FieldList: TFieldConfigList);
var
  i, TopOffset: Integer;
  lbl: TLabel;
  edt: TDBEdit;
begin
  TopOffset := 20;
  for i := 0 to High(FieldList) do
  begin
    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 20;
    lbl.Top := TopOffset;
    lbl.Caption := FieldList[i].LabelText + ':';

    edt := TDBEdit.Create(Self);
    edt.Parent := Self;
    edt.Left := 120;
    edt.Top := TopOffset;
    edt.Width := FieldList[i].Width;
    edt.DataSource := dsDialog;
    edt.DataField := FieldList[i].FieldName;
    edt.MaxLength := FieldList[i].MaxLength;
    edt.TabOrder := i;

    TopOffset := TopOffset + 30;
  end;
end;

function TFrmTransporterEditDialog.LoadFieldConfigFromJSON(const FileName: string): TFieldConfigList;
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
      LabelText := GetValue('label').Value;
      Width := StrToIntDef(GetValue('width').Value, 200);
      MaxLength := StrToIntDef(GetValue('maxlength').Value, 100);
    end;
  end;
end;

procedure TFrmTransporterEditDialog.FormShow(Sender: TObject);
begin
  if FDataSet.State = dsInsert then
    Caption := 'Add New Transporter'
  else
    Caption := 'Edit Transporter';
end;

procedure TFrmTransporterEditDialog.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFrmTransporterEditDialog.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.