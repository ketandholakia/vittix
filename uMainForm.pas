unit uMainForm;

interface
uses
uRolesPermissionsForm, DateUtils, Vcl.Forms, Vcl.StdCtrls, vcl.Dialogs, uShortcutManager, uPermissionMatrix, System.Classes, Vcl.Controls,
VCL.Graphics,  Winapi.Windows, Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
system.IniFiles,  Vcl.ActnMan, Vcl.Menus, SysUtils, Vcl.ComCtrls, uBackupManager,
  RzStatus, RzPanel, System.ImageList, Vcl.ImgList, FireDAC.Comp.Client;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    ActionManager1: TActionManager;
    actUsersForm: TAction;
    actUsersForm1: TMenuItem;
    actCompaniesForm: TAction;
    actCompaniesForm1: TMenuItem;
    actUsersForm2: TMenuItem;
    actStateMaster: TAction;
    StateMaster1: TMenuItem;
    actbackup: TAction;
    ools1: TMenuItem;
    BackupDatabase1: TMenuItem;
    actBackupRestore: TAction;
    actBackupRestore1: TMenuItem;
    actUOMForm: TAction;
    Masters1: TMenuItem;
    UOM1: TMenuItem;
    actTransportersform: TAction;
    ransporters1: TMenuItem;
    actProductForm: TAction;
    actProductForm1: TMenuItem;
    ActCustomersForm: TAction;
    Customers1: TMenuItem;
    RzStatusBar1: TRzStatusBar;
    RzStatusPanehostname: TRzStatusPane;
    RzStatusPaneDatabase: TRzStatusPane;
    RzStatusPaneUserName: TRzStatusPane;
    RzStatusPaneRole: TRzStatusPane;
    RzStatusPanePort: TRzStatusPane;
    RzStatusPanebackupstatus: TRzStatusPane;
    actShortKeyManager: TAction;
    ShortKeyManager1: TMenuItem;
    ActionList1: TActionList;
    ActInvoices: TAction;
    actTaxCalc: TAction;
    act_company_config: TAction;
    RzStatusPane1: TRzStatusPane;
    actn_Role_Permission: TAction;
    procedure FormShow(Sender: TObject);
    procedure actUsersFormExecute(Sender: TObject);
    procedure actCompaniesFormExecute(Sender: TObject);
    procedure actStateMasterExecute(Sender: TObject);
    procedure actbackupExecute(Sender: TObject);
    procedure actBackupRestoreExecute(Sender: TObject);
    procedure actUOMFormExecute(Sender: TObject);
    procedure actTransportersformExecute(Sender: TObject);
    procedure actProductFormExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActCustomersFormExecute(Sender: TObject);
    procedure actShortKeyManagerExecute(Sender: TObject);
    procedure ActInvoicesExecute(Sender: TObject);
    procedure actTaxCalcExecute(Sender: TObject);
    procedure act_company_configExecute(Sender: TObject);
    procedure actn_Role_PermissionExecute(Sender: TObject);
    procedure RzStatusPaneRoleDblClick(Sender: TObject);
  private
    FUserRole: string;
    ShortcutMgr: TShortcutManager;
    procedure ApplyPermissions;
    procedure UpdateConnectionStatus;
    procedure UpdateUserCount;




  public
    property UserRole: string write FUserRole;
    procedure Initialize(const ARole: string);
    procedure LoadLastBackupStatus;

  end;

var
  frmMain: TfrmMain;
implementation
uses uUsersForm,  uDMmain, uCompaniesForm, uStatesForm, uBackupRestoreForm, uUOMManager,
  uTransportersForm, uProductsForm, uCustomersForm, uShortcutEditorForm,
  uInvoicesForm, uTaxCalcForm, uCompanyConfigForm, uAuthManager;
{$R *.dfm}


procedure TfrmMain.UpdateUserCount;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DMmain.FDConnectionMain;
    Q.SQL.Text := 'SELECT COUNT(*) FROM MON$ATTACHMENTS WHERE MON$REMOTE_ADDRESS IS NOT NULL';
    Q.Open;
    RzStatusPane1.Caption := 'Connected Users: ' + Q.Fields[0].AsString;

  finally
    Q.Free;
  end;
end;




procedure TfrmMain.Initialize(const ARole: string);
begin
  if ARole = '' then
  begin
    ShowMessage('User role not assigned. Initialization aborted.');
    Exit;
  end;

  FUserRole := ARole;
  ApplyPermissions;
  UpdateConnectionStatus;
end;



procedure TfrmMain.UpdateConnectionStatus;
var
  Server, Database, UserName, Port: string;
