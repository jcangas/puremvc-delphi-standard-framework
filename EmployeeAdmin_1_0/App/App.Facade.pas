unit App.Facade;

interface

uses
  PureMVC.Interfaces.IFacade;

type
  IApplicationFacade = interface(IFacade)
    ['{24ADFFE6-754C-4127-A573-84E0624409EB}']
    procedure Startup(App: TObject);
  end;


{$REGION 'Notification name constants'}

  MSG = class
  const
    Startup = 'Startup';

  const
    NEW_USER = 'NewUser';

  const
    DELETE_USER = 'DeleteUser';

  const
    CANCEL_SELECTED = 'CancelSelected';

  const
    USER_SELECTED = 'UserSelected';

  const
    USER_ADDED = 'UserAdded';

  const
    USER_UPDATED = 'UserUpdated';

  const
    USER_DELETED = 'UserDeleted';

  const
    ADD_ROLE = 'AddRole';

  const
    DELETE_ROLE = 'DeleteRole';

  const
    ADD_ROLE_RESULT = 'AddRoleResult';

  const
    SHOW_ALERT_DIALOG = 'ShowAlertDialog';

  const
    SHOW_DELETE_ROLE_COFIRMATION = 'ShowDeleteRoleConfirmation';
  end;
{$ENDREGION}

implementation

uses
  PureMVC.Patterns.Facade,
  EmployeeAdmin.Controller.StartupCommand,
  EmployeeAdmin.Controller.DeleteUserCommand,
  EmployeeAdmin.Controller.AddRoleResultCommand;

type
  TApplicationFacade = class(TFacade, IApplicationFacade)
  protected
    procedure InitializeController; override;
{$REGION 'Public methods'}
  public
    /// <summary>
    /// Start the application
    /// </summary>
    /// <param name="app"></param>
    procedure Startup(App: TObject);
{$ENDREGION}
  end;

  { TApplicationFacade }

procedure TApplicationFacade.Startup(App: TObject);
begin
  SendNotification(Self, MSG.Startup, App);
end;

procedure TApplicationFacade.InitializeController();
begin
  inherited;
  RegisterCommand(MSG.Startup, TStartupCommand);
  RegisterCommand(MSG.DELETE_USER, TDeleteUserCommand);
  RegisterCommand(MSG.ADD_ROLE_RESULT, TAddRoleResultCommand);
end;

initialization

TFacade.OnGetFacadeClass := procedure(var FacadeClass: TFacadeClass)
begin
  FacadeClass := TApplicationFacade;
end;

end.
