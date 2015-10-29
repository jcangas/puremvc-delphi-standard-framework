{
  PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
  PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
  Your reuse is governed by the Creative Commons Attribution 3.0 License
}
unit PureMVC.Core.View;

interface

uses
  SysUtils,
  PureMVC.Patterns.Collections,
  PureMVC.Patterns.Observer,
  PureMVC.Interfaces.Collections,
  PureMVC.Interfaces.IObserver,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IMediator,
  PureMVC.Interfaces.IView;

type
  /// <summary>
  /// A Singleton <c>IView</c> implementation.
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, the <c>View</c> class assumes these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Maintain a cache of <c>IMediator</c> instances</item>
  /// <item>Provide methods for registering, retrieving, and removing <c>IMediators</c></item>
  /// <item>Managing the observer lists for each <c>INotification</c> in the application</item>
  /// <item>Providing a method for attaching <c>IObservers</c> to an <c>INotification</c>'s observer list</item>
  /// <item>Providing a method for broadcasting an <c>INotification</c></item>
  /// <item>Notifying the <c>IObservers</c> of a given <c>INotification</c> when it broadcast</item>
  /// </list>
  /// </remarks>
  /// <see cref="PureMVC.Patterns.Mediator"/>
  /// <see cref="PureMVC.Patterns.Observer"/>
  /// <see cref="PureMVC.Patterns.Notification"/>
  TView = class(TInterfacedObject, IView)
    {$REGION 'Constructors'}
    /// <summary>
    /// Constructs and initializes a new view
    /// </summary>
    /// <remarks>
    /// <para>This <c>IView</c> implementation is a Singleton, so you should not call the constructor directly, but instead call the static Singleton Factory method <c>View.Instance</c></para>
    /// </remarks>
  protected
    constructor Create;
    procedure InitializeView; virtual;
  private

    {$ENDREGION}
  public
    destructor Destroy; override;
    class function Instance: IView; static;

    /// <summary>
    /// Register an <c>IObserver</c> to be notified of <c>INotifications</c> with a given name
    /// </summary>
    /// <param name="NotificationName">The name of the <c>INotifications</c> to notify this <c>IObserver</c> of</param>
    /// <param name="Observer">The <c>IObserver</c> to register</param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    procedure RegisterObserver(NotificationName: string; Observer: IObserver); virtual;

    /// <summary>
    /// Remove the observer for a given notifyContext from an observer list for a given Notification name.
    /// </summary>
    /// <param name="NotificationName">which observer list to remove from</param>
    /// <param name="NotifyContext">remove the observer with this object as its notifyContext</param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    procedure RemoveObserver(NotificationName: string; NotifyContext: TObject); virtual;

    /// <summary>
    /// Notify the <c>IObservers</c> for a particular <c>INotification</c>
    /// </summary>
    /// <param name="Notification">The <c>INotification</c> to notify <c>IObservers</c> of</param>
    /// <remarks>
    /// <para>All previously attached <c>IObservers</c> for this <c>INotification</c>'s list are notified and are passed a reference to the <c>INotification</c> in the order in which they were registered</para>
    /// </remarks>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    procedure NotifyObservers(Notification: INotification); virtual;

    /// <summary>
    /// Register an <c>IMediator</c> instance with the <c>View</c>
    /// </summary>
    /// <param name="Mediator">A reference to the <c>IMediator</c> instance</param>
    /// <remarks>
    /// <para>Registers the <c>IMediator</c> so that it can be retrieved by name, and further interrogates the <c>IMediator</c> for its <c>INotification</c> interests</para>
    /// <para>If the <c>IMediator</c> returns any <c>INotification</c> names to be notified about, an <c>Observer</c> is created encapsulating the <c>IMediator</c> instance's <c>handleNotification</c> method and registering it as an <c>Observer</c> for all <c>INotifications</c> the <c>IMediator</c> is interested in</para>
    /// </remarks>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    procedure RegisterMediator(Mediator: IMediator); virtual;

    /// <summary>
    /// Retrieve an <c>IMediator</c> from the <c>View</c>
    /// </summary>
    /// <param name="MediatorName">The name of the <c>IMediator</c> instance to retrieve</param>
    /// <returns>The <c>IMediator</c> instance previously registered with the given <c>mediatorName</c></returns>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    function RetrieveMediator(MediatorName: string): IMediator; virtual;

    /// <summary>
    /// Remove an <c>IMediator</c> from the <c>View</c>
    /// </summary>
    /// <param name="MediatorName">The name of the <c>IMediator</c> instance to be removed</param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    function RemoveMediator(MediatorName: string): IMediator; overload; virtual;
    function RemoveMediator(Mediator: IMediator): IMediator; overload;

    /// <summary>
    /// Check if a Mediator is registered or not
    /// </summary>
    /// <param name="MediatorName"></param>
    /// <returns>whether a Mediator is registered with the given <code>mediatorName</code>.</returns>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    function HasMediator(MediatorName: string): Boolean; overload; virtual;
    function HasMediator(Mediator: IMediator): Boolean; overload;

    {$REGION 'Members'}
  protected
    /// <summary>
    /// Mapping of Mediator names to Mediator instances
    /// </summary>
    FMediatorMap: TDictionary<string, IMediator>;

    /// <summary>
    /// Mapping of Notification names to Observer lists
    /// </summary>
    FObserverMap: TDictionary<string, IList<IObserver>>;

    /// <summary>
    /// Used for locking
    /// </summary>
    FSyncRoot: TObject; // readonly

    /// <summary>
    /// Singleton instance
    /// </summary>
    class var FInstance: IView; // volatile

    /// <summary>
    /// Used for locking the instance calls
    /// </summary>
    class var FStaticSyncRoot: TObject; // readonly

    {$ENDREGION}
  end;

