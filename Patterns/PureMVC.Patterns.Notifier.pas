unit PureMVC.Patterns.Notifier;

interface

uses
  RTTI,
  PureMVC.Interfaces.INotifier;

type
  TNotifier = class(TInterfacedObject, INotifier)
  public
    procedure SendNotification(name: string); overload;
    procedure SendNotification(name: string; Body: TValue); overload;
    procedure SendNotification(name: string; Body: TValue; Kind: TValue); overload;
  end;

implementation

uses
  PureMVC.Patterns.Facade;

procedure TNotifier.SendNotification(name: string);
begin
  SendNotification(name, nil, TValue.Empty);
end;

procedure TNotifier.SendNotification(name: string; Body: TValue);
begin
  SendNotification(name, Body, TValue.Empty);
end;

procedure TNotifier.SendNotification(name: string; Body: TValue; Kind: TValue);
begin
  TFacade.Instance.SendNotification(name, Body, Kind);
end;

end.
