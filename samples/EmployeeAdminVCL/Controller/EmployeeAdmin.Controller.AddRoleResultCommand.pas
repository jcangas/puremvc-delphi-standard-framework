{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Controller.AddRoleResultCommand;

interface
uses
  PureMVC.Interfaces.ICommand,
  PureMVC.Interfaces.INotification,
  PureMVC.Patterns.Command;

type
	TAddRoleResultCommand = class(TSimpleCommand, ICommand)
  public
		procedure Execute(Notification: INotification);override;
  end;

implementation
uses Dialogs;

{ TAddRoleResultCommand }

procedure TAddRoleResultCommand.Execute(Notification: INotification);
var
  Result: Boolean;
begin
  Result := Notification.Body.AsBoolean;
  if not Result then
    ShowMessage( 'Add User Role: ' + 'Role already exists for this user!');

end;

end.
