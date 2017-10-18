unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, Mask;

type
  TKBuch = record
    ID        : Integer;
    Kommentar : String[128];
    Betrag    : Currency;
    Entfernt  : Boolean;
    Datum     : TDate;
    Name      : String[32]
  end;

  TKBuch_lokal = record
    OEintrag : TKBuch;
    NEintrag : Boolean;
  end;
  TForm1 = class(TForm)
    DrawGrid1: TDrawGrid;
    DateEdit: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    DateTimePicker1: TDateTimePicker;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    KommentarEdit: TEdit;
    BetragEdit: TEdit;
    UserNameLabel: TStaticText;
    StaticText1: TStaticText;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    GesamtKommentar: TStaticText;
    GesamtBetrag: TStaticText;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure BetragEditKeyPress(Sender: TObject; var Key: Char);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Kassenbuch : Array of TKBuch_lokal;

    Procedure CalcGesamt;   
    Function CheckDatei : Boolean;
    Procedure LadeDatei;
    Procedure SpeicherDatei;
    Function CheckDel(ID_look : Integer) :  Boolean;
  end;

Const
  DATEINAME = 'KBuch.dat';
  Breiten : array[0..4] of Integer = (0, 20, 50, 20, 30);

var
  Form1: TForm1;

implementation

uses DateUtils, Types;

{$R *.dfm}

Procedure TForm1.CalcGesamt;
Var
  I : Integer;
  Betrag : Currency;
Begin
  Betrag := 0;
  For I := 0 to Length(Kassenbuch)-1 do
  Begin
    If not Kassenbuch[I].OEintrag.Entfernt then Betrag := Betrag + Kassenbuch[I].OEintrag.Betrag;
  end;
  GesamtBetrag.Caption := CurrToStrF(Betrag, ffFixed, 2) + ' €';
End;

Function TForm1.CheckDatei : Boolean;
Var
  I, J : Integer;
Begin
  Result := False;
  For I := 0 To Length(Kassenbuch)-1 do
    For J := 0 to Length(Kassenbuch)-1 do
    Begin
      If (J<>I) and (Kassenbuch[I].OEintrag.ID = Kassenbuch[J].OEintrag.ID) then
        Result := True;
    End;
End;


Procedure TForm1.LadeDatei; 
var
  MyFile      : TFileStream;
  MyKBuch     : TKBuch;
  LastChanged : TDateTime;
Begin
  SetLength(Kassenbuch, 0);
  If FileExists(DATEINAME) then
  Begin
    MyFile := TFileStream.Create(DATEINAME, fmOpenRead);
    With MyFile do
    Begin
      Read(LastChanged, SizeOf(LastChanged));
      Caption := 'Kassenbuch WG - ' + DateToStr(LastChanged);
      While Read(MyKBuch, SizeOf(MyKBuch)) > 0 do
      Begin
        SetLength(Kassenbuch, Length(Kassenbuch)+1);
        Kassenbuch[Length(Kassenbuch)-1].OEintrag := MyKBuch;
        Kassenbuch[Length(Kassenbuch)-1].NEintrag := False;
      End;
    End;
    FreeAndNil(MyFile);
  End else
    Caption := 'Kassenbuch WG - neues Buch';
End;

Procedure TForm1.SpeicherDatei;
var
  MyFile      : TFileStream;
  NewStream   : TMemoryStream;
  MyKBuch     : TKBuch;
  LastChanged, Temp : TDateTime;
  MaxID, I : Integer;
Begin                
  LastChanged := Now;
  MaxID := 1000;
  NewStream := TMemoryStream.Create;

  If FileExists(DATEINAME) then
  Begin
    MyFile := TFileStream.Create(DATEINAME, fmOpenRead or fmShareDenyWrite);
    MyFile.Read(Temp, SizeOf(Temp));       
    NewStream.Write(Temp, SizeOf(Temp));
    I := 0;
    while MyFile.Position < MyFile.Size do
    begin
      MyFile.Read(MyKBuch, SizeOf(MyKBuch));
      If CheckDel(MyKBuch.ID) then
      Begin
        MyKBuch.Entfernt := True;
      End;
      If MyKBuch.ID > MaxID then MaxID := MyKBuch.ID;
      NewStream.Write(MyKBuch, SizeOf(MyKBuch));
      Inc(I);
    end;
    FreeAndNil(MyFile);
  End else
  Begin
    MyFile := TFileStream.Create(DATEINAME, fmCreate);
    NewStream.Write(LastChanged, SizeOf(LastChanged));
    FreeAndNil(MyFile);
  end;

  With NewStream do
  Begin
    For I := 0 to Length(Kassenbuch)-1 do
    if Kassenbuch[I].NEintrag then
    Begin
      MyKBuch := Kassenbuch[I].OEintrag;
      MyKBuch.ID := MaxID+1;
      Write(MyKBuch, SizeOf(MyKBuch));
      Kassenbuch[I].NEintrag := False;
      Inc(MaxID);
    End;

    Seek(0, 0);
    Write(LastChanged, SizeOf(LastChanged));
  End;
  MyFile := TFileStream.Create(DATEINAME, fmOpenWrite or fmShareExclusive);
  MyFile.CopyFrom(NewStream, 0);
  FreeAndNil(MyFile);
  FreeAndNil(NewStream);
