unit uDMmain;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  Data.DB, Vcl.Dialogs, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDMmain = class(TDataModule)
    FDConnectionmain: TFDConnection;
    dsCustomers: TDataSource;
    dsTransporters: TDataSource;
    dsGSTSlabs: TDataSource;
    FDCustomers: TFDQuery;
    FDQueryCompanies: TFDQuery;
    dsCompanies: TDataSource;
    FDCompanyList: TFDQuery;
    dsCompanyList: TDataSource;
    FDInvoiceType: TFDQuery;
    dsInvoiceTypes: TDataSource;
    FDTransport: TFDQuery;

    procedure DataModuleCreate(Sender: TObject);


  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  DMmain: TDMmain;

implementation

uses
  uBackupManager, Windows;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

constructor TDMmain.Create(AOwner: TComponent);
begin
  inherited;
end;


procedure TDMmain.DataModuleCreate(Sender: TObject);
var
  Ini: TIniFile;
  IniPath: string;
  Server, DBPath, User, Password, Port, Charset: string;
begin
  IniPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini');

  if not FileExists(IniPath) then
  begin
    ShowMessage('Missing settings.ini. Database connection cannot be initialized.');
    Exit;
  end;

  Ini := TIniFile.Create(IniPath);
  try
    Server   := Ini.ReadString('Database', 'Server', 'localhost');
    DBPath   := Ini.ReadString('Database', 'Database', '');
    User     := Ini.ReadString('Database', 'User', '');
    Password := Ini.ReadString('Database', 'Password', '');
    Port     := Ini.ReadString('Database', 'Port', '3050');
    Charset  := Ini.ReadString('Database', 'Charset', 'UTF8');

    if DBPath = '' then
    begin
      ShowMessage('Database path missing in settings.ini.');
      Exit;
    end;

    if User = '' then
    begin
      ShowMessage('User name missing in settings.ini.');
      Exit;
    end;

    FDConnectionmain.Params.Clear;
    FDConnectionmain.Params.Values['DriverID']    := 'FB';
    FDConnectionmain.Params.Values['Server']      := Server;
    FDConnectionmain.Params.Values['Database']    := DBPath;
    FDConnectionmain.Params.Values['User_Name']   := User;
    FDConnectionmain.Params.Values['Password']    := Password;
    FDConnectionmain.Params.Values['Port']        := Port;
    FDConnectionmain.Params.Values['CharacterSet']:= Charset;
    FDConnectionmain.LoginPrompt := False;

    try
      FDConnectionmain.Connected := True;
      OutputDebugString(PChar('Connected to DB: ' + DBPath + ' on ' + Server + ' as ' + User));


      FDCustomers := TFDQuery.Create(Self);
      FDCustomers.Connection := FDConnectionmain;
      FDCustomers.SQL.Text := 'SELECT * FROM CUSTOMERS ORDER BY NAME';
      FDCustomers.Open;
      dsCustomers.DataSet := FDCustomers;

      FDQueryCompanies := TFDQuery.Create(Self);
      FDQueryCompanies.Connection := FDConnectionmain;
      FDQueryCompanies.SQL.Text := 'SELECT * FROM COMPANIES ORDER BY COMPANY_ID';
      FDQueryCompanies.Open;
      dsCompanies := TDataSource.Create(Self);
      dsCompanies.DataSet := FDQueryCompanies;


FDCompanyList := TFDQuery.Create(Self);
FDCompanyList.Connection := FDConnectionmain;
FDCompanyList.SQL.Text := 'SELECT COMPANY_ID, NAME FROM COMPANIES ORDER BY NAME';
FDCompanyList.Open;
dsCompanyList := TDataSource.Create(Self);
dsCompanyList.DataSet := FDCompanyList;

FDInvoiceType := TFDQuery.Create(Self);
FDInvoiceType.Connection := FDConnectionmain;
FDInvoiceType.SQL.Text := 'SELECT * FROM INVOICETYPE ORDER BY Description';
FDInvoiceType.Open;

FDTransport := TFDQuery.Create(Self);
FDTransport.Connection := FDConnectionmain;
FDTransport.SQL.Text := 'SELECT * FROM TRANSPORTER ORDER BY NAME';
FDTransport.Open;
dsTransporters.DataSet := FDTransport;



dsInvoiceTypes := TDataSource.Create(Self);
dsInvoiceTypes.DataSet := FDInvoiceType;




    except
      on E: Exception do
        ShowMessage('Database connection failed: ' + E.Message);
    end;
  finally
    Ini.Free;
  end;
end;




end.
