unit uUOMEditDialog;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Data.DB, FireDAC.Comp.Client, System.JSON, System.IOUtils, Vcl.Controls,
  Vcl.Mask;

type
  TfrmUOMEditDialog = class(TForm)
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  public
    class function Execute(DataSet: TFDQuery; LookupSource: TDataSource): Boolean;
  end;

implementation

{$R *.dfm}

procedure TfrmUOMEditDialog.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmUOMEditDialog.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

class function TfrmUOMEditDialog.Execute(DataSet: TFDQuery; LookupSource: TDataSource): Boolean;
var
  dlg: TfrmUOMEditDialog;
  scroll: TScrollBox;
  panelButtons: TPanel;
  ds: TDataSource;
  topOffset: Integer;
  JSONText: string;
  JSONObject: TJSONObject;
  FieldsArray, ButtonsArray: TJSONArray;
  i: Integer;
begin
  dlg := TfrmUOMEditDialog.Create(nil);
  try
    dlg.Caption := 'Edit UOM';
    dlg.Width := 420;
    dlg.Height := 360;
    dlg.Position := poScreenCenter;

    ds := TDataSource.Create(dlg);
    ds.DataSet := DataSet;

    // ScrollBox for fields
    scroll := TScrollBox.Create(dlg);
    scroll.Parent := dlg;
    scroll.Align := alClient;
    scroll.BorderStyle := bsNone;
    scroll.VertScrollBar.Visible := True;

    JSONText := TFile.ReadAllText('configs\UOM.json');
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

    // Button panel docked at bottom
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
      if BtnDef.GetValue<string>('modalResult') = 'mrOk' then
        btn.ModalResult := mrOk
      else
        btn.ModalResult := mrCancel;
    end;

    Result := dlg.ShowModal = mrOk;
  finally
    dlg.Free;
  end;
end;

end.
