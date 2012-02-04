unit ApplicationFacade;

interface

uses
  PureMVC.Interfaces.IFacade;

type
  IApplicationFacade = interface(IFacade)
  ['{24ADFFE6-754C-4127-A573-84E0624409EB}']
    procedure Startup(App: TObject);
  end;

{$REGION 'Notification name constants'}
    CMD = class
      const STARTUP = 'startup';
      const NEW_USER = 'newUser';
      const DELETE_USER = 'deleteUser';
      const CANCEL_SELECTED = 'cancelSelected';
      const USER_SELECTED = 'userSelected';
      const USER_ADDED = 'userAdded';
      const USER_UPDATED = 'userUpdated';
      const USER_DELETED = 'userDeleted';
      const ADD_ROLE = 'addRole';
      const ADD_ROLE_RESULT = 'addRoleResult';
    end;
{$ENDREGION}

implementation
uses
  PureMVC.Patterns.Facade;

type
  TApplicationFacade = class(TFacade, IApplicationFacade)
  public
  type

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
  SendNotification(Self, CMD.STARTUP, App);
end;

initialization
  TFacade.OnGetFacadeClass := procedure(var FacadeClass: TFacadeClass) begin
    FacadeClass := TApplicationFacade;
  end;
end.
