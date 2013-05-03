unit Test.PureMVC.Core.Controller;

interface

uses
  TestFramework,
  SysUtils,
  PureMVC.Interfaces.IController, PureMVC.Interfaces.IView,
  PureMVC.Interfaces.INotification,
  PureMVC.Interfaces.ICommand,
  PureMVC.Patterns.Command,
  PureMVC.Patterns.Notification,
  PureMVC.Utils,
  PureMVC.Core.Controller,
  PureMVC.Core.View,
  PureMVC.Patterns.Observer;

type
  // Test methods for class TController

  TestTController = class(TTestCase)
  private
  public
  published
    procedure TestHasCommand;
    procedure TestRegisterAndExecuteCommand;
    procedure TestRegisterAndRemoveCommand;
    procedure TestGetInstance;
    procedure TestReregisterAndExecuteCommand;
  end;

implementation

uses Classes;

type
  TControllerTestCommand = class(TSimpleCommand)
  public
    procedure Execute(Notification: INotification); override;
  end;

  TControllerTestVO = class
  private
    FInput: integer;
    FResult: integer;
  public
    constructor Create(Input: integer);
    property Input: integer read FInput write FInput;
    property Result: integer read FResult write FResult;
  end;

  { TTestableCommand }

procedure TControllerTestCommand.Execute(Notification: INotification);
var
  VO: TControllerTestVO;
begin
  VO := Notification.Body.AsType<TControllerTestVO>;
  VO.Result := VO.Result + VO.Input * 2;
end;

{ TControllerTestVO }

constructor TControllerTestVO.Create(Input: integer);
begin
  FInput := Input;
  FResult := 0;
end;

{ TestTController }

procedure TestTController.TestGetInstance;
var
  ReturnValue: IController;
begin
  ReturnValue := TController.Instance;
  CheckNotNull(ReturnValue, 'Controller.Instance is null');
  CheckTrue(Supports(ReturnValue, IController),
    'Expecting instance implements IController');
end;

procedure TestTController.TestRegisterAndExecuteCommand;
var
  Controller: IController;
  Note: INotification;
  VO: TControllerTestVO;
  Name: string;
begin
  Name := 'ControllerTest' + IntToStr(TThread.CurrentThread.ThreadID);
  Controller := TController.Instance;
  Controller.RegisterCommand(Name, TControllerTestCommand);
  VO := TControllerTestVO.Create(12);
  Note := TNotification.Create(Self, Name, VO, nil);
  Controller.ExecuteCommand(Note);
  CheckEquals(24, VO.Result);
  VO.Free;
end;

procedure TestTController.TestRegisterAndRemoveCommand;
var
  Controller: IController;
  Note: INotification;
  VO: TControllerTestVO;
  Name: string;
begin
  Name := 'ControllerRemoveTest' + IntToStr(TThread.CurrentThread.ThreadID);
  Controller := TController.Instance;
  Controller.RegisterCommand(Name, TControllerTestCommand);
  VO := TControllerTestVO.Create(12);
  Note := TNotification.Create(Self, Name, VO, nil);
  Controller.ExecuteCommand(Note);
  CheckEquals(24, VO.Result);

  // Remove the Command from the Controller
  Controller.RemoveCommand(Name);

  // Tell the controller to execute the Command associated with the
  // note. This time, it should not be registered, and our VO result
  // will not change
  VO.Result := 0;
  Controller.ExecuteCommand(Note);
  CheckEquals(0, VO.Result);
  VO.Free;
end;

procedure TestTController.TestReregisterAndExecuteCommand;
var
  Controller: IController;
  Note: INotification;
  VO: TControllerTestVO;
  Name: string;
  View: IView;

begin
  Name := 'ControllerTest2' + IntToStr(TThread.CurrentThread.ThreadID);
  Controller := TController.Instance;
  Controller.RegisterCommand(Name, TControllerTestCommand);

  // Remove the Command from the Controller
  Controller.RemoveCommand(Name);

  // Re-register the Command with the Controller
  Controller.RegisterCommand(Name, TControllerTestCommand);

  // Create a 'ControllerTest2' note
  VO := TControllerTestVO.Create(12);
  Note := TNotification.Create(Self, Name, VO, nil);
  // retrieve a reference to the View.
  View := TView.Instance;
  // send the Notification
  View.NotifyObservers(Note);

  // if the command is executed once the value will be 24
  CheckEquals(24, VO.Result);
  // Prove that accumulation works in the VO by sending the notification again
  View.NotifyObservers(Note);
  // if the command is executed twice the value will be 48
  CheckEquals(48, VO.Result);
  VO.Free;
end;

procedure TestTController.TestHasCommand;
var
  Controller: IController;
  Name: string;
begin
  // register the ControllerTestCommand to handle 'hasCommandTest' notes
  Name := 'HasCommandTest' + IntToStr(TThread.CurrentThread.ThreadID);
  Controller := TController.Instance;
  Controller.RegisterCommand(Name, TControllerTestCommand);

  // test that hasCommand returns true for hasCommandTest notifications
  CheckTrue(Controller.HasCommand(Name));

  Controller.RemoveCommand(Name);
  // test that hasCommand returns false for hasCommandTest notifications
  CheckFalse(Controller.HasCommand(Name));
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTController.Suite);

end.
