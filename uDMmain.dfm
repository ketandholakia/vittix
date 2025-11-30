object DMmain: TDMmain
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 622
  Width = 1139
  object FDConnectionmain: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'Port=3050'
      'Database=D:\ketan\github\firebird-Invoice\VI.FDB'
      'DriverID=FB')
    Connected = True
    Left = 56
    Top = 8
  end
  object dsCustomers: TDataSource
    Left = 888
    Top = 32
  end
  object dsTransporters: TDataSource
    DataSet = FDTransport
    Left = 1056
    Top = 16
  end
  object dsGSTSlabs: TDataSource
    Left = 776
    Top = 24
  end
  object FDCustomers: TFDQuery
    Connection = FDConnectionmain
    SQL.Strings = (
      'Select * from CUSTOMERS')
    Left = 888
    Top = 96
  end
  object FDQueryCompanies: TFDQuery
    Connection = FDConnectionmain
    Left = 64
    Top = 392
  end
  object dsCompanies: TDataSource
    DataSet = FDQueryCompanies
    Left = 80
    Top = 464
  end
  object FDCompanyList: TFDQuery
    Connection = FDConnectionmain
    Left = 560
    Top = 312
  end
  object dsCompanyList: TDataSource
    DataSet = FDCompanyList
    Left = 560
    Top = 360
  end
  object FDInvoiceType: TFDQuery
    Connection = FDConnectionmain
    Left = 312
    Top = 384
  end
  object dsInvoiceTypes: TDataSource
    DataSet = FDInvoiceType
    Left = 304
    Top = 304
  end
  object FDTransport: TFDQuery
    Connection = FDConnectionmain
    Left = 1056
    Top = 88
  end
end
