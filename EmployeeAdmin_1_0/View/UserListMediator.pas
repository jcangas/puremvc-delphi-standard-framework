unit UserListMediator;

interface
uses
  PureMVC.Patterns.Mediator,
  PureMVC.Interfaces.IMediator,
  PureMVC.Interfaces.INotification,
  SummerFW.Utils.Collections,
  UserProxy, UserLst;

type
	TUserListMediator = class(TMediator, IMediator)
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
		function ListNotificationInterests: IList<string>;override;
  published
    procedure CancelSelected(Note: INotification);
    procedure UserAdded(Note: INotification);
    procedure UserUpdated(Note: INotification);
    procedure UserDeleted(Note: INotification);
  end;

implementation

uses Types,
  ApplicationFacade,
  UserVO;

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

function TUserListMediator.ListNotificationInterests: IList<string>;
begin
  Result := Tlist<string>.Create;
  Result.AddRange(TStringDynArray.Create(CMD.CANCEL_SELECTED, CMD.USER_ADDED, CMD.USER_UPDATED, CMD.USER_DELETED));
end;

procedure TUserListMediator.OnRegister;
begin
  inherited;
   UserProxy := Facade.RetrieveProxy(UserProxy.NAME) as TUserProxy;
   UserList.Users := UserProxy.Users;
end;

procedure TUserListMediator.UserListNewUser(Sender: TObject);
begin
  SendNotification(Self, CMD.NEW_USER, TUserVO.Create);
end;

procedure TUserListMediator.UserListDeleteUser(Sender: TObject);
begin
  SendNotification(Self, CMD.DELETE_USER, UserList.SelectedUser);
end;

procedure TUserListMediator.UserListSelectUser(Sender: TObject);
begin
  SendNotification(Self, CMD.USER_SELECTED, UserList.SelectedUser);
end;

end.
