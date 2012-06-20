program EmployeeAdmin;

uses
  Vcl.Forms,
  EmployeeAdmin.Facade in '..\App\EmployeeAdmin.Facade.pas',
  EmployeeAdmin.MainWin in '..\App\EmployeeAdmin.MainWin.pas' {MainWindow},
  EmployeeAdmin.Controller.AddRoleResultCommand in '..\Controller\EmployeeAdmin.Controller.AddRoleResultCommand.pas',
  EmployeeAdmin.Controller.DeleteUserCommand in '..\Controller\EmployeeAdmin.Controller.DeleteUserCommand.pas',
  EmployeeAdmin.Controller.StartupCommand in '..\Controller\EmployeeAdmin.Controller.StartupCommand.pas',
  EmployeeAdmin.Model.RoleProxy in '..\Model\EmployeeAdmin.Model.RoleProxy.pas',
  EmployeeAdmin.Model.UserProxy in '..\Model\EmployeeAdmin.Model.UserProxy.pas',
  EmployeeAdmin.Model.VO.RoleVO in '..\Model\VO\EmployeeAdmin.Model.VO.RoleVO.pas',
  EmployeeAdmin.Model.VO.UserVO in '..\Model\VO\EmployeeAdmin.Model.VO.UserVO.pas',
  EmployeeAdmin.Model.Enum.DeptEnum in '..\Model\Enum\EmployeeAdmin.Model.Enum.DeptEnum.pas',
  EmployeeAdmin.Model.Enum.Enum in '..\Model\Enum\EmployeeAdmin.Model.Enum.Enum.pas',
  EmployeeAdmin.Model.Enum.RoleEnum in '..\Model\Enum\EmployeeAdmin.Model.Enum.RoleEnum.pas',
  EmployeeAdmin.View.RolePanelMediator in '..\View\EmployeeAdmin.View.RolePanelMediator.pas',
  EmployeeAdmin.View.UserFormMediator in '..\View\EmployeeAdmin.View.UserFormMediator.pas',
  EmployeeAdmin.View.UserListMediator in '..\View\EmployeeAdmin.View.UserListMediator.pas',
  EmployeeAdmin.View.Components.RolePanl in '..\View\Components\EmployeeAdmin.View.Components.RolePanl.pas' {RolePanel: TFrame},
  EmployeeAdmin.View.Components.UserFrm in '..\View\Components\EmployeeAdmin.View.Components.UserFrm.pas' {UserForm: TFrame},
  EmployeeAdmin.View.Components.UserLst in '..\View\Components\EmployeeAdmin.View.Components.UserLst.pas' {UserList: TFrame};

{$R *.res}
var
  MainWindow: TMainWindow;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainWindow, MainWindow);
  ApplicationFacade.Startup(MainWindow);
  Application.Run;
end.
