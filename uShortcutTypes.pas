unit uShortcutTypes;

interface

type
  PActionData = ^TActionData;
  TActionData = record
    Name: string;
    Caption: string;
    Shortcut: string;
  end;

implementation

end.
