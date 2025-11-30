unit uCompaniesForm;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, Vcl.DBCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt;

type
  TfrmCompanies = class(TForm)
    pnlTop: TPanel;
    btnRefresh: TButton;
    btnAdd: TButton;
    btnDelete: TButton;
    btnSave: TButton;
    DBGrid1: TDBGrid;
    dsCompanies: TDataSource;
    qryCompanies: TFDQuery;
    qryCompaniesCOMPANY_ID: TIntegerField;
    qryCompaniesNAME: TWideStringField;
    qryCompaniesADDRESS: TWideStringField;
    qryCompaniesCITY: TWideStringField;
    qryCompaniesSTATE_ID: TIntegerField;
    qryCompaniesPINCODE: TWideStringField;
    qryCompaniesGSTIN: TWideStringField;
    qryCompaniesPAN: TWideStringField;
    qryCompaniesPHONE: TWideStringField;
    qryCompaniesEMAIL: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    procedure LoadCompanies;
  public
    { Public declarations }
  end;

var
  frmCompanies: TfrmCompanies;

implementation

uses uDMMain;

{$R *.dfm}

procedure TfrmCompanies.FormCreate(Sender: TObject);
begin
  qryCompanies.Connection := DMMain.FDConnectionMain;
  LoadCompanies;
end;

procedure TfrmCompanies.LoadCompanies;
begin
  qryCompanies.Close;
  qryCompanies.SQL.Text := 'SELECT * FROM COMPANIES ORDER BY COMPANY_ID';
  qryCompanies.Open;
end;

procedure TfrmCompanies.btnRefreshClick(Sender: TObject);
begin
  LoadCompanies;
end;

procedure TfrmCompanies.btnAddClick(Sender: TObject);
begin
  qryCompanies.Append;
end;

procedure TfrmCompanies.btnDeleteClick(Sender: TObject);
begin
  if not qryCompanies.IsEmpty then
    qryCompanies.Delete;
end;

procedure TfrmCompanies.btnSaveClick(Sender: TObject);
begin
  if qryCompanies.State in [dsEdit, dsInsert] then
    qryCompanies.Post;
end;

end.

