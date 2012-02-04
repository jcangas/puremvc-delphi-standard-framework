object UserList: TUserList
  Left = 0
  Top = 0
  Width = 623
  Height = 337
  TabOrder = 0
  object UserGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 623
    Height = 298
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 141
  end
  object ButtonBar: TPanel
    Left = 0
    Top = 298
    Width = 623
    Height = 39
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      623
      39)
    object NewBtn: TButton
      Left = 444
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'New'
      TabOrder = 0
    end
    object DeleteBtn: TButton
      Left = 537
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Delete'
      TabOrder = 1
    end
  end
end
