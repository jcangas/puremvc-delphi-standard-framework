{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.Enum.DeptEnum;

interface

uses Classes,
  SummerFW.Utils.Collections,
  EmployeeAdmin.Model.Enum.Enum;

type
  TDeptEnum = class(TEnum)
  private
    class var FItems: array of TDeptEnum;
    class function GetItems(Index: Integer): TDeptEnum; static;
    class procedure SetItems(Index: Integer; Value: TDeptEnum); static;
public
    class function Count: Integer; override;
    class procedure Fill(L: TStrings); override;
    class property Items[Index: Integer]: TDeptEnum read GetItems write SetItems;
    constructor Create(Value: string; Ordinal: Integer);override;

    class property NONE_SELECTED: TDeptEnum index 0 read GetItems;
    class property ACCT: TDeptEnum index 1 read GetItems;
    class property SALES: TDeptEnum index 2 read GetItems;
    class property PLANT: TDeptEnum index 3 read GetItems;
    class property SHIPPING: TDeptEnum index 4 read GetItems;
    class property QC: TDeptEnum index 5 read GetItems;
  end;

implementation

{ TDeptEnum }

class function TDeptEnum.Count: Integer;
begin
  Result := Length(FItems);
end;

constructor TDeptEnum.Create(Value: string; Ordinal: Integer);
begin
  inherited;
  SetItems(Count, Self);
end;

class procedure TDeptEnum.Fill(L: TStrings);
var
  Item: TEnum;
begin
  for Item in FItems do
    L.AddObject(Item.Value, Item)
end;

class function TDeptEnum.GetItems(Index: Integer): TDeptEnum;
begin
  Result := FItems[Index];
end;

class procedure TDeptEnum.SetItems(Index: Integer; Value: TDeptEnum);
begin
  if Index >= Count then begin
    SetLength(FItems, 1 + Index);
  end;
  FItems[Index] := Value;
  Value.FIndex := Index;
end;

initialization

TDeptEnum.Create('-None Selected--', -1);
TDeptEnum.Create('Accounting', 0);
TDeptEnum.Create('Sales', 1);
TDeptEnum.Create('Plant', 2);
TDeptEnum.Create('Shipping', 3);
TDeptEnum.Create('Quality Control', 4);

end.
