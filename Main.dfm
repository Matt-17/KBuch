object Form1: TForm1
  Left = 258
  Top = 391
  Width = 620
  Height = 601
  Caption = 'Kassenbuch WG'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnPaint = FormPaint
  OnShow = FormShow
  DesignSize = (
    612
    567)
  PixelsPerInch = 96
  TextHeight = 13
  object DrawGrid1: TDrawGrid
    Left = 8
    Top = 8
    Width = 596
    Height = 401
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clWhite
    DefaultRowHeight = 16
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 2
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goRowSelect, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = DrawGrid1DrawCell
  end
  object DateEdit: TGroupBox
    Left = 8
    Top = 480
    Width = 412
    Height = 49
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Datum'
    TabOrder = 1
    object RadioButton1: TRadioButton
      Left = 8
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Heute'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 78
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Datum:'
      TabOrder = 1
      OnClick = RadioButton1Click
    end
    object DateTimePicker1: TDateTimePicker
      Left = 132
      Top = 20
      Width = 186
      Height = 21
      Date = 38686.042714467590000000
      Time = 38686.042714467590000000
      Enabled = False
      TabOrder = 2
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 432
    Width = 412
    Height = 49
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Kommentar'
    TabOrder = 2
    DesignSize = (
      412
      49)
    object KommentarEdit: TEdit
      Left = 8
      Top = 20
      Width = 396
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 427
    Top = 432
    Width = 177
    Height = 49
    Anchors = [akRight, akBottom]
    Caption = 'Betrag'
    TabOrder = 3
    DesignSize = (
      177
      49)
    object BetragEdit: TEdit
      Left = 8
      Top = 20
      Width = 129
      Height = 21
      Anchors = [akTop, akRight]
      AutoSize = False
      TabOrder = 0
      OnKeyPress = BetragEditKeyPress
    end
    object StaticText1: TStaticText
      Left = 136
      Top = 20
      Width = 33
      Height = 21
      AutoSize = False
      BevelInner = bvLowered
      BevelKind = bkSoft
      Caption = 'EUR'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 427
    Top = 480
    Width = 177
    Height = 49
    Anchors = [akRight, akBottom]
    Caption = 'Benutzername'
    TabOrder = 4
    object UserNameLabel: TStaticText
      Left = 8
      Top = 20
      Width = 161
      Height = 21
      AutoSize = False
      BevelInner = bvLowered
      BevelKind = bkSoft
      Caption = 'UserNameLabel'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 16
    Top = 536
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 536
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 433
    Top = 536
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #220'bernehmen'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 521
    Top = 536
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Beenden'
    TabOrder = 8
    OnClick = Button5Click
  end
  object GesamtKommentar: TStaticText
    Left = 8
    Top = 410
    Width = 412
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'Gesamtbetrag in der Haushaltskasse'
    Color = 8454143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 9
  end
  object GesamtBetrag: TStaticText
    Left = 427
    Top = 410
    Width = 177
    Height = 21
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    AutoSize = False
    BorderStyle = sbsSunken
    Color = 8454143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 10
  end
  object CheckBox1: TCheckBox
    Left = 176
    Top = 544
    Width = 105
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Gel'#246'schte zeigen'
    TabOrder = 11
    OnClick = CheckBox1Click
  end
end
