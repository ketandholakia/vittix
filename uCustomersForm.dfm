object frmCustomers: TfrmCustomers
  Left = 0
  Top = 0
  Caption = 'Customers'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnAdd: TButton
      Left = 10
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 95
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 180
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object grdCustomers: TDBGrid
    Left = 0
    Top = 40
    Width = 600
    Height = 360
    Align = alClient
    DataSource = dsCustomers
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    PopupMenu = PopupMenu1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = btnEditClick
  end
  object PopupMenu1: TPopupMenu
    Left = 456
    Top = 248
    object Add2: TMenuItem
      Caption = 'Add'
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
    end
    object delete: TMenuItem
      Caption = 'Delete'
    end
  end
  object qryCustomers: TFDQuery
    CachedUpdates = True
    Connection = DMmain.FDConnectionmain
    SQL.Strings = (
      '')
    Left = 168
    Top = 144
  end
  object dsCustomers: TDataSource
    DataSet = qryCustomers
    Left = 496
    Top = 120
  end
end