implementation

{ TView }

constructor TView.Create;
begin
  inherited;
  FSyncRoot := TObject.Create;
  FMediatorMap := TDictionary<string, IMediator>.Create;
  FObserverMap := TDictionary < string, IList < IObserver >>.Create;
  InitializeView;
end;

destructor TView.Destroy;
begin
  FSyncRoot.Free;
  FMediatorMap.Free;
  FObserverMap.Free;
end;

{$REGION 'Public Methods'}
{$REGION 'IView Members'}
{$REGION 'Observer'}

procedure TView.RegisterObserver(NotificationName: string; Observer: IObserver);
begin
  TMonitor.Enter(FSyncRoot);
  try
    if not FObserverMap.ContainsKey(NotificationName) then FObserverMap.Add(NotificationName, TList<IObserver>.Create);
    FObserverMap[NotificationName].Add(Observer);
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

procedure TView.RemoveObserver(NotificationName: string; NotifyContext: TObject);
var
  Observers: IList<IObserver>;
  I: Integer;
begin
  TMonitor.Enter(FSyncRoot);
  try
    if not(FObserverMap.ContainsKey(NotificationName)) then Exit;

    // the observer list for the notification under inspection
    Observers := FObserverMap[NotificationName];

    // find the observer for the notifyContext
    for I := 0 to (Observers.Count - 1) do begin
      if (Observers[I].CompareNotifyContext(NotifyContext)) then begin
        // there can only be one Observer for a given notifyContext
        // in any given Observer list, so remove it and break
        Observers.Delete(I);
        Break;
      end;
    end;

    // Also, when a Notification's Observer list length falls to
    // zero, delete the notification key from the observer map
    if (Observers.Count = 0) then FObserverMap.Remove(NotificationName);

  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

procedure TView.NotifyObservers(Notification: INotification);
var
  Observers: IList<IObserver>;
  ObserversRef: IList<IObserver>;
  Observer: IObserver;
begin
  Observers := nil;
  TMonitor.Enter(FSyncRoot);
  try
    if not(FObserverMap.ContainsKey(Notification.Name)) then Exit;

    // Get a reference to the observers list for this notification name
    ObserversRef := FObserverMap[Notification.Name];
    // Copy observers from reference array to working array,
    // since the reference array may change during the notification loop
    Observers := TList<IObserver>.Create(ObserversRef);

  finally
    TMonitor.Exit(FSyncRoot);
  end;

  // Notify outside of the lock
  if (Observers = nil) then Exit;

  // Notify Observers from the working array
  for Observer in Observers do Observer.NotifyObserver(Notification);

