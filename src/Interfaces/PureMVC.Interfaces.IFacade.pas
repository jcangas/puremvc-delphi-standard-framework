{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Interfaces.IFacade;

interface

uses
  PureMVC.Interfaces.IProxy,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IMediator;

type
  /// <summary>
  /// The interface definition for a PureMVC Facade
  /// </summary>
  /// <remarks>
  /// <para>The Facade Pattern suggests providing a single class to act as a certal point of communication for subsystems</para>
  /// <para>In PureMVC, the Facade acts as an interface between the core MVC actors (Model, View, Controller) and the rest of your application</para>
  /// </remarks>
  /// <see cref="PureMVC.Interfaces.IModel"/>
  /// <see cref="PureMVC.Interfaces.IView"/>
  /// <see cref="PureMVC.Interfaces.IController"/>
  /// <see cref="PureMVC.Interfaces.ICommand"/>
  /// <see cref="PureMVC.Interfaces.INotification"/>
  IFacade = interface(INotifier)
    ['{7FFB8968-33D6-4636-9CD7-93EF9E3FB734}']

{$REGION 'Proxy'}
    /// <summary>
    /// Register an <c>IProxy</c> with the <c>Model</c> by name
    /// </summary>
    /// <param name="Proxy">The <c>IProxy</c> to be registered with the <c>Model</c></param>

    procedure RegisterProxy(Proxy: IProxy);

    /// <summary>
    /// Retrieve a <c>IProxy</c> from the <c>Model</c> by name
    /// </summary>
    /// <param name="ProxyName">The name of the <c>IProxy</c> instance to be retrieved</param>
    /// <returns>The <c>IProxy</c> previously regisetered by <c>proxyName</c> with the <c>Model</c></returns>

    function RetrieveProxy(ProxyName: string): IProxy;

    /// <summary>
    /// Remove an <c>IProxy</c> instance from the <c>Model</c> by name
    /// </summary>
    /// <param name="ProxyName">The <c>IProxy</c> to remove from the <c>Model</c></param>

    function RemoveProxy(ProxyName: string): IProxy;

    /// <summary>
    /// Check if a Proxy is registered
    /// </summary>
    /// <param name="ProxyName">The name of the <c>IProxy</c> instance to check</param>
    /// <returns>whether a Proxy is currently registered with the given <c>proxyName</c>.</returns>
    function HasProxy(ProxyName: string): Boolean;
{$ENDREGION}
{$REGION 'Command'}
    /// <summary>
    /// Register an <c>ICommand</c> with the <c>Controller</c>
    /// </summary>
    /// <param name="NotificationName">The name of the <c>INotification</c> to associate the <c>ICommand</c> with.</param>
    /// <param name="CommandType">A reference to the <c>Type</c> of the <c>ICommand</c></param>
    procedure RegisterCommand(NotificationName: string; CommandType: TClass);

    /// <summary>
    /// Remove a previously registered <c>ICommand</c> to <c>INotification</c> mapping from the Controller.
    /// </summary>
    /// <param name="NotificationName">TRemove a previously registered <c>ICommand</c> to <c>INotification</c> mapping from the Controller.</param>
    procedure RemoveCommand(NotificationName: string);

    /// <summary>
    /// Check if a Command is registered for a given Notification
    /// </summary>
    /// <param name="NotificationName">The name of the <c>INotification</c> to check.</param>
    /// <returns>whether a Command is currently registered for the given <c>notificationName</c>.</returns>
    function HasCommand(NotificationName: string): Boolean;

{$ENDREGION}
{$REGION 'Mediator'}
    /// <summary>
    /// Register an <c>IMediator</c> instance with the <c>View</c>
    /// </summary>
    /// <param name="Mediator">A reference to the <c>IMediator</c> instance</param>
    procedure RegisterMediator(Mediator: IMediator);

    /// <summary>
    /// Retrieve an <c>IMediator</c> instance from the <c>View</c>
    /// </summary>
    /// <param name="MediatorName">The name of the <c>IMediator</c> instance to retrieve</param>
    /// <returns>The <c>IMediator</c> previously registered with the given <c>mediatorName</c></returns>
    function RetrieveMediator(MediatorName: string): IMediator;

    /// <summary>
    /// Remove a <c>IMediator</c> instance from the <c>View</c>
    /// </summary>
    /// <param name="MediatorName">The name of the <c>IMediator</c> instance to be removed</param>
    function RemoveMediator(MediatorName: string): IMediator; overload;
    function RemoveMediator(Mediator: IMediator): IMediator; overload;

    /// <summary>
    /// Check if a Mediator is registered or not
    /// </summary>
    /// <param name="MediatorName">The name of the <c>IMediator</c> instance to check</param>
    /// <returns>whether a Mediator is registered with the given <c>mediatorName</c>.</returns>
    function HasMediator(MediatorName: string): Boolean;

{$ENDREGION}
{$REGION 'Observer'}
    /// <summary>
    /// Notify the <c>IObservers</c> for a particular <c>INotification</c>.
    /// <para>All previously attached <c>IObservers</c> for this <c>INotification</c>'s list are notified and are passed a reference to the <c>INotification</c> in the order in which they were registered.</para>
    /// <para>NOTE: Use this method only if you are sending custom Notifications. Otherwise use the sendNotification method which does not require you to create the Notification instance.</para>
    /// </summary>
    /// <param name="Note">the <c>INotification</c> to notify <c>IObservers</c> of.</param>
    procedure NotifyObservers(Note: INotification);
{$ENDREGION}
  end;

implementation

end.
