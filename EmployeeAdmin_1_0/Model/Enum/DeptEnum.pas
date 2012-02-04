{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit DeptEnum;

interface

uses SummerFW.Utils.Collections;

type

  TDeptEnum = class(TObject)
  private
    FOrdinal: Integer;
    FValue: string;

  class var
    FNONE_SELECTED: TDeptEnum;
    FACCT: TDeptEnum;
    FSALES: TDeptEnum;
    FPLANT: TDeptEnum;
    FSHIPPING: TDeptEnum;
    FQC: TDeptEnum;
  public
    class property NONE_SELECTED: TDeptEnum read FNONE_SELECTED;
    class property ACCT: TDeptEnum read FACCT;
    class property SALES: TDeptEnum read FSALES;
    class property PLANT: TDeptEnum read FPLANT;
    class property SHIPPING: TDeptEnum read FSHIPPING;
    class property QC: TDeptEnum read FQC;

    class function List: IList<TDeptEnum>;
    class function ComboList: IList<TDeptEnum>;

    constructor Create(Value: string; Ordinal: Integer);
    function Equals(Other: TObject): Boolean; override;
    function ToString: string; override;
    property Ordinal: Integer read FOrdinal;
    property Value: string read FValue;
  end;

implementation

{ TDeptEnum }

class function TDeptEnum.ComboList: IList<TDeptEnum>;
begin
  Result := List;
  Result.Insert(0, NONE_SELECTED);
end;

constructor TDeptEnum.Create(Value: string; Ordinal: Integer);
begin
  inherited Create;
  FValue := Value;
  FOrdinal := Ordinal;
end;

function TDeptEnum.Equals(Other: TObject): Boolean;
begin
  Result := (Other is TDeptEnum) and (Ordinal = TDeptEnum(Other).Ordinal) and
    (Value = TDeptEnum(Other).Value);
end;

class function TDeptEnum.List: IList<TDeptEnum>;
begin
  Result := TList<TDeptEnum>.Create;
  Result.Add(ACCT);
  Result.Add(SALES);
  Result.Add(PLANT);
end;

function TDeptEnum.ToString: string;
begin
  Result := Value;
end;

initialization

TDeptEnum.FNONE_SELECTED := TDeptEnum.Create('-None Selected--', -1);
TDeptEnum.FACCT := TDeptEnum.Create('Accounting', 0);
TDeptEnum.FSALES := TDeptEnum.Create('Sales', 1);
TDeptEnum.FPLANT := TDeptEnum.Create('Plant', 2);
TDeptEnum.FSHIPPING := TDeptEnum.Create('Shipping', 3);
TDeptEnum.FQC := TDeptEnum.Create('Quality Control', 4);

end.
