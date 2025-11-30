unit uBackupManager;

interface

uses
  System.SysUtils, ShellAPI, Winapi.Windows;

type
  TBackupManager = class
  private
    FDBPath: string;
    FBackupDir: string;
    FUsername: string;
    FPassword: string;
    procedure Log(const Msg: string);
    function TimestampedBackupName: string;
  public
    constructor Create(const ADBPath, ABackupDir, AUsername, APassword: string);
    procedure RunBackup;
    procedure RunRestore(const BackupFilePath: string);
  end;

implementation

uses
  Vcl.Dialogs;

{ TBackupManager }

constructor TBackupManager.Create(const ADBPath, ABackupDir, AUsername, APassword: string);
begin
  FDBPath := ADBPath;
  FBackupDir := IncludeTrailingPathDelimiter(ABackupDir);
  FUsername := AUsername;
  FPassword := APassword;
end;

procedure TBackupManager.Log(const Msg: string);
begin
  OutputDebugString(PChar('[BackupManager] ' + Msg));
end;

function TBackupManager.TimestampedBackupName: string;
begin
  Result := FBackupDir + 'backup_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.fbk';
end;

procedure TBackupManager.RunBackup;
var
  GbakPath, BackupPath, Cmd: string;
begin
  if not DirectoryExists(FBackupDir) then
    CreateDir(FBackupDir);

  GbakPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'gbak.exe';
  BackupPath := TimestampedBackupName;

  Cmd := Format('"%s" -b -user %s -pass %s "%s" "%s"',
    [GbakPath, FUsername, FPassword, FDBPath, BackupPath]);

  Log('Executing backup: ' + Cmd);
  ShowMessage('Running backup command:' + sLineBreak + Cmd);

  if ShellExecute(0, nil, 'cmd.exe', PChar('/C "' + Cmd + '"'), nil, SW_SHOW) <= 32 then
    ShowMessage('Backup failed to start.')
  else
    ShowMessage('Backup started. File: ' + BackupPath);
end;

procedure TBackupManager.RunRestore(const BackupFilePath: string);
var
  GbakPath, Cmd: string;
begin
  GbakPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'gbak.exe';

  Cmd := Format('"%s" -c -user %s -pass %s "%s" "%s"',
    [GbakPath, FUsername, FPassword, BackupFilePath, FDBPath]);

  Log('Executing restore: ' + Cmd);
  ShowMessage('Running restore command:' + sLineBreak + Cmd);

  if ShellExecute(0, nil, 'cmd.exe', PChar('/C "' + Cmd + '"'), nil, SW_SHOW) <= 32 then
    ShowMessage('Restore failed to start.')
  else
    ShowMessage('Restore started. Target DB: ' + FDBPath);
end;

end.
