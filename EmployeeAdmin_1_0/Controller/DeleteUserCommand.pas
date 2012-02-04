{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit DeleteUserCommand;
interface

uses
  PureMVC.Interfaces.ICommand,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IFacade,
  PureMVC.Patterns.Command;

type

	TDeleteUserCommand = class(TSimpleCommand, ICommand)
  public
		/// <summary>
		/// retrieve the user and role proxies and delete the user
		/// and his roles. then send the USER_DELETED notification
		/// </summary>
		/// <param name="Notification"></param>
		procedure Execute(Notification: INotification );override;
  end;

implementation
uses UserVO, RoleProxy, UserProxy, ApplicationFacade;

{ TDeleteUserCommand }

procedure TDeleteUserCommand.Execute(Notification: INotification);
var
  User: TUserVO;
  UserProxy: TUserProxy;
  RoleProxy: TRoleProxy;
begin
  inherited;
  User := Notification.Body.AsType<TUserVO>;
  UserProxy := Facade.RetrieveProxy(UserProxy.NAME) as TUserProxy;
  RoleProxy := Facade.RetrieveProxy(RoleProxy.NAME) as TRoleProxy;
  UserProxy.DeleteItem(User);
  RoleProxy.DeleteItem(User);
  SendNotification(Self, CMD.USER_DELETED);

end;

end.

