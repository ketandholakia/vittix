unit uStateEditDialog;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.DBCtrls, Vcl.Dialogs, System.JSON, System.IOUtils;

type
  TFrmStateEditDialog = class(TForm)
    pnlMain: TPanel;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    dsDialog: TDataSource;

    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FDataSet: TDataSet;
    procedure ValidateInputs;
    procedure BuildFormFromJSON(const ConfigPath: string);
  public
    class function Execute(DataSet: TDataSet; const ConfigPath: string): Boolean;
  end;

implementation

{$R *.dfm}

type
  TFieldConfig = record
    Field: string;
    LabelText: string;
    Width: Integer;
    ReadOnly: Boolean;
    Visible: Boolean;
    Required: Boolean;
  end;

  TFieldConfigList = TArray<TFieldConfig>;

function LoadDialogConfig(const FileName: string; out FieldConfigs: TFieldConfigList; out FormConfig: TJSONObject): Boolean;
var
  RootObj: TJSONObject;
  JSONArr: TJSONArray;
  i: Integer;
  JObj: TJSONObject;
begin
  Result := False;
  RootObj := TJSONObject.ParseJSONValue(TFile.ReadAllText(FileName)) as TJSONObject;
  if not Assigned(RootObj) then Exit;

  FormConfig := RootObj.GetValue<TJSONObject>('form');

  JSONArr := RootObj.GetValue<TJSONArray>('fields');
  if not Assigned(JSONArr) then Exit;

  SetLength(FieldConfigs, JSONArr.Count);
  for i := 0 to JSONArr.Count - 1 do
  begin
    JObj := JSONArr.Items[i] as TJSONObject;
    with FieldConfigs[i] do
    begin
      Field := JObj.GetValue('field').Value;
      LabelText := JObj.GetValue('label').Value;
      Width := StrToIntDef(JObj.GetValue('width').Value, 150);
      ReadOnly := JObj.TryGetValue('readonly', ReadOnly) and ReadOnly;
      Visible := not (JObj.TryGetValue('visible', Visible) and (not Visible));
      Required := JObj.TryGetValue('required', Required) and Required;
    end;
  end;

  Result := True;
end;


class function TFrmStateEditDialog.Execute(DataSet: TDataSet; const ConfigPath: string): Boolean;
var
  Dlg: TFrmStateEditDialog;
begin
  Result := False;
  Dlg := TFrmStateEditDialog.Create(Application);
  try
    Dlg.FDataSet := DataSet;
    Dlg.dsDialog.DataSet := DataSet;
    Dlg.BuildFormFromJSON(ConfigPath);
    Result := Dlg.ShowModal = mrOK;
  finally
    Dlg.Free;
  end;
end;

procedure TFrmStateEditDialog.BuildFormFromJSON(const ConfigPath: string);
var
  FieldConfigs: TFieldConfigList;
  FormConfig: TJSONObject;
  i, TopOffset: Integer;
  Lbl: TLabel;
  Edit: TDBEdit;
  PosStr: string;
  W, H: Integer;
begin
  if not LoadDialogConfig(ConfigPath, FieldConfigs, FormConfig) then
    raise Exception.Create('Invalid JSON format in dialog config.');

  // Apply form size and position
  if Assigned(FormConfig) then
  begin
    if FormConfig.TryGetValue<Integer>('width', W) then
      Self.Width := W;
    if FormConfig.TryGetValue<Integer>('height', H) then
      Self.Height := H;
    if FormConfig.TryGetValue<string>('position', PosStr) then
    begin
      if PosStr = 'poScreenCenter' then
        Self.Position := poScreenCenter
      else if PosStr = 'poMainFormCenter' then
        Self.Position := poMainFormCenter
      else if PosStr = 'poDesktopCenter' then
        Self.Position := poDesktopCenter;
    end;
  end;

  // Build fields
  TopOffset := 20;
  for i := 0 to High(FieldConfigs) do
  begin
    if not FieldConfigs[i].Visible then Continue;

    Lbl := TLabel.Create(Self);
    Lbl.Parent := pnlMain;
    Lbl.Left := 20;
    Lbl.Top := TopOffset;
    Lbl.Caption := FieldConfigs[i].LabelText;

    Edit := TDBEdit.Create(Self);
    Edit.Parent := pnlMain;
    Edit.Left := 120;
    Edit.Top := TopOffset - 4;
    Edit.Width := FieldConfigs[i].Width;
    Edit.DataSource := dsDialog;
    Edit.DataField := FieldConfigs[i].Field;
    Edit.ReadOnly := FieldConfigs[i].ReadOnly;
    Edit.Tag := Ord(FieldConfigs[i].Required);

    TopOffset := TopOffset + 30;
  end;
end;
procedure TFrmStateEditDialog.FormShow(Sender: TObject);
begin
  if FDataSet.State = dsInsert then
    Caption := 'Add New State'
  else
    Caption := 'Edit State';
end;

procedure TFrmStateEditDialog.btnOKClick(Sender: TObject);
begin
  try
    ValidateInputs;
    ModalResult := mrOK;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFrmStateEditDialog.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmStateEditDialog.ValidateInputs;
var
  i: Integer;
begin
  for i := 0 to pnlMain.ControlCount - 1 do
  begin
    if pnlMain.Controls[i] is TDBEdit then
    begin
      with TDBEdit(pnlMain.Controls[i]) do
      begin
        if (Tag = 1) and (Trim(Text) = '') then
          raise Exception.Create('Field "' + DataField + '" is required.');
      end;
    end;
  end;
end;

end.
