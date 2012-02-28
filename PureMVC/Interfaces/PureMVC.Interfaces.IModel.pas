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
  IModel = interface
    // TODO: write members
    procedure RegisterProxy(Proxy: IProxy);
    function RetrieveProxy(ProxyName: string): IProxy;
    function RemoveProxy(ProxyName: string): IProxy;
    function HasProxy(ProxyName: string): Boolean;
  end;

implementation

end.
