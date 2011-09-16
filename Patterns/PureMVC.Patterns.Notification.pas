unit PureMVC.Patterns.Notification;

interface

uses Rtti,
  PureMVC.Interfaces.INotification;
type
  TNotification = class(TInterfacedObject, INotification)
  private
    FBody: TValue;
    FKind: TValue;
    FName: string;
    function GetBody: TValue;
    procedure SetBody(Value: TValue);
    function GetName: string;
    function GetKind: TValue;
    procedure SetKind(const Value: TValue);
  public
    constructor Create(Name: string; Body: TValue; Kind: TValue);
    function ToString: string;override;
    property Name: string read GetName;
    property Body: TValue read GetBody write SetBody;
    property Kind: TValue read GetKind write SetKind;
  end;

implementation
uses SysUtils;

constructor TNotification.Create(Name: string; Body: TValue ; Kind: TValue);
begin
  inherited Create;
  FName := Name;
  FBody := Body;
  FKind := Kind;
end;

function TNotification.GetBody: TValue;
begin
  Result := FBody;
end;

function TNotification.GetKind: TValue;
begin
  Result := FKind;
end;

function TNotification.GetName: string;
begin
  Result := FName
end;

procedure TNotification.SetBody(Value: TValue);
begin
  FBody := Value;
end;

procedure TNotification.SetKind(const Value: TValue);
begin
  FKind := Value;
end;

function TNotification.ToString: string;
begin
  Result := Format('<#Notification{%s, %s, %s}>', [Name, Body.AsString, Kind.AsString]);
end;

end.
