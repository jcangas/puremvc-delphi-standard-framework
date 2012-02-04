unit StartupCommand;

interface
uses
  PureMVC.Interfaces.ICommand,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IFacade,
  PureMVC.Patterns.Command;

type

	TStartupCommand = class(TSimpleCommand, ICommand)
  public
		/// <summary>
		/// Register the Proxies and Mediators.
		///
		/// Get the View Components for the Mediators from the app,
		/// which passed a reference to itself on the notification.
		/// </summary>
		/// <param name="note"></param>
		procedure Execute(Note: INotification);override;
  end;

implementation
uses UserProxy, RoleProxy, MainWin,
  UserFormMediator, UserListMediator, RolePanelMediator;
  //Demo.PureMVC.EmployeeAdmin.Model;
  //Demo.PureMVC.EmployeeAdmin.View;

{ TStartupCommand }

procedure TStartupCommand.Execute(Note: INotification);
var
  Window: TMainWindow;
begin
  Facade.RegisterProxy(TUserProxy.Create);
  Facade.RegisterProxy(TRoleProxy.Create);

  Window := Note.Body.AsType<TMainWindow>;

  Facade.RegisterMediator(TUserFormMediator.Create(Window.userForm));
  Facade.RegisterMediator(TUserListMediator.Create(Window.userList));
  Facade.RegisterMediator(TRolePanelMediator.Create(Window.rolePanel));

end;

end.
