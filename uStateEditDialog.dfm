object FrmStateEditDialog: TFrmStateEditDialog
  Left = 0
  Top = 0
  Caption = 'Edit State'
  ClientHeight = 220
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 160
    Align = alTop
    TabOrder = 0
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 160
    Width = 400
    Height = 60
    Align = alBottom
    TabOrder = 1
    object btnOK: TButton
      Left = 200
      Top = 15
      Width = 80
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 290
      Top = 15
      Width = 80
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object dsDialog: TDataSource
    Left = 20
    Top = 180
  end
end
