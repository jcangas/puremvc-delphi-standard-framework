unit UserLst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TUserList = class(TFrame)
    UserGrid: TStringGrid;
    ButtonBar: TPanel;
    NewBtn: TButton;
    DeleteBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