End;


Function TForm1.CheckDel(ID_look : Integer) :  Boolean;
Var
  I :integer;
Begin
  
  For I := 0 to Length(Kassenbuch)-1 do
  Begin
    If Kassenbuch[I].OEintrag.ID = ID_Look then Result := Kassenbuch[I].OEintrag.Entfernt;
  End;
End;


procedure TForm1.FormCreate(Sender: TObject);
var
  ComputerName : array[1..20] of Char;
  UserName: array[1..512] of Char;
  arrSize: DWord;
  I : Integer;
begin                       
  arrSize := SizeOf(ComputerName);
  GetComputerName(@ComputerName, arrSize); 
  UserNameLabel.Caption := ComputerName;

  arrSize := SizeOf(UserName);
  GetUserName(@UserName, arrSize);
  UserNameLabel.Caption :=  Trim(UserNameLabel.Caption) + '|'+UserName;

  DrawGrid1.ColWidths[0] := 30;
  DrawGrid1.ColWidths[1] := 80;
  DrawGrid1.ColWidths[2] := 300;
  DrawGrid1.ColWidths[3] := 60;
  DrawGrid1.ColWidths[4] := 103;
  
  LadeDatei;
  If CheckDatei then
  Begin
    MessageDlg('Fehler in der '+DATEINAME, mtError, [mbOk], 0);
   // SetLength(Kassenbuch, 0);
  End;
  If Length(Kassenbuch) >= 2 then
    DrawGrid1.RowCount := Length(Kassenbuch)+1
  else
    DrawGrid1.RowCount := 2;  
  For I := 0 to Length(Kassenbuch)-1 do
  Begin
    If Kassenbuch[I].OEintrag.Entfernt and not CheckBox1.Checked then DrawGrid1.RowHeights[I+1] := 0
     else DrawGrid1.RowHeights[I+1] := 16;
  end;

  CalcGesamt;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  DateTimePicker1.Enabled := RadioButton2.Checked;
end;

procedure TForm1.BetragEditKeyPress(Sender: TObject; var Key: Char);
Var
  P : Integer;
begin             
  P := Pos(',', BetragEdit.Text);
  If (not (Key in ['0'..'9', ',', '-', Chr(VK_BACK)])) Or
     ((BetragEdit.SelStart > 0) and (Key = '-')) Or
     ((P <> 0) and (P+1 < Length(BetragEdit.Text)) and
      (BetragEdit.SelStart > P) and (Key <> Chr(VK_BACK))) then
    Key := Chr(0);
end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
Var
  Temp : String;
  BigRect : TRect;
