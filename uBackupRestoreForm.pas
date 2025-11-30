unit uBackupRestoreForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, FileCtrl, Vcl.Dialogs, Vcl.StdCtrls, System.IniFiles,
  uBackupManager;

type
  TfrmBackupRestore = class(TForm)
    edtBackupDir: TEdit;
    edtRestoreFile: TEdit;
    lblBackupDir: TLabel;
    lblRestoreFile: TLabel;
    btnBackup: TButton;
    btnRestore: TButton;
    btnBrowseBackup: TButton;
    btnBrowseRestore: TButton;
    dlgOpen: TOpenDialog;

    procedure FormCreate(Sender: TObject);
    procedure btnBrowseBackupClick(Sender: TObject);
    procedure btnBrowseRestoreClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
  private
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SaveLastBackupTimestamp;
  public

  end;

var
  frmBackupRestore: TfrmBackupRestore;

implementation

uses
  uDMmain, uMainForm;

{$R *.dfm}

procedure TfrmBackupRestore.FormCreate(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmBackupRestore.LoadSettings;
var
  Ini: TIniFile;
  IniPath: string;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'settings.ini';
  Ini := TIniFile.Create(IniPath);
  try
    edtBackupDir.Text := Ini.ReadString('Paths', 'BackupDir', '');
    edtRestoreFile.Text := Ini.ReadString('Paths', 'RestoreFile', '');
  finally
    Ini.Free;
  end;
end;

procedure TfrmBackupRestore.SaveSettings;
var
  Ini: TIniFile;
  IniPath: string;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'settings.ini';
  Ini := TIniFile.Create(IniPath);
  try
    Ini.WriteString('Paths', 'BackupDir', edtBackupDir.Text);
    Ini.WriteString('Paths', 'RestoreFile', edtRestoreFile.Text);
  finally
    Ini.Free;
  end;
end;

procedure TfrmBackupRestore.SaveLastBackupTimestamp;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'settings.ini');
  try
    Ini.WriteString('Status', 'LastBackup', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
  finally
    Ini.Free;
  end;
  frmMain.LoadLastBackupStatus;
end;


procedure TfrmBackupRestore.btnBrowseBackupClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtBackupDir.Text;
  if SelectDirectory('Select Backup Folder', '', Dir) then
    edtBackupDir.Text := Dir;
end;

procedure TfrmBackupRestore.btnBrowseRestoreClick(Sender: TObject);
begin
  dlgOpen.Filter := 'Firebird Backup (*.fbk)|*.fbk';
  if dlgOpen.Execute then
    edtRestoreFile.Text := dlgOpen.FileName;
end;

procedure TfrmBackupRestore.btnBackupClick(Sender: TObject);
var
  BM: TBackupManager;
begin
  BM := TBackupManager.Create(
    DMmain.FDConnectionmain.Params.Database,
    edtBackupDir.Text,
    'sysdba',
    'masterkey'
  );
  BM.RunBackup;
  SaveLastBackupTimestamp;
  SaveSettings;

end;

procedure TfrmBackupRestore.btnRestoreClick(Sender: TObject);
var
  BM: TBackupManager;
begin
  BM := TBackupManager.Create(
    DMmain.FDConnectionmain.Params.Database,
    edtBackupDir.Text,
    'sysdba',
    'masterkey'
  );
  BM.RunRestore(edtRestoreFile.Text);
  SaveSettings;
end;

end.