object FrmTransporterEditDialog: TFrmTransporterEditDialog
  Left = 0
  Top = 0
  Caption = 'Edit Transporter'
  ClientHeight = 400
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
  object pnlButtons: TPanel
    Left = 0
    Top = 350
    Width = 400
    Height = 50
    Align = alBottom
    TabOrder = 0
    object btnOK: TButton
      Left = 200
      Top = 10
      Width = 80
      Height = 30
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 290
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object dsDialog: TDataSource
    Left = 132
    Top = 120
  end
end
