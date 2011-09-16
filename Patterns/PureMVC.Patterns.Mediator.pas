unit PureMVC.Patterns.Mediator;

interface

uses
  SummerFW.Utils.Collections,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.IMediator,
  PureMVC.Patterns.Notifier;

type
{$M+}
  TMediator = class(TNotifier, IMediator, INotifier)
  private
    FMediatorName: string;
    FViewComponent: TObject;
  public
    function GetMediatorName: string;
    function GetViewComponent: TObject;
    procedure SetViewComponent(Value: TObject);
    procedure OnRemove; virtual;
    procedure OnRegister; virtual;
    function ListNotificationInterests: IList<string>; virtual;

    constructor Create(Name: string; AViewComponent: TObject);overload;
    constructor Create(View: TObject);overload;

    property MediatorName: string read GetMediatorName;
    property ViewComponent: TObject read GetViewComponent write SetViewComponent;
  published
    procedure HandleNotification(Notification: INotification); virtual;
  end;
{$M-}

implementation

constructor TMediator.Create(Name: string; AViewComponent: TObject);
begin
  inherited Create;
  FMediatorName := Name;
  FViewComponent := AViewComponent;
end;

constructor TMediator.Create(View: TObject);
begin
  Create(ClassName, View);
end;

function TMediator.GetMediatorName: string;
begin
  Result := FMediatorName;
end;

function TMediator.GetViewComponent: TObject;
begin
  Result := FViewComponent;
end;

procedure TMediator.SetViewComponent(Value: TObject);
begin
  FViewComponent := Value;
end;

procedure TMediator.HandleNotification(Notification: INotification);
var
  M: TMethod;
begin
  M.Code := MethodAddress(Notification.Name);
  if M.Code = nil then
    Exit;
  M.Data := Self;
  TNotifyHandler(M)(Notification);
end;

function TMediator.ListNotificationInterests: IList<string>;
begin
  Result := nil;
end;

procedure TMediator.OnRegister;
begin
end;

procedure TMediator.OnRemove;
begin
end;

end.
