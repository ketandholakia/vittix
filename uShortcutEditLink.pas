unit uShortcutEditLink;

interface

uses
Vcl.Forms, VirtualTrees.EditLink,  VirtualTrees, Vcl.Controls, uShortcutCaptureEdit, uShortcutTypes,  uShortcutManager, System.Classes, Winapi.Windows;

type
  TShortcutEditLink = class(TWinControlEditLink, IVTEditLink)
  private
    FEdit: TShortcutCaptureEdit;
    FNode: PVirtualNode;
    FManager: TShortcutManager;
    FForm: TForm;
  public
    constructor Create(AForm: TForm; AManager: TShortcutManager; ANode: PVirtualNode);
    function GetBounds: TRect; override;
    procedure SetBounds(R: TRect); override;

    procedure PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure EndEdit;
    function GetEditControl: TWinControl;
  end;

implementation

uses
  Vcl.Menus, System.SysUtils;

constructor TShortcutEditLink.Create(AForm: TForm; AManager: TShortcutManager; ANode: PVirtualNode);
begin
  inherited Create;
  FForm := AForm;
  FManager := AManager;
  FNode := ANode;
  FEdit := TShortcutCaptureEdit.Create(FForm);
end;

function TShortcutEditLink.GetBounds: TRect;
begin
  Result := inherited GetBounds;
end;

procedure TShortcutEditLink.SetBounds(R: TRect);
begin
  FEdit.BoundsRect := R;
end;

procedure TShortcutEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PActionData;
begin
  Data := Tree.GetNodeData(Node);
  FEdit.Text := Data^.Shortcut;
  FEdit.Parent := Tree;
  FEdit.SetFocus;
end;

procedure TShortcutEditLink.EndEdit;
var
  Data: PActionData;
begin
  Data := TBaseVirtualTree(FEdit.Parent).GetNodeData(FNode);
  if Assigned(Data) then
  begin
    if Data^.Shortcut <> FEdit.Text then
    begin
      if not SameText(FEdit.Text, '') then
      begin
        if FManager <> nil then
          FManager.ApplyShortcut(Data^.Name, FEdit.Text);
        Data^.Shortcut := FEdit.Text;
      end;
    end;
  end;
  FEdit.Free;
end;

function TShortcutEditLink.GetEditControl: TWinControl;
begin
  Result := FEdit;
end;

end.
