unit Test.PureMVC.Core.Model;

interface

uses
  TestFramework,
  PureMVC.Core.Model,
  PureMVC.Interfaces.IProxy,
  PureMVC.Interfaces.IModel,
  PureMVC.Patterns.Proxy,
  PureMVC.Utils
  ;

type
  // Test methods for class TModel

  TestTModel = class(TTestCase)
  strict private
    FModel: TModel;
  private
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestIsNotRegisteredProxy;
    procedure TestRegisterProxy;
    procedure TestRetrieveProxy;
    procedure TestRemoveProxy;
    procedure TestInstance;
    procedure TestOnRegister;
    procedure TestOnRemove;
  end;

implementation

type
  TTestableModel = class(TModel);
  TTestableProxy = class(TProxy)
  public
  const
    NAME = 'ModelTestProxy';
    ON_REGISTER_CALLED = 'onRegister Called';
    ON_REMOVE_CALLED = 'onRemove Called';
  public
    constructor Create;
    procedure OnRegister;override;
    procedure OnRemove;override;
  end;

procedure TestTModel.SetUp;
begin
  FModel := TTestableModel.Create;
end;

procedure TestTModel.TearDown;
begin
  FModel.Free;
  FModel := nil;
end;

procedure TestTModel.TestInstance;
var
  ReturnValue: IModel;
begin
  ReturnValue := TModel.Instance;
  CheckNotNull(ReturnValue, 'Model.Instance is null');
end;

procedure TestTModel.TestIsNotRegisteredProxy;
begin
  CheckFalse(FModel.HasProxy('colors'));
end;

procedure TestTModel.TestRegisterProxy;
begin
  FModel.RegisterProxy(TProxy.Create('colors' ));
  CheckTrue(FModel.HasProxy('colors'));
end;

procedure TestTModel.TestRetrieveProxy;
const
  Color = 'Red';
var
  Proxy: IProxy;
begin
  FModel.RegisterProxy(TProxy.Create('colors',  Color ));
  Proxy := FModel.RetrieveProxy('colors');
  CheckEquals(Color, Proxy.Data.ToString);
end;

procedure TestTModel.TestRemoveProxy;
begin
  FModel.RegisterProxy(TProxy.Create('colors' ));
  FModel.RemoveProxy('colors');
  CheckFalse(FModel.HasProxy('colors'));
end;

procedure TestTModel.TestOnRegister;
var
  Proxy: IProxy;
begin
  Proxy := TTestableProxy.Create;
  FModel.RegisterProxy(Proxy);
  CheckEquals(TTestableProxy.ON_REGISTER_CALLED, Proxy.data.ToString);
end;

procedure TestTModel.TestOnRemove;
var
  Proxy: IProxy;
begin
  Proxy := TTestableProxy.Create;
  FModel.RegisterProxy(Proxy);
  FModel.RemoveProxy(TTestableProxy.NAME);
  CheckEquals(TTestableProxy.ON_REMOVE_CALLED, Proxy.data.ToString);
end;

{ TModelTestProxy }

constructor TTestableProxy.Create;
begin
  inherited Create(Name);
end;

procedure TTestableProxy.OnRegister;
begin
  Data := ON_REGISTER_CALLED;
end;

procedure TTestableProxy.OnRemove;
begin
  Data := ON_REMOVE_CALLED;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTModel.Suite);
end.

