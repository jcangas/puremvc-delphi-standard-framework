unit EmployeeAdmin.Facade;

interface

uses
  PureMVC.Interfaces.IFacade;

type
  IApplicationFacade = interface(IFacade)
    ['{24ADFFE6-754C-4127-A573-84E0624409EB}']
    procedure Startup(Info: TObject);
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

/// <summary>
///  IApplicationFacade accessor: must be ensured the first access to facade
///  is done by this method: see program start.
/// </summary>
function ApplicationFacade: IApplicationFacade;

implementation

uses
  PureMVC.Patterns.Facade,
  EmployeeAdmin.Controller.StartupCommand,
  EmployeeAdmin.Controller.DeleteUserCommand,
  EmployeeAdmin.Controller.AddRoleResultCommand;

type
  TApplicationFacade = class(TFacade, IApplicationFacade)
  protected
    /// <summary>
    ///  Protected constructor: we aren't allowed to initialize new instances
    /// from outside this class; You can override it, but is very rare
    /// </summary>
    constructor Create;override;
{$REGION 'Public methods'}
  public
    /// <summary>
    /// Optional initialization hook for Facade.
    /// Read the body for a generic implementation of this method.
    /// </summary>
    procedure InitializeFacade;override;

    /// <summary>
    /// Optional initialization hook for View.
    /// Read the body for a generic implementation of this method.
    /// </summary>
    procedure InitializeView;override;

    /// <summary>
    /// Optional initialization hook for Controller.
    /// Read the body for a generic implementation of this method.
    /// </summary>
    procedure InitializeController; override;

    /// <summary>
    /// Optional initialization hook for Model.
    /// Read the body for a generic implementation of this method.
    /// </summary>
    procedure InitializeModel;override;

    /// <summary>
    /// Start the application
    /// </summary>
    /// <param name="Info"></param>
    procedure Startup(Info: TObject);
{$ENDREGION}
  end;

  { TApplicationFacade }

procedure TApplicationFacade.InitializeFacade;
begin
  /// call inherited
  inherited;

  /// do any special subclass initialization here

end;

procedure TApplicationFacade.InitializeModel;
begin
  /// call inherited to use the PureMVC Model Singleton.
  inherited;

  /// Otherwise, if you're implmenting your own
  /// IModel, then instead do:
  /// if Assgined(FModel) then Exit;
  /// Fmodel = MyAppModel.getInstance;
  ///
  /// do any special subclass initialization here
  /// such as creating and registering Model proxys
  /// that don't require a facade reference at
  /// construction time, such as fixed type lists
  /// that never need to send Notifications.
  ///
  /// CAREFUL: Can't reference Facade instance in constructor
  /// of new Proxys from here, since this step is part of
  /// Facade construction!  Usually, Proxys needing to send
  /// notifications are registered elsewhere in the app
  /// for this reason.
end;

procedure TApplicationFacade.InitializeView;
begin
  /// call inherited to use the PureMVC View Singleton.
  inherited;

  /// Otherwise, if you're implmenting your own
  /// IView, then instead do:
  /// if Assigned( FView) then Exit;
  /// FView = MyAppView.getInstance;
  ///
  /// do any special subclass initialization here
  /// such as creating and registering Mediators
  /// that do not need a Facade reference at construction
  /// time.
  ///
  /// CAREFUL: Can't reference Facade instance in constructor
  /// of new Mediators from here, since this is a step
  /// in Facade construction! Usually, all Mediators need
  /// receive notifications, and are registered elsewhere in
  /// the app for this reason.

end;

procedure TApplicationFacade.Startup(Info: TObject);
begin
  SendNotification(Self, MSG.Startup, Info);
end;

constructor TApplicationFacade.Create;
begin
  /// call inherited
  inherited;

end;

procedure TApplicationFacade.InitializeController();
begin
  /// call inherited to use the PureMVC Controller Singleton.
  inherited;
  /// Otherwise, if you're implmenting your own
  /// IController, then instead do:
  /// if Assigned(FController) then Exit;
  /// FController = MyAppController.getInstance;

  /// do any special subclass initialization here
  /// such as registering Commands
  RegisterCommand(MSG.Startup, TStartupCommand);
  RegisterCommand(MSG.DELETE_USER, TDeleteUserCommand);
  RegisterCommand(MSG.ADD_ROLE_RESULT, TAddRoleResultCommand);
end;

function ApplicationFacade: IApplicationFacade;
begin
  Result := (TApplicationFacade.Instance as IApplicationFacade)
end;

end.
