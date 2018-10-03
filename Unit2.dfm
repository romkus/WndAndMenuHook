object Form2: TForm2
  Left = 212
  Top = 146
  Width = 560
  Height = 147
  Caption = #1042#1074#1077#1076#1110#1090#1100' '#1090#1077#1082#1089#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 0
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 521
    Height = 21
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 16
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 96
    Top = 88
    Width = 75
    Height = 25
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 16
    Top = 56
    Width = 521
    Height = 21
    TabOrder = 1
    OnKeyPress = Edit2KeyPress
  end
end
