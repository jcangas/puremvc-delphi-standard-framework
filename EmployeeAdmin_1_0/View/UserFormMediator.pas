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
  public
		const NAME = 'UserFormMediator';
		procedure OnRegister;override;
		constructor Create(ViewComponent: TUserForm);
		function ListNotificationInterests(): IList<string>;override;

		procedure UserForm_AddUser(Sender: TObject);
		procedure UserForm_UpdateUser(Sender: TObject);
		procedure UserForm_CancelUser(Sender: TObject);

		procedure HandleNotification(Note: INotification);override;
		property UserForm: TUserForm read GetUserForm;
  end;


implementation
uses
 UserVO,
 ApplicationFacade;

{ TUserFormMediator }

constructor TUserFormMediator.Create(ViewComponent: TUserForm);
begin
  inherited Create(NAME, ViewComponent);
  UserForm.AddUser := UserForm_AddUser;
  UserForm.UpdateUser := UserForm_UpdateUser;
  UserForm.CancelUser := UserForm_CancelUser;
end;

function TUserFormMediator.GetUserForm: TUserForm;
begin
  Result := ViewComponent as TUserForm;
end;

procedure TUserFormMediator.HandleNotification(Note: INotification);
var
  User: TUserVO;
begin
  if Note.Name = CMD.NEW_USER then begin
    User := Note.Body.AsType<TUserVO>;
    UserForm.ShowUser(User, TUserFormMode.ADD);
  end
  else if Note.Name= CMD.USER_DELETED then
    UserForm.ClearForm()
  else if Note.Name = CMD.USER_SELECTED then begin
    User := Note.Body.AsType<TUserVO>;
    UserForm.ShowUser(User, TUserFormMode.EDIT);
  end;
end;

function TUserFormMediator.ListNotificationInterests: IList<string>;
begin
  Result := TList<string>.Create;
  Result.Add(CMD.NEW_USER);
  Result.Add(CMD.USER_DELETED);
  Result.Add(CMD.USER_SELECTED);
end;

procedure TUserFormMediator.OnRegister;
begin
  inherited;
  FUserProxy := (Facade.RetrieveProxy(TUserProxy.NAME) as TUserProxy);
end;

procedure TUserFormMediator.UserForm_AddUser(Sender: TObject);
var
  User: TUserVO;
begin
  User := UserForm.User;
  FUserProxy.AddItem(user);
  SendNotification(Self, CMD.USER_ADDED, User);
  UserForm.ClearForm();
end;

procedure TUserFormMediator.UserForm_CancelUser(Sender: TObject);
begin
  SendNotification(Self, CMD.CANCEL_SELECTED);
  UserForm.ClearForm();
end;

procedure TUserFormMediator.UserForm_UpdateUser(Sender: TObject);
var
  User: TUserVO;
begin
  User := UserForm.User;
  FUserProxy.UpdateItem(User);
  SendNotification(Self, CMD.USER_UPDATED, User);
  UserForm.ClearForm();
end;

end.
