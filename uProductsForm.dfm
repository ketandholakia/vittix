object frmProducts: TfrmProducts
  Left = 0
  Top = 0
  Caption = 'Product Management'
  ClientHeight = 500
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 180
    Align = alTop
    TabOrder = 0
    object lblName: TLabel
      Left = 16
      Top = 16
      Width = 67
      Height = 13
      Caption = 'Product Name'
    end
    object lblHSN: TLabel
      Left = 16
      Top = 48
      Width = 72
      Height = 13
      Caption = 'HSN/SAC Code'
    end
    object lblUnitPrice: TLabel
      Left = 260
      Top = 48
      Width = 45
      Height = 13
      Caption = 'Unit Price'
    end
    object lblGST: TLabel
      Left = 16
      Top = 80
      Width = 67
      Height = 13
      Caption = 'GST Rate (%)'
    end
    object lblStock: TLabel
      Left = 260
      Top = 80
      Width = 71
      Height = 13
      Caption = 'Stock Quantity'
    end
    object lblDescription: TLabel
      Left = 16
      Top = 112
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object edtName: TEdit
      Left = 140
      Top = 12
      Width = 300
      Height = 21
      TabOrder = 0
    end
    object edtHSN: TEdit
      Left = 140
      Top = 44
      Width = 100
      Height = 21
      TabOrder = 1
    end
    object edtUnitPrice: TEdit
      Left = 340
      Top = 44
      Width = 100
      Height = 21
      TabOrder = 2
    end
    object edtGST: TEdit
      Left = 140
      Top = 76
      Width = 100
      Height = 21
      TabOrder = 3
    end
    object edtStock: TEdit
      Left = 340
      Top = 76
      Width = 100
      Height = 21
      TabOrder = 4
    end
    object memDescription: TMemo
      Left = 140
      Top = 108
      Width = 300
      Height = 50
      TabOrder = 5
    end
    object btnAdd: TButton
      Left = 460
      Top = 12
      Width = 100
      Height = 25
      Caption = 'Add'
      TabOrder = 6
      OnClick = btnAddClick
    end
    object btnUpdate: TButton
      Left = 460
      Top = 44
      Width = 100
      Height = 25
      Caption = 'Update'
      TabOrder = 7
      OnClick = btnUpdateClick
    end
    object btnDelete: TButton
      Left = 460
      Top = 76
      Width = 100
      Height = 25
      Caption = 'Delete'
      TabOrder = 8
      OnClick = btnDeleteClick
    end
  end
  object dbgProducts: TDBGrid
    Left = 0
    Top = 180
    Width = 700
    Height = 320
    Align = alClient
    DataSource = dsProducts
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dsProducts: TDataSource
    DataSet = qryProducts
    Left = 16
    Top = 460
  end
  object qryProducts: TFDQuery
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      'Select * from PRODUCTS;')
    Left = 80
    Top = 460
    object qryProductsPRODUCT_ID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'PRODUCT_ID'
      Origin = 'PRODUCT_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryProductsNAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Required = True
      Size = 255
    end
    object qryProductsDESCRIPTION: TMemoField
      FieldName = 'DESCRIPTION'
      Origin = 'DESCRIPTION'
      BlobType = ftMemo
    end
    object qryProductsHSN_SAC_CODE: TWideStringField
      FieldName = 'HSN_SAC_CODE'
      Origin = 'HSN_SAC_CODE'
      Size = 10
    end
    object qryProductsUNIT_PRICE: TFMTBCDField
      FieldName = 'UNIT_PRICE'
      Origin = 'UNIT_PRICE'
      Required = True
      Precision = 18
      Size = 2
    end
    object qryProductsGST_RATE: TCurrencyField
      FieldName = 'GST_RATE'
      Origin = 'GST_RATE'
      Required = True
    end
    object qryProductsSTOCK_QUANTITY: TFMTBCDField
      FieldName = 'STOCK_QUANTITY'
      Origin = 'STOCK_QUANTITY'
      Precision = 18
      Size = 2
    end
  end
end
