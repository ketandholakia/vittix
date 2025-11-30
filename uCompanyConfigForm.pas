unit uCompanyConfigForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.UITypes, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TfrmCompanyConfig = class(TForm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    btnOK: TButton;
    DBLookupComboBox1: TDBLookupComboBox;
    FDCompany: TFDQuery;
    DSCompany: TDataSource;
    Company: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblPreview: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DBLookupComboBox1CloseUp(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure DBEdit1Change(Sender: TObject);
    procedure DBEdit2Change(Sender: TObject);
  private
    procedure LoadCompany(const ACompanyID: Integer);
    procedure UpdatePreview;
    procedure DSCompanyDataChange(Sender: TObject; Field: TField);

  public
    { Public declarations }
  end;

var
  frmCompanyConfig: TfrmCompanyConfig;

implementation

uses uDMmain;

{$R *.dfm}

procedure TfrmCompanyConfig.DSCompanyDataChange(Sender: TObject; Field: TField);
begin
  UpdatePreview;
end;


procedure TfrmCompanyConfig.FormCreate(Sender: TObject);
begin
  DMmain.FDCompanyList.Close;
  DMmain.FDCompanyList.SQL.Text := 'SELECT COMPANY_ID, NAME FROM COMPANIES ORDER BY NAME';
  DMmain.FDCompanyList.Open;

  DBLookupComboBox1.ListSource := DMmain.dsCompanyList;
  DBLookupComboBox1.KeyField := 'COMPANY_ID';
  DBLookupComboBox1.ListField := 'NAME';

  DSCompany.OnDataChange := DSCompanyDataChange;


  lblPreview.Caption := 'Preview:';

  if not DMmain.FDCompanyList.IsEmpty then
    LoadCompany(DMmain.FDCompanyList.FieldByName('COMPANY_ID').AsInteger);
end;

procedure TfrmCompanyConfig.DBLookupComboBox1CloseUp(Sender: TObject);
begin
  if not VarIsNull(DBLookupComboBox1.KeyValue) then
    LoadCompany(DBLookupComboBox1.KeyValue);
end;

procedure TfrmCompanyConfig.LoadCompany(const ACompanyID: Integer);
begin
  FDCompany.Close;
  FDCompany.Connection := DMmain.FDConnectionmain;
  FDCompany.SQL.Text := 'SELECT * FROM COMPANIES WHERE COMPANY_ID = :ID';
  FDCompany.ParamByName('ID').AsInteger := ACompanyID;

  try
    FDCompany.Open;
  except
    on E: Exception do
    begin
      ShowMessage('Failed to load company: ' + E.Message);
      Exit;
    end;
  end;

  DSCompany.DataSet := FDCompany;

  DBEdit1.DataSource := DSCompany;
  DBEdit1.DataField := 'DEFAULT_INVOICE_PREFIX';

  DBEdit2.DataSource := DSCompany;
  DBEdit2.DataField := 'DEFAULT_INVOICE_SUFFIX';

  UpdatePreview;
end;

procedure TfrmCompanyConfig.UpdatePreview;
var
  Prefix, Suffix, FormattedNumber: string;
begin
  if FDCompany.Active and (FDCompany.FindField('DEFAULT_INVOICE_PREFIX') <> nil) then
  begin
    Prefix := FDCompany.FieldByName('DEFAULT_INVOICE_PREFIX').AsString;
    Suffix := FDCompany.FieldByName('DEFAULT_INVOICE_SUFFIX').AsString;
    FormattedNumber := Format('%.3d', [6]);  // Format separately
    lblPreview.Caption := 'Preview: ' + Prefix + FormattedNumber + Suffix;
  end
  else
    lblPreview.Caption := 'Preview:';
end;


procedure TfrmCompanyConfig.DBEdit1Change(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TfrmCompanyConfig.DBEdit2Change(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TfrmCompanyConfig.btnOKClick(Sender: TObject);
begin
  try
    if FDCompany.State in [dsEdit, dsInsert] then
      FDCompany.Post;


    ShowMessage('Company invoice settings saved successfully.');
    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      ShowMessage('Failed to save settings: ' + E.Message);
      ModalResult := mrNone;
    end;
  end;
end;

end.
