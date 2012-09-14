{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Patterns.Mediator;

interface

uses
  SysUtils,
  RTTI,
  PureMVC.Utils,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.IMediator,
  PureMVC.Patterns.Notifier;

type
  /// <summary>
  ///  Tools for implements IMediator and Notification handle using CustomAttributes
  /// Attribute to mark a method as a PureMVC notification handler
  /// </summary>
  PureMVCNotifyAttribute = class(TCustomAttribute)
  private
    FNotificationName: string;
    FOrder: Integer;
  public
    constructor Create(const NotificationName: string; const Order: Integer=0);
    property NotificationName: string read FNotificationName;
    property Order: Integer read FOrder;
  end;

  /// <summary>
  ///  Tools for implements IMediator and Notification handle using CustomAttributes
  /// A helper to query and manage methods using PureMVCNotifyAttribute
  /// </summary>
  TPureMVCNotifyHelper = class Helper for TObject
  protected
    procedure InvokeByPureMVCNotify(NotificationName: string; Args: array of TValue);
  public
    procedure HandlePureMVCNotification(Notification: INotification);
    function GetPureMVCNotifyNames: IList<string>;
  end;


  /// <summary>
  ///  A default Mediator implementation based on PureMVCNotifyAttribute
  /// </summary>
  TMediator = class(TNotifier, IMediator, INotifier)
  private
    FMediatorName: string;
    FViewComponent: TObject;
  public
    function GetMediatorName: string;
    function GetViewComponent: TObject;
    procedure SetViewComponent(Value: TObject);virtual;
    procedure OnRemove; virtual;
    procedure OnRegister; virtual;
    function ListNotificationInterests: IList<string>; virtual;

    constructor Create(Name: string; AViewComponent: TObject);overload;
    constructor Create(View: TObject);overload;

    property MediatorName: string read GetMediatorName;
    property ViewComponent: TObject read GetViewComponent write SetViewComponent;
    procedure HandleNotification(Notification: INotification); virtual;
  end;

implementation

uses Generics.Defaults;

type
  TAttributePredicate = TPredicate<TCustomAttribute>;
  TAttributedMethod = record
  private
    FMethod: TRttiMethod;
    FByAttribute: TCustomAttribute;
  public
    constructor Create(AMethod: TRttiMethod; ByAttribute: TCustomAttribute);
    property Method: TRttiMethod read FMethod;
    property ByAttribute: TCustomAttribute read FByAttribute;
  end;

  TAttributedMethods = class(TList<TAttributedMethod>)
  private
    FSource: TObject;
    RC: TRttiContext;
    RType: TRttiType;
  public
    constructor Create(Source: TObject);
    destructor Destroy;override;
    function ByAttribute(AP: TAttributePredicate): TAttributedMethods;
    function Invoke(Args: array of TValue): TAttributedMethods;
  end;

  TAttributedMethodComparer = class(TComparer<TAttributedMethod>)
  public
    function Compare(const Left, Right: TAttributedMethod): Integer; override;
  end;

{ PureMVCNotifyAttribute }

constructor PureMVCNotifyAttribute.Create(const NotificationName: string; const Order: Integer=0);
begin
  inherited Create;
  FNotificationName := NotificationName;
  FOrder := Order;
end;

{ TAttributedMethodComparer }

function TAttributedMethodComparer.Compare(const Left, Right:  TAttributedMethod): Integer;
begin
  Result := PureMVCNotifyAttribute(Left.ByAttribute).Order - PureMVCNotifyAttribute(Right.ByAttribute).Order;
end;

{ TAttributedMethod }

constructor TAttributedMethod.Create(AMethod: TRttiMethod; ByAttribute: TCustomAttribute);
begin
  FMethod := AMethod;
  FByAttribute := ByAttribute;
end;

{ TAttributedMethods }

constructor TAttributedMethods.Create(Source: TObject);
begin
  inherited Create;
  FSource := Source;
  RC := TRttiContext.Create;
  RType := RC.GetType(FSource.ClassType) as TRttiType;
end;

destructor TAttributedMethods.Destroy;
begin
  RC.Free;
  inherited;
end;

function TAttributedMethods.Invoke(Args: array of TValue): TAttributedMethods;
var
  Item: TAttributedMethod;
begin
  Result := Self;
  for Item in Self do
    Item.Method.Invoke(FSource, Args);
end;

function TAttributedMethods.ByAttribute(AP: TAttributePredicate): TAttributedMethods;
var
  RMethod: TRttiMethod;
  Atr: TCustomAttribute;
begin
  Result := Self;
  try
    for RMethod in RType.GetMethods do begin
      for Atr in RMethod.GetAttributes do begin
        if AP(Atr) then begin
          Add(TAttributedMethod.Create(RMethod, Atr));
          Break;
        end;
      end;
    end;
    Sort;
  finally
    RC.Free;
  end;
end;

{ TMediatorHelper }

procedure TPureMVCNotifyHelper.InvokeByPureMVCNotify(NotificationName: string; Args: array of TValue);
var
  Comparer: IComparer<TAttributedMethod>;
begin
  with TAttributedMethods.Create(Self) do
  try
    ByAttribute(function(Atr: TCustomAttribute): Boolean begin
        Result := Atr.InheritsFrom(PureMVCNotifyAttribute) and
        (PureMVCNotifyAttribute(Atr).NotificationName = NotificationName);
    end);
    Comparer := TAttributedMethodComparer.Create;
    Sort(Comparer);
    Comparer := nil;;
    Invoke(Args);
  finally
    Free;
  end;
end;

procedure TPureMVCNotifyHelper.HandlePureMVCNotification(Notification: INotification);
begin
  InvokeByPureMVCNotify(Notification.Name, [TValue.From(Notification)]);
end;

function TPureMVCNotifyHelper.GetPureMVCNotifyNames: IList<string>;
var
  Item: TAttributedMethod;
  Methods: TAttributedMethods;
begin
  Result := TList<string>.Create;
  Methods := TAttributedMethods.Create(Self);
  try
    Methods.ByAttribute(function(Atr: TCustomAttribute): Boolean begin
        Result := Atr.InheritsFrom(PureMVCNotifyAttribute);
    end);
    for Item in Methods do begin
       Result.Add(PureMVCNotifyAttribute(Item.ByAttribute).NotificationName);
    end;
  finally
    Methods.Free;
  end;
end;

{ TMediator }

constructor TMediator.Create(Name: string; AViewComponent: TObject);
begin
  inherited Create;
  FMediatorName := Name;
  ViewComponent := AViewComponent;
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

procedure TMediator.OnRegister;
begin
end;

procedure TMediator.OnRemove;
begin
end;

procedure TMediator.HandleNotification(Notification: INotification);
begin
  HandlePureMVCNotification(Notification);
end;

function TMediator.ListNotificationInterests: IList<string>;
begin
  Result := GetPureMVCNotifyNames;
end;

end.
