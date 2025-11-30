program dfLogin;

uses
  Vcl.Forms,
  System.SysUtils,
  System.UITypes,
  Vcl.Dialogs,
  uDMmain in 'uDMmain.pas' {DMmain: TDataModule},
  uLoginForm in 'uLoginForm.pas' {frmLogin},
  uMainForm in 'uMainForm.pas' {frmMain},
  uUsersForm in 'uUsersForm.pas' {frmUsers},
  uCompaniesForm in 'uCompaniesForm.pas' {frmCompanies},
  uStatesForm in 'uStatesForm.pas' {frmStates},
  uProductsForm in 'uProductsForm.pas' {frmProducts},
  uCustomersForm in 'uCustomersForm.pas' {frmCustomers},
  uInvoicesForm in 'uInvoicesForm.pas' {frmInvoices},
  uTransporterEditDialog in 'uTransporterEditDialog.pas' {FrmTransporterEditDialog},
  uStateEditDialog in 'uStateEditDialog.pas' {FrmStateEditDialog},
  uUOMEditDialog in 'uUOMEditDialog.pas' {frmUOMEditDialog},
  uCustomerEditDialog in 'uCustomerEditDialog.pas' {frmCustomerEdit},
  uShortcutEditDialog in 'uShortcutEditDialog.pas' {frmShortcutEditDialog},
  uInvoiceEditForm in 'uInvoiceEditForm.pas' {frmInvoiceEdit},
  uUOMManager in 'uUOMManager.pas' {frmUOMManager},
  uTransportersForm in 'uTransportersForm.pas' {frmTransporters},
  uBackupRestoreForm in 'uBackupRestoreForm.pas' {frmBackupRestore},
  uShortcutEditorForm in 'uShortcutEditorForm.pas' {frmuShortcutEditor},
  uBackupManager in 'uBackupManager.pas',
  uAuthManager in 'uAuthManager.pas',
  uPermissionMatrix in 'uPermissionMatrix.pas',
  uRoleManager in 'uRoleManager.pas',
  uIDValidators in 'uIDValidators.pas',
  uStateUtils in 'uStateUtils.pas',
  uINRtoWords in 'uINRtoWords.pas',
  uShortcutManager in 'uShortcutManager.pas',
  uShortcutCaptureEdit in 'uShortcutCaptureEdit.pas',
  uShortcutEditLink in 'uShortcutEditLink.pas',
  uShortcutTypes in 'uShortcutTypes.pas' {frmShortcutTypes},
  uTaxCalcForm in 'uTaxCalcForm.pas' {frmTaxCalc},
  uCompanyConfigForm in 'uCompanyConfigForm.pas' {frmCompanyConfig},
  uInvoiceUtils in 'uInvoiceUtils.pas',
  uInvoiceTypeSelectForm in 'uInvoiceTypeSelectForm.pas' {frmInvoiceTypeSelect};

{$R *.res}

var
  role: string;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  try
    Application.CreateForm(TDMmain, DMmain);
  if not DMmain.FDConnectionMain.Connected then
    begin
      MessageDlg('Database connection failed. Please check your settings.', mtError, [mbOK], 0);
      Application.Terminate;
      Exit;
    end;

    Application.CreateForm(TfrmLogin, frmLogin);

    if frmLogin.ShowModal = mrOk then
    begin
      role := frmLogin.UserRole;
      frmLogin.Free;

      Application.CreateForm(TfrmMain, frmMain);
      frmMain.Initialize(role);

      // Optional: preload config form for admin role
      if SameText(role, 'admin') then

      Application.Run;
    end
    else
    begin
      frmLogin.Free;
      Application.Terminate;
    end;

  except
    on E: Exception do
    begin
      MessageDlg('Fatal error: ' + E.Message, mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;
end.
