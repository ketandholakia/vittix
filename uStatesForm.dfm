object frmStates: TfrmStates
  Left = 0
  Top = 0
  Caption = 'State Manager'
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
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 50
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 185
    object btnAdd: TButton
      Left = 20
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 110
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 200
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object grdStates: TDBGrid
    Left = 0
    Top = 50
    Width = 600
    Height = 350
    Align = alClient
    DataSource = dsStates
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dsStates: TDataSource
    DataSet = qryStates
    Left = 20
    Top = 360
  end
  object qryStates: TFDQuery
    Connection = DMmain.FDConnectionmain
    Left = 120
    Top = 360
  end
end
