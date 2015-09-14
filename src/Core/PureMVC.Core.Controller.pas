{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Core.Controller;

interface

uses
  SysUtils,
  PureMVC.Patterns.Collections,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IController,
  PureMVC.Interfaces.ICommand,
  PureMVC.Interfaces.IView,
  PureMVC.Patterns.Observer,
  PureMVC.Patterns.Command;

/// <summary>
/// A Singleton <c>IController</c> implementation.
/// </summary>
/// <remarks>
/// <para>In PureMVC, the <c>Controller</c> class follows the 'Command and Controller' strategy, and assumes these responsibilities:</para>
/// <list type="bullet">
/// <item>Remembering which <c>ICommand</c>s are intended to handle which <c>INotifications</c>.</item>
/// <item>Registering itself as an <c>IObserver</c> with the <c>View</c> for each <c>INotification</c> that it has an <c>ICommand</c> mapping for.</item>
/// <item>Creating a new instance of the proper <c>ICommand</c> to handle a given <c>INotification</c> when notified by the <c>View</c>.</item>
/// <item>Calling the <c>ICommand</c>'s <c>execute</c> method, passing in the <c>INotification</c>.</item>
/// </list>
/// <para>Your application must register <c>ICommands</c> with the <c>Controller</c>.</para>
/// <para>The simplest way is to subclass <c>Facade</c>, and use its <c>initializeController</c> method to add your registrations.</para>
/// </remarks>
/// <see cref="PureMVC.Core.View"/>
/// <see cref="PureMVC.Patterns.Observer"/>
/// <see cref="PureMVC.Patterns.Notification"/>
/// <see cref="PureMVC.Patterns.SimpleCommand"/>
/// <see cref="PureMVC.Patterns.MacroCommand"/>

type
  {$M+}
  TController = class(TInterfacedObject, IController)
    {$REGION 'Constructors'}
    /// <summary>
    /// Constructs and initializes a new controller
    /// </summary>
    /// <remarks>
    /// <para>
    /// This <c>IController</c> implementation is a Singleton,
    /// so you should not call the constructor
    /// directly, but instead call the static Singleton
    /// Factory method <c>Controller.getInstance()</c>
    /// </para>
    /// </remarks>
  protected
    constructor Create;
  public
    destructor Destroy; override;
    {$ENDREGION}
    {$REGION 'IController Members'}
    /// <summary>
    /// If an <c>ICommand</c> has previously been registered
    /// to handle a the given <c>INotification</c>, then it is executed.
    /// </summary>
    /// <param name="Note">An <c>INotification</c></param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    procedure ExecuteCommand(Note: INotification); virtual;
    /// <summary>
    /// Register a particular <c>ICommand</c> class as the handler
    /// for a particular <c>INotification</c>.
    /// </summary>
    /// <param name="NotificationName">The name of the <c>INotification</c></param>
    /// <param name="CommandType">The <c>Type</c> of the <c>ICommand</c></param>
    /// <remarks>
    /// <para>
    /// If an <c>ICommand</c> has already been registered to
    /// handle <c>INotification</c>s with this name, it is no longer
    /// used, the new <c>ICommand</c> is used instead.
    /// </para>
    /// </remarks>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
  public
    procedure RegisterCommand(NotificationName: string; CommandType: TClass); virtual;
    /// <summary>
    /// Check if a Command is registered for a given Notification
    /// </summary>
    /// <param name="NotificationName"></param>
    /// <returns>whether a Command is currently registered for the given <c>notificationName</c>.</returns>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
  public

    function HasCommand(NotificationName: string): Boolean; virtual;
    /// <summary>
    /// Remove a previously registered <c>ICommand</c> to <c>INotification</c> mapping.
    /// </summary>
    /// <param name="NotificationName">The name of the <c>INotification</c> to remove the <c>ICommand</c> mapping for</param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
  public
    procedure RemoveCommand(NotificationName: string); virtual;
    {$ENDREGION}
    {$REGION 'Accessors'}
    /// <summary>
    /// Singleton Factory method.  This method is thread safe.
    /// </summary>
  public
    class function Instance: IController; static;
    {$ENDREGION}
    {$REGION 'Protected & Internal Methods'}
  protected
    /// <summary>
    /// Initialize the Singleton <c>Controller</c> instance
    /// </summary>
    /// <remarks>
    /// <para>Called automatically by the constructor</para>
    ///
    /// <para>
    /// Note that if you are using a subclass of <c>View</c>
    /// in your application, you should also subclass <c>Controller</c>
    /// and override the <c>InitializeController</c> method in the following way:
    /// </para>
    /// <example>
    ///   <code lang="Delphi">
    /// // ensure that the Controller is talking to my IView implementation
    /// procedure TSampleController.InitializeController;override;
    /// begin
    ///  FView = MyView.Instance;
    /// end
    ///   </code>
    /// </example>
    /// </remarks>
    procedure InitializeController; virtual;
    {$ENDREGION}
    {$REGION 'Members'}
    /// <summary>
    /// Local reference to View
    /// </summary>
  protected
    FView: IView;

    /// <summary>
    /// Mapping of Notification names to Command Class references
    /// </summary>
  protected
    FCommandMap: TDictionary<string, TCommandClass>;

    /// <summary>
    /// Singleton instance, can be sublcassed though....
    /// </summary>
  protected
    class var FInstance: IController; // volatile

    /// <summary>
    /// Used for locking
    /// </summary>
  protected
    // readonly
    FSyncRoot: TObject;

    /// <summary>
    /// Used for locking the instance calls
    /// </summary>
  protected
    // readonly
    class var FStaticSyncRoot: TObject;
    {$ENDREGION}
  end;
  {$M-}

implementation

uses
  PureMVC.Core.View;

constructor TController.Create;
begin
  FCommandMap := TDictionary<string, TCommandClass>.Create;
  FSyncRoot := TObject.Create;
  InitializeController;
end;

destructor TController.Destroy;
begin
  FCommandMap.Free;
  FSyncRoot.Free;
  inherited;
end;

procedure TController.ExecuteCommand(Note: INotification);
var
  CommandType: TCommandClass;
  CommandIntf: ICommand;
begin
  TMonitor.Enter(FSyncRoot);
  try
    if not FCommandMap.TryGetValue(Note.Name, CommandType) then Exit;
  finally
    TMonitor.Exit(FSyncRoot);
  end;

  CommandIntf := CommandType.Create;
  if CommandIntf = nil then Exit;
  CommandIntf.Execute(Note);
end;

procedure TController.RegisterCommand(NotificationName: string; CommandType: TClass);
begin
  Assert(CommandType.InheritsFrom(TCommand));
  TMonitor.Enter(FSyncRoot);
  try
    if FCommandMap.ContainsKey(NotificationName) then Exit;

    // This call needs to be monitored carefully. Have to make sure that RegisterObserver
    // doesn't call back into the controller, or a dead lock could happen.

    FView.RegisterObserver(NotificationName, TObserver.Create('ExecuteCommand', Self));
    FCommandMap.Add(NotificationName, TCommandClass(CommandType));

  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

function TController.HasCommand(NotificationName: string): Boolean;
begin
  TMonitor.Enter(FSyncRoot);
  try
    Result := FCommandMap.ContainsKey(NotificationName);
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

procedure TController.RemoveCommand(NotificationName: string);
begin
  TMonitor.Enter(FSyncRoot);
  try
    if (FCommandMap.ContainsKey(NotificationName)) then begin
      // remove the observer

      // This call needs to be monitored carefully. Have to make sure that RemoveObserver
      // doesn't call back into the controller, or a dead lock could happen.
      FView.RemoveObserver(NotificationName, Self);
      FCommandMap.Remove(NotificationName);
    end;
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

class function TController.Instance: IController;
begin
  if (FInstance = nil) then begin
    TMonitor.Enter(FStaticSyncRoot);
    try
      if (FInstance = nil) then FInstance := TController.Create;
    finally
      TMonitor.Exit(FStaticSyncRoot);
    end;
  end;
  Result := FInstance;
end;

procedure TController.InitializeController;
begin
  FView := TView.Instance;
end;

initialization

TController.FStaticSyncRoot := TObject.Create;

finalization

FreeAndNil(TController.FStaticSyncRoot);

end.
