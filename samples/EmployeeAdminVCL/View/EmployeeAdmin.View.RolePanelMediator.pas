unit EmployeeAdmin.View.RolePanelMediator;

interface
uses
  PureMVC.Interfaces.Collections,
  PureMVC.Interfaces.INotification,
  PureMVC.Patterns.Mediator,
  EmployeeAdmin.Facade,
  EmployeeAdmin.Model.RoleProxy,
  EmployeeAdmin.View.Components.RolePanl;

type
	TRolePanelMediator = class(TMediator)
  private
    RoleProxy: TRoleProxy;
		function GetRolePanel: TRolePanel;
  protected
		procedure RolePanel_RemoveRole(Sender: TObject);
		procedure RolePanel_AddRole(Sender: TObject);

  public
		const NAME = 'RolePanelMediator';
		constructor Create(viewComponent: TRolePanel);
		procedure OnRegister;override;
		property RolePanel: TRolePanel read GetRolePanel;

    [PureMVCNotify(MSG.NEW_USER)]
    procedure NewUser(Note: INotification);

    [PureMVCNotify(MSG.USER_ADDED)]
    procedure UserAdded(Note: INotification);

    [PureMVCNotify(MSG.USER_UPDATED)]
    procedure UserUpdated(Note: INotification);

    [PureMVCNotify(MSG.ADD_ROLE_RESULT)]
    procedure AddRoleResult(Note: INotification);

    [PureMVCNotify(MSG.CANCEL_SELECTED)]
    procedure CancelSelected(Note: INotification);

    [PureMVCNotify(MSG.DELETE_ROLE)]
    procedure DeleteRole(Note: INotification);

    [PureMVCNotify(MSG.USER_DELETED)]
    procedure UserDeleted(Note: INotification);

    [PureMVCNotify(MSG.USER_SELECTED)]
    procedure UserSelected(Note: INotification);

  end;

implementation
uses
  Types,
  EmployeeAdmin.Model.Enum.RoleEnum,
  EmployeeAdmin.Model.VO.RoleVO,
  EmployeeAdmin.Model.VO.UserVO;
{ TRolePanelMediator }

constructor TRolePanelMediator.Create(viewComponent: TRolePanel);
begin
  inherited Create(NAME, viewComponent);
  RolePanel.UpdateCombo(TRoleEnum, TRoleEnum.NONE_SELECTED);
  RolePanel.OnAddRole := RolePanel_AddRole;
  RolePanel.OnRemoveRole := RolePanel_RemoveRole;
end;

function TRolePanelMediator.GetRolePanel: TRolePanel;
begin
  Result := ViewComponent as TRolePanel;
end;

procedure TRolePanelMediator.NewUser(Note: INotification);
begin
  RolePanel.ClearForm;
end;

procedure TRolePanelMediator.UserAdded(Note: INotification);
var
  User: TUserVO;
	Role: TRoleVO;
  UserName: string;
begin
  UserName := '';
  User := Note.Body.AsType<TUserVO>;
  if User <> nil then
    UserName := User.UserName;

  Role := TRoleVO.Create(UserName);
  RoleProxy.AddItem(role);
  RolePanel.ClearForm();
end;

procedure TRolePanelMediator.UserUpdated(Note: INotification);
begin
  RolePanel.ClearForm;
end;

procedure TRolePanelMediator.UserDeleted(Note: INotification);
begin
  RolePanel.ClearForm;
end;

procedure TRolePanelMediator.UserSelected(Note: INotification);
var
  User: TUserVO;
  UserName: string;
begin
  User := Note.Body.AsType<TUserVO>;
  if User = nil then
    UserName := ''
  else
    UserName := User.UserName;

  RolePanel.ShowUser(User, RoleProxy.GetUserRoles(userName));
end;

procedure TRolePanelMediator.CancelSelected(Note: INotification);
begin
  RolePanel.ClearForm;
end;

procedure TRolePanelMediator.AddRoleResult(Note: INotification);
var
  UserName: string;
begin
    if RolePanel.User = nil then
      UserName := ''
    else
      UserName := RolePanel.User.UserName;

    RolePanel.ShowUserRoles(RoleProxy.GetUserRoles(UserName));
end;

procedure TRolePanelMediator.DeleteRole(Note: INotification);
var
  UserName: string;
  R: TRoleEnum;
begin
    if RolePanel.User = nil then
      UserName := ''
    else
      UserName := RolePanel.User.UserName;

  R := Note.body.AsType<TRoleEnum>;
  RoleProxy.RemoveRoleFromUser(RolePanel.User, R);
  RolePanel.ShowUserRoles(RoleProxy.GetUserRoles(UserName));
end;

procedure TRolePanelMediator.OnRegister;
begin
  inherited;
  RoleProxy := Facade.RetrieveProxy(RoleProxy.NAME) as TRoleProxy;
end;

procedure TRolePanelMediator.RolePanel_AddRole(Sender: TObject);
var
  Result: Boolean;
begin
  Result := RoleProxy.AddRoleToUser(RolePanel.User, RolePanel.SelectedRole);
  SendNotification(MSG.ADD_ROLE_RESULT, Self, Result);
end;

procedure TRolePanelMediator.RolePanel_RemoveRole(Sender: TObject);
begin
  SendNotification(MSG.DELETE_ROLE, Self, RolePanel.SelectedRole);
  //self.send_notification(NotificationName::SHOW_DELETE_ROLE_COFIRMATION, [self.view.selected_role, self.view.user])
end;

end.
