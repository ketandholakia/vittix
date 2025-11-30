unit uShortcutCaptureEdit;

interface

uses
  Vcl.StdCtrls, Winapi.Windows, System.Classes, Vcl.Controls, System.SysUtils;

type
  TShortcutCaptureEdit = class(TEdit)
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  end;

implementation

uses Vcl.Menus;

procedure TShortcutCaptureEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Convert key + shift state to shortcut text
  Text := ShortCutToText(ShortCut(Key, Shift));

  // Prevent typing actual characters
  Key := 0;
end;

end.