begin
  If DrawGrid1.RowHeights[ARow] > 0 then with DrawGrid1.Canvas do
  Begin
    Brush.Color := clBlack;   
    FillRect(Rect);
    Rect.Right := Rect.Right-1;
    Rect.Bottom := Rect.Bottom-1;
    If ARow = 0 then
    Begin
      Brush.Color := clSkyBlue;
      Font.Color := clBlack;
      Font.Style := Font.Style+[fsBold];
      FillRect(Rect);
      Case ACol of
        0 : TextRect(Rect, Rect.Left+5, Rect.Top+1, 'ID');
        1 : TextRect(Rect, Rect.Left+5, Rect.Top+1, 'Datum');
        2 : TextRect(Rect, Rect.Left+5, Rect.Top+1, 'Kommentar');
        3 : TextRect(Rect, Rect.Left+5, Rect.Top+1, 'Betrag');
        4 : TextRect(Rect, Rect.Left+5, Rect.Top+1, 'Name');
      End;
    End else
    Begin
      Font.Style := Font.Style-[fsBold];
      If (ACol = 3) and (ARow-1 < Length(Kassenbuch)) then
      Begin
        If Kassenbuch[ARow-1].OEintrag.Betrag > 0 then Brush.Color := clMoneyGreen else
          Brush.Color := $008080FF;
      End else
       If  gdSelected in State then Brush.Color := $00F3E9E9
        else Brush.Color := clWhite;
      FillRect(Rect);
      Font.Color := clBlack;
      If ARow-1 < Length(Kassenbuch) then
      Begin
        Temp := CurrToStrF(Kassenbuch[ARow-1].OEintrag.Betrag, ffFixed, 2) + ' €';
        Case ACol of
          0 : TextRect(Rect, Rect.Left+2, Rect.Top+1, IntToStr(Kassenbuch[ARow-1].OEintrag.ID));
          1 : TextRect(Rect, Rect.Left+5, Rect.Top+1, DateToStr(Kassenbuch[ARow-1].OEintrag.Datum));
          2 : TextRect(Rect, Rect.Left+5, Rect.Top+1, Kassenbuch[ARow-1].OEintrag.Kommentar);
          3 : TextRect(Rect, Rect.Right-5-TextWidth(Temp), Rect.Top+1, Temp);
          4 : TextRect(Rect, Rect.Left+5, Rect.Top+1, Kassenbuch[ARow-1].OEintrag.Name);
        End;
      End;
    End;
  End;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If (Trim(KommentarEdit.Text) <> '') and (BetragEdit.Text <> '') then
  Begin
    SetLength(Kassenbuch, Length(Kassenbuch)+1);
    With Kassenbuch[Length(Kassenbuch)-1] do
    Begin
      OEintrag.ID := -1;
      OEintrag.Kommentar := KommentarEdit.Text;
      OEintrag.Betrag := StrToCurr(BetragEdit.Text);
      OEintrag.Entfernt := False;
      If RadioButton1.Checked then
        OEintrag.Datum := Today
      else
        OEintrag.Datum := DateTimePicker1.Date;
      OEintrag.Name := UserNameLabel.Caption;
      NEintrag := True;
    End;        
    KommentarEdit.Text := '';
    BetragEdit.Text := '';
    KommentarEdit.SetFocus;
  End else
    MessageDlg('Kommentar und Betrag müssen ausgefüllt werden!', mtError, [mbOk], 0);
  If Length(Kassenbuch) >= 2 then
    DrawGrid1.RowCount := Length(Kassenbuch)+1
  else
    DrawGrid1.RowCount := 2;
  CalcGesamt;
  DrawGrid1.Refresh;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then Button1Click(Sender);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  SpeicherDatei;
  LadeDatei;
  DrawGrid1.Refresh;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin                    
  KommentarEdit.SetFocus;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  I, Act : Integer;
begin
  Act := DrawGrid1.Selection.Top -1;
  If Kassenbuch[Act].NEintrag then
  Begin
    For I := Act to Length(Kassenbuch)-2 do
      Kassenbuch[I] := Kassenbuch[I+1];
    SetLength(Kassenbuch, Length(Kassenbuch)-1);
  End else
  Begin
    Kassenbuch[Act].OEintrag.Entfernt := True;
    Kassenbuch[Act].NEintrag := True;
  End;

  If Length(Kassenbuch) >= 2 then
    DrawGrid1.RowCount := Length(Kassenbuch)+1
  else
    DrawGrid1.RowCount := 2;
  CalcGesamt;
  DrawGrid1.Refresh;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  I : Integer;
  Temp : Boolean;
begin
  Temp := False;
  For I := 0 to Length(Kassenbuch)-1 do
    Temp := Temp or Kassenbuch[I].NEintrag;
  If Temp then
  Case
    MessageDlg('Einige Datensätze sind noch nicht gespeichert. '+#13+
               'Möchten Sie dies nun nachholen?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    mrYes : Begin CanClose := True; SpeicherDatei; End;
    mrNo  : CanClose := True;
    mrCancel : CanClose := False;
  End;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
Var
  I : Integer;
begin
  For I := 0 to Length(Kassenbuch)-1 do
  Begin
    If Kassenbuch[I].OEintrag.Entfernt and not CheckBox1.Checked then DrawGrid1.RowHeights[I+1] := 0
     else DrawGrid1.RowHeights[I+1] := 16;
  end;
  DrawGrid1.Refresh;
end;

procedure TForm1.FormPaint(Sender: TObject);
Var  I : Integer;
begin
  For I:= 2 to 4 do DrawGrid1.ColWidths[I] := Breiten[I] * (DrawGrid1.Width- 110) div 100 ;
end;

end.
