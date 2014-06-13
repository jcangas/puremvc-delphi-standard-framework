unit PureMVC.Utils;

interface
uses
  TypInfo,
  SysUtils,
  Generics.Defaults,
  Generics.Collections;

type
  IList<T> = interface(IEnumerable<T>)
    function GetCount: Integer;
    procedure SetCount(Value: Integer);
    function GetCapacity: Integer;
    procedure SetCapacity(Value: Integer);
    function GetOnNotify: TCollectionNotifyEvent<T>;
    procedure SetOnNotify(Value: TCollectionNotifyEvent<T>);
    function GetItem(Index: Integer): T;
    procedure SetItem(Index: Integer; const Value: T);

    function Add(const Value: T): Integer;

    procedure AddRange(const Values: array of T); overload;
    procedure AddRange(const Collection: IEnumerable<T>); overload;
    {$IF RTLVersion >= 26}
    procedure AddRange(const Collection: TEnumerable<T>); overload;
    {$ELSE}
    procedure AddRange(Collection: TEnumerable<T>); overload;
    {$IFEND}

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
    function ItemType: PTypeInfo;
    function ToArray: TArray<T>;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: T read GetItem write SetItem; default;
    property OnNotify: TCollectionNotifyEvent<T> read GetOnNotify write SetOnNotify;
  end;
  IObjectList = IList<TObject>;

  TInterfacedEnumerator = class abstract(TInterfacedObject, IEnumerator)
  protected
    function DoGetCurrent: TObject;virtual;
    function IEnumerator.GetCurrent = DoGetCurrent;
    function MoveNext: Boolean; virtual; abstract;
    procedure Reset; virtual; abstract;
  end;

  TInterfacedEnumerator<T> = class abstract(TInterfacedEnumerator, IEnumerator<T>)
  protected
    function GetCurrent: T;virtual;abstract;
  end;

  TInterfacedEnumerableList<T> = class(Generics.Collections.TList<T>, IEnumerable)
  private
    FRefCount: Integer;
  protected
    function DoPlainEnumerator: IEnumerator;virtual;
  public
    function ItemType: PTypeInfo;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    property RefCount: Integer read FRefCount;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    function IEnumerable.GetEnumerator = DoPlainEnumerator;
    function GetEnumerator: IEnumerator<T>;virtual;
    type
      TEnumerator = class(TInterfacedEnumerator<T>)
      private
        FList: Generics.Collections.TList<T>;
        FIndex: Integer;
      protected
        function GetCurrent: T;override;
      public
        constructor Create(AList: Generics.Collections.TList<T>);
        property Current: T read GetCurrent;
        function MoveNext: Boolean;override;
        procedure Reset;override;
      end;
  end;

  TList<T> = class(TInterfacedEnumerableList<T>, IList<T>)
  public
    function GetCount: Integer;
    procedure SetCount(Value: Integer);
    function GetCapacity: Integer;
    procedure SetCapacity(Value: Integer);
    function GetOnNotify: TCollectionNotifyEvent<T>;
    procedure SetOnNotify(Value: TCollectionNotifyEvent<T>);
    function GetItem(Index: Integer): T;
    procedure SetItem(Index: Integer; const Value: T);
    constructor Create(Collection: IEnumerable<T>);overload;
    constructor Create(const Values: array of T); overload;
  end;

  TObjectList<T: class> = class(Generics.Collections.TObjectList<T>);
  //TObjectList<T: class> = class(TList<T>);

  TObjectList = TObjectList<TObject>;

  TDictionary<TKey,TValue> = class(Generics.Collections.TDictionary<TKey,TValue>);

  TDictionaryOwnerships = set of (doOwnsKeys, doOwnsValues);
  TObjectDictionary<TKey,TValue> = class(Generics.Collections.TObjectDictionary<TKey,TValue>)
  public
    constructor Create(Ownerships: TDictionaryOwnerships; ACapacity: Integer = 0); overload;
    constructor Create(Ownerships: TDictionaryOwnerships;
      const AComparer: IEqualityComparer<TKey>); overload;
    constructor Create(Ownerships: TDictionaryOwnerships; ACapacity: Integer;
      const AComparer: IEqualityComparer<TKey>); overload;
  end;

  Sync = class
    public
      class procedure Lock(obj: TObject; P: TProc);overload;static;
      class function Lock<T>(obj: TObject; F: TFunc<T>): T;overload;static;
    end;

function InterlockedIncrement(var Addend: Integer): Integer;
function InterlockedDecrement(var Addend: Integer): Integer;

implementation

{$REGION 'IInterface Members'}

{$IF RTLVersion >= 14.0} // >= XE5
function InterlockedIncrement(var Addend: Integer): Integer; inline;
begin
  Result := AtomicIncrement(Addend);
end;

function InterlockedDecrement(var Addend: Integer): Integer; inline;
begin
  Result := AtomicDecrement(Addend);
