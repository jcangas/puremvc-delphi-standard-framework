unit PureMVC.Interfaces.INotifier;

interface

uses
  RTTI;

type
  /// <summary>
  /// The interface definition for a PureMVC Notifier
  /// </summary>
  /// <remarks>
  /// <para><c>MacroCommand, Command, Mediator</c> and <c>Proxy</c> all have a need to send <c>Notifications</c></para>
  /// <para>The <c>INotifier</c> interface provides a common method called <c>sendNotification</c> that relieves implementation code of the necessity to actually construct <c>Notifications</c></para>
  /// <para>The <c>Notifier</c> class, which all of the above mentioned classes extend, also provides an initialized reference to the <c>Facade</c> Singleton, which is required for the convienience method for sending <c>Notifications</c>, but also eases implementation as these classes have frequent <c>Facade</c> interactions and usually require access to the facade anyway</para>
  /// </remarks>
  /// <see cref="PureMVC.Interfaces.IFacade"/>
  /// <see cref="PureMVC.Interfaces.INotification"/>
  INotifier = interface

    /// <summary>
    /// Send a <c>INotification</c>
    /// </summary>
    /// <remarks>
    /// <para>Convenience method to prevent having to construct new notification instances in our implementation code</para>
    /// </remarks>
    /// <param name="notificationName">The name of the notification to send</param>
    procedure SendNotification(NotificationName: string); overload;

    /// <summary>
    /// Send a <c>INotification</c>
    /// </summary>
    /// <remarks>
    /// <para>Convenience method to prevent having to construct new notification instances in our implementation code</para>
    /// </remarks>
    /// <param name="notificationName">The name of the notification to send</param>
    /// <param name="body">The body of the notification</param>
    procedure SendNotification(NotificationName: string;
        Body: TValue); overload;

    /// <summary>
    /// Send a <c>INotification</c>
    /// </summary>
    /// <remarks>
    /// <para>Convenience method to prevent having to construct new notification instances in our implementation code</para>
    /// </remarks>
    /// <param name="notificationName">The name of the notification to send</param>
    /// <param name="body">The body of the notification</param>
    /// <param name="Kind">The 'kind' of the notification</param>
    procedure SendNotification(NotificationName: string; Body: TValue;
        Kind: TValue); overload;
  end;

implementation

end.
