unit uShortcutEditDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmShortcutEditDialog = class(TForm)
    lblActionName: TLabel;
    lblCaption: TLabel;
    lblShortcut: TLabel;
    edtShortcut: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    // New Declaration for Key Capture
    procedure edtShortcutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    class function Execute(const ActionName, Caption, CurrentShortcut: string; out NewShortcut: string): Boolean;
  end;

implementation

{$R *.dfm}

{ TfrmShortcutEditDialog }

// -----------------------------------------------------------------
// Key Capture Logic Implementation
// -----------------------------------------------------------------
procedure TfrmShortcutEditDialog.edtShortcutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ShortCutValue: TShortCut;
  S: String;
begin
  // 1. CLEAR COMMAND: Allow Delete or Escape to clear the shortcut
  if (Key = VK_DELETE) or (Key = VK_ESCAPE) then
  begin
    edtShortcut.Text := '';
    Key := 0; // Consume the key
    Exit;
  end;

  // 2. IGNORE MODIFIERS ALONE: Do not display text for Ctrl, Shift, or Alt pressed by themselves
  if (Key = VK_CONTROL) or (Key = VK_SHIFT) or (Key = VK_MENU) then
  begin
    Key := 0;
    Exit;
  end;

  // 3. COMBINE & CONVERT: Use Vcl.Menus to convert key press to TShortCut value
  // We explicitly qualify Vcl.Menus to avoid the E2003 error.
  ShortCutValue := Vcl.Menus.ShortCut(Key, Shift);
  S := Vcl.Menus.ShortCutToText(ShortCutValue);

  // 4. UPDATE UI
  (Sender as TEdit).Text := S;

  // 5. CONSUME KEY: Essential to prevent the TEdit from receiving the key as standard text input
  Key := 0;
end;


procedure TfrmShortcutEditDialog.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;


procedure TfrmShortcutEditDialog.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;


// -----------------------------------------------------------------
// Modified Execute Function
// -----------------------------------------------------------------
class function TfrmShortcutEditDialog.Execute(const ActionName, Caption, CurrentShortcut: string; out NewShortcut: string): Boolean;
var
  dlg: TfrmShortcutEditDialog;
begin
  dlg := TfrmShortcutEditDialog.Create(nil);
  try
    // Assign the new key capture event handler dynamically
    dlg.edtShortcut.OnKeyDown := dlg.edtShortcutKeyDown; // ASSIGNMENT HERE

    dlg.Caption := 'Edit Shortcut';
    dlg.lblActionName.Caption := 'Action: ' + ActionName;
    dlg.lblCaption.Caption := 'Caption: ' + Caption;
    dlg.edtShortcut.Text := CurrentShortcut;
    dlg.edtShortcut.SelectAll;

    Result := dlg.ShowModal = mrOK;
    if Result then
      NewShortcut := dlg.edtShortcut.Text;
  finally
    dlg.Free;
  end;
end;

end.
