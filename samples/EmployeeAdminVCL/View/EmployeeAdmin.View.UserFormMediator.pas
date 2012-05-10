unit EmployeeAdmin.View.UserFormMediator;

interface
uses
  SummerFW.Utils.Collections,
  PureMVC.Patterns.Mediator,
  PureMVC.Interfaces.INotification,
  EmployeeAdmin.Facade,
  EmployeeAdmin.Model.UserProxy,
  EmployeeAdmin.View.Components.UserFrm;

type
	TUserFormMediator = class(TMediator)
  private
      FuserProxy: TUserProxy;
    function GetUserForm: TUserForm;

  public
		const NAME = 'UserFormMediator';
    [PureMVCNotify(Msg.NEW_USER)]
    procedure NewUser(Note: INotification);

    [PureMVCNotify(Msg.USER_SELECTED)]
    procedure UserSelected(Note: INotification);

    [PureMVCNotify(Msg.USER_DELETED)]
    procedure UserDeleted(Note: INotification);

		procedure OnRegister;override;
		constructor Create(ViewComponent: TUserForm);

		procedure UserFormOnAddUser(Sender: TObject);
		procedure UserFormOnUpdateUser(Sender: TObject);
		procedure UserFormOnCancelUser(Sender: TObject);

		property UserForm: TUserForm read GetUserForm;
  end;

implementation
uses
  Types,
  EmployeeAdmin.Model.Enum.DeptEnum,
  EmployeeAdmin.Model.VO.UserVO;

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
  SendNotification(Self, MSG.USER_ADDED, User);
  UserForm.ClearForm();
end;

procedure TUserFormMediator.UserFormOnCancelUser(Sender: TObject);
begin
  SendNotification(Self, MSG.CANCEL_SELECTED);
  UserForm.ClearForm();
end;

procedure TUserFormMediator.UserFormOnUpdateUser(Sender: TObject);
var
  User: TUserVO;
begin
  User := UserForm.User;
  FUserProxy.UpdateItem(User);
  SendNotification(Self, MSG.USER_UPDATED, User);
  UserForm.ClearForm();
end;

end.
