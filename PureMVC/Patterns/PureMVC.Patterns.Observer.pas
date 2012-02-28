{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

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
begin
  FNotifyContext.HandlePureMVCNotification(FNotifyMethod, Notification);
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
