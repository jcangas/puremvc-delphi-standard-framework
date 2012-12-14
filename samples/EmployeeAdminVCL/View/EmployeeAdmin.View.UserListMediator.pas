unit EmployeeAdmin.View.UserListMediator;

interface
uses
  PureMVC.Utils,
  PureMVC.Interfaces.INotification,
  PureMVC.Patterns.Mediator,
  EmployeeAdmin.Facade,
  EmployeeAdmin.Model.UserProxy,
  EmployeeAdmin.View.Components.UserLst;

type
	TUserListMediator = class(TMediator)
  private
    UserProxy: TUserProxy;
    procedure UserListDeleteUser(Sender: TObject);
    procedure UserListNewUser(Sender: TObject);
    procedure UserListSelectUser(Sender: TObject);
    function GetUserList: TUserList;
  public
    const NAME = 'UserListMediator';
		constructor Create(UserList: TUserList);
		procedure OnRegister;override;
    property UserList: TUserList read GetUserList;

    [PureMVCNotify(Msg.CANCEL_SELECTED)]
    procedure CancelSelected(Note: INotification);
    [PureMVCNotify(Msg.USER_ADDED)]
    procedure UserAdded(Note: INotification);
    [PureMVCNotify(Msg.USER_UPDATED)]
    procedure UserUpdated(Note: INotification);
    [PureMVCNotify(Msg.USER_DELETED)]
    procedure UserDeleted(Note: INotification);
  end;

implementation

uses Types,
  EmployeeAdmin.Model.VO.UserVO;


{ TUserListMediator }

procedure TUserListMediator.CancelSelected(Note: INotification);
begin
  UserList.Deselect;
end;

procedure TUserListMediator.UserAdded(Note: INotification);
begin
  UserList.Deselect;
  UserList.BindUpdateCtl;
end;

procedure TUserListMediator.UserDeleted(Note: INotification);
begin
  UserList.Deselect;
  UserList.BindUpdateCtl;
end;

procedure TUserListMediator.UserUpdated(Note: INotification);
var
  User: TUserVO;
begin
  UserList.Deselect;
  User := Note.Body.AsType<TUserVO>;
  UserList.BindUpdateCtlItem(User);
end;

constructor TUserListMediator.Create(userList: TUserList);
begin
  inherited Create(NAME, UserList);
  UserList.OnNewUser := UserListNewUser;
  UserList.OnDeleteUser := UserListDeleteUser;
  UserList.OnSelectUser := UserListSelectUser;
end;

function TUserListMediator.GetUserList: TUserList;
begin
  Result := TUserList(ViewComponent);
end;

procedure TUserListMediator.OnRegister;
begin
  inherited;
   UserProxy := Facade.RetrieveProxy(UserProxy.NAME) as TUserProxy;
   UserList.Users := UserProxy.Users;
end;

procedure TUserListMediator.UserListNewUser(Sender: TObject);
begin
  SendNotification(Self, MSG.NEW_USER, TUserVO.Create);
end;

procedure TUserListMediator.UserListDeleteUser(Sender: TObject);
begin
  SendNotification(Self, MSG.DELETE_USER, UserList.SelectedUser);
end;

procedure TUserListMediator.UserListSelectUser(Sender: TObject);
begin
  SendNotification(Self, MSG.USER_SELECTED, UserList.SelectedUser);
end;

end.
