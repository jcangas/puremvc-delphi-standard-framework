unit MainWin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, UserFrm, UserLst, RolePanl;

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
