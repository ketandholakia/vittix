object frmRolesPermissions: TfrmRolesPermissions
  Left = 0
  Top = 0
  Caption = 'Manage Roles and Permissions'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 41
    Align = alTop
    Caption = 'Role Permission Management'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 200
    Height = 359
    Align = alLeft
    Caption = 'Roles'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      200
      359)
    object lblRoles: TLabel
      Left = 8
      Top = 8
      Width = 31
      Height = 15
      Caption = 'Roles:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lstRoles: TListBox
      Left = 8
      Top = 29
      Width = 185
      Height = 320
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 15
      TabOrder = 0
      OnClick = lstRolesClick
    end
  end
  object Panel3: TPanel
    Left = 200
    Top = 41
    Width = 400
    Height = 359
    Align = alClient
    Caption = 'Permissions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    DesignSize = (
      400
      359)
    object lblPermissions: TLabel
      Left = 8
      Top = 8
      Width = 66
      Height = 15
      Caption = 'Permissions:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object chkListPermissions: TCheckListBox
      Left = 8
      Top = 29
      Width = 385
      Height = 280
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 15
      TabOrder = 0
      OnClick = chkListPermissionsClick
    end
    object btnSave: TButton
      Left = 259
      Top = 318
      Width = 131
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = 'Save Permissions'
      TabOrder = 1
      OnClick = btnSaveClick
    end
  end
  object qryRoles: TFDQuery
    Active = True
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'SELECT ROLE_ID, ROLE_NAME FROM ROLES ORDER BY ROLE_NAME')
    Left = 56
    Top = 48
  end
  object qryPermissions: TFDQuery
    Active = True
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      
        'SELECT PERMISSION_ID, PERMISSION_NAME, DESCRIPTION FROM PERMISSI' +
        'ONS ORDER BY PERMISSION_NAME')
    Left = 56
    Top = 88
  end
end
