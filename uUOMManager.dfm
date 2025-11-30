object frmUOMManager: TfrmUOMManager
  Left = 0
  Top = 0
  Caption = 'Unit of Measurement Manager'
  ClientHeight = 480
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 40
    Align = alTop
    TabOrder = 0
    object btnAdd: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 28
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 88
      Top = 6
      Width = 75
      Height = 28
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 168
      Top = 6
      Width = 75
      Height = 28
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object grdUOM: TDBGrid
    Left = 0
    Top = 40
    Width = 720
    Height = 440
    Align = alClient
    DataSource = dsUOM
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object qryUOM: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'SELECT * FROM UOM ORDER BY UOM_CODE')
    Left = 16
    Top = 100
    object qryUOMUOM_ID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'UOM_ID'
      Origin = 'UOM_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryUOMUOM_CODE: TWideStringField
      FieldName = 'UOM_CODE'
      Origin = 'UOM_CODE'
      Required = True
      Size = 10
    end
    object qryUOMUOM_NAME: TWideStringField
      FieldName = 'UOM_NAME'
      Origin = 'UOM_NAME'
      Required = True
      Size = 50
    end
    object qryUOMIS_ACTIVE: TBooleanField
      FieldName = 'IS_ACTIVE'
      Origin = 'IS_ACTIVE'
    end
    object qryUOMUQC_CODE: TWideStringField
      FieldName = 'UQC_CODE'
      Origin = 'UQC_CODE'
      Size = 3
    end
  end
  object qryUQC: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'SELECT UQC_CODE FROM UQC ORDER BY UQC_CODE')
    Left = 120
    Top = 100
  end
  object dsUOM: TDataSource
    DataSet = qryUOM
    Left = 112
    Top = 252
  end
  object dsUQC: TDataSource
    DataSet = qryUQC
    Left = 120
    Top = 140
  end
end
