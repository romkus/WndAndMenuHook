unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls,MyWinClicks_B,MyWinClicks;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Panel3: TPanel;
    StringGrid2: TStringGrid;
    Button2: TButton;
    Edit3: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    Button3: TButton;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const sc_InvalidNumber='Це було некоректне число...';
var
  Form3: TForm3;
  FinishForm3:Integer=-1;
  Form3Waiting:Boolean=False;

implementation
uses MyObjects;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  FinishForm3:=0;
  Form3Waiting:=True;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form3Waiting:=False;
  if FinishForm3<=0 then
  begin
    FinishForm3:=-1;
    Action:=caFree;
    if FinishForm1>=0 then Form1.Button2.Enabled:=True;
  end
  else Action:=caNone;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  Self.StringGrid1.Cells[0,0]:='Тексти вікон';
  Self.StringGrid1.Cells[1,0]:='Класи вікон';
  Self.StringGrid2.Cells[0,0]:='Важіль вікна з меню';
  Self.StringGrid2.Cells[1,0]:='Написи пунктів меню';
  Self.StringGrid2.Cells[0,1]:='0';
end;

procedure TForm3.Button1Click(Sender: TObject);
var NowMas:TMySearchFWinArray;
    p1:Integer;
    NowWindow:hWnd;
begin
  SetLength(NowMas,Self.StringGrid1.RowCount-Self.StringGrid1.FixedRows);
  for p1:=Self.StringGrid1.FixedRows to Self.StringGrid1.RowCount-1 do
  begin
    NowMas[p1-Self.StringGrid1.FixedRows].FWindow:=Self.StringGrid1.Cells[0,p1];
    NowMas[p1-Self.StringGrid1.FixedRows].FWndClass:=Self.StringGrid1.Cells[1,p1];
  end;
  NowWindow:=MyWinClicks.MyShowWindows(Application.Handle,True,True,True,True,NowMas,Nil);
  if NowWindow=0 then
    Self.Edit1.Text:='Вікно не знайдено...'
  else
  begin
    Self.Edit1.Text:=MyGetWindowInfoString(NowWindow,bc_ShowAll);
  end;
end;

procedure TForm3.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=Chr(13) then
  begin
    try
      Self.StringGrid1.RowCount:=Self.StringGrid1.FixedRows+StrToInt(Edit2.Text);
    except
      Edit2.Text:=sc_InvalidNumber;
    end;
  end;
end;

procedure TForm3.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=Chr(13) then
  begin
    try
      Self.StringGrid2.RowCount:=Self.StringGrid2.FixedRows+StrToInt(Edit3.Text);
    except
      Edit3.Text:=sc_InvalidNumber;
    end;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
var NowMas:MWords{TMyStringArray};
    p1:Integer;
    NowWindow:TMyMenuItemRec;
    s1:String;
begin
  SetLength(NowMas,Self.StringGrid2.RowCount-Self.StringGrid2.FixedRows);
  for p1:=Self.StringGrid2.FixedRows to Self.StringGrid2.RowCount-1 do
  begin
    NowMas[p1-Self.StringGrid2.FixedRows]:=Self.StringGrid2.Cells[1,p1];
  end;
  NowWindow:=MyWinClicks.MyShowMenu(Self.StringGrid2.Cells[0,1],
    StrToInt(Self.StringGrid2.Cells[0,1]),NowMas,Nil,Nil);
  if (NowWindow.Menu=0) and (NowWindow.ItemPos=0) then
    Self.Edit4.Text:='Вікно не знайдено...'
  else
  begin
    SetLength(s1,GetMenuString(NowWindow.Menu,NowWindow.ItemPos,nil,
      0,MF_BYPOSITION)+1);
    SetLength(s1,GetMenuString(NowWindow.Menu,NowWindow.ItemPos,PChar(s1),
      Length(s1),MF_BYPOSITION));
    Self.Edit4.Text:='"'+s1+'"';
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
var NowSearching:TMyWaitForWindowHookRec;
begin
  FinishForm3:=FinishForm3+1;
  SetLength(NowSearching.SSearching,1);
  NowSearching.SSearching[0].FWindow:=Edit6.Text;
  NowSearching.SSearching[0].FWndClass:=Edit7.Text;
  NowSearching.SSearching[0].SParent:=0;
  try
    NowSearching.SSearching[0].SWindow:=StrToInt(Edit5.Text);
  except
    NowSearching.SSearching[0].SWindow:=0;
    Edit5.Text:=sc_InvalidNumber;
    Exit;
  end;
  Form3.Button3.Enabled:=False;
  MyWinClicks.MyHookAndWaitForWindow(NowSearching,@Form3Waiting,{Infinite}HCBT_Activate);
  Form3.Button3.Enabled:=True;
  if Form3Waiting then
  begin
    if NowSearching.FoundNames>=0 then
    begin
      Edit6.Text:=NowSearching.SSearching[NowSearching.FoundNames].FWindow;
      Edit7.Text:=NowSearching.SSearching[NowSearching.FoundNames].FWndClass;
      Edit5.Text:=IntToStr(NowSearching.SResultWindow);
    end;
  end;
  FinishForm3:=FinishForm3-1;
  if not(Form3Waiting) then Form3.Close;
end;

end.
