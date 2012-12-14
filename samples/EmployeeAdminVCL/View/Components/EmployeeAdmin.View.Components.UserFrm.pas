unit EmployeeAdmin.View.Components.UserFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList,
  EmployeeAdmin.Model.Enum.Enum,
  EmployeeAdmin.Model.Enum.DeptEnum,
  EmployeeAdmin.Model.VO.UserVO;
type
  TUserFormMode = (ADD, EDIT);

  TUserForm = class(TFrame)
    FirstNameCtl: TLabeledEdit;
    LastNameCtl: TLabeledEdit;
    EmailCtl: TLabeledEdit;
    UserNameCtl: TLabeledEdit;
    PasswordCtl: TLabeledEdit;
    ConfirmPasswordCtl: TLabeledEdit;
    DepartmentCtl: TComboBox;
    Label1: TLabel;
    SaveBtn: TButton;
    CancelBtn: TButton;
    ActionList: TActionList;
    SaveAct: TAction;
    CancelAct: TAction;
    procedure SaveActUpdate(Sender: TObject);
    procedure SaveActExecute(Sender: TObject);
    procedure CancelActUpdate(Sender: TObject);
    procedure CancelActExecute(Sender: TObject);
  private
    FUser: TUserVO;
    FOnAddUser: TNotifyEvent;
    FOnCancelUser: TNotifyEvent;
    FOnUpdateUser: TNotifyEvent;
    FMode: TUserFormMode;
    procedure BindUpdateCtl;
    procedure BindUpdateVO;
    function IsValid: Boolean;
  protected
    procedure DoAddUser(Sender: TObject); virtual;
    procedure DoUpdateUser(Sender: TObject); virtual;
    procedure DoOnCancelUser(Sender: TObject); virtual;
  public
    procedure UpdateCombo(EnumClass: TEnumClass; Selected: TEnum);
    procedure ClearForm;
    procedure ShowUser(User: TUserVO; Mode: TUserFormMode);
    property User: TUserVO read FUser;
    property Mode: TUserFormMode read FMode;
    property OnAddUser: TNotifyEvent read FOnAddUser write FOnAddUser;
    property OnUpdateUser: TNotifyEvent read FOnUpdateUser write FOnUpdateUser;
    property OnCancelUser: TNotifyEvent read FOnCancelUser write FOnCancelUser;
  end;

implementation

{$R *.dfm}

{ TUserForm }

procedure TUserForm.CancelActUpdate(Sender: TObject);
begin
  CancelAct.Enabled := Assigned(FUser);
end;

procedure TUserForm.ClearForm;
begin
  FUser := nil;
  FirstNameCtl.Text := '';
  LastNameCtl.Text := '';
  EmailCtl.Text := '';
  UserNameCtl.Text := '';
  PasswordCtl.Text := '';
  ConfirmPasswordCtl.Text := '';
  DepartmentCtl.ItemIndex := TDeptEnum.NONE_SELECTED.Index;
end;

procedure TUserForm.DoAddUser(Sender: TObject);
begin
  if Assigned(FOnAddUser) then OnAddUser(Sender);
end;

procedure TUserForm.DoUpdateUser(Sender: TObject);
begin
  if Assigned(FOnUpdateUser) then OnUpdateUser(Sender);
end;

procedure TUserForm.DoOnCancelUser(Sender: TObject);
begin
  if Assigned(FOnCancelUser) then OnCancelUser(Sender);
end;

function TUserForm.IsValid: Boolean;
begin
  BindUpdateVO;
  Result := (ConfirmPasswordCtl.Text = PasswordCtl.Text) and User.IsValid;
end;

procedure TUserForm.BindUpdateCtl;
begin
  FirstNameCtl.Text := User.FirstName;
  LastNameCtl.Text := User.LastName;
  EmailCtl.Text := User.Email;
  UserNameCtl.Text := User.UserName;
  PasswordCtl.Text := User.Password;
  DepartmentCtl.ItemIndex := User.Department.Index;
  ConfirmPasswordCtl.Text := PasswordCtl.Text;
end;

procedure TUserForm.BindUpdateVO;
begin
  FUser := TUserVO.Create(UserNameCtl.Text, FirstNameCtl.Text, LastNameCtl.Text, EmailCtl.Text, PasswordCtl.Text, TDeptEnum.Items[DepartmentCtl.ItemIndex]);
end;

procedure TUserForm.SaveActExecute(Sender: TObject);
begin
  if FMode = TUserFormMode.ADD then
    DoAddUser(Self)
  else
    DoUpdateUser(Self);
end;

procedure TUserForm.CancelActExecute(Sender: TObject);
begin
  DoOnCancelUser(Self);
end;

procedure TUserForm.SaveActUpdate(Sender: TObject);
begin
  if FMode = TUserFormMode.ADD then
    SaveAct.Caption := 'Add User'
  else
    SaveAct.Caption := 'Update User';

  SaveAct.Enabled := Assigned(FUser) and IsValid;
end;

procedure TUserForm.ShowUser(User: TUserVO; Mode: TUserFormMode);
begin
  FMode := Mode;
  if (User = nil) then ClearForm()
  else begin
    FUser := User;
    BindUpdateCtl;
    FirstNameCtl.SetFocus;
  end;
end;

procedure TUserForm.UpdateCombo(EnumClass: TEnumClass; Selected: TEnum);
begin
  DepartmentCtl.Items.Clear;
  EnumClass.Fill(DepartmentCtl.Items);
  DepartmentCtl.ItemIndex := Selected.Index;
end;

end.
