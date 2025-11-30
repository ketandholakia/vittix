unit uShortcutManager;

interface

uses
  System.Classes, Vcl.ActnMan, Vcl.ActnList, Vcl.Menus, System.SysUtils, System.JSON, System.IOUtils;

type
  TShortcutManager = class
  private
    FActionManager: TActionManager;
    FConfigPath: string;
  public
    constructor Create(AActionManager: TActionManager; const ConfigFile: string);
    procedure LoadShortcuts;
    procedure SaveShortcut(const ActionName, ShortcutText: string);
    procedure ApplyShortcut(const ActionName, ShortcutText: string);
    procedure SaveAllShortcuts;
    property ActionManager: TActionManager read FActionManager;
  end;

implementation

constructor TShortcutManager.Create(AActionManager: TActionManager; const ConfigFile: string);
begin
  FActionManager := AActionManager;
  FConfigPath := ConfigFile;
end;

procedure TShortcutManager.LoadShortcuts;
var
  JSONText: string;
  JSONObject: TJSONObject;
  i: Integer;
  ShortcutText: string;
  Pair: TJSONPair;
  ActionName: string; // To hold the name from JSON key
  FoundAction: TBasicAction; // To hold the found action
begin
  if not FileExists(FConfigPath) then Exit;

  JSONText := TFile.ReadAllText(FConfigPath, TEncoding.UTF8);

  // Use a try..except block for safer parsing
  try
    JSONObject := TJSONObject.ParseJSONValue(JSONText) as TJSONObject;
  except
    on E: Exception do
    begin
      // Log error or show a message for corrupt JSON file
      Exit;
    end;
  end;

  if not Assigned(JSONObject) then Exit;

  try
    // Iterate directly over the JSON pairs
    for Pair in JSONObject do
    begin
      // 1. Get Action Name (JSON key) and Shortcut Text (JSON value)
      ActionName := Pair.JSONString.Value;
      ShortcutText := Pair.JSONValue.Value;

      FoundAction := nil;

      // 2. SEARCH: Find the action in the ActionManager by iterating the Actions list
      for i := 0 to FActionManager.ActionCount - 1 do
      begin
        if SameText(FActionManager.Actions[i].Name, ActionName) then
        begin
          FoundAction := FActionManager.Actions[i];
          Break; // Stop searching once found
        end;
      end;

      // 3. APPLY: Apply the shortcut if the action was found and is a TCustomAction
      if Assigned(FoundAction) and (FoundAction is TCustomAction) then
      begin
        TCustomAction(FoundAction).ShortCut := TextToShortCut(ShortcutText);
      end;
    end;
  finally
    JSONObject.Free;
  end;
end;

procedure TShortcutManager.SaveShortcut(const ActionName, ShortcutText: string);
var
  JSONText: string;
  JSONObject: TJSONObject;
begin
  if FileExists(FConfigPath) then
    JSONText := TFile.ReadAllText(FConfigPath, TEncoding.UTF8)
  else
    JSONText := '{}';

  JSONObject := TJSONObject.ParseJSONValue(JSONText) as TJSONObject;
  if not Assigned(JSONObject) then
    JSONObject := TJSONObject.Create;

  try
    if JSONObject.Values[ActionName] <> nil then
      JSONObject.RemovePair(ActionName);

    JSONObject.AddPair(ActionName, ShortcutText);
    TFile.WriteAllText(FConfigPath, JSONObject.ToJSON, TEncoding.UTF8);
  finally
    JSONObject.Free;
  end;
end;

procedure TShortcutManager.SaveAllShortcuts;
var
  JSONObject: TJSONObject;
  i: Integer;
  Action: TBasicAction;
  CustomAction: TCustomAction; // Temporary variable for safe casting
begin
  JSONObject := TJSONObject.Create;
  try
    for i := 0 to FActionManager.ActionCount - 1 do
    begin
      Action := FActionManager.Actions[i];

      // 1. SAFELY CAST the TBasicAction to TCustomAction
      if Action is TCustomAction then
      begin
        CustomAction := TCustomAction(Action);

        // 2. Add only actions that have an assigned shortcut (ShortCut <> 0)
        if CustomAction.ShortCut <> 0 then
        begin
          JSONObject.AddPair(
            Action.Name,
            ShortCutToText(CustomAction.ShortCut)
          );
        end;
      end;
    end;
    TFile.WriteAllText(FConfigPath, JSONObject.ToJSON, TEncoding.UTF8);
  finally
    JSONObject.Free;
  end;
end;

procedure TShortcutManager.ApplyShortcut(const ActionName, ShortcutText: string);
var
  i: Integer;
begin
  for i := 0 to FActionManager.ActionCount - 1 do
    if FActionManager.Actions[i].Name = ActionName then
    begin
      FActionManager.Actions[i].ShortCut := TextToShortCut(ShortcutText);
      Break;
    end;
end;

end.