end;
{$ELSE}
// copied from System Unit
function InterlockedAdd(var Addend: Integer; Increment: Integer): Integer;
asm
      MOV   ECX,EAX
      MOV   EAX,EDX
 LOCK XADD  [ECX],EAX
      ADD   EAX,EDX
end;

function InterlockedIncrement(var Addend: Integer): Integer;
asm
      MOV   EDX,1
      JMP   InterlockedAdd
end;

function InterlockedDecrement(var Addend: Integer): Integer;
asm
      MOV   EDX,-1
      JMP   InterlockedAdd
end;

{$IFEND}


{ Sync }

class procedure Sync.Lock(obj: TObject; P: TProc);
begin
  TMonitor.Enter(obj);
  try
    P;
  finally
    TMonitor.Exit(obj);
  end;
end;

class function Sync.Lock<T>(obj: TObject; F: TFunc<T>): T;
begin
  TMonitor.Enter(obj);
  try
    Result := F;
  finally
    TMonitor.Exit(obj);
  end;
end;

// Set an implicit refcount so that refcounting
// during construction won't destroy the object.
class function TInterfacedEnumerableList<T>.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TInterfacedEnumerableList<T>(Result).FRefCount := 1;
end;

function TInterfacedEnumerableList<T>.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TInterfacedEnumerableList<T>.AfterConstruction;
begin
// Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);
  inherited;
end;

procedure TInterfacedEnumerableList<T>.BeforeDestruction;
begin
  if FRefCount <> 0 then
    System.Error(reInvalidPtr);
  inherited;
end;

function TInterfacedEnumerableList<T>.DoPlainEnumerator: IEnumerator;
begin
  Result := Self.GetEnumerator;
end;

function TInterfacedEnumerableList<T>.GetEnumerator: IEnumerator<T>;
begin
  Result := TInterfacedEnumerableList<T>.TEnumerator.Create(Self);
end;

function TInterfacedEnumerableList<T>.ItemType: PTypeInfo;
begin
  Result := TypeInfo(T);
end;

function TInterfacedEnumerableList<T>._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TInterfacedEnumerableList<T>._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

{$ENDREGION}

{$REGION 'IList Members'}

constructor TList<T>.Create(Collection: IEnumerable<T>);
begin
  inherited Create;
  InsertRange(0, Collection);
end;

constructor TList<T>.Create(const Values: array of T);
begin
  inherited Create;
  InsertRange(0, Values);
end;

function TList<T>.GetCapacity: Integer;
begin
  Result := inherited Capacity;
end;

procedure TList<T>.SetCapacity(Value: Integer);
begin
  inherited Capacity := Value;
end;

function TList<T>.GetCount: Integer;
begin
  Result := inherited Count;
end;

procedure TList<T>.SetCount(Value: Integer);
begin
  inherited Count := Value;
end;

function TList<T>.GetItem(Index: Integer): T;
begin
  Result := inherited Items[Index];
end;

procedure TList<T>.SetItem(Index: Integer; const Value: T);
begin
  inherited Items[Index] := Value;
end;

function TList<T>.GetOnNotify: TCollectionNotifyEvent<T>;
begin
  Result := inherited OnNotify;
end;

procedure TList<T>.SetOnNotify(Value: TCollectionNotifyEvent<T>);
begin
  inherited OnNotify := Value;
end;
{$ENDREGION}


{ TInterfacedEnumerator<T> }

{ TEnumerableList<T>.TEnumerator }

constructor TInterfacedEnumerableList<T>.TEnumerator.Create(AList: Generics.Collections.TList<T>);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TInterfacedEnumerableList<T>.TEnumerator.GetCurrent: T;
begin
  Result := FList[FIndex];
end;

function TInterfacedEnumerableList<T>.TEnumerator.MoveNext: Boolean;
begin
  if FIndex >= FList.Count then
    Exit(False);
  Inc(FIndex);
  Result := FIndex < FList.Count;
end;

procedure TInterfacedEnumerableList<T>.TEnumerator.Reset;
begin
  FIndex := -1;
end;

{ TObjectDictionary<TKey, TValue> }

constructor TObjectDictionary<TKey, TValue>.Create(
  Ownerships: TDictionaryOwnerships; ACapacity: Integer);
begin
  inherited Create( Generics.Collections.TDictionaryOwnerships(Ownerships), ACapacity);
end;

constructor TObjectDictionary<TKey, TValue>.Create(
  Ownerships: TDictionaryOwnerships; const AComparer: IEqualityComparer<TKey>);
begin
  inherited Create( Generics.Collections.TDictionaryOwnerships(Ownerships), AComparer);
end;

constructor TObjectDictionary<TKey, TValue>.Create(
  Ownerships: TDictionaryOwnerships; ACapacity: Integer;
  const AComparer: IEqualityComparer<TKey>);
begin
  inherited Create( Generics.Collections.TDictionaryOwnerships(Ownerships), ACapacity, AComparer);
end;

{ TInterfacedEnumerator }

function TInterfacedEnumerator.DoGetCurrent: TObject;
begin
  raise Exception.Create('Not Implemented');
end;

end.

