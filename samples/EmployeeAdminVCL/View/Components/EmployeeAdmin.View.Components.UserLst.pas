unit EmployeeAdmin.View.Components.UserLst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids,
  PureMVC.Utils,
  EmployeeAdmin.Model.VO.UserVO;

type
  TUserList = class(TFrame)
    UserGrid: TStringGrid;
    ButtonBar: TPanel;
    NewBtn: TButton;
    DeleteBtn: TButton;
    procedure NewBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure UserGridClick(Sender: TObject);
  private
    FUsers: IList<TUserVO>;
    FOnNewUser: TNotifyEvent;
    FOnDeleteUser: TNotifyEvent;
    FOnSelectUser: TNotifyEvent;
    FSelectedUser: TUserVO;
    procedure SetUserList(const Value: IList<TUserVO>);
    procedure SetSelectedUser(const Value: TUserVO);
    procedure BindUpdateCtlRow(RowIdx: Integer; User: TUserVO);
    procedure BindUpdateCtlTitles;
    function Search(User: TUserVO; out Index: Integer): Boolean;
  protected
  {$REGION 'Fire Events'}
    procedure DoOnNewUser;virtual;
    procedure DoOnDeleteUser;virtual;
    procedure DoOnSelectUser;virtual;
  {$ENDREGION}
  public
    constructor Create(AOwner: TComponent);override;
    procedure Deselect;
    procedure BindUpdateCtl;
    procedure BindUpdateCtlItem(User: TUserVO);
		property SelectedUser: TUserVO read FSelectedUser write SetSelectedUser;
    property Users: IList<TUserVO> read FUsers write SetUserList;

    property OnNewUser: TNotifyEvent read FOnNewUser write FOnNewUser;
    property OnDeleteUser: TNotifyEvent read FOnDeleteUser write FOnDeleteUser;
    property OnSelectUser: TNotifyEvent read FOnSelectUser write FOnSelectUser;
  end;

implementation

{$R *.dfm}

{ TUserList }

{$REGION 'Fire Events'}

procedure TUserList.DoOnSelectUser;
begin
  if Assigned(FOnSelectUser) then
    OnSelectUser(Self);
end;

procedure TUserList.DoOnNewUser;
begin
  if Assigned(FOnNewUser) then
    OnNewUser(Self);
end;

procedure TUserList.DoOnDeleteUser;
begin
  if Assigned(FOnDeleteUser) then
    OnDeleteUser(Self);
end;

{$ENDREGION}

procedure TUserList.NewBtnClick;
begin
  DoOnNewUser;
end;

procedure TUserList.DeleteBtnClick(Sender: TObject);
begin
  DoOnDeleteUser;
end;

procedure TUserList.SetSelectedUser(const Value: TUserVO);
begin
  FSelectedUser := Value;
  DoOnSelectUser;
end;

procedure TUserList.SetUserList(const Value: IList<TUserVO>);
begin
  FUsers := Value;
  BindUpdateCtl;
end;

procedure TUserList.BindUpdateCtlRow(RowIdx: Integer; User: TUserVO);
begin
  UserGrid.Cells[0, RowIdx] := IntToStr(RowIdx);
  UserGrid.Cells[1, RowIdx] := User.UserName;
  UserGrid.Cells[2, RowIdx] := User.FirstName;
  UserGrid.Cells[3, RowIdx] := User.LastName;
  UserGrid.Cells[4, RowIdx] := User.Email;
  UserGrid.Cells[5, RowIdx] := User.Department.ToString;
  UserGrid.Cells[6, RowIdx] := User.Password;
end;

function TUserList.Search(User: TUserVO; out Index: Integer): Boolean;
var
  I: Integer;
begin
  for I := 0 to Users.Count - 1 do
    if Users[I].UserName = User.UserName then begin
      Index := I;
      Exit(True);
    end;
  Result := False;
end;

procedure TUserList.BindUpdateCtlItem(User: TUserVO);
var
  RowIdx: Integer;
begin
  if Search(User, RowIdx) then
    BindUpdateCtlRow(1 + RowIdx, User);
end;

procedure TUserList.BindUpdateCtlTitles;
const
  ColTitles: array[1 .. 6] of string =
    ('UserName', 'FirstName', 'LastName', 'Email', 'Department', 'Password');
var
  ColIdx: Integer;
begin
  UserGrid.ColCount := SizeOf(ColTitles) + 1;
  for ColIdx := Low(ColTitles) to High(ColTitles) do
    UserGrid.Cells[ColIdx, 0] := ColTitles[ColIdx];

end;

constructor TUserList.Create(AOwner: TComponent);
begin
  inherited;
  BindUpdateCtlTitles
end;

procedure TUserList.BindUpdateCtl;
var
  User: TUserVO;
  RowIdx: Integer;
begin
  RowIdx := 0;
  UserGrid.RowCount := Users.Count + 1;
  for User in Users do begin
    Inc(RowIdx);
    BindUpdateCtlRow(RowIdx, User);
  end;
end;

procedure TUserList.UserGridClick(Sender: TObject);
begin
  if (UserGrid.Row < 1) then Exit;
  SelectedUser := Users[UserGrid.Row - 1];
end;

procedure TUserList.Deselect;
begin

end;

end.
