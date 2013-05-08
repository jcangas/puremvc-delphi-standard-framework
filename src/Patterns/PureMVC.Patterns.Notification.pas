{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Patterns.Notification;

interface

uses Rtti,
  PureMVC.Interfaces.INotification;
type
  TNotification = class(TInterfacedObject, INotification)
  private
    FSender: TObject;
    FBody: TValue;
    FKind: TValue;
    FName: string;
  protected
    function GetName: string;
    function GetSender: TObject;
    function GetBody: TValue;
    function GetKind: TValue;
    procedure SetName(Value: string);
    procedure SetSender(const Value: TObject);
    procedure SetBody(Value: TValue);
    procedure SetKind(const Value: TValue);
  public
    constructor Create(Name: string; Sender: TObject; Body: TValue; Kind: TValue);overload;
    constructor Create(Name: string; Sender: TObject; Body: TValue);overload;
    constructor Create(Name: string; Sender: TObject = nil);overload;
    function ToString: string;override;
    property Sender: TObject read GetSender;
    property Name: string read GetName;
    property Body: TValue read GetBody;
    property Kind: TValue read GetKind;
  end;

implementation
uses SysUtils;

constructor TNotification.Create(Name: string; Sender: TObject; Body: TValue ; Kind: TValue);
begin
  inherited Create;
  SetName(Name);
  SetSender(Sender);
  SetBody(Body);
  SetKind(Kind);
end;

constructor TNotification.Create(Name: string; Sender: TObject; Body: TValue);
begin
  Create(Name, Sender, Body, nil);
end;

constructor TNotification.Create(Name: string; Sender: TObject = nil);
begin
  Create(Name, Sender, nil, nil);
end;

function TNotification.GetName: string;
begin
  Result := FName
end;

function TNotification.GetSender: TObject;
begin
  Result := FSender;
end;

function TNotification.GetBody: TValue;
begin
  Result := FBody;
end;

function TNotification.GetKind: TValue;
begin
  Result := FKind;
end;

procedure TNotification.SetName(Value: string);
begin
  FName := Value;
end;

procedure TNotification.SetSender(const Value: TObject);
begin
  FSender := Value;
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
const
  ToStrFmt = 'Notification{Name:%s\nSender:%p\nBody:%s\nType:%s}';
begin
  Result := Format(ToStrFmt, [Name, Pointer(Sender), Body.AsString, Kind.AsString]);
end;

end.
