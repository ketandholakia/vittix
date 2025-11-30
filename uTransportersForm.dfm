object frmTransporters: TfrmTransporters
  Left = 0
  Top = 0
  Caption = 'Transporter Manager'
  ClientHeight = 385
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 50
    Width = 600
    Height = 335
    Align = alClient
    TabOrder = 0
    object dbgTransporters: TDBGrid
      Left = 0
      Top = 0
      Width = 320
      Height = 120
      Align = alClient
      DataSource = dsTransporters
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 50
    Align = alTop
    TabOrder = 1
    object btnAdd: TButton
      Left = 127
      Top = 11
      Width = 100
      Height = 30
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnUpdate: TButton
      Left = 237
      Top = 11
      Width = 100
      Height = 30
      Caption = 'Update'
      TabOrder = 1
      OnClick = btnUpdateClick
    end
    object btnDelete: TButton
      Left = 347
      Top = 11
      Width = 100
      Height = 30
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object dsTransporters: TDataSource
    DataSet = qryTransporters
    Left = 400
    Top = 300
  end
  object qryTransporters: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'Select * from TRANSPORTER')
    Left = 500
    Top = 300
    object qryTransportersTRANSPORTER_ID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'TRANSPORTER_ID'
      Origin = 'TRANSPORTER_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryTransportersNAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Required = True
      Size = 100
    end
    object qryTransportersADDRESS: TWideStringField
      FieldName = 'ADDRESS'
      Origin = 'ADDRESS'
      Size = 255
    end
    object qryTransportersCITY: TWideStringField
      FieldName = 'CITY'
      Origin = 'CITY'
      Size = 50
    end
    object qryTransportersSTATE: TWideStringField
      FieldName = 'STATE'
      Origin = 'STATE'
      Size = 50
    end
    object qryTransportersCOUNTRY: TWideStringField
      FieldName = 'COUNTRY'
      Origin = 'COUNTRY'
      Size = 50
    end
    object qryTransportersPIN_CODE: TWideStringField
      FieldName = 'PIN_CODE'
      Origin = 'PIN_CODE'
      Size = 10
    end
    object qryTransportersGSTIN: TWideStringField
      FieldName = 'GSTIN'
      Origin = 'GSTIN'
      Size = 15
    end
    object qryTransportersCONTACT_PERSON: TWideStringField
      FieldName = 'CONTACT_PERSON'
      Origin = 'CONTACT_PERSON'
      Size = 100
    end
    object qryTransportersPHONE: TWideStringField
      FieldName = 'PHONE'
      Origin = 'PHONE'
    end
    object qryTransportersEMAIL: TWideStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 100
    end
  end
end
