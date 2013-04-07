{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.RoleProxy;

interface

uses PureMVC.Utils,
  PureMVC.Interfaces.IProxy,
  PureMVC.Patterns.Proxy,
  EmployeeAdmin.Model.Enum.RoleEnum,
  EmployeeAdmin.Model.VO.RoleVO,
  EmployeeAdmin.Model.VO.UserVO;

type
  TRoleProxy = class(TProxy, IProxy)
  private
    FRoles: IList<TRoleVO>;
    function GetRoles: IList<TRoleVO>;
  public const
    NAME = 'RoleProxy';

    constructor Create;

    /// <summary>
    /// get the data property cast to the appropriate type
    /// </summary>
    property Roles: IList<TRoleVO>read GetRoles;

    /// <summary>
    /// add an item to the data
    /// </summary>
    /// <param name="Role"></param>
    procedure AddItem(Role: TRoleVO);
    /// <summary>
    /// delete an item from the data
    /// </summary>
    /// <param name="User"></param>
    procedure DeleteItem(User: TUserVO);
    /// <summary>
    /// determine if the user has a given role
    /// </summary>
    /// <param name="User"></param>
    /// <param name="Role"></param>
    /// <returns></returns>
    function DoesUserHaveRole(User: TUserVO; Role: TRoleEnum): Boolean;
    /// <summary>
    /// add a role to this user
    /// </summary>
    /// <param name="User"></param>
    /// <param name="Role"></param>
    function AddRoleToUser(User: TUserVO; Role: TRoleEnum): Boolean;
    /// <summary>
    /// remove a role from the user
    /// </summary>
    /// <param name="User"></param>
    /// <param name="Role"></param>
    procedure RemoveRoleFromUser(User: TUserVO; Role: TRoleEnum);
    /// <summary>
    // get a user"s roles
    /// </summary>
    function GetUserRoles(Username: string): IList<TRoleEnum>;
  end;

implementation

uses RTTI, EmployeeAdmin.Facade;

{ TRoleProxy }

procedure TRoleProxy.AddItem(Role: TRoleVO);
begin
  Roles.Add(Role);
end;

constructor TRoleProxy.Create;
begin
  FRoles := TList<TRoleVO>.Create;
  inherited Create(NAME, TValue.From(FRoles));
  // generate some test data
  AddItem(TRoleVO.Create('lstooge', [TRoleEnum.PAYROLL,
    TRoleEnum.EMP_BENEFITS]));

  AddItem(TRoleVO.Create('cstooge', [TRoleEnum.ACCT_PAY, TRoleEnum.ACCT_RCV,
    TRoleEnum.GEN_LEDGER]));

  AddItem(TRoleVO.Create('mstooge', [TRoleEnum.INVENTORY, TRoleEnum.PRODUCTION,
    TRoleEnum.SALES, TRoleEnum.SHIPPING]));
end;

procedure TRoleProxy.DeleteItem(User: TUserVO);
var
  Role: TRoleVO;
begin
  for Role in Roles do
    if (Role.Username = User.Username) then begin
      Roles.Remove(Role);
      Exit;
    end;
end;

function TRoleProxy.GetRoles: IList<TRoleVO>;
begin
  Result := FRoles;
end;

function TRoleProxy.GetUserRoles(Username: string): IList<TRoleEnum>;
var
  R: TRoleVO;
begin
  for R in Roles do
    if (R.Username = Username) then Exit(R.Roles);

  Result := TList<TRoleEnum>.Create;
end;

function TRoleProxy.DoesUserHaveRole(User: TUserVO; Role: TRoleEnum): Boolean;
var
  R: TRoleVO;
  UserRoles: IList<TRoleEnum>;
begin
 for R in Roles do begin
    if (R.Username <> User.Username) then Continue;
    UserRoles := R.Roles;
    if UserRoles.Contains(Role) then Exit(True);
  end;
  Result := False;
end;

function TRoleProxy.AddRoleToUser(User: TUserVO; Role: TRoleEnum): Boolean;
var
  R: TRoleVO;
  UserRoles: IList<TRoleEnum>;
begin
  Result := False;
  if not DoesUserHaveRole(User, Role) then
    for R in Roles do begin
      if (R.Username <> User.Username) then Continue;
      UserRoles := R.Roles;
      UserRoles.Add(Role);
      Result := True;
      Break;
    end;
end;

procedure TRoleProxy.RemoveRoleFromUser(User: TUserVO; Role: TRoleEnum);
var
  R: TRoleVO;
  UserRoles: IList<TRoleEnum>;
  CurRole: TRoleEnum;
begin
  if not DoesUserHaveRole(User, Role) then Exit;
  for R in Roles do begin
    if (R.Username <> User.Username) then Continue;
    UserRoles := R.Roles;
    for curRole in UserRoles do begin
      if not(curRole.Equals(Role)) then Continue;
      UserRoles.Remove(Role);
      Exit;
    end;
    Exit;
  end;
end;

end.
