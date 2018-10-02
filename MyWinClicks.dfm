object Form1: TForm1
  Left = 192
  Top = 103
  Width = 696
  Height = 480
  Caption = #1055#1077#1088#1077#1075#1083#1103#1076#1072#1095' '#1074#1110#1082#1086#1085
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 305
    Top = 0
    Width = 8
    Height = 376
    Cursor = crHSplit
    Beveled = True
    ResizeStyle = rsUpdate
  end
  object Panel2: TPanel
    Left = 0
    Top = 376
    Width = 688
    Height = 77
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 128
      Top = 8
      Width = 44
      Height = 13
      Caption = #1053#1072#1076#1087#1080#1089'1'
      Visible = False
    end
    object Button1: TButton
      Left = 16
      Top = 4
      Width = 97
      Height = 25
      Caption = #1064#1091#1082#1072#1090#1080' '#1074#1110#1082#1085#1072
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 576
      Top = 40
      Width = 97
      Height = 25
      Caption = #1047#1085#1072#1081#1090#1080' '#1074#1110#1082#1085#1086'...'
      TabOrder = 1
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 32
      Width = 185
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1091#1074#1072#1090#1080' '#1089#1074#1086#1108' '#1074#1110#1082#1085#1086
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 48
      Width = 185
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1091#1074#1072#1090#1080' '#1085#1077#1074#1080#1076#1080#1084#1110' '#1074#1110#1082#1085#1072
      TabOrder = 3
    end
    object CheckBox3: TCheckBox
      Left = 208
      Top = 32
      Width = 217
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1091#1074#1072#1090#1080' '#1076#1086#1095#1110#1088#1085#1110' '#1074#1110#1082#1085#1072
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object CheckBox4: TCheckBox
      Left = 208
      Top = 48
      Width = 217
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1091#1074#1072#1090#1080' '#1074#1110#1082#1085#1072' '#1073#1077#1079' '#1079#1072#1075#1086#1083#1086#1074#1082#1110#1074
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
  end
  object Panel1: TGroupBox
    Left = 0
    Top = 0
    Width = 305
    Height = 376
    Align = alLeft
    Caption = #1042#1110#1082#1085#1072
    TabOrder = 1
    object TreeView2: TTreeView
      Left = 2
      Top = 15
      Width = 301
      Height = 359
      Align = alClient
      Images = ImageList1
      Indent = 20
      PopupMenu = PopupMenu1
      TabOrder = 0
      OnChange = TreeView2Change
      OnDblClick = TreeView2DblClick
    end
  end
  object Panel3: TGroupBox
    Left = 313
    Top = 0
    Width = 375
    Height = 376
    Align = alClient
    Caption = #1043#1086#1083#1086#1074#1085#1077' '#1084#1077#1085#1102' '#1074#1080#1073#1088#1072#1085#1086#1075#1086' '#1074#1110#1082#1085#1072
    TabOrder = 2
    object TreeView1: TTreeView
      Left = 2
      Top = 15
      Width = 371
      Height = 359
      Align = alClient
      Indent = 19
      TabOrder = 0
      OnDblClick = TreeView1DblClick
    end
  end
  object ImageList1: TImageList
    Left = 144
    Top = 48
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 184
    object N1: TMenuItem
      Caption = #1055#1086#1089#1083#1072#1090#1080' '#1090#1077#1082#1089#1090
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = #1053#1072#1090#1080#1089#1082#1072#1085#1085#1103' '#1084#1080#1096#1110
      object N4: TMenuItem
        Caption = #1055#1086#1076#1074#1110#1081#1085#1077
        object N5: TMenuItem
          Caption = #1051#1110#1074#1072' '#1082#1085#1086#1087#1082#1072
          OnClick = N5Click
        end
        object N6: TMenuItem
          Caption = #1055#1088#1072#1074#1072' '#1082#1085#1086#1087#1082#1072
          OnClick = N6Click
        end
        object N7: TMenuItem
          Caption = #1057#1077#1088#1077#1076#1085#1103' '#1082#1085#1086#1087#1082#1072
          OnClick = N7Click
        end
      end
      object N8: TMenuItem
        Caption = #1051#1110#1074#1072' '#1082#1085#1086#1087#1082#1072
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #1055#1088#1072#1074#1072' '#1082#1085#1086#1087#1082#1072
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = #1057#1077#1088#1077#1076#1085#1103' '#1082#1085#1086#1087#1082#1072
        OnClick = N10Click
      end
    end
  end
end
