object frmTaxCalc: TfrmTaxCalc
  Left = 0
  Top = 0
  Caption = 'VAT Calculator'
  ClientHeight = 192
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 13
  object pnlValue: TPanel
    Left = 10
    Top = 10
    Width = 280
    Height = 40
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 49
      Height = 13
      Caption = 'Net Value'
    end
    object edValue: TEdit
      Left = 100
      Top = 8
      Width = 150
      Height = 21
      TabOrder = 0
      OnChange = edValueChange
    end
  end
  object pnlVatAmount: TPanel
    Left = 310
    Top = 10
    Width = 280
    Height = 40
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 12
      Width = 29
      Height = 13
      Caption = 'VAT %'
    end
    object edVat: TEdit
      Left = 100
      Top = 8
      Width = 150
      Height = 21
      TabOrder = 0
      OnChange = edValueChange
    end
  end
  object btnCalculate: TButton
    Left = 250
    Top = 60
    Width = 100
    Height = 30
    Caption = 'Calculate'
    TabOrder = 2
    OnClick = btnCalculateClick
  end
  object ledVat: TLabeledEdit
    Left = 10
    Top = 110
    Width = 200
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'VAT Amount'
    TabOrder = 3
    Text = ''
  end
  object ledGross: TLabeledEdit
    Left = 220
    Top = 110
    Width = 200
    Height = 21
    EditLabel.Width = 73
    EditLabel.Height = 13
    EditLabel.Caption = 'Gross Amount'
    TabOrder = 4
    Text = ''
  end
  object ledNet: TLabeledEdit
    Left = 430
    Top = 110
    Width = 150
    Height = 21
    EditLabel.Width = 77
    EditLabel.Height = 13
    EditLabel.Caption = 'Net from Gross'
    TabOrder = 5
    Text = ''
  end
  object ledVatFromGross: TLabeledEdit
    Left = 10
    Top = 160
    Width = 200
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = 'VAT from Gross'
    TabOrder = 6
    Text = ''
  end
  object ledNetFromVat: TLabeledEdit
    Left = 220
    Top = 160
    Width = 200
    Height = 21
    EditLabel.Width = 65
    EditLabel.Height = 13
    EditLabel.Caption = 'Net from VAT'
    TabOrder = 7
    Text = ''
  end
  object ledGrossFromVat: TLabeledEdit
    Left = 430
    Top = 160
    Width = 150
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = 'Gross from VAT'
    TabOrder = 8
    Text = ''
  end
end
