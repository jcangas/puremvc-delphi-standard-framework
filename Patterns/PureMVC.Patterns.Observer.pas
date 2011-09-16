unit PureMVC.Patterns.Observer;

interface

uses
  SummerFW.Utils.Collections,
  PureMVC.Interfaces.IObserver,
  PureMVC.Interfaces.INotification;

type
  TObserver = class(TInterfacedObject, IObserver)
  private
    FNotifyMethod: string;
    FNotifyContext: TObject;
  public
    constructor Create(Notify: string = ''; Context: TObject = nil);
    procedure NotifyObserver(Notification: INotification);
    function CompareNotifyContext(Other: TObject): Boolean;

    procedure SetNotifyMethod(const Value: string);
    property NotifyMethod: string write SetNotifyMethod;

    procedure SetNotifyContext(Value: TObject);
    property NotifyContext: TObject write SetNotifyContext;
  end;

  TObserverList = TObjectList<TObserver>;

implementation

function TObserver.CompareNotifyContext(Other: TObject): Boolean;
begin
  Result := FNotifyContext = Other;
end;

constructor TObserver.Create(Notify: string; Context: TObject);
begin
  FNotifyMethod := Notify;
  FNotifyContext := Context;
end;

procedure TObserver.NotifyObserver(Notification: INotification);
var
  M: TMethod;
begin
  M.Code := FNotifyContext.MethodAddress(FNotifyMethod);
  if M.Code = nil then Exit;
  M.Data := FNotifyContext;
  TNotifyHandler(M)(Notification);
end;

procedure TObserver.SetNotifyContext(Value: TObject);
begin
  FNotifyContext := Value;
end;

procedure TObserver.SetNotifyMethod(const Value: string);
begin
  FNotifyMethod := Value;
end;

end.
