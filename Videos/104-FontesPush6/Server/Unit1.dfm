object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 297
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edt_msg: TEdit
    Left = 24
    Top = 24
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 319
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Enviar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 72
    Width = 422
    Height = 225
    Align = alBottom
    TabOrder = 2
  end
end
