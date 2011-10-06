unit PureMVC.Patterns.Notifier;

interface

uses
  RTTI,
  PureMVC.Interfaces.INotifier;

type
  TNotifier = class(TInterfacedObject, INotifier)
  public
    procedure SendNotification(Sender: TObject; Name: string); overload;
    procedure SendNotification(Sender: TObject; Name: string; Body: TValue); overload;
    procedure SendNotification(Sender: TObject; Name: string; Body: TValue; Kind: TValue); overload;
  end;

implementation

uses
  PureMVC.Patterns.Facade;

procedure TNotifier.SendNotification(Sender: TObject; Name: string);
begin
  SendNotification(Sender, Name, nil, TValue.Empty);
end;

procedure TNotifier.SendNotification(Sender: TObject; Name: string; Body: TValue);
begin
  SendNotification(Sender, Name, Body, TValue.Empty);
end;

procedure TNotifier.SendNotification(Sender: TObject; Name: string; Body: TValue; Kind: TValue);
begin
  TFacade.Instance.SendNotification(Sender, Name, Body, Kind);
end;

end.