begin
  if Assigned(DMmain) and Assigned(DMmain.FDConnectionmain) then
  begin
    if DMmain.FDConnectionmain.Connected then
    begin
      Server   := DMmain.FDConnectionmain.Params.Values['Server'];
      Database := DMmain.FDConnectionmain.Params.Values['Database'];
      UserName := DMmain.FDConnectionmain.Params.Values['User_Name'];
      Port     := DMmain.FDConnectionmain.Params.Values['Port'];

      RzStatusPanehostname.Caption := 'Host: ' + Server;
      RzStatusPaneDatabase.Caption := 'Database: ' + Database;
      RzStatusPaneUserName.Caption := 'User: ' + UserName;
      RzStatusPaneRole.Caption := 'Role: ' + FUserRole;
      RzStatusPanePort.Caption := 'Port: ' + Port;


    end
    else
     RzStatusPanehostname.Caption := 'Database not connected';
  end
  else
    RzStatusPanehostname.Caption :=  'Connection object missing';
end;


procedure TfrmMain.LoadLastBackupStatus;
var
  ini: TIniFile;
  iniPath, lastBackupStr: string;
  lastBackupDT: TDateTime;
  daysDiff: Integer;
  FS: TFormatSettings;
begin
  iniPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'settings.ini';
  ini := TIniFile.Create(iniPath);
  try
    lastBackupStr := ini.ReadString('Status', 'LastBackup', 'Not available');
    RzStatusPanebackupstatus.Caption := 'Last Backup: ' + lastBackupStr;

    FS := TFormatSettings.Create;
    FS.DateSeparator := '-';
    FS.TimeSeparator := ':';
    FS.ShortDateFormat := 'yyyy-mm-dd';
    FS.LongTimeFormat := 'hh:nn:ss';

    if TryStrToDateTime(lastBackupStr, lastBackupDT, FS) then
    begin
      daysDiff := DaysBetween(Now, lastBackupDT);

      case daysDiff of
        0..2:
          begin
            RzStatusPanebackupstatus.Font.Color := clGreen;
            RzStatusPanebackupstatus.Blinking := False;
            RzStatusPanebackupstatus.ShowHint := False;
          end;
        3..5:
          begin
            RzStatusPanebackupstatus.Font.Color := clOlive;
            RzStatusPanebackupstatus.Blinking := False;
            RzStatusPanebackupstatus.ShowHint := False;
          end;
        else
          begin
            RzStatusPanebackupstatus.Font.Color := clRed;
            RzStatusPanebackupstatus.Blinking := True;
//            RzStatusPanebackupstatus.BlinkInterval := 500;
            RzStatusPanebackupstatus.Hint := 'Take backup now';
            RzStatusPanebackupstatus.ShowHint := True;
          end;
      end;
    end
    else
    begin
      RzStatusPanebackupstatus.Font.Color := clGray;
      RzStatusPanebackupstatus.Caption := 'Last Backup: Invalid date';
      RzStatusPanebackupstatus.Blinking := False;
      RzStatusPanebackupstatus.ShowHint := False;
    end;
  finally
    ini.Free;
  end;
end;





procedure TfrmMain.RzStatusPaneRoleDblClick(Sender: TObject);
begin
if Assigned(frmMain) then
begin
    // Call the event handler procedure directly on the form instance
    frmMain.actn_Role_PermissionExecute(frmMain.actn_Role_Permission);
end;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LoadLastBackupStatus;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  // Initialization of ShortcutMgr occurs only once,
  // when the form is first shown, guaranteeing ActionManager1 is created.
  if not Assigned(ShortcutMgr) then
  begin
    ShortcutMgr := TShortcutManager.Create(ActionManager1, 'shortcuts.json');
    ShortcutMgr.LoadShortcuts;
  end;
  ApplyPermissions;
  UpdateConnectionStatus;
  UpdateUserCount;
end;

procedure TfrmMain.actbackupExecute(Sender: TObject);
var
  BackupMgr: TBackupManager;
begin
  BackupMgr := TBackupManager.Create(
    DMmain.FDConnectionmain.Params.Database,
    ExtractFilePath(ParamStr(0)) + 'backups',
    'sysdba',
    'masterkey'
  );
  BackupMgr.RunBackup;

end;

procedure TfrmMain.actBackupRestoreExecute(Sender: TObject);
begin
  if not Assigned(frmBackupRestore) then
    frmBackupRestore := TfrmBackupRestore.Create(Self);
  frmBackupRestore.Show;

end;

procedure TfrmMain.actCompaniesFormExecute(Sender: TObject);
begin
  if not Assigned(frmCompanies) then
    frmCompanies := TfrmCompanies.Create(Self); // or Application if you prefer

  frmCompanies.Show; // or ShowModal if you want modal behavior

end;

procedure TfrmMain.ActCustomersFormExecute(Sender: TObject);
begin
  if not Assigned(frmCustomers) then
    frmCustomers := TfrmCustomers.Create(Self); // or Application if you prefer

  frmCustomers.Show; // or ShowModal if you want modal behavior

end;

