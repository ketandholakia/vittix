object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Vittix by Varni Infoweb'
  ClientHeight = 537
  ClientWidth = 1063
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 518
    Width = 1063
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 0
    object RzStatusPanehostname: TRzStatusPane
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 40
      Height = 13
      Align = alLeft
      AutoSize = True
      Caption = ''
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 19
    end
    object RzStatusPaneDatabase: TRzStatusPane
      AlignWithMargins = True
      Left = 49
      Top = 3
      Width = 40
      Height = 13
      Align = alLeft
      AutoSize = True
      Caption = ''
      ExplicitLeft = 40
      ExplicitTop = 0
      ExplicitHeight = 19
    end
    object RzStatusPaneUserName: TRzStatusPane
      AlignWithMargins = True
      Left = 95
      Top = 3
      Width = 40
      Height = 13
      Align = alLeft
      AutoSize = True
      Caption = ''
      ExplicitLeft = 80
      ExplicitTop = 0
      ExplicitHeight = 19
    end
    object RzStatusPaneRole: TRzStatusPane
      AlignWithMargins = True
      Left = 141
      Top = 3
      Width = 40
      Height = 13
      Align = alLeft
      OnDblClick = RzStatusPaneRoleDblClick
      AutoSize = True
      Caption = ''
      ExplicitLeft = 120
      ExplicitTop = 0
      ExplicitHeight = 19
    end
    object RzStatusPanePort: TRzStatusPane
      AlignWithMargins = True
      Left = 187
      Top = 3
      Width = 40
      Height = 13
      Align = alLeft
      AutoSize = True
      Caption = ''
      ExplicitLeft = 160
      ExplicitTop = 0
      ExplicitHeight = 19
    end
    object RzStatusPanebackupstatus: TRzStatusPane
      AlignWithMargins = True
      Left = 233
      Top = 3
      Width = 40
      Height = 13
      Align = alLeft
      OnDblClick = actBackupRestoreExecute
      AutoSize = True
      Caption = ''
      ExplicitLeft = 200
      ExplicitTop = 0
      ExplicitHeight = 19
    end
    object RzStatusPane1: TRzStatusPane
      Left = 276
      Top = 0
      Width = 40
      Height = 19
      Align = alLeft
      AutoSize = True
      Caption = ''
    end
  end
  object MainMenu1: TMainMenu
    Left = 704
    Top = 112
    object actUsersForm1: TMenuItem
      Caption = 'File'
      object actCompaniesForm1: TMenuItem
        Action = actCompaniesForm
      end
    end
    object Masters1: TMenuItem
      Caption = 'Masters'
      object actUsersForm2: TMenuItem
        Action = actUsersForm
      end
      object StateMaster1: TMenuItem
        Action = actStateMaster
      end
      object UOM1: TMenuItem
        Action = actUOMForm
      end
      object ransporters1: TMenuItem
        Action = actTransportersform
      end
      object actProductForm1: TMenuItem
        Action = actProductForm
      end
      object Customers1: TMenuItem
        Action = ActCustomersForm
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object BackupDatabase1: TMenuItem
        Action = actbackup
      end
      object actBackupRestore1: TMenuItem
        Action = actBackupRestore
        Caption = 'Backup and Restore'
      end
      object ShortKeyManager1: TMenuItem
        Action = actShortKeyManager
      end
    end
  end
  object ActionManager1: TActionManager
    Left = 312
    Top = 192
    StyleName = 'Platform Default'
    object actUsersForm: TAction
      Caption = 'Users'
      OnExecute = actUsersFormExecute
    end
    object actCompaniesForm: TAction
      Caption = 'Company'
      OnExecute = actCompaniesFormExecute
    end
    object actStateMaster: TAction
      Caption = 'States'
      OnExecute = actStateMasterExecute
    end
    object actbackup: TAction
      Caption = 'actbackup'
      OnExecute = actbackupExecute
    end
    object actBackupRestore: TAction
      Caption = 'Backup / Restore Database'
      OnExecute = actBackupRestoreExecute
    end
    object actUOMForm: TAction
      Caption = 'UOM'
      OnExecute = actUOMFormExecute
    end
    object actTransportersform: TAction
      Caption = 'Transporters'
      OnExecute = actTransportersformExecute
    end
    object actProductForm: TAction
      Caption = 'Products'
      OnExecute = actProductFormExecute
    end
    object ActCustomersForm: TAction
      Caption = 'Customers'
      OnExecute = ActCustomersFormExecute
    end
    object actShortKeyManager: TAction
      Caption = 'ShortKey Manager'
      OnExecute = actShortKeyManagerExecute
    end
    object ActInvoices: TAction
      Caption = 'Invoices'
      OnExecute = ActInvoicesExecute
    end
    object actTaxCalc: TAction
      Caption = 'Tax Calc'
      OnExecute = actTaxCalcExecute
    end
    object act_company_config: TAction
      Caption = 'Company Config'
      OnExecute = act_company_configExecute
    end
    object actn_Role_Permission: TAction
      Caption = 'actn_Role_Permission'
      OnExecute = actn_Role_PermissionExecute
    end
  end
  object ActionList1: TActionList
    Left = 528
    Top = 288
  end
end
