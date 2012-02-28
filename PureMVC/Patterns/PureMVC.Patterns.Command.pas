{
 PureMVC Delphi Port by Jorge L. Cangas <jorge.cangas@puremvc.org>
 PureMVC - Copyright(c) 2006-11 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 License
}

unit PureMVC.Patterns.Command;

interface

uses
  SummerFW.Utils.Collections,
  PureMVC.Patterns.Notifier,
  PureMVC.Interfaces.ICommand,
  PureMVC.Interfaces.INotifier,
  PureMVC.Interfaces.INotification;

type
  TCommandClass = class of TCommand;
  TCommand = class(TNotifier, ICommand, INotifier)
  public
    constructor Create;virtual;
    procedure Execute(Notification: INotification); virtual;
  end;

  /// <summary>
  /// A base <c>ICommand</c> implementation
  /// </summary>
  /// <remarks>
  /// <para>Your subclass should override the <c>execute</c> method where your business logic will handle the <c>INotification</c></para>
  /// </remarks>
  /// <see cref="PureMVC.Core.Controller"/>
  /// <see cref="PureMVC.Patterns.Notification"/>
  /// <see cref="PureMVC.Patterns.MacroCommand"/>
  TSimpleCommand = class(TCommand, ICommand, INotifier)
  public
    /// <summary>
    /// Fulfill the use-case initiated by the given <c>INotification</c>
    /// </summary>
    /// <param name="notification">The <c>INotification</c> to handle</param>
    /// <remarks>
    /// <para>In the Command Pattern, an application use-case typically begins with some user action, which results in an <c>INotification</c> being broadcast, which is handled by business logic in the <c>execute</c> method of an <c>ICommand</c></para>
    /// </remarks>
    procedure Execute(Notification: INotification); override;
  end;

  /// <summary>
  /// A base <c>ICommand</c> implementation that executes other <c>ICommand</c>s
  /// </summary>
  /// <remarks>
  /// <para>A <c>MacroCommand</c> maintains an list of <c>ICommand</c> Class references called <i>SubCommands</i></para>
  /// <para>When <c>execute</c> is called, the <c>MacroCommand</c> instantiates and calls <c>execute</c> on each of its <i>SubCommands</i> turn. Each <i>SubCommand</i> will be passed a reference to the original <c>INotification</c> that was passed to the <c>MacroCommand</c>'s <c>execute</c> method</para>
  /// <para>Unlike <c>SimpleCommand</c>, your subclass should not override <c>execute</c>, but instead, should override the <c>initializeMacroCommand</c> method, calling <c>addSubCommand</c> once for each <i>SubCommand</i> to be executed</para>
  /// </remarks>
  /// <see cref="PureMVC.Core.Controller"/>
  /// <see cref="PureMVC.Patterns.Notification"/>
  /// <see cref="PureMVC.Patterns.SimpleCommand"/>
  TMacroCommand = class(TCommand, ICommand, INotifier)

{$REGION 'Constructors'}
  public
    /// <summary>
    /// Constructs a new macro command
    /// </summary>
    /// <remarks>
    /// <para>You should not need to define a constructor, instead, override the <c>initializeMacroCommand</c> method</para>
    /// <para>If your subclass does define a constructor, be sure to call <c>super()</c></para>
    /// </remarks>
    constructor Create;override;
{$ENDREGION}
{$REGION 'Public Methods'}
  public
{$REGION 'ICommand Members'}
    /// <summary>
    /// Execute this <c>MacroCommand</c>'s <i>SubCommands</i>
    /// </summary>
    /// <param name="notification">The <c>INotification</c> object to be passsed to each <i>SubCommand</i></param>
    /// <remarks>
    /// <para>The <i>SubCommands</i> will be called in First In/First Out (FIFO) order</para>
    /// </remarks>
    procedure Execute(Notification: INotification);override;final;
{$ENDREGION}
{$ENDREGION}
{$REGION 'Protected & Internal Methods'}
  protected

    /// <summary>
    /// Initialize the <c>MacroCommand</c>
    /// </summary>
    /// <remarks>
    /// <para>In your subclass, override this method to initialize the <c>MacroCommand</c>'s <i>SubCommand</i> list with <c>ICommand</c> class references like this:</para>
    /// <example>
    /// <code>
    /// // Initialize MyMacroCommand
    /// protected override initializeMacroCommand( )
    /// {
    /// addSubCommand( com.me.myapp.controller.FirstCommand );
    /// addSubCommand( com.me.myapp.controller.SecondCommand );
    /// addSubCommand( com.me.myapp.controller.ThirdCommand );
    /// }
    /// </code>
    /// </example>
    /// <para>Note that <i>SubCommand</i>s may be any <c>ICommand</c> implementor, <c>MacroCommand</c>s or <c>SimpleCommands</c> are both acceptable</para>
    /// </remarks>
    procedure InitializeMacroCommand(); virtual;

    /// <summary>
    /// Add a <i>SubCommand</i>
    /// </summary>
    /// <param name="commandType">A a reference to the <c>Type</c> of the <c>ICommand</c></param>
    /// <remarks>
    /// <para>The <i>SubCommands</i> will be called in First In/First Out (FIFO) order</para>
    /// </remarks>
    procedure AddSubCommand(CommandType: TCommandClass);
{$ENDREGION}
{$REGION 'Members'}
  private
    FSubCommands: IList<TCommandClass>;
{$ENDREGION}
  end;

implementation

uses
  SysUtils;

{ TCommand }

constructor TCommand.Create;
begin
  inherited;
end;

procedure TCommand.Execute(Notification: INotification);
begin

end;

{ TSimpleCommand }

procedure TSimpleCommand.Execute(Notification: INotification);
begin

end;

{ TMacroCommand }

constructor TMacroCommand.Create;
begin
  inherited;
  FSubCommands := TList<TCommandClass>.Create;
  InitializeMacroCommand;
end;

procedure TMacroCommand.AddSubCommand(CommandType: TCommandClass);
begin
  FSubCommands.Add(CommandType);
end;

procedure TMacroCommand.InitializeMacroCommand;
begin

end;

procedure TMacroCommand.Execute(Notification: INotification);
var
  CommandType: TClass;
  CommandInstance: TObject;
  CommandIntf: ICommand;

begin
  for CommandType in FSubCommands do begin
    CommandInstance := CommandType.Create;
    if Supports(CommandInstance, ICommand, CommandIntf) then
      CommandIntf.Execute(Notification);

  end;
  FSubCommands.Clear;

end;

end.
