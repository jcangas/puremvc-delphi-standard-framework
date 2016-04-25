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
  PureMVC.Interfaces.Collections,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.IMediator,
  PureMVC.Patterns.Notifier;

type
  /// <summary>
  /// Tools for implements IMediator and Notification handle using CustomAttributes
  /// Attribute to mark a method as a PureMVC notification handler.
  /// The method MUST have signature:
  /// procedure (Notification: INotification);
  /// Sample:
  /// [PureMVCNotify(AppMsg.DAO_CHANGED)]
  /// procedure DAOChanged(Notification: INotification);
  /// </summary>
  PureMVCNotifyAttribute = class(TCustomAttribute)
  private
    FNotificationName: string;
  public
    constructor Create(const NotificationName: string; const Order: Integer = 0);
    property NotificationName: string
      read FNotificationName;
  end;

  // Short alias
  PureMVCAttribute = PureMVCNotifyAttribute;

  /// <summary>
  /// Tools for implements IMediator and Notification handle using CustomAttributes
  /// A helper to query and manage methods using PureMVCNotifyAttribute
  /// </summary>
  TPureMVCNotifyHelper = class helper for TObject
  protected
    procedure InvokeByPureMVCNotify(NotificationName: string; Args: array of TValue);
  public
    procedure HandlePureMVCNotification(Notification: INotification);
    function GetPureMVCNotifyNames: IList<string>;
  end;

  /// <summary>
  /// A default Mediator implementation based on PureMVCNotifyAttribute
  /// </summary>
  TMediator = class(TNotifier, IMediator, INotifier)
  private
    FMediatorName: string;
    FViewComponent: TObject;
  public
    function GetMediatorName: string;
    function GetViewComponent: TObject;
    procedure SetViewComponent(Value: TObject); virtual;
    procedure OnRemove; virtual;
    procedure OnRegister; virtual;
    function ListNotificationInterests: IList<string>; virtual;

    constructor Create(Name: string = ''; AViewComponent: TObject = nil); overload;
    constructor Create(View: TObject); overload;

    property MediatorName: string
      read GetMediatorName;
    property ViewComponent: TObject
      read GetViewComponent
      write SetViewComponent;
    procedure HandleNotification(Notification: INotification); virtual;
  end;

implementation

uses
  System.Generics.Defaults,
  System.TypInfo,
  PureMVC.Patterns.Collections;

type
  TAttributeClass = class of TCustomAttribute;
  TCollectStrategy = (csAll, csFirstWins, csLastWins);

  TRttiObjectHelper = class helper for TRttiObject
  public
    function CollectAttributes(AttrClass: TAttributeClass; Strategy: TCollectStrategy = csAll): TObjectList<TCustomAttribute>;
  end;

  TAttributeCollector = class
  public type
    TAttrInfo<T: TRttiNamedObject> = record
      RTTI: T;
      Attrs: TCustomAttribute;
    end;

    TClassAttrInfo = TAttrInfo<TRttiInstanceType>;
    TMethodAttrInfo = TAttrInfo<TRttiMethod>;

    TMethodsInfoDict = TDictionary<string, TMethodAttrInfo>;

  strict private
    RC: TRttiContext;
    FAttrClassInfo: TClassAttrInfo;
    FAttrMethodsInfo: TMethodsInfoDict;
    FClassAttr: TAttributeClass;
    FMethodAttr: TAttributeClass;
    FMethodFilter: TPredicate<TRttiMethod>;
    function GetInfoKey(Info: TMethodAttrInfo): string;
  protected
    procedure CollectClassInfo(InstanceType: TRttiInstanceType);
    procedure CollectMethodInfo(Method: TRttiMethod);
    function AcceptMethod(Method: TRttiMethod): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Explore(ExploredClass: TClass);
    procedure ClassFilter(ClassAttr: TAttributeClass);
    procedure MethodFilter(MethodAttr: TAttributeClass; Filter: TPredicate<TRttiMethod> = nil);
    property ClassAttrInfo: TClassAttrInfo
      read FAttrClassInfo;
    property MethodsAttrInfo: TMethodsInfoDict
      read FAttrMethodsInfo;
  end;

  { TRttiObjectHelper }

function TRttiObjectHelper.CollectAttributes(AttrClass: TAttributeClass; Strategy: TCollectStrategy): TObjectList<TCustomAttribute>;
var
  Attr: TCustomAttribute;
begin
  Result := TObjectList<TCustomAttribute>.Create(False);
  for Attr in GetAttributes do begin
    if (AttrClass = nil) or not Attr.InheritsFrom(AttrClass) then Continue;
    case Strategy of
      csAll: Result.Add(Attr as AttrClass);
      csFirstWins: if (Result.Count = 0) then Result.Add(Attr as AttrClass);
      csLastWins: begin
          Result.Clear;
          Result.Add(Attr as AttrClass);
        end;
    end;
  end;
end;

{ TAttributeCollector }

constructor TAttributeCollector.Create;
begin
  inherited Create;
  FAttrMethodsInfo := TMethodsInfoDict.Create;
  FClassAttr := TCustomAttribute;
  FMethodAttr := TCustomAttribute;
end;

