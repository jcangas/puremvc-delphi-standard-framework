{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.VO.RoleVO;

interface
uses PureMVC.Utils,
  EmployeeAdmin.Model.Enum.RoleEnum;

type

	TRoleVO = class
  private
    FUserName: string;
		//TODO: ObservableCollection<RoleEnum> m_roles = new ObservableCollection<RoleEnum>();
    FRoles: IList<TRoleEnum>;
  public
		constructor Create(Username: string);overload;
		constructor Create(Username: string; Roles: IList<TRoleEnum>);overload;
		constructor Create(Username: string; const Roles: array of TRoleEnum);overload;

		property UserName: string read FUserName;
		property Roles: IList<TRoleEnum> read FRoles;
  end;

implementation

{ TRoleVO }

constructor TRoleVO.Create(Username: string);
begin
  inherited Create;
  FUserName := Username;

  // TODO: FRoles := TObservableCollection<TRoleEnum>();
  //public class ObservableCollection<T> : Collection<T>,	INotifyCollectionChanged, INotifyPropertyChanged
  FRoles := TList<TRoleEnum>.Create;
end;

constructor TRoleVO.Create(Username: string; Roles: IList<TRoleEnum>);
var
  Role: TRoleEnum;
begin
  inherited Create;
  Create(Username);

  if not Assigned(Roles) then Exit;

  for Role in Roles do
    FRoles.Add(Role);
end;

constructor TRoleVO.Create(Username: string; const Roles: array of TRoleEnum);
begin
  inherited Create;
  Create(Username);
  FRoles.AddRange(Roles);
end;

end.

