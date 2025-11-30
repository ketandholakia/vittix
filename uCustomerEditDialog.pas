unit uCustomerEditDialog;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Data.DB, FireDAC.Comp.Client, System.JSON, System.IOUtils,
  Vcl.Controls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.Dialogs, Generics.Collections, uIDValidators;

type
  TfrmCustomerEdit = class(TForm)
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    ValidatedEdits: TList<TDBEdit>;
    FLookupSource: TDataSource;
    procedure ValidateGSTIN(Sender: TObject);
    procedure ValidatePAN(Sender: TObject);
    procedure ValidateGSTINvsPAN(Sender: TObject);
    function IsFieldValid(edit: TDBEdit): Boolean;
  public
    class function Execute(DataSet: TFDQuery; LookupSource: TDataSource): Boolean;
  end;

implementation

{$R *.dfm}

procedure TfrmCustomerEdit.btnOKClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ValidatedEdits.Count - 1 do
  begin
    if not IsFieldValid(ValidatedEdits[i]) then
    begin
      ValidatedEdits[i].SetFocus;
      Exit; // block save
    end;
  end;
  ModalResult := mrOk;
end;

procedure TfrmCustomerEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfrmCustomerEdit.IsFieldValid(edit: TDBEdit): Boolean;
var
  fieldName: string;
  ds: TDataSet;
  stateID: Integer;
  stateName, gstin, pan: string;
begin
  Result := True;

  if not Assigned(edit) or not Assigned(edit.DataSource) or not Assigned(edit.DataSource.DataSet) then
    Exit(True); // allow save if control is unbound

  ds := edit.DataSource.DataSet;
  fieldName := edit.DataField;

  if SameText(fieldName, 'STATE_ID') then
  begin
    if ds.FieldByName('STATE_ID').IsNull then
    begin
      ShowMessage('State must be selected');
      Result := False;
      Exit;
    end;
  end
  else if SameText(fieldName, 'GSTIN') then
  begin
    gstin := string(edit.Text).Trim;
    if gstin <> '' then
    begin
      Result := IsValidGSTIN(gstin);
      if not Result then
      begin
        ShowMessage('Invalid GSTIN format');
        Exit;
      end;

      pan := string(ds.FieldByName('PAN').AsString).Trim;
      stateID := ds.FieldByName('STATE_ID').AsInteger;
      stateName := '';

      if Assigned(FLookupSource) and Assigned(FLookupSource.DataSet) then
      begin
        if FLookupSource.DataSet.Locate('STATE_ID', stateID, []) then
          stateName := string(FLookupSource.DataSet.FieldByName('STATE_NAME').AsString).Trim;
      end;

      if (pan <> '') and (stateName <> '') and
         (not IsGSTINMatchingPANAndState(gstin, pan, stateName)) then
      begin
        ShowMessage('GSTIN does not match PAN and State');
        Result := False;
      end;
    end;
  end
  else if SameText(fieldName, 'PAN') then
  begin
    pan := string(edit.Text).Trim;
    if pan <> '' then
    begin
      Result := IsValidPAN(pan);
      if not Result then
        ShowMessage('Invalid PAN format');
    end;
  end;
end;



procedure TfrmCustomerEdit.ValidateGSTIN(Sender: TObject);
begin
  var edit := Sender as TDBEdit;
  if not IsValidGSTIN(edit.Text) then
    ShowMessage('Invalid GSTIN format');
end;

procedure TfrmCustomerEdit.ValidatePAN(Sender: TObject);
begin
  var edit := Sender as TDBEdit;
  if not IsValidPAN(edit.Text) then
    ShowMessage('Invalid PAN format');
end;

procedure TfrmCustomerEdit.ValidateGSTINvsPAN(Sender: TObject);
begin
  var edit := Sender as TDBEdit;
  var ds := edit.DataSource.DataSet;
  var gstin := edit.Text;
  var pan := ds.FieldByName('PAN').AsString;
  var stateID := ds.FieldByName('STATE_ID').AsInteger;
  var stateName := '';

  if Assigned(FLookupSource) and Assigned(FLookupSource.DataSet) then
  begin
    if FLookupSource.DataSet.Locate('STATE_ID', stateID, []) then
      stateName := FLookupSource.DataSet.FieldByName('STATE_NAME').AsString;
  end;

  if not IsGSTINMatchingPANAndState(gstin, pan, stateName) then
    ShowMessage('GSTIN does not match PAN and State');
end;

class function TfrmCustomerEdit.Execute(DataSet: TFDQuery; LookupSource: TDataSource): Boolean;
var
  dlg: TfrmCustomerEdit;
  scroll: TScrollBox;
  panelButtons: TPanel;
  ds: TDataSource;
  topOffset: Integer;
  JSONText: string;
  JSONObject: TJSONObject;
  FieldsArray, ButtonsArray: TJSONArray;
  i: Integer;
