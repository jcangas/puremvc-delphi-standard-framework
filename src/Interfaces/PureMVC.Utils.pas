unit PureMVC.Utils;

interface
uses
Generics.Collections,
SummerFW.Utils.RTL,
SummerFW.Utils.Collections;

type
  Sync =  SummerFW.Utils.RTL.Sync;
  IList<T> = interface(SummerFW.Utils.Collections.IList<T>)
  end;

  TList<T> = class(SummerFW.Utils.Collections.TList<T>, IList<T>)
  end;

  TObjectList<T: class> = class(SummerFW.Utils.Collections.TObjectList<T>)
  end;

  TDictionary<TKey,TValue> = class(Generics.Collections.TDictionary<TKey,TValue>);

implementation

end.
