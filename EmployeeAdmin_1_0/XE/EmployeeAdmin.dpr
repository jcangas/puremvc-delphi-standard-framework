program EmployeeAdmin;

uses
  Forms,
  PureMVC.Patterns.Facade,
  MainWin in '..\View\MainWin.pas' {MainWindow},
  AddRoleResultCommand in '..\Controller\AddRoleResultCommand.pas',
  DeleteUserCommand in '..\Controller\DeleteUserCommand.pas',
  UserVO in '..\Model\VO\UserVO.pas',
  RoleProxy in '..\Model\RoleProxy.pas',
  UserProxy in '..\Model\UserProxy.pas',
  ApplicationFacade in '..\ApplicationFacade.pas',
  DeptEnum in '..\Model\Enum\DeptEnum.pas',
  RoleEnum in '..\Model\Enum\RoleEnum.pas',
  RoleVO in '..\Model\VO\RoleVO.pas',
  StartupCommand in '..\Controller\StartupCommand.pas',
  UserFormMediator in '..\View\UserFormMediator.pas',
  UserListMediator in '..\View\UserListMediator.pas',
  RolePanelMediator in '..\View\RolePanelMediator.pas',
  UserFrm in '..\View\Components\UserFrm.pas' {UserForm: TFrame},
  UserLst in '..\View\Components\UserLst.pas' {UserList: TFrame},
  RolePanl in '..\View\Components\RolePanl.pas' {RolePanel: TFrame};

{$R *.res}
var
  MainWindow: TMainWindow;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainWindow, MainWindow);
  (TFacade.Instance as IApplicationFacade).Startup(MainWindow);
  Application.Run;
end.
