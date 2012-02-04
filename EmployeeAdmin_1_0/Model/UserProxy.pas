{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit UserProxy;

interface

uses SummerFW.Utils.Collections,
  PureMVC.Interfaces.IProxy,
  PureMVC.Patterns.Proxy,
  DeptEnum,
  RoleVO,
  UserVO;

type
  TUserProxy = class(TProxy, IProxy)
  private
    function GetUsers: IList<TUserVO>;
  public const
    NAME = 'UserProxy';
    constructor Create;
    /// <summary>
    /// Return data property cast to proper type
    /// </summary>
    property Users: IList<TUserVO>read GetUsers;
    /// <summary>
    /// add an item to the data
    /// </summary>
    /// <param name="user"></param>
    procedure AddItem(User: TUserVO);
    /// <summary>
    /// update an item in the data
    /// </summary>
    /// <param name="user"></param>
    procedure UpdateItem(User: TUserVO);
    /// <summary>
    /// delete an item in the data
    /// </summary>
    /// <param name="user"></param>
    procedure DeleteItem(User: TUserVO);
  end;

implementation

{ TUserProxy }

{ TUserProxy }

procedure TUserProxy.AddItem(User: TUserVO);
begin
  Users.Add(User);
end;

constructor TUserProxy.Create;
begin
  // TODO: : base(NAME, new ObservableCollection<RoleVO>())
  inherited Create(NAME, TList<TRoleVO>.Create);

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
  Result := Data.AsType<IList<TUserVO>>;
end;

procedure TUserProxy.UpdateItem(User: TUserVO);
var
  i: Integer;
begin
  for i := 0 to Users.Count - 1 do
    if (Users[i].UserName = User.UserName) then begin
      Users[i] := User;
      Break;
    end;
end;

procedure TUserProxy.DeleteItem(User: TUserVO);
var
  i: Integer;
begin
  for i := 0 to Users.Count - 1 do
    if (Users[i].UserName = User.UserName) then begin
      Users.Delete(i);
      Break;
    end;
end;

end.
