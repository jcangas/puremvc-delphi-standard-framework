object RolePanel: TRolePanel
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 287
  Height = 244
  Padding.Left = 5
  Padding.Top = 5
  Padding.Right = 5
  Padding.Bottom = 5
  TabOrder = 0
  object UserRolesCtl: TListBox
    Left = 5
    Top = 5
    Width = 277
    Height = 204
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnClick = UserRolesCtlClick
  end
  object BottomPanel: TPanel
    Left = 5
    Top = 209
    Width = 277
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      277
      30)
    object RemoveBtn: TButton
      Left = 220
      Top = 3
      Width = 57
      Height = 25
      Action = RoleRemoveAct
      Anchors = [akTop, akRight]
      TabOrder = 0
    end
    object AddBtn: TButton
      Left = 152
      Top = 3
      Width = 54
      Height = 25
      Action = RoleAddAct
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object RoleListCtl: TComboBox
      Left = 0
      Top = 5
      Width = 137
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnSelect = RoleListCtlSelect
    end
  end
  object ActionList: TActionList
    Left = 128
    Top = 112
    object RoleAddAct: TAction
      Category = 'Role'
      Caption = 'Add'
      OnExecute = RoleAddActExecute
    end
    object RoleRemoveAct: TAction
      Category = 'Role'
      Caption = 'Remove'
      OnExecute = RoleRemoveActExecute
    end
  end
end
