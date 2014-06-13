unit PureMVC.Core.Model;

interface

uses
  PureMVC.Patterns.Collections,
  PureMVC.Interfaces.IModel,
  PureMVC.Interfaces.IProxy;

type
  /// <summary>
  /// A Singleton <c>IModel</c> implementation
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, the <c>Model</c> class provides access to model objects (Proxies) by named lookup</para>
  /// <para>The <c>Model</c> assumes these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Maintain a cache of <c>IProxy</c> instances</item>
  /// <item>Provide methods for registering, retrieving, and removing <c>IProxy</c> instances</item>
  /// </list>
  /// <para>
  /// Your application must register <c>IProxy</c> instances
  /// with the <c>Model</c>. Typically, you use an
  /// <c>ICommand</c> to create and register <c>IProxy</c>
  /// instances once the <c>Facade</c> has initialized the Core actors
  /// </para>
  /// </remarks>
  /// <seealso cref="PureMVC.Patterns.Proxy"/>
  /// <seealso cref="PureMVC.Interfaces.IProxy" />
  TModel = class(TInterfacedObject, IModel)

    {$REGION 'Constructors'}
    /// <summary>
    /// Constructs and initializes a new model
    /// </summary>
    /// <remarks>
    /// <para>This <c>IModel</c> implementation is a Singleton, so you should not call the constructor directly, but instead call the static Singleton Factory method <c>Model.getInstance()</c></para>
    /// </remarks>
  protected
    constructor Create();
    {$ENDREGION}
    {$REGION 'Public Methods'}
  public
    destructor Destroy; override;
    {$REGION 'IModel Members'}
    /// <summary>
    /// Register an <c>IProxy</c> with the <c>Model</c>
    /// </summary>
    /// <param name="Proxy">An <c>IProxy</c> to be held by the <c>Model</c></param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    procedure RegisterProxy(Proxy: IProxy); virtual;
    /// <summary>
    /// Retrieve an <c>IProxy</c> from the <c>Model</c>
    /// </summary>
    /// <param name="ProxyName">The name of the <c>IProxy</c> to retrieve</param>
    /// <returns>The <c>IProxy</c> instance previously registered with the given <c>proxyName</c></returns>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    function RetrieveProxy(ProxyName: string): IProxy; virtual;
    /// <summary>
    /// Check if a Proxy is registered
    /// </summary>
    /// <param name="ProxyName"></param>
    /// <returns>whether a Proxy is currently registered with the given <c>proxyName</c>.</returns>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    function HasProxy(ProxyName: string): Boolean; virtual;
    /// <summary>
    /// Remove an <c>IProxy</c> from the <c>Model</c>
    /// </summary>
    /// <param name="ProxyName">The name of the <c>IProxy</c> instance to be removed</param>
    /// <remarks>This method is thread safe and needs to be thread safe in all implementations.</remarks>
    function RemoveProxy(ProxyName: string): IProxy; virtual;

    {$ENDREGION}
    {$ENDREGION}
    {$REGION 'Accessors'}
    /// <summary>
    /// <c>Model</c> Singleton Factory method.  This method is thread safe.
    /// </summary>
    class function Instance: IModel; static;
    {$ENDREGION}
    {$REGION 'Protected & Internal Methods'}
    /// <summary>
    /// Initialize the Singleton <c>Model</c> instance.
    /// </summary>
    /// <remarks>
    /// <para>Called automatically by the constructor, this is your opportunity to initialize the Singleton instance in your subclass without overriding the constructor</para>
    /// </remarks>
  protected
    procedure InitializeModel; virtual;
    {$ENDREGION}
    {$REGION 'Members'}
    /// <summary>
    /// Mapping of proxyNames to <c>IProxy</c> instances
    /// </summary>
  protected
    FProxyMap: TDictionary<string, IProxy>;

    /// <summary>
    /// Singleton instance
    /// </summary>
  protected
  class var
    FInstance: IModel;
    /// <summary>
    /// Used for locking the instance calls
    /// </summary>
    FStaticSyncRoot: TObject;

    /// <summary>
    /// Used for locking
    /// </summary>
  var
    FSyncRoot: TObject;
    {$ENDREGION}
  end;

implementation

{ TModel }

constructor TModel.Create;
begin
  inherited;
  FSyncRoot := TObject.Create;
  FProxyMap := TDictionary<string, IProxy>.Create;
  InitializeModel();
end;

destructor TModel.Destroy;
begin
  FProxyMap.Free;
  FSyncRoot.Free;
  inherited;
end;

function TModel.HasProxy(ProxyName: string): Boolean;
begin
  TMonitor.Enter(FSyncRoot);
  try
    Result := FProxyMap.ContainsKey(ProxyName);
  finally
    TMonitor.Exit(FSyncRoot);
  end;
end;

procedure TModel.InitializeModel;
begin

end;

class function TModel.Instance: IModel;
begin
  if (FInstance = nil) then begin
    TMonitor.Enter(FStaticSyncRoot);
    try
      if (FInstance = nil) then FInstance := TModel.Create;
    finally
      TMonitor.Exit(FStaticSyncRoot);
    end;
  end;

  Result := FInstance;
end;

procedure TModel.RegisterProxy(Proxy: IProxy);
begin
  TMonitor.Enter(FSyncRoot);
  try
    FProxyMap.Add(Proxy.ProxyName, Proxy);
  finally
    TMonitor.Exit(FSyncRoot);
  end;

  Proxy.OnRegister;
end;

function TModel.RemoveProxy(ProxyName: string): IProxy;
var
  Proxy: IProxy;
begin
  Proxy := nil;
  TMonitor.Enter(FSyncRoot);
  try
    if (FProxyMap.ContainsKey(ProxyName)) then begin
      Proxy := RetrieveProxy(ProxyName);
      FProxyMap.Remove(ProxyName);
    end;
  finally
    TMonitor.Exit(FSyncRoot);
  end;
  if Assigned(Proxy) then Proxy.OnRemove();
  Result := Proxy;
end;

function TModel.RetrieveProxy(ProxyName: string): IProxy;
var
  Proxy: IProxy;
begin
  TMonitor.Enter(FSyncRoot);
  try
    Proxy := nil;
    if FProxyMap.ContainsKey(ProxyName) then Proxy := FProxyMap[ProxyName];
  finally
    TMonitor.Exit(FSyncRoot);
  end;
  Result := Proxy;
end;

initialization

TModel.FStaticSyncRoot := TObject.Create;

finalization

TModel.FStaticSyncRoot.Free;

end.
