{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.Enum.RoleEnum;

interface

uses
  Classes,
  PureMVC.Interfaces.Collections,
  EmployeeAdmin.Model.Enum.Enum;

type
  TRoleEnum = class(TEnum)
  private
  private
    class var FItems: array of TRoleEnum;
    class function GetItems(Index: Integer): TRoleEnum; static;
    class procedure SetItems(Index: Integer; Value: TRoleEnum); static;
  public
    class function Count: Integer; override;
    class procedure Fill(L: TStrings); override;
    class property Items[Index: Integer]: TRoleEnum read GetItems write SetItems;
    constructor Create(Value: string; Ordinal: Integer);override;

    class property NONE_SELECTED: TRoleEnum index 0 read GetItems;
    class property ADMIN: TRoleEnum index 1 read GetItems;
    class property ACCT_PAY: TRoleEnum index 2 read GetItems;
    class property ACCT_RCV: TRoleEnum index 3 read GetItems;
    class property EMP_BENEFITS: TRoleEnum index 4 read GetItems;
    class property GEN_LEDGER: TRoleEnum index 5 read GetItems;
    class property PAYROLL: TRoleEnum index 6 read GetItems;
    class property INVENTORY: TRoleEnum index 7 read GetItems;
    class property PRODUCTION: TRoleEnum index 8 read GetItems;
    class property QUALITY_CTL: TRoleEnum index 9 read GetItems;
    class property SALES: TRoleEnum index 10 read GetItems;
    class property ORDERS: TRoleEnum index 11 read GetItems;
    class property CUSTOMERS: TRoleEnum index 12 read GetItems;
    class property SHIPPING: TRoleEnum index 13 read GetItems;
    class property RETURNS: TRoleEnum index 14 read GetItems;
    class function List: IList<TRoleEnum>;
    class function ComboList: IList<TRoleEnum>;
  end;

implementation
uses
  PureMVC.Patterns.Collections;


{ TRoleEnum }

class function TRoleEnum.List: IList<TRoleEnum>;
var
  idx: Integer;
begin
  Result := TList<TRoleEnum>.Create;
  for idx := 1 to Self.Count - 1 do
    Result.Add(Self.Items[idx]);
end;

class function TRoleEnum.ComboList: IList<TRoleEnum>;
begin
  Result := List;
  Result.Insert(0, NONE_SELECTED);
end;

constructor TRoleEnum.Create(Value: string; Ordinal: Integer);
begin
  inherited;
  SetItems(Count, Self);
end;

class function TRoleEnum.Count: Integer;
begin
  Result := Length(FItems);
end;

class procedure TRoleEnum.Fill(L: TStrings);
var
  Item: TEnum;
begin
  for Item in FItems do
    L.AddObject(Item.Value, Item)
end;

class function TRoleEnum.GetItems(Index: Integer): TRoleEnum;
begin
  Result := FItems[Index];
end;

class procedure TRoleEnum.SetItems(Index: Integer; Value: TRoleEnum);
begin
  if Index >= Count then begin
    SetLength(FItems, 1 + Index);
  end;
  FItems[Index] := Value;
  Value.FIndex := Index;
end;

initialization

TRoleEnum.Create('--None Selected--', -1);
TRoleEnum.Create('Administrator', 0);
TRoleEnum.Create('Accounts Payable', 1);
TRoleEnum.Create('Accounts Receivable', 2);
TRoleEnum.Create('Employee Benefits', 3);
TRoleEnum.Create('General Ledger', 4);
TRoleEnum.Create('Payroll', 5);
TRoleEnum.Create('Inventory', 6);
TRoleEnum.Create('Production', 7);
TRoleEnum.Create('Quality Control', 8);
TRoleEnum.Create('Sales', 9);
TRoleEnum.Create('Orders', 10);
TRoleEnum.Create('Customers', 11);
TRoleEnum.Create('Shipping', 12);
TRoleEnum.Create('Returns', 13);

end.
