{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.UserProxy;

interface

uses Generics.Collections,
  SummerFW.Utils.Collections,
  PureMVC.Interfaces.IProxy,
  PureMVC.Patterns.Proxy,
  EmployeeAdmin.Model.Enum.DeptEnum,
  EmployeeAdmin.Model.VO.RoleVO,
  EmployeeAdmin.Model.VO.UserVO;

type
  TUserProxy = class(TProxy, IProxy)
  private
    FUsers: IList<TUserVO>;
    function GetUsers: IList<TUserVO>;
  public
  const NAME = 'UserProxy';
    constructor Create;
    /// <summary>
    /// Return data property cast to proper type
    /// </summary>
    property Users: IList<TUserVO>read GetUsers;
    /// <summary>
    /// add an item to the data
    /// </summary>
    /// <param name="User"></param>
    procedure AddItem(User: TUserVO);
    /// <summary>
    /// update an item in the data
    /// </summary>
    /// <param name="User"></param>
    procedure UpdateItem(User: TUserVO);
    /// <summary>
    /// delete an item in the data
    /// </summary>
    /// <param name="User"></param>
    procedure DeleteItem(User: TUserVO);
  end;

implementation
uses RTTI;

{ TUserProxy }

procedure TUserProxy.AddItem(User: TUserVO);
begin
  Users.Add(User);
end;

constructor TUserProxy.Create;
begin
  FUsers := TList<TUserVO>.Create;
  inherited Create(NAME, TValue.From(FUsers));

  // generate some test data
  AddItem(TUserVO.Create('lstooge', 'Larry', 'Stooge', 'larry@stooges.com',
    'ijk456', TDeptEnum.ACCT));
  AddItem(TUserVO.Create('cstooge', 'Curly', 'Stooge', 'curly@stooges.com',
    'xyz987', TDeptEnum.SALES));
  AddItem(TUserVO.Create('mstooge', 'Moe', 'Stooge', 'moe@stooges.com',
    'abc123', TDeptEnum.PLANT));

end;

function TUserProxy.GetUsers: IList<TUserVO>;
begin
  Result := FUsers
end;

procedure TUserProxy.UpdateItem(User: TUserVO);
var
  i: Integer;
begin
  if Users.BinarySearch(User, i) then
    Users[i] := User;
end;

procedure TUserProxy.DeleteItem(User: TUserVO);
var
  i: Integer;
begin
  if Users.BinarySearch(User, i) then
      Users.Delete(i);
end;

end.
