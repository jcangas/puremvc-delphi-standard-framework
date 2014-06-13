{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Interfaces.IMediator;

interface

uses
  PureMVC.Interfaces.Collections,
  PureMVC.Interfaces.INotification;

type

  /// <summary>
  /// The interface definition for a PureMVC Mediator.
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, <c>IMediator</c> implementors assume these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Implement a common method which returns a list of all <c>INotification</c>s the <c>IMediator</c> has interest in.</item>
  /// <item>Implement a common notification (callback) method</item>
  /// </list>
  /// <para>Additionally, <c>IMediator</c>s typically:</para>
  /// <list type="bullet">
  /// <item>Act as an intermediary between one or more view components such as text boxes or list controls, maintaining references and coordinating their behavior.</item>
  /// <item>In Flash-based apps, this is often the place where event listeners are added to view components, and their handlers implemented</item>
  /// <item>Respond to and generate <c>INotifications</c>, interacting with of the rest of the PureMVC app</item>
  /// </list>
  /// <para>When an <c>IMediator</c> is registered with the <c>IView</c>, the <c>IView</c> will call the <c>IMediator</c>'s <c>listNotificationInterests</c> method. The <c>IMediator</c> will return an <c>IList</c> of <c>INotification</c> names which it wishes to be notified about</para>
  /// <para>The <c>IView</c> will then create an <c>Observer</c> object encapsulating that <c>IMediator</c>'s (<c>handleNotification</c>) method and register it as an Observer for each <c>INotification</c> name returned by <c>listNotificationInterests</c></para>
  /// </remarks>
  /// <see cref="PureMVC.Interfaces.INotification"/>
  IMediator = interface
    ['{04873D3B-0566-4221-9CEF-DB2E1F352592}']
    /// <summary>
    /// Tthe <c>IMediator</c> instance name
    /// </summary>
    function GetMediatorName: string;
    property MediatorName: string read GetMediatorName;

    /// <summary>
    /// The <c>IMediator</c>'s view component
    /// </summary>
    function GetViewComponent: TObject;
    procedure SetViewComponent(Value: TObject);
    property ViewComponent: TObject read GetViewComponent
        write SetViewComponent;

    /// <summary>
    /// List <c>INotification interests</c>
    /// </summary>
    /// <returns>An <c>IList</c> of the <c>INotification</c> names this <c>IMediator</c> has an interest in</returns>
    function ListNotificationInterests: IList<string>;

    /// <summary>
    /// Handle an <c>INotification</c>
    /// </summary>
    /// <param name="Notification">The <c>INotification</c> to be handled</param>
    procedure HandleNotification(Notification: INotification);

    /// <summary>
    /// Called by the View when the Mediator is registered
    /// </summary>
    procedure OnRegister;

    /// <summary>
    /// Called by the View when the Mediator is removed
    /// </summary>
    procedure OnRemove;
  end;

implementation

end.
