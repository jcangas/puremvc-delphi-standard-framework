object UserForm: TUserForm
  Left = 0
  Top = 0
  Width = 305
  Height = 281
  TabOrder = 0
  DesignSize = (
    305
    281)
  object Label1: TLabel
    Left = 31
    Top = 209
    Width = 57
    Height = 13
    Caption = 'Department'
  end
  object FirstNameCtl: TLabeledEdit
    Left = 95
    Top = 8
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 51
    EditLabel.Height = 13
    EditLabel.Caption = 'First Name'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 0
  end
  object LastNameCtl: TLabeledEdit
    Left = 95
    Top = 41
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'Last Name'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 1
  end
  object EmailCtl: TLabeledEdit
    Left = 95
    Top = 75
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = 'Email'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 2
  end
  object UserNameCtl: TLabeledEdit
    Left = 95
    Top = 108
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'Username'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 3
  end
  object PasswordCtl: TLabeledEdit
    Left = 95
    Top = 142
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Password'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 4
  end
  object ConfirmPasswordCtl: TLabeledEdit
    Left = 95
    Top = 177
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 86
    EditLabel.Height = 13
    EditLabel.Caption = 'Confirm Password'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 5
  end
  object DepartmentCtl: TComboBox
    Left = 95
    Top = 206
    Width = 192
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
  end
  object SaveBtn: TButton
    Left = 95
    Top = 241
    Width = 72
    Height = 25
    Action = SaveAct
    TabOrder = 7
  end
  object CancelBtn: TButton
    Left = 215
    Top = 241
    Width = 72
    Height = 25
    Action = CancelAct
    Anchors = [akTop, akRight]
    TabOrder = 8
  end
  object ActionList: TActionList
    Left = 40
    Top = 224
    object SaveAct: TAction
      Caption = 'Update'
      OnExecute = SaveActExecute
      OnUpdate = SaveActUpdate
    end
    object CancelAct: TAction
      Caption = 'Cancel'
      OnExecute = CancelActExecute
      OnUpdate = CancelActUpdate
    end
  end
end
