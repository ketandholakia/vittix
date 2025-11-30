object frmInvoiceEdit: TfrmInvoiceEdit
  Left = 0
  Top = 0
  Caption = 'frmInvoiceEdit'
  ClientHeight = 546
  ClientWidth = 991
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lbldb_Invoice_No_display: TRzDBLabel
    Left = 288
    Top = 368
    Width = 65
    Height = 17
    DataField = 'INVOICE_NUMBER_DISPLAY'
    DataSource = dsInvoice
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 991
    Height = 153
    Align = alTop
    TabOrder = 0
    object pnl_invoice_detail: TPanel
      Left = 747
      Top = 1
      Width = 243
      Height = 151
      Align = alRight
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 241
        Height = 36
        Align = alTop
        TabOrder = 0
        object lbl_invoice_no: TLabel
          Left = 15
          Top = 11
          Width = 29
          Height = 15
          Caption = 'INV #'
        end
        object dbEdit_Invoice_No: TDBEdit
          Left = 57
          Top = 8
          Width = 121
          Height = 23
          DataField = 'INVOICE_NO'
          DataSource = dsInvoice
          TabOrder = 0
        end
        object chkManualInvoiceNo: TCheckBox
          Left = 187
          Top = 11
          Width = 97
          Height = 17
          Hint = 'Enable to set Invoice Number Manual'
          Caption = 'M'
          TabOrder = 1
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 37
        Width = 241
        Height = 36
        Align = alTop
        TabOrder = 1
        object lbl_invoice_date: TLabel
          Left = 15
          Top = 11
          Width = 46
          Height = 15
          Caption = 'INV Date'
        end
        object dbdateedit_invoice_date: TRzDBDateTimeEdit
          Left = 97
          Top = 7
          Width = 121
          Height = 23
          DataSource = dsInvoice
          DataField = 'INVOICE_DATE'
          TabOrder = 0
          EditType = etDate
        end
      end
      object Panel4: TPanel
        Left = 1
        Top = 109
        Width = 241
        Height = 36
        Align = alTop
        TabOrder = 2
        object Label1: TLabel
          Left = 15
          Top = 11
          Width = 43
          Height = 15
          Caption = 'PO Date'
        end
        object dbeditdate_PURCHASE_ORDER_DATE: TRzDBDateTimeEdit
          Left = 97
          Top = 7
          Width = 121
          Height = 23
          DataSource = dsInvoice
          DataField = 'PURCHASE_ORDER_DATE'
          TabOrder = 0
          EditType = etDate
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 73
        Width = 241
        Height = 36
        Align = alTop
        TabOrder = 3
        object Label2: TLabel
          Left = 15
          Top = 11
          Width = 26
          Height = 15
          Caption = 'PO #'
        end
        object DBEdit_PURCHASE_ORDER_REF: TDBEdit
          Left = 97
          Top = 8
          Width = 121
          Height = 23
          DataField = 'PURCHASE_ORDER_REF'
          DataSource = dsInvoice
          TabOrder = 0
        end
      end
    end
    object pnl_billing: TPanel
      Left = 353
      Top = 1
      Width = 352
      Height = 151
      Align = alLeft
      TabOrder = 1
      object dblookupcombo_INVOICETYPEID: TDBLookupComboBox
        Left = 112
        Top = 15
        Width = 225
        Height = 23
        DataField = 'INVOICETYPEID'
        DataSource = dsInvoice
        KeyField = 'INVOICETYPEID'
        ListField = 'DESCRIPTION'
        ListSource = DMmain.dsInvoiceTypes
        TabOrder = 0
      end
      object dblookupcombo_TRANSPORTER_ID: TDBLookupComboBox
        Left = 112
        Top = 59
        Width = 225
        Height = 23
        DataField = 'TRANSPORTER_ID'
        DataSource = dsInvoice
        KeyField = 'TRANSPORTER_ID'
        ListField = 'NAME'
        ListSource = DMmain.dsTransporters
        TabOrder = 1
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 352
      Height = 151
      Align = alLeft
      TabOrder = 2
      object dblookupcombo_CUSTOMER_ID: TDBLookupComboBox
        Left = 20
        Top = 14
        Width = 309
        Height = 23
        DataField = 'CUSTOMER_ID'
        DataSource = dsInvoice
        ListField = 'NAME'
        ListSource = DMmain.dsCustomers
        TabOrder = 0
        OnCloseUp = dblookupcombo_CUSTOMER_IDCloseUp
      end
    end
  end
  object btnOK: TButton
    Left = 872
    Top = 608
    Width = 75
    Height = 25
    Caption = 'btnOK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object RzSizePanel1: TRzSizePanel
    Left = 0
    Top = 377
    Width = 991
    Height = 169
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 480
    object RzPanel1: TRzPanel
      Left = 48
      Top = 27
      Width = 137
      Height = 41
      TabOrder = 0
      object Label3: TLabel
        Left = 10
        Top = 13
        Width = 47
        Height = 15
        Caption = 'Net Days'
      end
      object DBEdit_Netdays: TDBEdit
        Left = 63
        Top = 10
        Width = 57
        Height = 23
        TabOrder = 0
      end
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 153
    Width = 991
    Height = 224
    Align = alClient
    TabOrder = 3
    ExplicitLeft = 208
    ExplicitTop = 192
    ExplicitWidth = 185
    ExplicitHeight = 41
    object dbgridInvoiceItems: TDBGrid
      Left = 2
      Top = 2
      Width = 987
      Height = 220
      Align = alClient
      DataSource = dsInvoiceItems
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object dsInvoice: TDataSource
    DataSet = FDInvoice
    Left = 488
    Top = 280
  end
  object FDInvoiceDetail: TFDQuery
    Left = 240
    Top = 240
  end
  object dsInvoiceItems: TDataSource
    DataSet = FDInvoiceDetail
    Left = 744
    Top = 248
  end
  object FDInvoice: TFDQuery
    Left = 616
    Top = 216
  end
end
