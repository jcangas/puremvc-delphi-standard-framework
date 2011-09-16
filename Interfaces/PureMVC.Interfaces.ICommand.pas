unit PureMVC.Interfaces.ICommand;

interface

uses
  PureMVC.Interfaces.INotification;

type
  /// <summary>
  /// The interface definition for a PureMVC Command
  /// </summary>
  /// <see cref="PureMVC.Interfaces.INotification"/>

  ICommand = interface
    ['{39A5AA54-698E-4E79-8005-2CB6E34302D4}']
    /// <summary>
    /// Execute the <c>ICommand</c>'s logic to handle a given <c>INotification</c>
    /// </summary>
    /// <param name="notification">An <c>INotification</c> to handle</param>
    procedure Execute(Notification: INotification);
  end;

implementation

end.
