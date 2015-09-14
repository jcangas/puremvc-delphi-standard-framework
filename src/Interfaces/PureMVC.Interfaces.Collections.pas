{********************************************************************* 
This file is a major copy from Generics.Collections oficial Delphi unit.
 We reintroduce IEnumarable<T> in orde to define IList<T> 
 compatible with the Genercis.Collections TList<T>.
 This way, we don't need reimplement all Collections from sracht.
 Here only the minimum to export IList.
*********************************************************************}

unit PureMVC.Interfaces.Collections;

{$R-,T-,X+,H+,B-}

interface

uses
  System.Types,
  System.SysUtils,
  System.Generics.Defaults,
  System.SyncObjs;

type

  TEnumerator<T> = class abstract
  protected
    function DoGetCurrent: T; virtual; abstract;
    function DoMoveNext: Boolean; virtual; abstract;
  public
    property Current: T
      read DoGetCurrent;
    function MoveNext: Boolean;
  end;

  IEnumerable<T> = interface(IInterface)
    function GetEnumerator: TEnumerator<T>;
  end;

  TEnumerable<T> = class abstract(TInterfacedObject, IEnumerable<T>)
  protected
    {$HINTS OFF}
    function ToArrayImpl(Count: Integer): TArray<T>; // used by descendants
    {$HINTS ON}
  protected
    function DoGetEnumerator: TEnumerator<T>; virtual; abstract;
    {$IF Defined(WEAKREF)}
    function HasWeakRef: Boolean;
    {$ENDIF}
  public
    function GetEnumerator: TEnumerator<T>;
    function ToArray: TArray<T>; virtual;
  end;

  TCollectionNotification   = (cnAdded, cnRemoved, cnExtracted);
  TCollectionNotifyEvent<T> = procedure(Sender: TObject; const Item: T; Action: TCollectionNotification) of object;

  IList<T> = interface(IEnumerable<T>)
    function GetCount: Integer;
    procedure SetCount(Value: Integer);
    function GetCapacity: Integer;
    procedure SetCapacity(Value: Integer);
    function GetOnNotify: TCollectionNotifyEvent<T>;
    procedure SetOnNotify(const Value: TCollectionNotifyEvent<T>);
    function GetItem(Index: Integer): T;
    procedure SetItem(Index: Integer; const Value: T);

    function Add(const Value: T): Integer;

    procedure AddRange(const Values: array of T); overload;
    procedure AddRange(const Collection: IEnumerable<T>); overload;
    procedure AddRange(const Collection: TEnumerable<T>); overload;
    procedure Insert(Index: Integer; const Value: T);

    procedure InsertRange(Index: Integer; const Values: array of T); overload;
    procedure InsertRange(Index: Integer; const Collection: IEnumerable<T>); overload;
    procedure InsertRange(Index: Integer; const Collection: TEnumerable<T>); overload;

    function Remove(const Value: T): Integer;
    procedure Delete(Index: Integer);
    procedure DeleteRange(AIndex, ACount: Integer);
    function Extract(const Value: T): T;

    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    function First: T;
    function Last: T;

    procedure Clear;

    function Contains(const Value: T): Boolean;
    function IndexOf(const Value: T): Integer;
    function LastIndexOf(const Value: T): Integer;

    procedure Reverse;

    procedure Sort; overload;
    procedure Sort(const AComparer: IComparer<T>); overload;
    function BinarySearch(const Item: T; out Index: Integer): Boolean; overload;
    function BinarySearch(const Item: T; out Index: Integer; const AComparer: IComparer<T>): Boolean; overload;

    procedure TrimExcess;
    function ToArray: TArray<T>;
    property Capacity: Integer
      read GetCapacity
      write SetCapacity;
    property Count: Integer
      read GetCount
      write SetCount;
    property Items[index: Integer]: T
      read GetItem
      write SetItem;
      default;
    property OnNotify: TCollectionNotifyEvent<T>
      read GetOnNotify
      write SetOnNotify;
  end;

implementation

uses
  System.TypInfo,
  System.SysConst,
  System.RTLConsts;

{ TEnumerator<T> }

function TEnumerator<T>.MoveNext: Boolean;
begin
  Result := DoMoveNext;
end;

{ TEnumerable<T> }

function TEnumerable<T>.GetEnumerator: TEnumerator<T>;
begin
  Result := DoGetEnumerator;
end;

function TEnumerable<T>.ToArray: TArray<T>;
var
  ACount: Integer;
  x: T;
begin
  ACount := 0;
  for x in Self do Inc(ACount);
  Result := ToArrayImpl(ACount);
end;

function TEnumerable<T>.ToArrayImpl(Count: Integer): TArray<T>;
var
  x: T;
begin
  // We assume our caller has passed correct Count
  SetLength(Result, Count);
  Count := 0;
  for x in Self do begin
    Result[Count] := x;
    Inc(Count);
  end;
end;

{$IF Defined(WEAKREF)}

function TEnumerable<T>.HasWeakRef: Boolean;
begin
  Result := System.TypInfo.HasWeakRef(TypeInfo(T));
end;
{$ENDIF}

end.
