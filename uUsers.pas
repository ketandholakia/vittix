unit uUsers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrmUsers = class(TForm)
    grdUsers: TDBGrid;
    edtUsername: TEdit;
    cmbRole: TComboBox;
    chkActive: TCheckBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnSave: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUsers: TfrmUsers;

implementation

{$R *.dfm}

end.
