object frmUsers: TfrmUsers
  Left = 0
  Top = 0
  Caption = 'frmUsers'
  ClientHeight = 324
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 283
    Width = 526
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnAdd: TButton
      Left = 100
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 181
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 262
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnSave: TButton
      Left = 343
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 3
      OnClick = btnSaveClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 283
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 350
      Height = 281
      Align = alClient
      Caption = 'Panel1'
      TabOrder = 0
      object grdUsers: TDBGrid
        Left = 1
        Top = 1
        Width = 348
        Height = 279
        Align = alClient
        DataSource = dsUsers
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = grdUsersCellClick
      end
    end
    object Panel4: TPanel
      Left = 351
      Top = 1
      Width = 174
      Height = 281
      Align = alRight
      TabOrder = 1
      object Label1: TLabel
        Left = 17
        Top = 33
        Width = 52
        Height = 13
        Caption = 'User Name'
      end
      object Label2: TLabel
        Left = 15
        Top = 89
        Width = 46
        Height = 13
        Caption = 'Password'
      end
      object Label3: TLabel
        Left = 15
        Top = 145
        Width = 21
        Height = 13
        Caption = 'Role'
      end
      object edtUsername: TEdit
        Left = 15
        Top = 53
        Width = 121
        Height = 21
        TabOrder = 0
        TextHint = 'User Name'
      end
      object cmbRole: TComboBox
        Left = 17
        Top = 164
        Width = 139
        Height = 21
        TabOrder = 1
        Text = 'cmbRole'
      end
      object chkActive: TCheckBox
        Left = 17
        Top = 202
        Width = 97
        Height = 17
        Caption = 'Active '
        TabOrder = 2
      end
      object edtPassword: TEdit
        Left = 15
        Top = 110
        Width = 141
        Height = 21
        TabOrder = 3
        TextHint = 'Password'
      end
    end
  end
  object dsUsers: TDataSource
    DataSet = qryUsers
    Left = 184
    Top = 168
  end
  object qryUsers: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'select * from USERS;')
    Left = 200
    Top = 80
  end
  object qryRoles: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'select * FROM ROLES;')
    Left = 72
    Top = 80
  end
end