procedure TfrmMain.ActInvoicesExecute(Sender: TObject);
begin
  if not Assigned(frmInvoices) then
    frmInvoices := TfrmInvoices.Create(Self); // or Application if you prefer

  frmInvoices.Show; // or ShowModal if you want modal behavior


end;

procedure TfrmMain.act_company_configExecute(Sender: TObject);
begin
  if not Assigned(frmCompanyConfig) then
    frmCompanyConfig := TfrmCompanyConfig.Create(Self); // or Application if you prefer

  frmCompanyConfig.Show; // or ShowModal if you want modal behavior

end;

procedure TfrmMain.actn_Role_PermissionExecute(Sender: TObject);
begin
// 1. Create the form instance if it doesn't exist
  if not Assigned(frmRolesPermissions) then
    frmRolesPermissions := TfrmRolesPermissions.Create(Application);
  // 2. Display the form modally
  frmRolesPermissions.ShowModal;
  // After the user closes the permission manager, re-apply permissions
  // in case their own role's permissions were changed (usually rare, but safe).
  ApplyPermissions;
end;

procedure TfrmMain.actProductFormExecute(Sender: TObject);
begin
  if not Assigned(frmProducts) then
    frmProducts := TfrmProducts.Create(Self); // or Application if you prefer

  frmProducts.Show; // or ShowModal if you want modal behavior

end;

procedure TfrmMain.actShortKeyManagerExecute(Sender: TObject);
var
  ShortcutEditor: TfrmuShortcutEditor;
begin
  ShortcutEditor := TfrmuShortcutEditor.CreateEditor(Self, ShortcutMgr);
  try
    ShortcutEditor.ShowModal;
  finally
    ShortcutEditor.Free;
  end;
end;


procedure TfrmMain.actStateMasterExecute(Sender: TObject);
begin
  if not Assigned(frmStates) then
    frmStates := TfrmStates.Create(Self); // or Application if you prefer

  frmStates.Show; // or ShowModal if you want modal behavior

end;

procedure TfrmMain.actTaxCalcExecute(Sender: TObject);
begin
  if not Assigned(frmTaxCalc) then
    frmTaxCalc := TfrmTaxCalc.Create(Self);
  frmTaxCalc.Show;

end;

procedure TfrmMain.actTransportersformExecute(Sender: TObject);
begin
  if not Assigned(frmTransporters) then
    frmTransporters := TfrmTransporters.Create(Self);
  frmTransporters.Show;


end;

procedure TfrmMain.actUOMFormExecute(Sender: TObject);
begin
  if not Assigned(frmUOMManager) then
    frmUOMManager := TfrmUOMManager.Create(Self);
  frmUOMManager.Show;

end;

procedure TfrmMain.actUsersFormExecute(Sender: TObject);
begin
  if not Assigned(frmUsers) then
    frmUsers := TfrmUsers.Create(Self); // or Application if you prefer

  frmUsers.Show; // or ShowModal if you want modal behavior


end;

Procedure TfrmMain.ApplyPermissions;
begin
  // --- Master Data Permissions ---
  // Check if the role has permission to manage users
  actUsersForm.Enabled := HasPermission('manage_users');
  // Check if the role has permission to manage companies
  actCompaniesForm.Enabled := HasPermission('manage_companies');
  // Check if the role has permission to manage customers
  ActCustomersForm.Enabled := HasPermission('manage_customers');
  // Check if the role has permission to manage products
  actProductForm.Enabled := HasPermission('manage_products');
  // Check if the role has permission to manage UOM (Units of Measure)
  actUOMForm.Enabled := HasPermission('manage_uom');
  // Check if the role has permission to manage Transporters
  actTransportersform.Enabled := HasPermission('manage_transporters');
  // Check if the role has permission to manage States (location masters)
  actStateMaster.Enabled := HasPermission('manage_states');
  // --- Transaction Permissions ---
  // Check if the role has permission to create/view invoices
  ActInvoices.Enabled := HasPermission('access_invoicing');
  // --- Configuration/System Permissions ---
  // Check if the role has permission to access the tax calculator
  actTaxCalc.Enabled := HasPermission('access_tax_calc');
  // Check if the role has permission to manage general company settings
  act_company_config.Enabled := HasPermission('manage_config');
  // Check if the role has permission to manage backups
  actbackup.Enabled := HasPermission('manage_backup');
  actBackupRestore.Enabled := HasPermission('manage_backup');
  // Check if the role has permission to modify the permission matrix (ADMIN ONLY)
  actn_Role_Permission.Enabled := HasPermission('manage_permissions');
  // Check if the role has permission to manage application shortcuts
  actShortKeyManager.Enabled := HasPermission('manage_shortcuts');
  // Update status bar to reflect the role
  RzStatusPaneRole.Caption := 'Role: ' + FUserRole;
end;

end.
