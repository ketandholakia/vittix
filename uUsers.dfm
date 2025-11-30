object frmUsers: TfrmUsers
  Left = 0
  Top = 0
  Caption = 'frmUsers'
  ClientHeight = 324
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grdUsers: TDBGrid
    Left = 24
    Top = 128
    Width = 320
    Height = 120
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object edtUsername: TEdit
    Left = 72
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edtUsername'
  end
  object cmbRole: TComboBox
    Left = 72
    Top = 51
    Width = 145
    Height = 21
    TabOrder = 2
    Text = 'cmbRole'
  end
  object chkActive: TCheckBox
    Left = 72
    Top = 78
    Width = 97
    Height = 17
    Caption = 'chkActive'
    TabOrder = 3
  end
  object btnAdd: TButton
    Left = 24
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 4
  end
  object btnEdit: TButton
    Left = 105
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 5
  end
  object btnDelete: TButton
    Left = 186
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 6
  end
  object btnSave: TButton
    Left = 267
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 7
  end
end
