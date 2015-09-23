{
  PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
  PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
  Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Patterns.Notifier;

interface

uses
  RTTI,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.IFacade;

type
  TNotifier = class(TInterfacedObject, INotifier)
  public

    /// <summary>
    /// Send an <c>INotification</c>
    /// </summary>
    /// <param name="NotificationName">The name of the notiification to send</param>
    /// <remarks>Keeps us from having to construct new notification instances in our implementation code</remarks>
    /// <remarks>This method is thread safe</remarks>
    procedure SendNotification(Name: string; Sender: TObject = nil); overload;

    /// <summary>
    /// Send an <c>INotification</c>
    /// </summary>
    /// <param name="NotificationName">The name of the notification to send</param>
    /// <param name="Body">The body of the notification</param>
    /// <remarks>Keeps us from having to construct new notification instances in our implementation code</remarks>
    /// <remarks>This method is thread safe</remarks>
    procedure SendNotification(Name: string; Sender: TObject; Body: TValue); overload;

    /// <summary>
    /// Send an <c>INotification</c>
    /// </summary>
    /// <param name="NotificationName">The name of the notification to send</param>
    /// <param name="Body">The body of the notification</param>
    /// <param name="Kind">The kind of the notification</param>
    /// <remarks>Keeps us from having to construct new notification instances in our implementation code</remarks>
    /// <remarks>This method is thread safe</remarks>
    procedure SendNotification(Name: string; Sender: TObject; Body: TValue; Kind: TValue); overload;

  protected
    /// <summary>
    /// Local reference to the Facade Singleton
    /// </summary>
    function Facade: IFacade;
  end;

implementation

uses
  PureMVC.Patterns.Facade;

procedure TNotifier.SendNotification(Name: string; Sender: TObject = nil);
begin
  SendNotification(name, Sender, nil, TValue.Empty);
end;

procedure TNotifier.SendNotification(Name: string; Sender: TObject; Body: TValue);
begin
  SendNotification(name, Sender, Body, TValue.Empty);
end;

procedure TNotifier.SendNotification(Name: string; Sender: TObject; Body: TValue; Kind: TValue);
begin
  Facade.SendNotification(name, Sender, Body, Kind);
end;

function TNotifier.Facade: IFacade;
begin
  Result := TFacade.Instance;
end;

end.
