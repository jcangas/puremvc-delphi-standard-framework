object MainWindow: TMainWindow
  Left = 0
  Top = 0
  Caption = 'MainWindow'
  ClientHeight = 576
  ClientWidth = 671
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BottomArea: TPanel
    Left = 0
    Top = 297
    Width = 671
    Height = 279
    Align = alBottom
    TabOrder = 0
    inline UserForm: TUserForm
      Left = 1
      Top = 1
      Width = 376
      Height = 277
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 376
      ExplicitHeight = 277
      DesignSize = (
        376
        277)
      inherited PasswordCtl: TLabeledEdit [1]
        Left = 97
        Width = 270
        EditLabel.ExplicitLeft = 46
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
      inherited UserNameCtl: TLabeledEdit [2]
        Left = 97
        Width = 270
        EditLabel.ExplicitLeft = 44
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
      inherited SaveBtn: TButton [3]
      end
      inherited DepartmentCtl: TComboBox [4]
        Left = 97
        Width = 270
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
      inherited EmailCtl: TLabeledEdit [5]
        Left = 97
        Width = 270
        EditLabel.ExplicitLeft = 68
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
      inherited FirstNameCtl: TLabeledEdit [6]
        Left = 97
        Width = 270
        EditLabel.ExplicitLeft = 41
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
      inherited CancelBtn: TButton [7]
        Left = 302
        Width = 65
        ExplicitLeft = 302
        ExplicitWidth = 65
      end
      inherited LastNameCtl: TLabeledEdit [8]
        Left = 97
        Width = 270
        EditLabel.ExplicitLeft = 42
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
      inherited ConfirmPasswordCtl: TLabeledEdit [9]
        Left = 97
        Width = 270
        EditLabel.ExplicitLeft = 6
        ExplicitLeft = 97
        ExplicitWidth = 270
      end
    end
    inline RolePanel: TRolePanel
      AlignWithMargins = True
      Left = 380
      Top = 4
      Width = 287
      Height = 271
      Align = alRight
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      TabOrder = 1
      ExplicitLeft = 380
      ExplicitTop = 4
      ExplicitHeight = 271
      inherited UserRolesCtl: TListBox
        Height = 231
        ExplicitHeight = 231
      end
      inherited BottomPanel: TPanel
        Top = 236
        ExplicitTop = 236
      end
    end
  end
  inline UserList: TUserList
    Left = 0
    Top = 0
    Width = 671
    Height = 297
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 671
    ExplicitHeight = 297
    inherited UserGrid: TStringGrid
      Width = 671
      Height = 258
      ExplicitWidth = 671
      ExplicitHeight = 258
    end
    inherited ButtonBar: TPanel
      Top = 258
      Width = 671
      ExplicitTop = 258
      ExplicitWidth = 671
      inherited NewBtn: TButton
        Left = 474
        ExplicitLeft = 474
      end
      inherited DeleteBtn: TButton
        Left = 587
        ExplicitLeft = 587
      end
    end
  end
end
