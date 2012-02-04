unit PureMVC.Patterns.Proxy;

interface

uses
  RTTI,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.IProxy,
  PureMVC.Patterns.Notifier;

type
  /// <summary>
  /// A base <c>IProxy</c> implementation
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, <c>Proxy</c> classes are used to manage parts of the application's data model</para>
  /// <para>A <c>Proxy</c> might simply manage a reference to a local data object, in which case interacting with it might involve setting and getting of its data in synchronous fashion</para>
  /// <para><c>Proxy</c> classes are also used to encapsulate the application's interaction with remote services to save or retrieve data, in which case, we adopt an asyncronous idiom; setting data (or calling a method) on the <c>Proxy</c> and listening for a <c>Notification</c> to be sent when the <c>Proxy</c> has retrieved the data from the service</para>
  /// </remarks>
  /// <see cref="PureMVC.Core.Model"/>
  TProxy = class(TNotifier, IProxy, INotifier)
{$REGION 'Members'}
  protected
    /// <summary>
    /// The name of the proxy
    /// </summary>
    FProxyName: string;

    /// <summary>
    /// The data object to be managed
    /// </summary>
    FData: TValue;

{$ENDREGION}
{$REGION 'Constants'}
  public
  /// <summary>
  /// The default proxy name
  /// </summary>
    const
    NAME = 'Proxy';
{$ENDREGION}
{$REGION 'Constructors'}
    /// <summary>
    /// Constructs a new proxy with the specified name and data
    /// </summary>
    /// <param name="proxyName">The name of the proxy</param>
    /// <param name="data">The data to be managed</param>
    constructor Create(ProxyName: string; Data: TValue); overload;
    constructor Create(ProxyName: string = NAME); overload;
{$ENDREGION}
{$REGION 'Methods'}
{$REGION 'IProxy Members'}
  public
    /// <summary>
    /// Called by the Model when the Proxy is registered
    /// </summary>
    procedure OnRegister; virtual;
    /// <summary>
    /// Called by the Model when the Proxy is removed
    /// </summary>
    procedure OnRemove; virtual;

    function GetProxyName: string;
    function GetData: TValue;
    procedure SetData(Value: TValue);
    property Data: TValue read GetData write SetData;

{$ENDREGION}
{$ENDREGION}
  end;

implementation

{ TProxy }

constructor TProxy.Create(ProxyName: string; Data: TValue);
begin
  inherited Create;
  FProxyName := ProxyName;
  if FProxyName = '' then
    FProxyName := NAME;

  FData := Data;
end;

constructor TProxy.Create(ProxyName: string);
begin
  Create(ProxyName, nil);
end;

procedure TProxy.SetData(Value: TValue);
begin
  FData := Value;
end;

function TProxy.GetData: TValue;
begin
  Result := FData;
end;

function TProxy.GetProxyName: string;
begin
  Result := FProxyName;
end;

procedure TProxy.OnRegister;
begin

end;

procedure TProxy.OnRemove;
begin

end;

end.
