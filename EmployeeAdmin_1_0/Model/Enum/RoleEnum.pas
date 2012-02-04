{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit RoleEnum;

interface

uses SummerFW.Utils.Collections;

type

  TRoleEnum = class
  private
    m_ordinal: Integer;
    m_value: string;

  class var
    FNONE_SELECTED: TRoleEnum;
    FADMIN: TRoleEnum;
    FACCT_PAY: TRoleEnum;
    FACCT_RCV: TRoleEnum;
    FEMP_BENEFITS: TRoleEnum;
    FGEN_LEDGER: TRoleEnum;
    FPAYROLL: TRoleEnum;
    FINVENTORY: TRoleEnum;
    FPRODUCTION: TRoleEnum;
    FQUALITY_CTL: TRoleEnum;
    FSALES: TRoleEnum;
    FORDERS: TRoleEnum;
    FCUSTOMERS: TRoleEnum;
    FSHIPPING: TRoleEnum;
    FRETURNS: TRoleEnum;
  public
    class property NONE_SELECTED: TRoleEnum read FNONE_SELECTED;
    class property ADMIN: TRoleEnum read FADMIN;
    class property ACCT_PAY: TRoleEnum read FACCT_PAY;
    class property ACCT_RCV: TRoleEnum read FACCT_RCV;
    class property EMP_BENEFITS: TRoleEnum read FEMP_BENEFITS;
    class property GEN_LEDGER: TRoleEnum read FGEN_LEDGER;
    class property PAYROLL: TRoleEnum read FPAYROLL;
    class property INVENTORY: TRoleEnum read FINVENTORY;
    class property PRODUCTION: TRoleEnum read FPRODUCTION;
    class property QUALITY_CTL: TRoleEnum read FQUALITY_CTL;
    class property SALES: TRoleEnum read FSALES;
    class property ORDERS: TRoleEnum read FORDERS;
    class property CUSTOMERS: TRoleEnum read FCUSTOMERS;
    class property SHIPPING: TRoleEnum read FSHIPPING;
    class property RETURNS: TRoleEnum read FRETURNS;

    class function List: IList<TRoleEnum>;
    class function ComboList: IList<TRoleEnum>;
    constructor Create(Value: string; Ordinal: Integer);
    function Equals(e: TObject): Boolean; override;
    function ToString: string; override;
    property Ordinal: Integer read m_ordinal;
    property Value: string read m_value;
  end;

implementation

{ TRoleEnum }

class function TRoleEnum.List: IList<TRoleEnum>;
begin
  Result := TList<TRoleEnum>.Create;
  Result.Add(ADMIN);
  Result.Add(ACCT_PAY);
  Result.Add(ACCT_RCV);
  Result.Add(EMP_BENEFITS);
  Result.Add(GEN_LEDGER);
  Result.Add(PAYROLL);
  Result.Add(INVENTORY);
  Result.Add(PRODUCTION);
  Result.Add(QUALITY_CTL);
  Result.Add(SALES);
  Result.Add(ORDERS);
  Result.Add(CUSTOMERS);
  Result.Add(SHIPPING);
  Result.Add(RETURNS);
end;

function TRoleEnum.ToString: string;
begin
  Result := Value;
end;

class function TRoleEnum.ComboList: IList<TRoleEnum>;
begin
  Result := List;
  Result.Insert(0, NONE_SELECTED);
end;

constructor TRoleEnum.Create(Value: string; Ordinal: Integer);
begin
  inherited Create;
  m_value := Value;
  m_ordinal := Ordinal;
end;

function TRoleEnum.Equals(e: TObject): Boolean;
begin
  Result := (e is TRoleEnum) and (Ordinal = TRoleEnum(e).Ordinal) and
    (Value = TRoleEnum(e).Value);
end;

initialization

TRoleEnum.FNONE_SELECTED := TRoleEnum.Create('--None Selected--', -1);
TRoleEnum.FADMIN := TRoleEnum.Create('Administrator', 0);
TRoleEnum.FACCT_PAY := TRoleEnum.Create('Accounts Payable', 1);
TRoleEnum.FACCT_RCV := TRoleEnum.Create('Accounts Receivable', 2);
TRoleEnum.FEMP_BENEFITS := TRoleEnum.Create('Employee Benefits', 3);
TRoleEnum.FGEN_LEDGER := TRoleEnum.Create('General Ledger', 4);
TRoleEnum.FPAYROLL := TRoleEnum.Create('Payroll', 5);
TRoleEnum.FINVENTORY := TRoleEnum.Create('Inventory', 6);
TRoleEnum.FPRODUCTION := TRoleEnum.Create('Production', 7);
TRoleEnum.FQUALITY_CTL := TRoleEnum.Create('Quality Control', 8);
TRoleEnum.FSALES := TRoleEnum.Create('Sales', 9);
TRoleEnum.FORDERS := TRoleEnum.Create('Orders', 10);
TRoleEnum.FCUSTOMERS := TRoleEnum.Create('Customers', 11);
TRoleEnum.FSHIPPING := TRoleEnum.Create('Shipping', 12);
TRoleEnum.FRETURNS := TRoleEnum.Create('Returns', 13);

end.