destructor TAttributeCollector.Destroy;
begin
  FAttrMethodsInfo.Free;
  inherited;
end;

function TAttributeCollector.AcceptMethod(Method: TRttiMethod): Boolean;
begin
  if not Assigned(FMethodFilter) then Exit(True);
  Result := FMethodFilter(Method);
end;

procedure TAttributeCollector.ClassFilter(ClassAttr: TAttributeClass);
begin
  FClassAttr := ClassAttr;
end;

procedure TAttributeCollector.CollectClassInfo(InstanceType: TRttiInstanceType);
var
  Method: TRttiMethod;
  CollectedAttrs: TObjectList<TCustomAttribute>;
begin
  FAttrClassInfo.RTTI := InstanceType;
  CollectedAttrs := InstanceType.CollectAttributes(FClassAttr, csLastWins);
  try
    if (CollectedAttrs <> nil) and (CollectedAttrs.Count > 0) then FAttrClassInfo.Attrs := CollectedAttrs.First;

    for Method in InstanceType.GetDeclaredMethods do begin
      CollectMethodInfo(Method);
    end;
  finally
    CollectedAttrs.Free;
  end;
end;

function TAttributeCollector.GetInfoKey(Info: TMethodAttrInfo): string;
begin
  Result := (Info.Attrs as PureMVCNotifyAttribute).NotificationName;
end;

procedure TAttributeCollector.CollectMethodInfo(Method: TRttiMethod);
var
  Info: TMethodAttrInfo;
  CollectedAttrs: TObjectList<TCustomAttribute>;
begin
  if not AcceptMethod(Method) then Exit;
  FAttrMethodsInfo.TryGetValue(Method.Name, Info);
  Info.RTTI := Method;
  CollectedAttrs := Method.CollectAttributes(FMethodAttr, csLastWins);
  try
    if not(CollectedAttrs.Count = 0) then Info.Attrs := CollectedAttrs.First;

    if Assigned(Info.Attrs) then FAttrMethodsInfo.AddOrSetValue(GetInfoKey(Info), Info);
  finally
    CollectedAttrs.Free;
  end;
end;

procedure TAttributeCollector.Explore(ExploredClass: TClass);
var
  RType: TRttiInstanceType;
begin
  if ExploredClass.ClassParent <> nil then Explore(ExploredClass.ClassParent);
  RType := RC.GetType(ExploredClass) as TRttiInstanceType;
  CollectClassInfo(RType);
end;

procedure TAttributeCollector.MethodFilter(MethodAttr: TAttributeClass; Filter: TPredicate<TRttiMethod> = nil);
begin
  FMethodAttr := FMethodAttr;
  FMethodFilter := Filter;
end;

{ PureMVCNotifyAttribute }

constructor PureMVCNotifyAttribute.Create(const NotificationName: string; const Order: Integer = 0);
begin
  inherited Create;
  FNotificationName := NotificationName;
end;

{ TMediatorHelper }

procedure TPureMVCNotifyHelper.HandlePureMVCNotification(Notification: INotification);
begin
  InvokeByPureMVCNotify(Notification.Name, [TValue.From(Notification)]);
end;

procedure TPureMVCNotifyHelper.InvokeByPureMVCNotify(NotificationName: string; Args: array of TValue);
var
  Collector: TAttributeCollector;
  MethodInfo: TAttributeCollector.TMethodAttrInfo;
  Attr: PureMVCNotifyAttribute;
begin
  Collector := TAttributeCollector.Create;
  try
    Collector.MethodFilter(PureMVCNotifyAttribute,
      function(Method: TRttiMethod): Boolean
      begin
        Result := Method.Visibility in [mvProtected, mvPublic, mvPublished];
      end);
    Collector.Explore(Self.ClassType);
    if Collector.MethodsAttrInfo.TryGetValue(NotificationName, MethodInfo) then
        MethodInfo.RTTI.Invoke(Self, Args);
  finally
    Collector.Free;
  end;
end;

function TPureMVCNotifyHelper.GetPureMVCNotifyNames: IList<string>;
var
  Collector: TAttributeCollector;
  MethodInfo: TAttributeCollector.TMethodAttrInfo;
  Attr: PureMVCNotifyAttribute;
begin
  Result := TList<string>.Create;
  Collector := TAttributeCollector.Create;
  try
    Collector.MethodFilter(PureMVCNotifyAttribute,
      function(Method: TRttiMethod): Boolean
      begin
        Result := Method.Visibility in [mvProtected, mvPublic, mvPublished];
      end);
    Collector.Explore(Self.ClassType);
    Result.AddRange(Collector.MethodsAttrInfo.Keys);
    (*
    for MethodInfo in Collector.MethodsAttrInfo.Values do begin
      Attr := MethodInfo.Attrs as PureMVCNotifyAttribute;
      Result.Add(Attr.NotificationName);
    end;
    *)
  finally
    Collector.Free;
  end;
end;

{ TMediator }

constructor TMediator.Create(Name: string; AViewComponent: TObject);
begin
  inherited Create;
  if name = '' then name := ClassName;
  FMediatorName := name;
  ViewComponent := AViewComponent;
end;

constructor TMediator.Create(View: TObject);
begin
  Create('', View);
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
