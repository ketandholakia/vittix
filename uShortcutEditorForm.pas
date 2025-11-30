unit uShortcutEditorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ActnMan, Vcl.ActnList, Vcl.Menus, uShortcutManager, uShortcutTypes,
  VirtualTrees.BaseAncestorVCL, VirtualTrees.BaseTree, VirtualTrees.AncestorVCL, VirtualTrees,
  uShortcutEditDialog, VirtualTrees.Types, System.JSON, System.IOUtils;

type
  TfrmuShortcutEditor = class(TForm)
    btnApply: TButton;
    btnClose: TButton;
    pnlBottom: TPanel;
    vstActions: TVirtualStringTree;
    btnShortKey: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure vstActionsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstActionsDblClick(Sender: TObject);
    procedure btnShortKeyClick(Sender: TObject);
  private
    FManager: TShortcutManager;
    procedure PopulateTree;
    function IsShortcutConflict(const NewShortcut: string; const CurrentAction: string): Boolean;
  public
    constructor CreateEditor(AOwner: TComponent; Manager: TShortcutManager); reintroduce;
  end;

implementation

{$R *.dfm}

// --- (Existing IsShortcutConflict and vstActionsDblClick procedures remain unchanged) ---
function TfrmuShortcutEditor.IsShortcutConflict(const NewShortcut: string; const CurrentAction: string): Boolean;
var
  i: Integer;
  ExistingShortcut: string;
  Action: TBasicAction;
begin
  Result := False;
  for i := 0 to FManager.ActionManager.ActionCount - 1 do
  begin
    Action := FManager.ActionManager.Actions[i];
    if (Action is TCustomAction) and (Action.Name <> CurrentAction) then
    begin
      ExistingShortcut := ShortCutToText(TCustomAction(Action).ShortCut);
      if SameText(ExistingShortcut, NewShortcut) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TfrmuShortcutEditor.vstActionsDblClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PActionData;
  NewShortcut: string;
begin
  Node := vstActions.FocusedNode;
  if Assigned(Node) then
  begin
    Data := vstActions.GetNodeData(Node);
    if Assigned(Data) then
    begin
      if TfrmShortcutEditDialog.Execute(Data^.Name, Data^.Caption, Data^.Shortcut, NewShortcut) then
      begin
        if IsShortcutConflict(NewShortcut, Data^.Name) then
        begin
          ShowMessage('Shortcut conflict detected. Please choose a different combination.');
          Exit;
        end;

        Data^.Shortcut := NewShortcut;
        vstActions.InvalidateNode(Node);
      end;
    end;
  end;
end;

// --- CRITICAL FIX: PopulateTree is moved here, ensuring FManager is assigned ---
constructor TfrmuShortcutEditor.CreateEditor(AOwner: TComponent; Manager: TShortcutManager);
begin
  inherited Create(AOwner);
  FManager := Manager;

  vstActions.NodeDataSize := SizeOf(TActionData);

  with vstActions.TreeOptions do
  begin
    MiscOptions := MiscOptions + [toGridExtensions];
    SelectionOptions := SelectionOptions - [toFullRowSelect] + [toMultiSelect];
    PaintOptions := PaintOptions + [toShowHorzGridLines];
  end;

  vstActions.Header.Options := [hoVisible, hoColumnResize, hoHotTrack];
  vstActions.Header.MainColumn := 2;

  vstActions.Header.Columns.Clear;
  vstActions.Header.Columns.Add.Text := 'Action Name';
  vstActions.Header.Columns.Add.Text := 'Caption';
  vstActions.Header.Columns.Add.Text := 'Shortcut';
  vstActions.Header.Columns[0].Width := 150;
  vstActions.Header.Columns[1].Width := 200;
  vstActions.Header.Columns[2].Width := 120;
  vstActions.Header.Columns[2].Alignment := taCenter;

  vstActions.OnGetText := vstActionsGetText;

  // FIX: Check for the manager and populate the tree here, where FManager is guaranteed to be set
  if not Assigned(FManager) or not Assigned(FManager.ActionManager) then
  begin
     // Show an error but allow the form to exist (it will be empty)
     ShowMessage('FATAL ERROR: Shortcut manager is missing ActionManager reference.');
     Exit;
  end;

  PopulateTree;
end;

procedure TfrmuShortcutEditor.FormCreate(Sender: TObject);
begin
  Caption := 'Shortcut Manager';

  // FIX: The initialization check and PopulateTree call have been removed from here.
  // The VCL execution order makes it unsafe to rely on FManager.ActionManager here.
end;

procedure TfrmuShortcutEditor.PopulateTree;
var
  i: Integer;
  Node: PVirtualNode;
  Data: PActionData;
  Action: TBasicAction;
begin
  vstActions.Clear;

  for i := 0 to FManager.ActionManager.ActionCount - 1 do
  begin
    Action := FManager.ActionManager.Actions[i];
    if Action is TCustomAction then
    begin
      Node := vstActions.AddChild(nil);
      Data := vstActions.GetNodeData(Node);
      if Assigned(Data) then
      begin
        Data^.Name := Action.Name;
        Data^.Caption := TCustomAction(Action).Caption;
        Data^.Shortcut := ShortCutToText(TCustomAction(Action).ShortCut);
      end;
    end;
  end;
end;

procedure TfrmuShortcutEditor.vstActionsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PActionData;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    case Column of
      0: CellText := Data^.Name;
      1: CellText := Data^.Caption;
      2: CellText := Data^.Shortcut;
    end;
  end;
end;

procedure TfrmuShortcutEditor.btnApplyClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PActionData;
  i: Integer;
  Action: TBasicAction;
begin
  Node := vstActions.GetFirst;
  while Assigned(Node) do
  begin
    Data := vstActions.GetNodeData(Node);
    if Assigned(Data) then
    begin
      // --- Phase 1: Apply to ActionManager ---
      for i := 0 to FManager.ActionManager.ActionCount - 1 do
      begin
        Action := FManager.ActionManager.Actions[i];
        if (Action is TCustomAction) and (Action.Name = Data^.Name) then
        begin
          // Apply the new shortcut from the editor (Data^.Shortcut string)
          TCustomAction(Action).ShortCut := TextToShortCut(Data^.Shortcut);
          Break;
        end;
      end;
    end;
    Node := vstActions.GetNext(Node);
  end;

  // --- Phase 2: Save All Current ActionManager Shortcuts to JSON ---
  FManager.SaveAllShortcuts;

  PopulateTree;
  ShowMessage('Shortcuts applied and saved successfully.');
end;


procedure TfrmuShortcutEditor.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmuShortcutEditor.btnShortKeyClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PActionData;
  PrintList: TStringList;
begin
  PrintList := TStringList.Create;
  try
    PrintList.Add('--- Custom Application Shortcuts ---');
    PrintList.Add(Format('%-20s %-30s %s', ['ACTION NAME', 'CAPTION', 'SHORTCUT']));
    PrintList.Add('----------------------------------------------------');

    Node := vstActions.GetFirst;
    while Assigned(Node) do
    begin
      Data := vstActions.GetNodeData(Node);
      if Assigned(Data) then
      begin
        // Format the data into a single line for the list
        PrintList.Add(Format('%-20s %-30s %s',
          [Data^.Name, Data^.Caption, Data^.Shortcut]));
      end;
      Node := vstActions.GetNext(Node);
    end;

    // In a real application, you would send PrintList.Text to a printer or report preview
  finally
    PrintList.Free;
  end;
end;

end.
