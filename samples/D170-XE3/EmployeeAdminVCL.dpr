program EmployeeAdminVCL;

uses
  Vcl.Forms,
  EmployeeAdmin.Facade in '..\EmployeeAdminVCL\App\EmployeeAdmin.Facade.pas',
  EmployeeAdmin.MainWin in '..\EmployeeAdminVCL\App\EmployeeAdmin.MainWin.pas' {MainWindow},
  EmployeeAdmin.Controller.AddRoleResultCommand in '..\EmployeeAdminVCL\Controller\EmployeeAdmin.Controller.AddRoleResultCommand.pas',
  EmployeeAdmin.Controller.DeleteUserCommand in '..\EmployeeAdminVCL\Controller\EmployeeAdmin.Controller.DeleteUserCommand.pas',
  EmployeeAdmin.Controller.StartupCommand in '..\EmployeeAdminVCL\Controller\EmployeeAdmin.Controller.StartupCommand.pas',
  EmployeeAdmin.Model.RoleProxy in '..\EmployeeAdminVCL\Model\EmployeeAdmin.Model.RoleProxy.pas',
  EmployeeAdmin.Model.UserProxy in '..\EmployeeAdminVCL\Model\EmployeeAdmin.Model.UserProxy.pas',
  EmployeeAdmin.Model.VO.RoleVO in '..\EmployeeAdminVCL\Model\VO\EmployeeAdmin.Model.VO.RoleVO.pas',
  EmployeeAdmin.Model.VO.UserVO in '..\EmployeeAdminVCL\Model\VO\EmployeeAdmin.Model.VO.UserVO.pas',
  EmployeeAdmin.Model.Enum.DeptEnum in '..\EmployeeAdminVCL\Model\Enum\EmployeeAdmin.Model.Enum.DeptEnum.pas',
  EmployeeAdmin.Model.Enum.Enum in '..\EmployeeAdminVCL\Model\Enum\EmployeeAdmin.Model.Enum.Enum.pas',
  EmployeeAdmin.Model.Enum.RoleEnum in '..\EmployeeAdminVCL\Model\Enum\EmployeeAdmin.Model.Enum.RoleEnum.pas',
  EmployeeAdmin.View.RolePanelMediator in '..\EmployeeAdminVCL\View\EmployeeAdmin.View.RolePanelMediator.pas',
  EmployeeAdmin.View.UserFormMediator in '..\EmployeeAdminVCL\View\EmployeeAdmin.View.UserFormMediator.pas',
  EmployeeAdmin.View.UserListMediator in '..\EmployeeAdminVCL\View\EmployeeAdmin.View.UserListMediator.pas',
  EmployeeAdmin.View.Components.RolePanl in '..\EmployeeAdminVCL\View\Components\EmployeeAdmin.View.Components.RolePanl.pas' {RolePanel: TFrame},
  EmployeeAdmin.View.Components.UserFrm in '..\EmployeeAdminVCL\View\Components\EmployeeAdmin.View.Components.UserFrm.pas' {UserForm: TFrame},
  EmployeeAdmin.View.Components.UserLst in '..\EmployeeAdminVCL\View\Components\EmployeeAdmin.View.Components.UserLst.pas' {UserList: TFrame};

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
