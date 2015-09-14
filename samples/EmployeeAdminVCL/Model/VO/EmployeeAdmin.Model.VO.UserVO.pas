{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.VO.UserVO;

interface
uses EmployeeAdmin.Model.Enum.DeptEnum;

type

  TUserVO = class(TObject)
  private
    FEmail: string;
    FLastName: string;
    FDepartment: TDeptEnum;
    FPassword: string;
    FFirstName: string;
    FUserName: string;
    function GetIsValid: Boolean;
    function GetGivenName: string;
  public
    constructor Create;overload;
    constructor Create(UName:string; FName: string; LName: string; Email: string; Password: string; Department: TDeptEnum);overload;
    function Equals(Other: TObject): Boolean;override;
		property UserName: string read FUserName;
    property FirstName: string read FFirstName;
    property LastName: string read FLastName;
		property Email: string read FEmail;
		property Password: string read FPassword;
		property Department: TDeptEnum read FDepartment;
		property IsValid: Boolean read GetIsValid;
		property GivenName: string read GetGivenName;
  end;

implementation

{ TUserVO }

constructor TUserVO.Create;
begin
  inherited Create;
  FDepartment := TDeptEnum.NONE_SELECTED;
end;

constructor TUserVO.Create(UName, FName, LName, Email, Password: string;
  Department: TDeptEnum);
begin
  Create;
	FUserName := UName;
	FFirstName := FName;
	FLastName := LName;
	FEmail := Email;
	FPassword := Password;
  FDepartment := Department;
end;

function TUserVO.Equals(Other: TObject): Boolean;
begin
  Result := (Other is TUserVO) and (Self.UserName = TUserVO(Other).UserName)
end;

function TUserVO.GetGivenName: string;
begin
  Result := LastName + ', ' + FirstName;
end;

function TUserVO.GetIsValid: Boolean;
begin
  Result :=(UserName <> '') and
    (Password <> '') and
    (Department <> TDeptEnum.NONE_SELECTED);
end;

end.