end;

{$ENDREGION}
{$REGION 'Mediator'}
{$ENDREGION}

procedure TView.RegisterMediator(Mediator: IMediator);
var
  Interest: string;
  Interests: IList<string>;
  Observer: IObserver;
begin
  TMonitor.Enter(FSyncRoot);
  try
    // do not allow re-registration (you must do RemoveMediator first)
    if (FMediatorMap.ContainsKey(Mediator.MediatorName)) then Exit;

    // Register the Mediator for retrieval by name
    FMediatorMap.Add(Mediator.MediatorName, Mediator);

    // Get Notification interests, if any.
    Interests := Mediator.ListNotificationInterests;

    // Register Mediator as an observer for each of its notification interests
    if (Interests.Count > 0) then begin
      // Create Observer
      Observer := TObserver.Create('HandleNotification', TObject(Mediator));

      // Register Mediator as Observer for its list of Notification interests
      for Interest in Interests do RegisterObserver(Interest, Observer);
    end;
    // alert the mediator that it has been registered
    Mediator.OnRegister();

  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

function TView.RetrieveMediator(MediatorName: string): IMediator;
begin
  TMonitor.Enter(FSyncRoot);
  try
    if not(FMediatorMap.ContainsKey(MediatorName)) then Exit(nil);
    Result := FMediatorMap[MediatorName];
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

function TView.HasMediator(MediatorName: string): Boolean;
begin
  TMonitor.Enter(FSyncRoot);
  try
    Result := FMediatorMap.ContainsKey(MediatorName);
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

function TView.HasMediator(Mediator: IMediator): Boolean;
begin
  TMonitor.Enter(FSyncRoot);
  try
    Result := FMediatorMap.ContainsValue(Mediator);
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

/// <summary>
/// Remove an <c>IMediator</c> from the <c>View</c>
/// </summary>
/// <param name="MediatorName">The name of the <c>IMediator</c> instance to be removed</param>
/// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>

function TView.RemoveMediator(MediatorName: string): IMediator;
var
  Interests: IList<string>;
  Mediator: IMediator;
  Interest: string;

begin
  TMonitor.Enter(FSyncRoot);
  try
    // Retrieve the named mediator
    if not(FMediatorMap.ContainsKey(MediatorName)) then Exit(nil);

    Mediator := FMediatorMap[MediatorName];

    // for every notification this mediator is interested in...
    Interests := Mediator.ListNotificationInterests;

    // remove the observer linking the mediator to the notification interest
    for Interest in Interests do RemoveObserver(Interest, TObject(Mediator));

    // remove the mediator from the map
    FMediatorMap.Remove(MediatorName);
    Result := Mediator;
  finally
    TMonitor.Exit(FSyncRoot);
  end;
  // alert the mediator that it has been removed
  if Assigned(Result) then Result.OnRemove();
end;

function TView.RemoveMediator(Mediator: IMediator): IMediator;
begin
  if Mediator = nil then Exit(nil);
  // Ensure we not remove an unregistered mediator
  if not HasMediator(Mediator) then Exit(nil);
  Result := RemoveMediator(Mediator.MediatorName);
end;

{$ENDREGION}
{$ENDREGION}
{$ENDREGION}
{$REGION 'Accessors'}

/// <summary>
/// View Singleton Factory method.  This method is thread safe.
/// </summary>
class function TView.Instance: IView;
begin
  if (FInstance = nil) then begin
    TMonitor.Enter(FStaticSyncRoot);
    try
      if (FInstance = nil) then FInstance := TView.Create;
    finally
      TMonitor.Exit(FStaticSyncRoot);
    end;
  end;
  Result := FInstance;
end;

{$ENDREGION}
{$REGION 'Protected & Internal Methods'}
/// <summary>
/// Initialize the Singleton View instance
/// </summary>
/// <remarks>
/// <para>Called automatically by the constructor, this is your opportunity to initialize the Singleton instance in your subclass without overriding the constructor</para>
/// </remarks>

// protected virtual
procedure TView.InitializeView;
begin
end;

{$ENDREGION}

initialization

TView.FStaticSyncRoot := TObject.Create;

finalization

FreeAndNil(TView.FStaticSyncRoot);

end.
