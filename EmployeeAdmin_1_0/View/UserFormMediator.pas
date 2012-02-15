unit UserFormMediator;

interface
uses
  SummerFW.Utils.Collections,
  PureMVC.Patterns.Mediator,
  PureMVC.Interfaces.IMediator,
  PureMVC.Interfaces.INotification,
  UserFrm,
  UserProxy;

type
	TUserFormMediator = class(TMediator, IMediator)
		private
      FuserProxy: TUserProxy;
    function GetUserForm: TUserForm;
  published
    procedure NewUser(Note: INotification);
    procedure UserSelected(Note: INotification);
    procedure UserDeleted(Note: INotification);
  public
		const NAME = 'UserFormMediator';
		procedure OnRegister;override;
		constructor Create(ViewComponent: TUserForm);
		function ListNotificationInterests(): IList<string>;override;

		procedure UserFormOnAddUser(Sender: TObject);
		procedure UserFormOnUpdateUser(Sender: TObject);
		procedure UserFormOnCancelUser(Sender: TObject);

		property UserForm: TUserForm read GetUserForm;
  end;

implementation
uses
  Types,
  DeptEnum,
  UserVO,
  ApplicationFacade;

{ TUserFormMediator }

constructor TUserFormMediator.Create(ViewComponent: TUserForm);
begin
  inherited Create(NAME, ViewComponent);
  UserForm.UpdateCombo(TDeptEnum, TDeptEnum.NONE_SELECTED);

  UserForm.OnAddUser := UserFormOnAddUser;
  UserForm.OnUpdateUser := UserFormOnUpdateUser;
  UserForm.OnCancelUser := UserFormOnCancelUser;
end;

function TUserFormMediator.GetUserForm: TUserForm;
begin
  Result := ViewComponent as TUserForm;
end;

procedure TUserFormMediator.NewUser(Note: INotification);
var
  User: TUserVO;
begin
  User := Note.Body.AsType<TUserVO>;
  UserForm.ShowUser(User, TUserFormMode.ADD);
end;

procedure TUserFormMediator.UserSelected(Note: INotification);
var
  User: TUserVO;
begin
  User := Note.Body.AsType<TUserVO>;
  UserForm.ShowUser(User, TUserFormMode.EDIT);
end;

procedure TUserFormMediator.UserDeleted(Note: INotification);
begin
  UserForm.ClearForm;
end;

function TUserFormMediator.ListNotificationInterests: IList<string>;
begin
  Result := TList<string>.Create;
  Result.AddRange(TStringDynArray.Create(CMD.NEW_USER, CMD.USER_DELETED, CMD.USER_SELECTED));
end;

procedure TUserFormMediator.OnRegister;
begin
  inherited;
  FUserProxy := (Facade.RetrieveProxy(TUserProxy.NAME) as TUserProxy);
end;

procedure TUserFormMediator.UserFormOnAddUser(Sender: TObject);
var
  User: TUserVO;
begin
  User := UserForm.User;
  FUserProxy.AddItem(user);
  SendNotification(Self, CMD.USER_ADDED, User);
  UserForm.ClearForm();
end;

procedure TUserFormMediator.UserFormOnCancelUser(Sender: TObject);
begin
  SendNotification(Self, CMD.CANCEL_SELECTED);
  UserForm.ClearForm();
end;

procedure TUserFormMediator.UserFormOnUpdateUser(Sender: TObject);
var
  User: TUserVO;
begin
  User := UserForm.User;
  FUserProxy.UpdateItem(User);
  SendNotification(Self, CMD.USER_UPDATED, User);
  UserForm.ClearForm();
end;

end.
