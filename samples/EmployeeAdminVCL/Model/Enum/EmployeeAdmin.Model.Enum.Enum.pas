{
  PureMVC Delphi / EmployeeAdmin Demo
  By Jorge L. Cangas <jorge.cangas@puremvc.org>
  Copyright(c) 2012 Jorge L. Cangas, Some rights reserved.
}

unit EmployeeAdmin.Model.Enum.Enum;

interface

uses Classes, PureMVC.Utils;

type
  TEnumClass = class of TEnum;
  TEnum = class
  private
    FOrdinal: Integer;
    FValue: string;
  protected
    FIndex: Integer;
  public
    class function Count: Integer; virtual;abstract;
    class procedure Fill(L: TStrings);virtual;abstract;
    constructor Create(Value: string; Ordinal: Integer);virtual;
    function Equals(e: TObject): Boolean;override;
    function ToString: string;override;
    property Index : Integer read FIndex;
    property Ordinal: Integer read FOrdinal;
    property Value: string read FValue;
  end;

implementation

{ TEnum }

constructor TEnum.Create(Value: string; Ordinal: Integer);
begin
  inherited Create;
  FValue := Value;
  FOrdinal := Ordinal;
end;

function TEnum.Equals(e: TObject): Boolean;
begin
  Result := (e is TEnum) and (Ordinal = TEnum(e).Ordinal) and
    (Value = TEnum(e).Value);
end;

function TEnum.ToString: string;
begin
  Result := Value;
end;

end.
