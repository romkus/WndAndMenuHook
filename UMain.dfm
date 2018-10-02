object Form4: TForm4
  Left = 192
  Top = 103
  Width = 696
  Height = 480
  Caption = #1055#1088#1086#1074#1110#1076#1085#1080#1082' '#1087#1086' '#1074#1110#1082#1085#1072#1084' '#1110' 1'#1057
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 415
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    Left = 136
    Top = 160
    object N3: TMenuItem
      Caption = '&'#1060#1072#1081#1083
      object N11: TMenuItem
        Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1080' "1'#1057':&'#1055#1110#1076#1087#1088#1080#1108#1084#1089#1090#1074#1086'"'
        ShortCut = 16466
        OnClick = N11Click
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object N12: TMenuItem
        Caption = #1047#1072#1076#1072#1090#1080' '#1082#1086#1088#1080#1089#1090#1091#1074#1072#1095#1072' 1'#1057
        OnClick = N12Click
      end
      object N8: TMenuItem
        Caption = #1047#1072#1076#1072#1090#1080' '#1087#1086#1090#1086#1095#1085#1091' '#1082#1086#1085#1092#1110#1075#1091#1088#1072#1094#1110#1102' 1'#1057
        OnClick = N8Click
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #1042#1110#1076#1082#1088#1080#1090#1080' &'#1082#1086#1085#1092#1110#1075#1091#1088#1072#1094#1110#1102' 1'#1057
        OnClick = N4Click
      end
      object N5: TMenuItem
        Caption = #1042#1110#1076#1082#1088#1080#1090#1080' &'#1073#1072#1079#1091' '#1076#1072#1085#1080#1093'...'
        Enabled = False
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Caption = '&'#1042#1080#1081#1090#1080
        ShortCut = 49240
        OnClick = N7Click
      end
    end
    object N1: TMenuItem
      Caption = '&'#1044#1086#1076#1072#1090#1082#1080
      object N2: TMenuItem
        Caption = #1055#1077#1088#1077#1083#1110#1082' &'#1074#1110#1082#1086#1085'...'
        OnClick = N2Click
      end
    end
  end
end
