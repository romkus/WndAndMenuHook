object Form3: TForm3
  Left = 206
  Top = 115
  Width = 696
  Height = 474
  Caption = #1058#1077#1089#1090' '#1087#1086#1096#1091#1082#1091' '#1074#1110#1082#1085#1072' '#1110' '#1087#1091#1085#1082#1090#1072' '#1084#1077#1085#1102
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 321
    Height = 328
    Align = alLeft
    TabOrder = 0
    object StringGrid1: TStringGrid
      Left = 1
      Top = 1
      Width = 319
      Height = 326
      Align = alClient
      ColCount = 2
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowMoving, goColMoving, goEditing, goTabs, goThumbTracking]
      TabOrder = 0
      ColWidths = (
        153
        141)
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 328
    Width = 688
    Height = 119
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 112
      Top = 8
      Width = 82
      Height = 13
      Caption = #1044#1086#1095#1110#1088#1085#1110#1089#1090#1100' '#1074#1110#1082#1085#1072
    end
    object Label2: TLabel
      Left = 112
      Top = 32
      Width = 121
      Height = 13
      Caption = #1044#1086#1095#1110#1088#1085#1110#1089#1090#1100' '#1087#1091#1085#1082#1090#1072' '#1084#1077#1085#1102
    end
    object Label3: TLabel
      Left = 184
      Top = 56
      Width = 196
      Height = 13
      Caption = #1042#1072#1078#1110#1083#1100' '#1074#1110#1082#1085#1072' (Handle) (0 - '#1085#1077' '#1079#1072#1076#1072#1074#1072#1090#1080'):'
    end
    object Label4: TLabel
      Left = 32
      Top = 88
      Width = 112
      Height = 13
      Caption = #1060#1088#1072#1075#1084#1077#1085#1090' '#1110#1084#1077#1085#1110' '#1074#1110#1082#1085#1072':'
    end
    object Label5: TLabel
      Left = 384
      Top = 88
      Width = 57
      Height = 13
      Caption = #1050#1083#1072#1089' '#1074#1110#1082#1085#1072':'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 97
      Height = 25
      Caption = #1064#1091#1082#1072#1090#1080' '#1074#1110#1082#1085#1086
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 336
      Top = 8
      Width = 337
      Height = 21
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 208
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '4'
      OnKeyPress = Edit2KeyPress
    end
    object Button2: TButton
      Left = 8
      Top = 34
      Width = 97
      Height = 25
      Caption = #1064#1091#1082#1072#1090#1080' '#1084#1077#1085#1102
      TabOrder = 3
      OnClick = Button2Click
    end
    object Edit3: TEdit
      Left = 240
      Top = 32
      Width = 89
      Height = 21
      TabOrder = 4
      Text = '4'
      OnKeyPress = Edit3KeyPress
    end
    object Edit4: TEdit
      Left = 336
      Top = 32
      Width = 337
      Height = 21
      TabOrder = 5
    end
    object Button3: TButton
      Left = 8
      Top = 60
      Width = 145
      Height = 25
      Caption = #1055#1086#1095#1077#1082#1072#1090#1080' '#1072#1082#1090#1080#1074#1072#1094#1110#1111' '#1074#1110#1082#1085#1072':'
      TabOrder = 6
      OnClick = Button3Click
    end
    object Edit5: TEdit
      Left = 384
      Top = 56
      Width = 185
      Height = 21
      TabOrder = 7
      Text = '0'
    end
    object Edit6: TEdit
      Left = 160
      Top = 88
      Width = 217
      Height = 21
      TabOrder = 8
    end
    object Edit7: TEdit
      Left = 448
      Top = 88
      Width = 209
      Height = 21
      TabOrder = 9
    end
  end
  object Panel3: TPanel
    Left = 321
    Top = 0
    Width = 367
    Height = 328
    Align = alClient
    TabOrder = 2
    object StringGrid2: TStringGrid
      Left = 1
      Top = 1
      Width = 365
      Height = 326
      Align = alClient
      ColCount = 2
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowMoving, goColMoving, goEditing, goTabs, goThumbTracking]
      TabOrder = 0
      ColWidths = (
        161
        175)
    end
  end
end
