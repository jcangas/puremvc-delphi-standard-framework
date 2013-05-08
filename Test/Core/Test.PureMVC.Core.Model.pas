unit Test.PureMVC.Core.Model;

interface

uses
  TestFramework,
  PureMVC.Core.Model,
  PureMVC.Interfaces.IProxy,
  PureMVC.Interfaces.IModel,
  PureMVC.Patterns.Proxy,
  PureMVC.Utils;

type
  // Test methods for class TModel

  TestTModel = class(TTestCase)
  private
  public
  published
    procedure TestGetInstance;
    procedure TestRegisterAndRetrieveProxy;
    procedure TestRegisterAndRemoveProxy;
    procedure TestHasProxy;
    procedure TestOnRegisterAndOnRemove;
  end;

implementation

uses
  SysUtils,
  Classes;

type

  TModelTestProxy = class(TProxy)
  public const
    NAME = 'ModelTestProxy';
    ON_REGISTER_CALLED = 'onRegister Called';
    ON_REMOVE_CALLED = 'onRemove Called';
  public
    constructor Create;
    procedure OnRegister; override;
    procedure OnRemove; override;
  end;

procedure TestTModel.TestGetInstance;
var
  Model: IModel;
begin
  Model := TModel.Instance;
  CheckNotNull(Model, 'TModel.Instance is null');
  CheckTrue(Supports(Model, IModel),
    'Expecting instance implements IModel');
end;

procedure TestTModel.TestRegisterAndRetrieveProxy;
const
  Color = 'Red';
var
  Model: IModel;
  Proxy: IProxy;
  Name: string;
begin
  Name := 'colors' + IntToStr(TThread.CurrentThread.ThreadID);
  Model := TModel.Instance;

  Model.RegisterProxy(TProxy.Create(Name, Color));
  Proxy := Model.RetrieveProxy(Name);
  CheckEquals(Proxy.Data.AsString, Color);

  Model.RemoveProxy(Name);
end;

procedure TestTModel.TestRegisterAndRemoveProxy;
const
  Sizes = '1,2,3';
var
  Model: IModel;
  Proxy: IProxy;
  RemovedProxy: IProxy;
  Name: string;
begin
  Name := 'sizes' + IntToStr(TThread.CurrentThread.ThreadID);
  Model := TModel.Instance;
  Model.RegisterProxy(TProxy.Create(Name, Sizes));

  Proxy := Model.RetrieveProxy(Name);
  RemovedProxy := Model.RemoveProxy(Name);

  CheckEquals(RemovedProxy.ProxyName, Name);
  Proxy := Model.RetrieveProxy(Name);
  CheckNull(Proxy);

end;

procedure TestTModel.TestHasProxy;
const
  Aces = 'clubs,spades,hearts,diamonds';
var
  Model: IModel;
  Name: string;
begin
  Name := 'aces' + IntToStr(TThread.CurrentThread.ThreadID);
  Model := TModel.Instance;
  Model.RegisterProxy(TProxy.Create(Name, Aces));
  CheckTrue(Model.HasProxy(Name));

  Model.RemoveProxy(name);
  CheckFalse(Model.HasProxy(Name));
end;

procedure TestTModel.TestOnRegisterAndOnRemove;
var
  Proxy: IProxy;
  Model: IModel;
begin
  Model := TModel.Instance;
  Proxy := TModelTestProxy.Create;
  Model.RegisterProxy(Proxy);
  CheckEquals(TModelTestProxy.ON_REGISTER_CALLED, Proxy.Data.ToString);

  Model.RemoveProxy(TModelTestProxy.Name);
  CheckEquals(TModelTestProxy.ON_REMOVE_CALLED, Proxy.Data.ToString);
end;

{ TModelTestProxy }

constructor TModelTestProxy.Create;
begin
  inherited Create(Name);
end;

procedure TModelTestProxy.OnRegister;
begin
  Data := ON_REGISTER_CALLED;
end;

procedure TModelTestProxy.OnRemove;
begin
  Data := ON_REMOVE_CALLED;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTModel.Suite);

end.