begin
  dlg := TfrmCustomerEdit.Create(nil);
  try
    dlg.Caption := 'Edit Customer';
    dlg.Width := 420;
    dlg.Height := 360;
    dlg.Position := poScreenCenter;
    dlg.ValidatedEdits := TList<TDBEdit>.Create;
    dlg.FLookupSource := LookupSource;

    ds := TDataSource.Create(dlg);
    ds.DataSet := DataSet;

    scroll := TScrollBox.Create(dlg);
    scroll.Parent := dlg;
    scroll.Align := alClient;
    scroll.BorderStyle := bsNone;
    scroll.VertScrollBar.Visible := True;

    JSONText := TFile.ReadAllText('configs\CustomerDialogConfig.json');
    JSONObject := TJSONObject.ParseJSONValue(JSONText) as TJSONObject;
    FieldsArray := JSONObject.GetValue<TJSONArray>('fields');
    topOffset := 20;

    for i := 0 to FieldsArray.Count - 1 do
    begin
      var FieldDef := FieldsArray.Items[i] as TJSONObject;
      var ctrlType := FieldDef.GetValue<string>('type');
      var fieldName := FieldDef.GetValue<string>('field');

      if ctrlType <> 'DBCheckBox' then
      begin
        var lbl := TLabel.Create(scroll);
        lbl.Parent := scroll;
        lbl.Left := 20;
        lbl.Top := topOffset;
        lbl.Caption := FieldDef.GetValue<string>('label');
      end;

      if ctrlType = 'DBEdit' then
      begin
        var edit := TDBEdit.Create(scroll);
        edit.Parent := scroll;
        edit.Left := 120;
        edit.Top := topOffset - 4;
        edit.Width := FieldDef.GetValue<Integer>('width');
        edit.DataSource := ds;
        edit.DataField := fieldName;

        var validateType: string;
        if FieldDef.TryGetValue<string>('validate', validateType) then
        begin
          if SameText(validateType, 'GSTIN') then
            edit.OnExit := dlg.ValidateGSTIN
          else if SameText(validateType, 'PAN') then
            edit.OnExit := dlg.ValidatePAN;

          dlg.ValidatedEdits.Add(edit);
        end;

        var matchPANState := False;
        if FieldDef.TryGetValue<Boolean>('matchPANState', matchPANState) and matchPANState then
        begin
          edit.OnExit := dlg.ValidateGSTINvsPAN;
          if not dlg.ValidatedEdits.Contains(edit) then
            dlg.ValidatedEdits.Add(edit);
        end;
      end
      else if ctrlType = 'DBLookupComboBox' then
      begin
        var combo := TDBLookupComboBox.Create(scroll);
        combo.Parent := scroll;
        combo.Left := 120;
        combo.Top := topOffset - 4;
        combo.Width := FieldDef.GetValue<Integer>('width');
        combo.DataSource := ds;
        combo.DataField := fieldName;
        combo.ListSource := LookupSource;
        combo.ListField := FieldDef.GetValue<string>('listField');
        combo.KeyField := FieldDef.GetValue<string>('keyField');
      end
      else if ctrlType = 'DBCheckBox' then
      begin
        var chk := TDBCheckBox.Create(scroll);
        chk.Parent := scroll;
        chk.Left := 120;
        chk.Top := topOffset - 4;
        chk.Caption := FieldDef.GetValue<string>('label');
        chk.DataSource := ds;
        chk.DataField := fieldName;
      end;

      Inc(topOffset, 36);
    end;

    panelButtons := TPanel.Create(dlg);
    panelButtons.Parent := dlg;
    panelButtons.Align := alBottom;
    panelButtons.Height := 50;
    panelButtons.BevelOuter := bvNone;

    ButtonsArray := JSONObject.GetValue<TJSONArray>('buttons');
    var totalButtonWidth := ButtonsArray.Count * 85;
    var startLeft := (panelButtons.Width - totalButtonWidth) div 2;

    for i := 0 to ButtonsArray.Count - 1 do
    begin
      var BtnDef := ButtonsArray.Items[i] as TJSONObject;
      var btn := TButton.Create(panelButtons);
      btn.Parent := panelButtons;
      btn.Caption := BtnDef.GetValue<string>('caption');
      btn.Width := 75;
      btn.Height := 28;
      btn.Top := 10;
      btn.Left := startLeft + (i * 85);

      var modalResult := BtnDef.GetValue<string>('modalResult');
      if SameText(modalResult, 'mrOk') then
        btn.OnClick := dlg.btnOKClick
      else if SameText(modalResult, 'mrCancel') then
        btn.OnClick := dlg.btnCancelClick;
    end;

    Result := dlg.ShowModal = mrOk;
  finally
    dlg.ValidatedEdits.Free;
    dlg.Free;
  end;
end;

end.

