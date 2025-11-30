object frmBackupRestore: TfrmBackupRestore
  Left = 200
  Top = 150
  Caption = 'Backup and Restore'
  ClientHeight = 211
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblBackupDir: TLabel
    Left = 16
    Top = 24
    Width = 67
    Height = 13
    Caption = 'Backup Folder'
  end
  object lblRestoreFile: TLabel
    Left = 16
    Top = 110
    Width = 87
    Height = 13
    Caption = 'Restore File (.fbk)'
  end
  object edtBackupDir: TEdit
    Left = 16
    Top = 40
    Width = 360
    Height = 21
    TabOrder = 0
  end
  object btnBrowseBackup: TButton
    Left = 390
    Top = 39
    Width = 75
    Height = 23
    Caption = 'Browse...'
    TabOrder = 1
    OnClick = btnBrowseBackupClick
  end
  object btnBackup: TButton
    Left = 16
    Top = 70
    Width = 100
    Height = 25
    Caption = 'Run Backup'
    TabOrder = 2
    OnClick = btnBackupClick
  end
  object edtRestoreFile: TEdit
    Left = 16
    Top = 126
    Width = 360
    Height = 21
    TabOrder = 3
  end
  object btnBrowseRestore: TButton
    Left = 390
    Top = 125
    Width = 75
    Height = 23
    Caption = 'Browse...'
    TabOrder = 4
    OnClick = btnBrowseRestoreClick
  end
  object btnRestore: TButton
    Left = 16
    Top = 156
    Width = 100
    Height = 25
    Caption = 'Run Restore'
    TabOrder = 5
    OnClick = btnRestoreClick
  end
  object dlgOpen: TOpenDialog
    Filter = 'Firebird Backup (*.fbk)|*.fbk'
    Left = 440
    Top = 10
  end
end
