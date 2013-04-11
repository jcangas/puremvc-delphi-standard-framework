unit EmployeeAdmin.View.Components.RolePanl;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ActnList,
  PureMVC.Utils,
  EmployeeAdmin.Model.Enum.Enum,
  EmployeeAdmin.Model.Enum.RoleEnum,
  EmployeeAdmin.Model.VO.UserVO;

type
  TRolePanel = class(TFrame)
    UserRolesCtl: TListBox;
    BottomPanel: TPanel;
    RemoveBtn: TButton;
    AddBtn: TButton;
    RoleListCtl: TComboBox;
    ActionList: TActionList;
    RoleAddAct: TAction;
    RoleRemoveAct: TAction;
    procedure RoleAddActExecute(Sender: TObject);
    procedure RoleRemoveActExecute(Sender: TObject);
    procedure RoleListCtlSelect(Sender: TObject);
    procedure UserRolesCtlClick(Sender: TObject);
  private
    FAddRole: TNotifyEvent;
    FRemoveRole: TNotifyEvent;
    FRoles: IList<TRoleEnum>;
    FUser: TUserVO;
    FSelectedRole: TRoleEnum;
  public
    procedure UpdateCombo(EnumClass: TEnumClass; Selected: TEnum);
    procedure ClearForm;
    procedure ShowUser(User: TUserVO; Roles: IList<TRoleEnum>);
    procedure ShowUserRoles(Roles: IList<TRoleEnum>);

    property User: TUserVO read FUser;
		property Roles: IList<TRoleEnum> read FRoles;
		property SelectedRole: TRoleEnum read FSelectedRole;
    property OnAddRole: TNotifyEvent read FAddRole write FAddRole;
    property OnRemoveRole: TNotifyEvent read FRemoveRole write FRemoveRole;
  end;

implementation

{$R *.dfm}

{ TRolePanel }

procedure TRolePanel.UpdateCombo(EnumClass: TEnumClass; Selected: TEnum);
begin
  RoleListCtl.Items.Clear;
  EnumClass.Fill(RoleListCtl.Items);
  RoleListCtl.ItemIndex := Selected.Index;
end;

procedure TRolePanel.ClearForm();
begin
  FUser := nil;
  FRoles := nil;
  UserRolesCtl.Clear;
  RoleListCtl.ItemIndex := TRoleEnum.NONE_SELECTED.Index;
end;

procedure TRolePanel.ShowUser(User: TUserVO; Roles: IList<TRoleEnum>);
begin
  if User = nil then
    ClearForm()
  else begin
    FUser := User;
    FRoles := Roles;
    ShowUserRoles(Roles);
    RoleListCtl.ItemIndex := TRoleEnum.NONE_SELECTED.Index;
  end;
end;

procedure TRolePanel.ShowUserRoles(Roles: IList<TRoleEnum>);
var
  R: TRoleEnum;
begin
  UserRolesCtl.Clear;
  for R in Roles do
    UserRolesCtl.Items.AddObject(R.Value, R);
end;

procedure TRolePanel.RoleAddActExecute(Sender: TObject);
begin
  OnAddRole(Self);
end;

procedure TRolePanel.RoleRemoveActExecute(Sender: TObject);
begin
  OnRemoveRole(Self);
end;

procedure TRolePanel.UserRolesCtlClick(Sender: TObject);
begin
  if (UserRolesCtl.ItemIndex = -1) then
    FSelectedRole := nil
  else
    FSelectedRole := UserRolesCtl.Items.Objects[UserRolesCtl.ItemIndex] as TRoleEnum;
end;

procedure TRolePanel.RoleListCtlSelect(Sender: TObject);
begin
  if (RoleListCtl.ItemIndex = TRoleEnum.NONE_SELECTED.Index) then
    FSelectedRole := nil
  else
    FSelectedRole := TRoleEnum.Items[RoleListCtl.ItemIndex];
end;

end.
