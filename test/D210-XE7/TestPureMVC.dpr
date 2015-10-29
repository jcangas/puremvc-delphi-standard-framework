program TestPureMVC;
{
  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Test.PureMVC.Core.Controller in '..\Core\Test.PureMVC.Core.Controller.pas',
  Test.PureMVC.Core.Model in '..\Core\Test.PureMVC.Core.Model.pas',
  Test.PureMVC.Core.View in '..\Core\Test.PureMVC.Core.View.pas',
  Test.PureMVC.Patterns.MacroCommand in '..\Patterns\Command\Test.PureMVC.Patterns.MacroCommand.pas',
  Test.PureMVC.Patterns.SimpleCommand in '..\Patterns\Command\Test.PureMVC.Patterns.SimpleCommand.pas',
  Test.PureMVC.Patterns.Facade in '..\Patterns\Facade\Test.PureMVC.Patterns.Facade.pas',
  Test.PureMVC.Patterns.Mediator in '..\Patterns\Mediator\Test.PureMVC.Patterns.Mediator.pas',
  Test.PureMVC.Patterns.Observer in '..\Patterns\Observer\Test.PureMVC.Patterns.Observer.pas',
  Test.PureMVC.Patterns.Notification in '..\Patterns\Observer\Test.PureMVC.Patterns.Notification.pas',
  Test.PureMVC.Patterns.Proxy in '..\Patterns\Proxy\Test.PureMVC.Patterns.Proxy.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

