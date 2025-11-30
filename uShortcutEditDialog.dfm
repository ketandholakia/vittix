object frmShortcutEditDialog: TfrmShortcutEditDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit Shortcut'
  ClientHeight = 160
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object lblActionName: TLabel
    Left = 16
    Top = 16
    Width = 320
    Height = 17
    AutoSize = False
    Caption = 'Action:'
  end
  object lblCaption: TLabel
    Left = 16
    Top = 40
    Width = 320
    Height = 17
    AutoSize = False
    Caption = 'Caption:'
  end
  object lblShortcut: TLabel
    Left = 16
    Top = 72
    Width = 48
    Height = 15
    Caption = 'Shortcut:'
  end
  object edtShortcut: TEdit
    Left = 104
    Top = 70
    Width = 200
    Height = 23
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 184
    Top = 112
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 272
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
