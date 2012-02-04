unit UserFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UserVO;

type
  TUserFormMode = (ADD, EDIT);

  TUserForm = class(TFrame)
  private
    FUser: TUserVO;
    FAddUser: TNotifyEvent;
    FCancelUser: TNotifyEvent;
    FUpdateUser: TNotifyEvent;
    FMode: TUserFormMode;
    procedure SetAddUser(const Value: TNotifyEvent);
    procedure SetCancelUser(const Value: TNotifyEvent);
    procedure SetUpdateUser(const Value: TNotifyEvent);
  public
    procedure ClearForm;
    procedure ShowUser(User: TUserVO; Mode: TUserFormMode);
    property User: TUserVO read FUser;
    property Mode: TUserFormMode read FMode;
    property AddUser: TNotifyEvent read FAddUser write SetAddUser;
    property UpdateUser: TNotifyEvent read FUpdateUser write SetUpdateUser;
    property CancelUser: TNotifyEvent read FCancelUser write SetCancelUser;
  end;

implementation

{$R *.dfm}
{ TUserForm }

procedure TUserForm.ClearForm;
begin
  FUser := nil;
  (*
    formGrid.DataContext = nil;
    firstName.Text = lastName.Text = email.Text = userName.Text = "";
    password.Password = confirmPassword.Password = "";
    department.SelectedItem = DeptEnum.NONE_SELECTED;
    UpdateButtons();
  *)
end;

procedure TUserForm.ShowUser(User: TUserVO; Mode: TUserFormMode);
begin
  FMode := Mode;

  if (User = nil) then
    ClearForm()
  else begin
    FUser := User;
    (*
    formGrid.DataContext = User;
    firstName.Text = User.firstName;
    lastName.Text = User.lastName;
    email.Text = User.email;
    userName.Text = User.userName;
    password.password = confirmPassword.password = User ! = null ? User.
      password: " ";
    department.SelectedItem = User.department;
    firstName.Focus();
    UpdateButtons();
    *)
  end;
end;

procedure TUserForm.SetAddUser(const Value: TNotifyEvent);
begin
  FAddUser := Value;
end;

procedure TUserForm.SetCancelUser(const Value: TNotifyEvent);
begin
  FCancelUser := Value;
end;

procedure TUserForm.SetUpdateUser(const Value: TNotifyEvent);
begin
  FUpdateUser := Value;
end;

end.
