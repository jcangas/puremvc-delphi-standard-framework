unit EmployeeAdmin.MainWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids,
  EmployeeAdmin.View.Components.UserFrm,
  EmployeeAdmin.View.Components.UserLst,
  EmployeeAdmin.View.Components.RolePanl;

type
  TMainWindow = class(TForm)
    UserForm: TUserForm;
    UserList: TUserList;
    BottomArea: TPanel;
    RolePanel: TRolePanel;
  private
  public
  end;

implementation

{$R *.dfm}

end.
