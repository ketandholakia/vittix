object frmCompanies: TfrmCompanies
  Left = 0
  Top = 0
  Caption = 'Companies Management'
  ClientHeight = 500
  ClientWidth = 800
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object btnRefresh: TButton
      Left = 20
      Top = 17
      Width = 80
      Height = 30
      Caption = '&Refresh'
      TabOrder = 0
      OnClick = btnRefreshClick
    end
    object btnAdd: TButton
      Left = 120
      Top = 17
      Width = 80
      Height = 30
      Caption = '&Add New'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 220
      Top = 17
      Width = 80
      Height = 30
      Caption = '&Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnSave: TButton
      Left = 320
      Top = 17
      Width = 80
      Height = 30
      Caption = '&Save'
      TabOrder = 3
      OnClick = btnSaveClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 60
    Width = 800
    Height = 440
    Align = alClient
    DataSource = dsCompanies
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dsCompanies: TDataSource
    DataSet = qryCompanies
    Left = 632
    Top = 16
  end
  object qryCompanies: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'SELECT * FROM COMPANIES;')
    Left = 680
    Top = 16
    object qryCompaniesCOMPANY_ID: TIntegerField
      FieldName = 'COMPANY_ID'
      Origin = 'COMPANY_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryCompaniesNAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Required = True
      Size = 255
    end
    object qryCompaniesADDRESS: TWideStringField
      FieldName = 'ADDRESS'
      Origin = 'ADDRESS'
      Required = True
      Size = 255
    end
    object qryCompaniesCITY: TWideStringField
      FieldName = 'CITY'
      Origin = 'CITY'
      Required = True
      Size = 100
    end
    object qryCompaniesSTATE_ID: TIntegerField
      FieldName = 'STATE_ID'
      Origin = 'STATE_ID'
    end
    object qryCompaniesPINCODE: TWideStringField
      FieldName = 'PINCODE'
      Origin = 'PINCODE'
      Size = 10
    end
    object qryCompaniesGSTIN: TWideStringField
      FieldName = 'GSTIN'
      Origin = 'GSTIN'
      Size = 15
    end
    object qryCompaniesPAN: TWideStringField
      FieldName = 'PAN'
      Origin = 'PAN'
      Size = 10
    end
    object qryCompaniesPHONE: TWideStringField
      FieldName = 'PHONE'
      Origin = 'PHONE'
    end
    object qryCompaniesEMAIL: TWideStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 100
    end
  end
end
