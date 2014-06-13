{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Patterns.Facade;

interface

uses
  SysUtils, RTTI,
  PureMVC.Interfaces.IModel,
  PureMVC.Interfaces.IController,
  PureMVC.Interfaces.IProxy,
  PureMVC.Interfaces.IView,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.IMediator,
  PureMVC.Interfaces.IFacade;

type
  /// <summary>
  /// A base Singleton <c>IFacade</c> implementation
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, the <c>Facade</c> class assumes these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Initializing the <c>Model</c>, <c>View</c> and <c>Controller</c> Singletons</item>
  /// <item>Providing all the methods defined by the <c>IModel, IView, &amp; IController</c> interfaces</item>
  /// <item>Providing the ability to override the specific <c>Model</c>, <c>View</c> and <c>Controller</c> Singletons created</item>
  /// <item>Providing a single point of contact to the application for registering <c>Commands</c> and notifying <c>Observers</c></item>
  /// </list>
  /// </remarks>
  /// <see cref="PureMVC.Core.Model"/>
  /// <see cref="PureMVC.Core.View"/>
  /// <see cref="PureMVC.Core.Controller"/>
  /// <see cref="PureMVC.Patterns.Notification"/>
  /// <see cref="PureMVC.Patterns.Mediator"/>
  /// <see cref="PureMVC.Patterns.Proxy"/>
  /// <see cref="PureMVC.Patterns.SimpleCommand"/>
  /// <see cref="PureMVC.Patterns.MacroCommand"/>

  TFacade = class(TInterfacedObject, IFacade)
  private
  protected
    constructor Create;virtual;
  public
    destructor Destroy; override;

{$REGION 'Proxy'}
  public
    procedure RegisterProxy(Proxy: IProxy);
    function RetrieveProxy(ProxyName: string): IProxy;
    function RemoveProxy(ProxyName: string): IProxy;
    function HasProxy(ProxyName: string): Boolean;
{$ENDREGION}
{$REGION 'Command'}
  public
    procedure RegisterCommand(NotificationName: string; CommandClass: TClass);
    procedure RemoveCommand(NotificationName: string);
    function HasCommand(NotificationName: string): Boolean;
{$ENDREGION}
{$REGION 'Mediator'}
  public
    procedure RegisterMediator(Mediator: IMediator);
    function RetrieveMediator(MediatorName: string): IMediator;
    function RemoveMediator(MediatorName: string): IMediator; overload;
    function RemoveMediator(Mediator: IMediator): IMediator; overload;
    function HasMediator(MediatorName: string): Boolean;
{$ENDREGION}
{$REGION 'Observer'}
  public
    procedure NotifyObservers(Notification: INotification);
{$ENDREGION}
{$REGION 'INotifier Members'}
  public
    procedure SendNotification(NotificationName: string; Sender: TObject = nil); overload;
    procedure SendNotification(NotificationName: string; Sender: TObject;
        Body: TValue); overload;
    procedure SendNotification(NotificationName: string; Sender: TObject; Body: TValue;
        Kind: TValue); overload;virtual;
{$ENDREGION}
{$REGION 'Accessors'}
  public
    /// <summary>
    /// Facade Singleton Factory method.  This method is thread safe.
    /// </summary>
    class function Instance: IFacade;
{$ENDREGION}
{$REGION 'Protected & Internal Methods'}
  protected
    /// <summary>
    /// Initialize the Singleton <c>Facade</c> instance
    /// </summary>
    /// <remarks>
    /// <para>Called automatically by the constructor. Override in your subclass to do any subclass specific initializations. Be sure to call <c>base.initializeFacade()</c>, though</para>
    /// </remarks>
    procedure InitializeFacade; virtual;
    /// <summary>
    /// Initialize the <c>Controller</c>
    /// </summary>
    /// <remarks>
    /// <para>Called by the <c>initializeFacade</c> method. Override this method in your subclass of <c>Facade</c> if one or both of the following are true:</para>
    /// <list type="bullet">
    /// <item>You wish to initialize a different <c>IController</c></item>
    /// <item>You have <c>Commands</c> to register with the <c>Controller</c> at startup</item>
    /// </list>
    /// <para>If you don't want to initialize a different <c>IController</c>, call <c>base.initializeController()</c> at the beginning of your method, then register <c>Command</c>s</para>
    /// </remarks>
    procedure InitializeController; virtual;
    /// <summary>
    /// Initialize the <c>Model</c>
    /// </summary>
    /// <remarks>
    /// <para>Called by the <c>initializeFacade</c> method. Override this method in your subclass of <c>Facade</c> if one or both of the following are true:</para>
    /// <list type="bullet">
    /// <item>You wish to initialize a different <c>IModel</c></item>
    /// <item>You have <c>Proxy</c>s to register with the Model that do not retrieve a reference to the Facade at construction time</item>
    /// </list>
    /// <para>If you don't want to initialize a different <c>IModel</c>, call <c>base.initializeModel()</c> at the beginning of your method, then register <c>Proxy</c>s</para>
    /// <para>Note: This method is <i>rarely</i> overridden; in practice you are more likely to use a <c>Command</c> to create and register <c>Proxy</c>s with the <c>Model</c>, since <c>Proxy</c>s with mutable data will likely need to send <c>INotification</c>s and thus will likely want to fetch a reference to the <c>Facade</c> during their construction</para>
    /// </remarks>
    procedure InitializeModel; virtual;
    /// <summary>
    /// Initialize the <c>View</c>
    /// </summary>
    /// <remarks>
    /// <para>Called by the <c>initializeFacade</c> method. Override this method in your subclass of <c>Facade</c> if one or both of the following are true:</para>
    /// <list type="bullet">
    /// <item>You wish to initialize a different <c>IView</c></item>
    /// <item>You have <c>Observers</c> to register with the <c>View</c></item>
    /// </list>
    /// <para>If you don't want to initialize a different <c>IView</c>, call <c>base.initializeView()</c> at the beginning of your method, then register <c>IMediator</c> instances</para>
    /// <para>Note: This method is <i>rarely</i> overridden; in practice you are more likely to use a <c>Command</c> to create and register <c>Mediator</c>s with the <c>View</c>, since <c>IMediator</c> instances will need to send <c>INotification</c>s and thus will likely want to fetch a reference to the <c>Facade</c> during their construction</para>
    /// </remarks>
    procedure InitializeView; virtual;

{$ENDREGION}

{$REGION 'Members'}
  protected
    FController: IController;
    FModel: IModel;
    FView: IView;
    class var FInstance: IFacade;
    class var FStaticSyncRoot: TObject;
{$ENDREGION}

  end;

implementation

uses
  PureMVC.Interfaces.Collections,
  PureMVC.Core.Model,
  PureMVC.Core.View,
  PureMVC.Core.Controller,
  PureMVC.Patterns.Notification;

constructor TFacade.Create;
begin
  inherited;
  InitializeFacade;
end;

procedure TFacade.InitializeFacade;
begin
  InitializeModel;
  InitializeController;
  InitializeView;
end;

procedure TFacade.InitializeModel;
begin
  if (FModel <> nil) then
    Exit;
  FModel := TModel.Instance;
end;

procedure TFacade.InitializeController;
begin
  if (FController <> nil) then
    Exit;
  FController := TController.Instance;
end;

procedure TFacade.InitializeView;
begin
  if (FView <> nil) then
    Exit;
  FView := TView.Instance;
end;

class function TFacade.Instance: IFacade;
begin
  if (FInstance = nil) then begin
    TMonitor.Enter(FStaticSyncRoot);
    try
      if (FInstance = nil) then FInstance := Self.Create;
    finally
      TMonitor.Exit(FStaticSyncRoot);
    end;
  end;
  Result := FInstance;
end;

{$REGION 'Proxy'}

function TFacade.RemoveProxy(ProxyName: string): IProxy;
begin
  Result := FModel.RemoveProxy(ProxyName);
end;

procedure TFacade.RegisterProxy(Proxy: IProxy);
var a: string;
begin
  a := Proxy.ProxyName;
  FModel.RegisterProxy(Proxy);
end;

function TFacade.RetrieveProxy(ProxyName: string): IProxy;
begin
  Result := FModel.RetrieveProxy(ProxyName);
end;

function TFacade.HasProxy(ProxyName: string): Boolean;
begin
  Result := FModel.HasProxy(ProxyName);
end;

{$ENDREGION}
{$REGION 'Mediator'}

procedure TFacade.RegisterMediator(Mediator: IMediator);
begin
  FView.RegisterMediator(Mediator);
end;

function TFacade.RetrieveMediator(MediatorName: string): IMediator;
begin
  Result := FView.RetrieveMediator(MediatorName);
end;

function TFacade.RemoveMediator(MediatorName: string): IMediator;
begin
  Result := FView.RemoveMediator(MediatorName);
end;

function TFacade.RemoveMediator(Mediator: IMediator): IMediator;
begin
  Result := FView.RemoveMediator(Mediator);
end;

function TFacade.HasMediator(MediatorName: string): Boolean;
begin
  Result := FView.HasMediator(MediatorName);
end;
{$ENDREGION}
{$REGION 'Command'}

procedure TFacade.RegisterCommand(NotificationName: string;
    CommandClass: TClass);
begin
  FController.RegisterCommand(NotificationName, CommandClass);
end;

destructor TFacade.Destroy;
begin
  FController := nil;
  FModel := nil;
  FView := nil;
  inherited;
end;

function TFacade.HasCommand(NotificationName: string): Boolean;
begin
  Result := FController.HasCommand(NotificationName);
end;

procedure TFacade.RemoveCommand(NotificationName: string);
begin
  FController.RemoveCommand(NotificationName);
end;
{$ENDREGION}

procedure TFacade.SendNotification(NotificationName: string; Sender: TObject; Body: TValue;
    Kind: TValue);
begin
  NotifyObservers(TNotification.Create(NotificationName, Sender, Body, Kind))
end;

procedure TFacade.SendNotification(NotificationName: string; Sender: TObject; Body: TValue);
begin
  SendNotification(NotificationName, Sender, Body, TValue.Empty);
end;

procedure TFacade.SendNotification(NotificationName: string; Sender: TObject = nil);
begin
  SendNotification(NotificationName, Sender, nil, TValue.Empty);
end;

procedure TFacade.NotifyObservers(Notification: INotification);
begin
  FView.NotifyObservers(Notification);
end;

initialization

TFacade.FStaticSyncRoot := TObject.Create;

finalization

TFacade.FStaticSyncRoot.Free;

end.
