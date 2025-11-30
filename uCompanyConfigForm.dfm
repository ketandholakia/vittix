object frmCompanyConfig: TfrmCompanyConfig
  Left = 0
  Top = 0
  Caption = 'frmCompanyConfig'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Company: TLabel
    Left = 17
    Top = 34
    Width = 52
    Height = 15
    Caption = 'Company'
  end
  object Label1: TLabel
    Left = 18
    Top = 79
    Width = 70
    Height = 15
    Caption = 'Invoice Prefix'
  end
  object Label2: TLabel
    Left = 21
    Top = 122
    Width = 70
    Height = 15
    Caption = 'Invoice Suffix'
  end
  object lblPreview: TLabel
    Left = 21
    Top = 160
    Width = 44
    Height = 15
    Caption = 'Preview:'
  end
  object DBEdit1: TDBEdit
    Left = 96
    Top = 80
    Width = 121
    Height = 23
    DataField = 'DEFAULT_INVOICE_PREFIX'
    DataSource = DSCompany
    TabOrder = 0
    OnChange = DBEdit1Change
  end
  object DBEdit2: TDBEdit
    Left = 96
    Top = 120
    Width = 121
    Height = 23
    DataField = 'DEFAULT_INVOICE_SUFFIX'
    DataSource = DSCompany
    TabOrder = 1
    OnChange = DBEdit2Change
  end
  object btnOK: TButton
    Left = 496
    Top = 392
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object DBLookupComboBox1: TDBLookupComboBox
    Left = 96
    Top = 32
    Width = 145
    Height = 23
    KeyField = 'COMPANY_ID'
    ListField = 'NAME'
    ListSource = DMmain.dsCompanyList
    TabOrder = 3
    OnCloseUp = DBLookupComboBox1CloseUp
  end
  object FDCompany: TFDQuery
    Connection = DMmain.FDConnectionmain
    Left = 416
    Top = 128
  end
  object DSCompany: TDataSource
    DataSet = FDCompany
    Left = 408
    Top = 232
  end
end
