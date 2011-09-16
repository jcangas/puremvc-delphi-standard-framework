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
