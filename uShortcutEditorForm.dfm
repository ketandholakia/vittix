object frmuShortcutEditor: TfrmuShortcutEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Shortcut Manager'
  ClientHeight = 439
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 379
    Width = 592
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 481
    object btnApply: TButton
      Left = 389
      Top = 14
      Width = 80
      Height = 30
      Caption = 'Apply'
      TabOrder = 0
      OnClick = btnApplyClick
    end
    object btnClose: TButton
      Left = 489
      Top = 14
      Width = 80
      Height = 30
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object vstActions: TVirtualStringTree
    Left = 16
    Top = 40
    Width = 553
    Height = 338
    DefaultNodeHeight = 19
    Header.AutoSizeIndex = 0
    Header.Height = 15
    Header.MainColumn = -1
    TabOrder = 0
    OnDblClick = vstActionsDblClick
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <>
  end
  object btnShortKey: TButton
    Left = 18
    Top = 398
    Width = 103
    Height = 25
    Caption = 'Print Shortkey'
    TabOrder = 2
    OnClick = btnShortKeyClick
  end
end
