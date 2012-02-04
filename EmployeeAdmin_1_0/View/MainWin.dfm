object MainWindow: TMainWindow
  Left = 0
  Top = 0
  Caption = 'MainWindow'
  ClientHeight = 416
  ClientWidth = 643
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
    Top = 208
    Width = 643
    Height = 208
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 706
    inline UserForm: TUserForm
      Left = 1
      Top = 1
      Width = 321
      Height = 206
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 272
      ExplicitTop = -21
    end
    inline RolePanel: TRolePanel
      Left = 322
      Top = 1
      Width = 320
      Height = 206
      Align = alRight
      TabOrder = 1
      ExplicitTop = -32
      inherited ºº: TListBox
        Height = 206
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 320
        ExplicitHeight = 240
      end
    end
  end
  inline UserList: TUserList
    Left = 0
    Top = 0
    Width = 643
    Height = 208
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 83
    ExplicitTop = 56
    inherited UserGrid: TStringGrid
      Width = 643
      Height = 169
      ExplicitHeight = 288
    end
    inherited ButtonBar: TPanel
      Top = 169
      Width = 643
      inherited NewBtn: TButton
        Left = 441
        ExplicitLeft = 434
      end
      inherited DeleteBtn: TButton
        Left = 550
        ExplicitLeft = 543
      end
    end
  end
end
