unit RolePanelMediator;

interface
uses
  SummerFW.Utils.Collections,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IMediator,
  PureMVC.Patterns.Mediator,
  RoleProxy,
  RolePanl;

type
	TRolePanelMediator = class(TMediator, IMediator)
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
    function ListNotificationInterests(): IList<string>;override;
  published
    procedure NewUser(Note: INotification);
    procedure UserAdded(Note: INotification);
    procedure UserUpdated(Note: INotification);
    procedure AddRoleResult(Note: INotification);
    procedure CancelSelected(Note: INotification);
    procedure DeleteRole(Note: INotification);
    procedure UserDeleted(Note: INotification);
    procedure UserSelected(Note: INotification);
  end;

implementation
uses
  Types,
  ApplicationFacade,
  RoleEnum,
  RoleVO,
  UserVO;

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

function TRolePanelMediator.ListNotificationInterests: IList<string>;
begin
  Result := TList<string>.Create;
  Result.AddRange(TStringDynArray.Create(
  MSG.NEW_USER, MSG.USER_ADDED, MSG.USER_DELETED, MSG.USER_SELECTED,
  MSG.USER_UPDATED, MSG.CANCEL_SELECTED, MSG.ADD_ROLE_RESULT, MSG.DELETE_ROLE));
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
  SendNotification(Self, MSG.ADD_ROLE_RESULT, Result);
end;

procedure TRolePanelMediator.RolePanel_RemoveRole(Sender: TObject);
begin
  SendNotification(Self, MSG.DELETE_ROLE, RolePanel.SelectedRole);
  //self.send_notification(NotificationName::SHOW_DELETE_ROLE_COFIRMATION, [self.view.selected_role, self.view.user])
end;

end.
