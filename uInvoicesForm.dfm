object frmInvoices: TfrmInvoices
  Left = 0
  Top = 0
  Caption = 'Invoices'
  ClientHeight = 480
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 50
    Align = alTop
    TabOrder = 0
    OnDblClick = btnEditClick
    object DBNavigator1: TDBNavigator
      Left = 260
      Top = 10
      Width = 240
      Height = 30
      TabOrder = 0
    end
    object btnAdd: TButton
      Left = 10
      Top = 10
      Width = 70
      Height = 30
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 90
      Top = 10
      Width = 70
      Height = 30
      Caption = 'Edit'
      TabOrder = 2
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 170
      Top = 10
      Width = 70
      Height = 30
      Caption = 'Delete'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
  end
  object grdInvoices: TDBGrid
    Left = 0
    Top = 50
    Width = 720
    Height = 430
    Align = alClient
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = btnEditClick
  end
end
