{
  PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
  PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
  Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Interfaces.IProxy;

interface

uses
  RTTI;

type

  /// <summary>
  /// The interface definition for a PureMVC Proxy
  /// </summary>
  /// <remarks>
  /// <para>In PureMVC, <c>IProxy</c> implementors assume these responsibilities:</para>
  /// <list type="bullet">
  /// <item>Implement a common method which returns the name of the Proxy</item>
  /// </list>
  /// <para>Additionally, <c>IProxy</c>s typically:</para>
  /// <list type="bullet">
  /// <item>Maintain references to one or more pieces of model data</item>
  /// <item>Provide methods for manipulating that data</item>
  /// <item>Generate <c>INotifications</c> when their model data changes</item>
  /// <item>Expose their name as a <c>public const</c> called <c>NAME</c></item>
  /// <item>Encapsulate interaction with local or remote services used to fetch and persist model data</item>
  /// </list>
  /// </remarks>

  IProxy = interface
    ['{D04338EF-900E-4DC3-8F0C-0BE2F7D3B373}']
    /// <summary>
    /// The Proxy instance name
    /// </summary>
    function GetProxyName: string;
    property ProxyName: string
      read GetProxyName;

    /// <summary>
    /// The data of the proxy
    /// </summary>
    function GetData: TValue;
    procedure SetData(Value: TValue);
    property Data: TValue
      read GetData
      write SetData;

    /// <summary>
    /// Called by the Model when the Proxy is registered
    /// </summary>
    procedure OnRegister();

    /// <summary>
    /// Called by the Model when the Proxy is removed
    /// </summary>
    procedure OnRemove();
  end;

  /// <summary>
  /// Delphi facility: IProxy interface that wraps Data with class type
  IProxy<T: class> = interface(IProxy)
    function GetDataObject: T;
    procedure SetDataObject(const Value: T);
    property DataObject: T
      read GetDataObject
      write SetDataObject;
  end;

implementation

end.
