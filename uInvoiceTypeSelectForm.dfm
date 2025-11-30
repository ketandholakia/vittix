object frmInvoiceTypeSelect: TfrmInvoiceTypeSelect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Invoice Type'
  ClientHeight = 270
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 229
    Width = 264
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 48
    ExplicitTop = 136
    ExplicitWidth = 185
    object btnCancel: TButton
      Left = 45
      Top = 7
      Width = 71
      Height = 24
      Caption = 'Cancel'
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 140
      Top = 7
      Width = 81
      Height = 24
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 264
    Height = 229
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 38
    ExplicitTop = 182
    ExplicitWidth = 185
    ExplicitHeight = 41
    object grdInvoiceTypes: TDBGrid
      Left = 2
      Top = 2
      Width = 260
      Height = 225
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object FDQueryInvoiceTypes: TFDQuery
    Left = 176
    Top = 72
  end
  object dsInvoiceTypes: TDataSource
    DataSet = FDQueryInvoiceTypes
    Left = 80
    Top = 56
  end
end
