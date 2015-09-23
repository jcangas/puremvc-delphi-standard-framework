{
  PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
  PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
  Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Interfaces.IModel;

interface

uses
  PureMVC.Interfaces.IProxy;

type
  /// <summary>
  /// The interface definition for a PureMVC Model
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, <c>IModel</c> implementors provide access to <c>IProxy</c> objects by named lookup</para>
  /// <para>An <c>IModel</c> assumes these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Maintain a cache of <c>IProxy</c> instances</item>
  /// <item>Provide methods for registering, retrieving, and removing <c>IProxy</c> instances</item>
  /// </list>
  /// </remarks>
  IModel = interface
    ['{9F376D21-60A8-4C14-8C48-DC2B24100BCC}']
    /// <summary>
    /// Register an <c>IProxy</c> instance with the <c>Model</c>
    /// </summary>
    /// <param name="Proxy">A reference to the proxy object to be held by the <c>Model</c></param>
    procedure RegisterProxy(Proxy: IProxy);

    /// <summary>
    /// Retrieve an <c>IProxy</c> instance from the Model
    /// </summary>
    /// <param name="ProxyName">The name of the proxy to retrieve</param>
    /// <returns>The <c>IProxy</c> instance previously registered with the given <c>proxyName</c></returns>
    function RetrieveProxy(ProxyName: string): IProxy;

    /// <summary>
    /// Remove an <c>IProxy</c> instance from the Model
    /// </summary>
    /// <param name="ProxyName">The name of the <c>IProxy</c> instance to be removed</param>
    function RemoveProxy(ProxyName: string): IProxy;

    /// <summary>
    /// Check if a Proxy is registered
    /// </summary>
    /// <param name="ProxyName">The name of the proxy to check for</param>
    /// <returns>whether a Proxy is currently registered with the given <c>proxyName</c>.</returns>
    function HasProxy(ProxyName: string): Boolean;
  end;

implementation

end.
