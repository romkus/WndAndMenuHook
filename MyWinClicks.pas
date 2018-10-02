unit MyWinClicks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus,
  MyObjects,MyWinClicks_B, Unit2;

const
   sc_MenuUnderlineIdn='&'; sc_SetTextIdent='Text:';
   sc_SelCBTextIdent='SCBText:';sc_SelLBTextIdent='SLBText:';
   sc_AutoSetOrSelTextIdent='AutoSetOrSelText:';
   sc_AutoForcedSetOrSelTextIdent='AutoForcedSetOrSelText:';
   bc_IsStillRunning=1;bc_CantCreateThread=2;bc_Ok=0;
   bc_ShowAll=0;bc_ShowWindowTitle=1;bc_ShowClassName=2;
   sc_ComboBoxClassName='ComboBox';sc_ListBoxClassName='List';
   sc_EditClassName='Edit';sc_ButtonClassName='Button';
   {bc_WaitForCreate=0;bc_WaitForClose=1;}
type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TGroupBox;
    Panel3: TGroupBox;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    TreeView2: TTreeView;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    {procedure ListBox1Click(Sender: TObject);}
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView2DblClick(Sender: TObject);
    procedure TreeView2Change(Sender: TObject; Node: TTreeNode);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function MyShowMenu(SWindow:String;SWindowHandle:hWnd;
            ArrayToSearch:MWords=Nil;STreeView:TTreeView=Nil;
            SLabel:TLabel=Nil):TMyMenuItemRec;
  procedure MyExecuteMenuItem(SItemString:String;SWindowString:String;
            SItemID:Cardinal;SWindowHandle:hWnd;
            ToActivateWindow:Boolean=True;SLabel:TLabel=Nil);
  function MyGetSuperGrandParentWindow(SWindow:hWnd;
           ToGetGrandOwner:Boolean=False):hWnd;
  function MyGetParentsOfWindow(SWindow:hWnd;
           ToShowOwners:Boolean=False):TMyWindowsArray;
  function MyGetWindowInfoString(SWindow:hWnd;ToShow:Byte=bc_ShowAll):String;
  function MyShowChildWindows(SParentWindow:hWnd;
            var ArrayToSearch:TMySearchFWinArray;SSearchNode:Integer;
            var MaxFoundCount:Integer;STreeNode:TTreeNode=Nil):hWnd;
  function MyShowWindows(SBaseWindow:hWnd;
          ToShowChilds:Boolean=True;ToShowInvisible:Boolean=False;
          ToShowWithoutNames:Boolean=True;ToShowSelf:Boolean=True;
          ArrayToSearch:TMySearchFWinArray=Nil;STreeView:TTreeView=Nil):hWnd;
  function MyShowWindowsWhichHaveOwner(SOwnerWindow:hWnd;
            var ArrayToSearch:TMySearchFWinArray;SSearchNode:Integer;
            var MaxFoundCount:Integer;
            STreeNode:TTreeNode=nil;
            ToShowChilds:Boolean=True;ToShowInvisible:Boolean=False;
            ToShowWithoutNames:Boolean=True):hWnd;
  procedure MyWakeUpWindow(SWindow:hWnd;ToActivate:Boolean=True);
  procedure MyStartWindowHook(var SFoundRec:TMyWaitForWindowHookRec;
           WaitForAction:Cardinal=HCBT_Activate;
           {WaitForMyExAction:Cardinal=0;}
           ExtWindowHookProc:TMyHookWindowExProc=Nil;
           DoNotInstallHook:Boolean=False);
  function MyWaitForWindow(var SFoundRec:TMyWaitForWindowHookRec;
           WaitUntilThisFalse:PMyShortBool;
           DoNotUninstallHook:Boolean=True):hWnd;
  function MyHookAndWaitForWindow(var SFoundRec:TMyWaitForWindowHookRec;
           WaitUntilThisFalse:PMyShortBool;
           WaitForAction:Cardinal=HCBT_Activate;
           {WaitForMyExAction:Cardinal=0;}
           ExtWindowHookProc:TMyHookWindowExProc=Nil;
           DoNotInstallHook:Boolean=False):hWnd;
  function MyPos(SSubString:String;SString:String;
    CaseSensetive:Boolean=False):Integer;
  function MyGetMSGProc(SlParam:TMsg):Integer;
  function MyVarInstall(SNativeWindow:hWnd;SNativeThreadId:Cardinal):Boolean; stdcall;
  procedure MyVarUnInstall; stdcall;
  function MyGetVariable:TMsg; stdcall;
  function MyClickWindow(SWindowHandle:hWnd;SClickType:String;
           ToActivateWindow:Boolean=True):String;

var
  Form1: TForm1;
  WM_MyRomHookMessage:Cardinal=0;
  WM_MyRomHookSyncMessage:Cardinal=0;
  FinishForm1:Integer=-1;
  Form1Waiting:Boolean=False;

implementation
uses Unit3, UMain;
var NowHookRec:TMyWaitForWindowHookRec;
    MyHookWindowExProc:TMyHookWindowExProc=Nil;

{$R *.dfm}

{procedure MyFreeThreadObjects(var SMasyv:TMyClickThreads);
var p1:Integer;
begin
  for p1:=0 to Length(SMasyv)-1 do
  begin
    if SMasyv[p1]<>Nil then
    begin
      SMasyv[p1].Terminate;
      SMasyv[p1].Free;
    end;
  end;
  SetLength(SMasyv,0);
end;}

{procedure InitMyWinClicks;
begin
  if not (MyUnitWinClicksInitialized=True) then
  begin
    SetLength(MyClickThreads,0);
    //MyClicksMessagesCriticalSection:=TCriticalSection.Create;
    MyUnitWinClicksInitialized:=True;
  end;
end;}

{procedure FinalizeMyWinClicks;
begin
  if (MyUnitWinClicksInitialized=True) then
  begin
    MyFreeThreadObjects(MyClickThreads);
    //MyClicksMessagesCriticalSection.Free;
    MyUnitWinClicksInitialized:=False;
  end;
end;}

function MyGetWindowInfoString(SWindow:hWnd;ToShow:Byte=bc_ShowAll):String;
var s1,s2:String;
    p1,p2:Integer;
    NIsOrdinalWindow:Boolean;
begin
  SetLength(s2,256);
  SetLength(s2,GetClassName(SWindow,PChar(s2),Length(s2)));
  if (ToShow=bc_ShowWindowTitle) or (ToShow=bc_ShowAll) then
  begin
    NIsOrdinalWindow:=True;
    if MyPos(sc_ListBoxClassName,s2,False)<>0 then
    begin
      NIsOrdinalWindow:=False;
      p1:=SendMessage(SWindow,LB_GETCARETINDEX,0,0);
      if p1>=0 then
      begin
        p2:=SendMessage(SWindow,LB_GETTEXTLEN,p1,0);
        if p2<>LB_ERR then
        begin
          SetLength(s1,p2+1);
          p2:=SendMessage(SWindow,LB_GETTEXT,p1,Integer(PChar(s1)));
          if p2<>LB_ERR then
            SetLength(s1,p2)
          else NIsOrdinalWindow:=True;
        end
        else NIsOrdinalWindow:=True;
      end
      else NIsOrdinalWindow:=True;
    end;
    if NIsOrdinalWindow=True then
    begin
      SetLength(s1,SendMessage(SWindow,WM_GETTEXTLENGTH,0,0)+1);
      SetLength(s1,SendMessage(SWindow,WM_GETTEXT,Length(s1),
        Integer(PChar(s1))));
      s1:=DeleteWords(s1,sc_MenuUnderlineIdn);
    end;
  end;
  if ToShow=bc_ShowAll then
    MyGetWindowInfoString:=IntToStr(SWindow)+', "'+s1+'"; "'+s2+'"'
  else if ToShow=bc_ShowWindowTitle then
    MyGetWindowInfoString:=s1
  else MyGetWindowInfoString:=s2;
end;

function MyGetSuperGrandParentWindow(SWindow:hWnd;
           ToGetGrandOwner:Boolean=False):hWnd;
var p2,p3,p4:hWnd;
begin
  p3:=SWindow;
  p2:=GetParent(SWindow);
  if not (ToGetGrandOwner) then
  begin
    p4:=GetWindow(SWindow,GW_OWNER);
    if p4=p2 then p2:=0;
  end;
  while p2<>0 do
  begin
    p3:=p2;
    p2:=GetParent(p2);
    if not (ToGetGrandOwner) then
    begin
      p4:=GetWindow(p3,GW_OWNER);
      if p4=p2 then p2:=0;
    end;
  end;
  Result:=p3;
end;

function MyGetParentsOfWindow(SWindow:hWnd;
           ToShowOwners:Boolean=False):TMyWindowsArray;
var p2,p3,p4:hWnd;
    NowParents:TMyWindowsArray;
begin
  SetLength(NowParents,1);
  NowParents[0]:=SWindow;
  p2:=GetParent(SWindow);
  if not (ToShowOwners) then
  begin
    p4:=GetWindow(SWindow,GW_OWNER);
    if p4=p2 then p2:=0;
  end;
  while p2<>0 do
  begin
    p3:=p2;
    SetLength(NowParents,Length(NowParents)+1);
    NowParents[Length(NowParents)-1]:=p3;
    p2:=GetParent(p2);
    if not (ToShowOwners) then
    begin
      p4:=GetWindow(p3,GW_OWNER);
      if p4=p2 then p2:=0;
    end;
  end;
  Result:=NowParents;
end;

procedure MyExecuteMenuItem(SItemString:String;SWindowString:String;
            SItemID:Cardinal;SWindowHandle:hWnd;
            ToActivateWindow:Boolean=True;SLabel:TLabel=Nil);
var p1{,p2}:LongBool;
    NowItemID:Cardinal;
    NowWindowHandle:hWnd;
begin
  if ({MyfindNumberInString(SItemString,',-',p1)=True}SItemID<>0) and
     ({MyfindNumberInString(SWindowString,',-',p2)=True}SWindowHandle<>0) then
  begin
    NowItemID:=SItemID;
    NowWindowHandle:=SWindowHandle;
    MyWakeUpWindow(NowWindowHandle,ToActivateWindow);
    p1:=PostMessage(NowWindowHandle,WM_Command,NowItemID,0);
    if (p1) and (SLabel<>Nil) then
    begin
      //MyClicksMessagesCriticalSection.Enter;
      SLabel.Caption:='Команду меню '+SItemString+' відіслано вікну '+
        SWindowString+' .';
      SLabel.Font.Color:=$00A000;
      SLabel.Visible:=True;
      //MyClicksMessagesCriticalSection.Leave;
    end;
  end;
end;
procedure MyWakeUpWindow(SWindow:hWnd;ToActivate:Boolean=True);
var p2:hWnd;
    prId,thId:Cardinal;
begin
  p2:=MyGetSuperGrandParentWindow(SWindow,False);
  prId:=0;
  thId:=GetWindowThreadProcessId(p2,prId);
  SetPriorityClass(prId,NORMAL_PRIORITY_CLASS);
  SetThreadPriority(thId,THREAD_PRIORITY_NORMAL);
  if ToActivate=True then
  begin
    if IsIconic(p2)=True then
      ShowWindow(p2,SW_Restore)
    else
    begin
      if not (IsWindowVisible(p2)) then ShowWindow(p2,SW_Show);
      SetForegroundWindow(p2);
    end;
    SetActiveWindow(p2);
  end;
end;
function MyClickWindow(SWindowHandle:hWnd;SClickType:String;
           ToActivateWindow:Boolean=True):String;
const sc_Template1='000';
var p1,p2:Integer;
    NWindowHandle:hWnd;
    s1,s2:String;
    {NIsSent:Boolean;}
    ForcedSet:Boolean;
    NowItemRect:Trect;
    ErrorSettingOrSelecting:Boolean;
begin
  ErrorSettingOrSelecting:=False;
  if {MyFindNumberInString(SWindow,',-',p1)=True}SWindowHandle<>0 then
  begin
    NWindowHandle:=SWindowHandle;
    MyWakeUpWindow(NWindowHandle,ToActivateWindow);
    s1:=sc_Template1;
    if Length(SClickType)>=3 then
    begin
      case SClickType[1] of
        '1':if PostMessage(NWindowHandle,WM_LBUTTONDOWN,MK_LBUTTON,0){<>0} then
              s1[1]:=SClickType[1];
        '2':begin
              if PostMessage(NWindowHandle,WM_LBUTTONDOWN,MK_LBUTTON,0){<>0} then
                s1[1]:='1';
              PostMessage(NWindowHandle,WM_LBUTTONUP,0,0);
              if PostMessage(NWindowHandle,WM_LBUTTONDBLCLK,MK_LBUTTON,0){<>0} then
                s1[1]:=SClickType[1];
            end;
      end;
      case SClickType[2] of
        '1':if PostMessage(NWindowHandle,WM_MBUTTONDOWN,MK_MBUTTON,0){<>0} then
             s1[2]:=SClickType[2];
        '2':begin
             if PostMessage(NWindowHandle,WM_MBUTTONDOWN,MK_MBUTTON,0){<>0} then
               s1[2]:='1';
             PostMessage(NWindowHandle,WM_MBUTTONUP,0,0);
             if PostMessage(NWindowHandle,WM_MBUTTONDBLCLK,MK_MBUTTON,0){<>0} then
               s1[2]:=SClickType[2];
            end;
      end;
      case SClickType[3] of
        '1':if PostMessage(NWindowHandle,WM_RBUTTONDOWN,MK_RBUTTON,0){<>0} then
              s1[3]:=SClickType[3];
        '2':begin
              if PostMessage(NWindowHandle,WM_RBUTTONDOWN,MK_RBUTTON,0){<>0} then
                s1[3]:='1';
              PostMessage(NWindowHandle,WM_RBUTTONUP,0,0);
              if PostMessage(NWindowHandle,WM_RBUTTONDBLCLK,MK_RBUTTON,0){<>0} then
                s1[3]:=SClickType[3];
            end;
      end;
      if (SClickType[1]='1') or (SClickType[1]='2') then
         PostMessage(NWindowHandle,WM_LBUTTONUP,0,0);
      if (SClickType[2]='1') or (SClickType[2]='2') then
         PostMessage(NWindowHandle,WM_MBUTTONUP,0,0);
      if (SClickType[3]='1') or (SClickType[3]='2') then
         PostMessage(NWindowHandle,WM_RBUTTONUP,0,0);
    end;
    if s1=sc_Template1 then
    begin
      p1:=Pos(sc_AutoSetOrSelTextIdent,SClickType);
      ForcedSet:=False;
      if p1=1 then s1:=Copy(SClickType,p1+Length(sc_AutoSetOrSelTextIdent),
         Length(SClickType)-p1-Length(sc_AutoSetOrSelTextIdent)+1)
      else
      begin
        p1:=Pos(sc_AutoForcedSetOrSelTextIdent,SClickType);
        if p1=1 then
        begin
          s1:=Copy(SClickType,p1+Length(sc_AutoForcedSetOrSelTextIdent),
            Length(SClickType)-p1-Length(sc_AutoForcedSetOrSelTextIdent)+1);
          ForcedSet:=True;
        end;
      end;
      if p1=1 then
      begin
        {NIsSent:=False;}
        s2:=MyGetWindowInfoString(NWindowHandle,bc_ShowClassName);
        if MyPos(sc_ComboBoxClassName,s2,False)<>0 then
        begin
          if SendMessage(NWindowHandle,CB_SELECTSTRING,-1,Integer(PChar(s1)))=CB_ERR then
          {PostThreadMessage}
            {NIsSent:=True
          else} if ForcedSet then
          begin
            {p2:=}SendMessage(NWindowHandle,CB_ADDSTRING,-1,Integer(PChar(s1)));
            {if (p2<>CB_ERR) and (p2<>CB_ERRSPACE) then
              NIsSent:=True;}
          end;
        end;
        if MyPos(sc_ListBoxClassName,s2,False)<>0 then
        begin
          p2:=SendMessage(NWindowHandle,LB_SELECTSTRING,-1,Integer(PChar(s1)));
          if p2=LB_ERR then
            {NIsSent:=True
          else} if ForcedSet then
          begin
            p2:=SendMessage(NWindowHandle,LB_ADDSTRING,-1,Integer(PChar(s1)));
            {if (p2<>LB_ERR) and (p2<>LB_ERRSPACE) then
              NIsSent:=True;}
          end;
          if (p2<>LB_ERR) and (p2<>LB_ERRSPACE) then
          begin
            ErrorSettingOrSelecting:=True;
            if SendMessage(NWindowHandle,LB_GETITEMRECT,p2,Integer(@NowItemRect))<>LB_ERR then
            begin
              {Windows.MessageBox(0,PChar('X='+IntToStr(NowItemRect.Left)+' Y='+
                IntToStr(NowItemRect.Top)),'Координати:',MB_Ok);}
              Form4.StatusBar1.SimpleText:='Координати: '+'X='+
                IntToStr(NowItemRect.Left)+' Y='+IntToStr(NowItemRect.Top);
              if (SendMessage(NWindowHandle,WM_LBUTTONDOWN,MK_LBUTTON,
                Cardinal(SmallInt(NowItemRect.Left)) or
                ((Cardinal(SmallInt(NowItemRect.Top)) shl 16) and $FFFF0000))=0) and
                (SendMessage(NWindowHandle,WM_LBUTTONUP,0,
                Cardinal(SmallInt(NowItemRect.Left)) or
                ((Cardinal(SmallInt(NowItemRect.Top)) shl 16) and $FFFF0000))=0) then
                  ErrorSettingOrSelecting:=False;
            end;
          end;
        end;
        {if Not(NIsSent) then}
        SendMessage(NWindowHandle,WM_SETTEXT,0,Integer(PChar(s1)));
        if ErrorSettingOrSelecting then Result:='' else
          Result:=MyGetWindowInfoString(NWindowHandle,bc_ShowWindowTitle);
        Exit;
      end;
      p1:=Pos(sc_SetTextIdent,SClickType);
      if p1=1 then
      begin
        s1:=Copy(SClickType,p1+Length(sc_SetTextIdent),
          Length(SClickType)-p1-Length(sc_SetTextIdent)+1);
        SendMessage(NWindowHandle,WM_SETTEXT,0,Integer(PChar(s1)));
        Result:=MyGetWindowInfoString(NWindowHandle,bc_ShowWindowTitle);
        Exit;
      end;
      p1:=Pos(sc_SelLBTextIdent,SClickType);
      if p1=1 then
      begin
        s1:=Copy(SClickType,p1+Length(sc_SelLBTextIdent),
          Length(SClickType)-p1-Length(sc_SelLBTextIdent)+1);
        p2:=SendMessage(NWindowHandle,LB_SELECTSTRING,-1,Integer(PChar(s1)));
        if p2<>LB_ERR then
        begin
          ErrorSettingOrSelecting:=True;
          if SendMessage(NWindowHandle,LB_GETITEMRECT,p2,Integer(@NowItemRect))<>LB_ERR then
          begin
            if {not (}(SendMessage(NWindowHandle,WM_LBUTTONDOWN,MK_LBUTTON,
              Cardinal(SmallInt(NowItemRect.Left)) or
              ((Cardinal(SmallInt(NowItemRect.Top)) shl 16) and $FFFF0000))=0) and
              (SendMessage(NWindowHandle,WM_LBUTTONUP,0,
              Cardinal(SmallInt(NowItemRect.Left)) or
              ((Cardinal(SmallInt(NowItemRect.Top)) shl 16) and $FFFF0000))=0){)} then
                ErrorSettingOrSelecting:=False;
          end;
        end;
        if ErrorSettingOrSelecting then Result:='' else
          Result:=MyGetWindowInfoString(NWindowHandle,bc_ShowWindowTitle);
        Exit;
      end;
      p1:=Pos(sc_SelCBTextIdent,SClickType);
      if p1=1 then
      begin
        s1:=Copy(SClickType,p1+Length(sc_SelCBTextIdent),
          Length(SClickType)-p1-Length(sc_SelCBTextIdent)+1);
        SendMessage(NWindowHandle,CB_SELECTSTRING,-1,Integer(PChar(s1)));
        Result:=MyGetWindowInfoString(NWindowHandle,bc_ShowWindowTitle);
      end
      else Result:='';
    end
    else Result:=s1;
    {if (p1<>0) or (p3<>0) then
      MessageDlg('Вікно не прийняло натискання кнопки миші...',mtError,[mbOk],0);}
  end;
end;

{procedure TMyClickWindowThread.Execute;
begin
  with Self.MyClickData do
  begin
    if MenuClick=True then
    begin
      MyExecuteMenuItem(SItemString,SWindowString,SItemID,SWindowHandle);
    end
    else
    begin
      SWindowString:=MyClickWindow(SWindowString,SWindowHandle,SClickType);
    end;
  end;
  if Self.FreeOnTerminate then
  begin
    if Length(MyClickThreads)-1>=Self.MyClickData.IndexInMasyv then
    begin
      if MyClickThreads[Self.MyClickData.IndexInMasyv]=Self then
        MyClickThreads[Self.MyClickData.IndexInMasyv]:=Nil;
    end;
  end;
end;}

function MyPos(SSubString:String;SString:String;CaseSensetive:Boolean=False):Integer;
begin
  if Not(CaseSensetive) then
  begin
    SSubString:=AnsiUpperCase(SSubString);
    SString:=AnsiUpperCase(SString);
  end;
  MyPos:=Pos(SSubString,SString);
end;


function MyGetMSGProc(SlParam:TMsg):Integer;
  {  Функція отримує повідомлення, що було перехоплене модулем-ловцем
   повідомлень (окремим dll) і передане в головну програму,
   перевіряє, чи це повідомлення було того виду, який очікувався,
   читає текст в цьому вікні, назву класу вікна, і номер-важіль (hwnd).
   Якщо хоч один з цих параметрів вікна містить шукані параметри
   (підрядок у тексті чи в назві класу, номер важеля), то встановлює
   прапорець про те, що шукане вікно знайдене, і записує всі ці його
   параметри (текст у вікні, назву класу вікна, важіль).
     Вхідні параметри:
       SlParam - запис-повідомлення, що було надіслано якомусь вікну
         і було перехоплено;
       NowHookRec - глобальна змінна-запис (у даному модулі) з параметрами
         шуканого вікна.
     Вихідні дані:
       NowHookRec - запис з параметрами знайденого вікна (якщо знайдене) і
         поміткою про те, чи було вікно, повідомлення для якого перехоплене,
         шуканим (і знайденим). }
var NowMSGRec:TMsg;
    NParent,NWindow:hWnd;
    p2:Integer;
    NowMessage:Cardinal;
    Found:Boolean;
    NowWindow,NowClass:String;
begin
  Found:=False;
  NowMSGRec:=SlParam;
  {if NowHookRec.WaitingForMyExAction=0 then}
    NowMessage:=NowHookRec.WaitingForAction;
  {else NowMessage:=0;}
  if {(}(NowMessage=NowMSGRec.message) or (NowMessage=Infinite){) and
     (NowMSGRec.message<>HCBT_CREATEWND)} then
  begin
    if (NowMSGRec.hwnd<>0) then
    begin
      NowClass:=MyGetWindowInfoString(NowMSGRec.hwnd,bc_ShowClassName);
        {  Якщо це було повідомлення про створення нового вікна, то
         вважаємо його текст пустим (ще не заповнений):}
      if NowMSGRec.message<>HCBT_CREATEWND then
      begin
        NowWindow:=MyGetWindowInfoString(NowMSGRec.hwnd,bc_ShowWindowTitle);
      end
      else
      begin
        NowWindow:='';
      end;
      NParent:=MyGetSuperGrandParentWindow(NowMSGRec.hwnd,True);
        {GetParent(NowMSGRec.hwnd);}
      NWindow:=NowMSGRec.hwnd;
      for p2:=0 to Length(NowHookRec.SSearching)-1 do
      begin
        if (NWindow<>0) and
           (NowHookRec.SSearching[p2].SWindow=NWindow) then
        begin
          NowHookRec.SSearching[p2].FWindow:=NowWindow;
          NowHookRec.SSearching[p2].FWndClass:=NowClass;
          NowHookRec.FoundNames:=p2;
          NowHookRec.SResultWindow:=NowMSGRec.hwnd;
          NowHookRec.FoundOnMessage:=NowMSGRec.message;
          Found:=True;
        end
        else if ((NowHookRec.SSearching[p2].SParent=0) and
           (NowHookRec.SSearching[p2].SWindow=0)) or
           ((NParent=NowHookRec.SSearching[p2].SParent) and (NParent<>0)) then
        begin
          if ((NowHookRec.SSearching[p2].FWindow='') or
             (MyPos(NowHookRec.SSearching[p2].FWindow, NowWindow)<>0)) and
             ((NowHookRec.SSearching[p2].FWndClass='') or
             (MyPos(NowHookRec.SSearching[p2].FWndClass, NowClass)<>0)) then
          begin
            NowHookRec.SSearching[p2].FWindow:=NowWindow;
            NowHookRec.SSearching[p2].FWndClass:=NowClass;
            NowHookRec.FoundNames:=p2;
            NowHookRec.SResultWindow:=NowMSGRec.hwnd;
            NowHookRec.FoundOnMessage:=NowMSGRec.message;
            Found:=True;
          end;
        end;
        if Found=True then Break;
      end;
    end;
  end;
  if (NowMSGRec.hwnd<>0) and (@MyHookWindowExProc<>Nil) then
  begin
    Result:=MyHookWindowExProc(NowHookRec,NowMSGRec);
  end
  else Result:=0;
end;

{function MyAPCFunction(SParam:Cardinal):Cardinal; stdcall;
  begin
    Result:=0;
  end;}
function MyGetMSGProc_Dll(SHookCode:Integer;SwParam:WParam;SlParam:PMSG):Integer; stdcall; external 'MyHookDLL1.dll';
function MyVarInstall(SNativeWindow:hWnd;SNativeThreadId:Cardinal):Boolean; stdcall; external 'MyHookDLL1.dll';
procedure MyVarUnInstall; stdcall; external 'MyHookDLL1.dll';
function MyGetVariable:TMsg; stdcall; external 'MyHookDLL1.dll';

procedure MyStartWindowHook(var SFoundRec:TMyWaitForWindowHookRec;
           WaitForAction:Cardinal=HCBT_Activate;
           {WaitForMyExAction:Cardinal=0;}
           ExtWindowHookProc:TMyHookWindowExProc=Nil;
           DoNotInstallHook:Boolean=False);
begin
  NowHookRec:=SFoundRec;
  NowHookRec.WaitingForAction:=WaitForAction;
  {NowHookRec.WaitingForMyExAction:=WaitForMyExAction;}
  NowHookRec.SResultWindow:=0;
  NowHookRec.FoundNames:=-1;
  if @ExtWindowHookProc<>Nil then
    MyHookWindowExProc:=ExtWindowHookProc;
  if not(DoNotInstallHook) then
    MyVarInstall(Application.Handle,GetCurrentThreadId{,WaitForAction});
end;

function MyWaitForWindow(var SFoundRec:TMyWaitForWindowHookRec;
           WaitUntilThisFalse:PMyShortBool;
           DoNotUninstallHook:Boolean=True):hWnd;
var b1:Boolean;
    {NMsg:TMsg;}
begin
  b1:=True;
  if WaitUntilThisFalse=Nil then WaitUntilThisFalse:=@b1;
  Application.ProcessMessages;
  while (NowHookRec.FoundNames<0) and ((WaitUntilThisFalse^=True)
    and (MyAppWaiting=True)) do
  begin
  {repeat}
    {if not(Boolean(PeekMessage(NMsg,0,0,0,PM_NOREMOVE))) then WaitMessage;
    Application.ProcessMessages;}
    Application.HandleMessage;
  {until (NowHookRec.FoundNames>=0) or (not (WaitUntilThisFalse^))
    or (not (MyAppWaiting));}
  end;
  Application.ProcessMessages;
  if Not(DoNotUninstallHook) then MyVarUninstall;
  SFoundRec:=NowHookRec;
  Result:=NowHookRec.SResultWindow;
end;

function MyHookAndWaitForWindow(var SFoundRec:TMyWaitForWindowHookRec;
           WaitUntilThisFalse:PMyShortBool;
           WaitForAction:Cardinal=HCBT_Activate;
           {WaitForMyExAction:Cardinal=0;}
           ExtWindowHookProc:TMyHookWindowExProc=Nil;
           DoNotInstallHook:Boolean=False):hWnd;
begin
  MyStartWindowHook(SFoundRec,WaitForAction,{WaitForMyExAction,}
    ExtWindowHookProc,DoNotInstallHook);
  Result:=MyWaitForWindow(SFoundRec,WaitUntilThisFalse);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.Button2.Enabled:=False;
  Form3:=TForm3.Create(Application);
  Form3.Show;

  {GetModuleHandle}

  {SetWindowsHookEx, WH_GETMESSAGE
  WM_ACTIVATE
  WM_CREATE
  GetCurrentThread
  WaitForSingleObjectEx
  GetWindowThreadProcessId
  GetWindowTask
  QueueUserAPC
  PostMessage використай замість SendMessage - і, може,
    не потрібні будуть паралельні потоки}

  {getwindow
  getwindowlong
  GetClassName
  findwindow
  EnumWindows
  EnumWindowsProc
  GetWindowText
  SetWindowText

  IsWindowVisible(WndHandle)
  якщо GetWindow(WndHandle, gw_Owner) = 0 , то
    вікно WndHandle не дочірнє}

  {TThreadStartRoutine = function(lpThreadParameter: Pointer): Integer stdcall;
  procedure TForm1.Button1Click(Sender: TObject);
  var
  h1:cardinal;
  begin
    createthread(nil,128,@printh,self,0,h1);
  end;}




  {gw_child
  getscrollrange
  getscrollinfo
  setwindowlong
  BorlandIDEServices}

  {GetSystemMenu
  GetMenu
  GetSubMenu
  GetMenuItemCount
  GetMenuString
  GetMenuItemID
  WM_COMMAND
  AppendMenu}

  {CB_FINDSTRING - повідомлення - знайти рядок у ComboBox! Видає знайдений рядок
   (якщо знайдений),перші символи якого співпадають з заданим рядком (без
   врахування регістру символів). Якщо рядок не знайдений, то видає значення
   "CB_ERR" (CB_ERR = -1).

  CB_SELECTSTRING
  wParam = (WPARAM) indexStart;          // item before first selection
  lParam = (LPARAM) (LPCSTR) lpszSelect; // address of prefix string
  CB_SELECTSTRING - повідомлення - вибрати вказаний рядок у ComboBox! Видає
    індекс вибраного рядка, якщо такий знайдений,
    перші символи якого співпадають з заданим рядком (без
    врахування регістру символів). Якщо рядок не знайдений, то видає значення
   "CB_ERR" (CB_ERR = -1), і вибраний рядок не змінюється.}

   {WM_SETTEXT
   WM_GETTEXTLENGTH
   WM_GETTEXT
   EM_GETSELTEXT}
end;

{function DeleteWords(SourceString,SubstringMarker:string):string;
var p1:integer;
    s:string;
begin
  s:=SourceString;
  p1:=pos(SubstringMarker,s);
  while p1<>0 do
  begin
    delete(s,p1,length(SubstringMarker));
    p1:=pos(SubstringMarker,s);
  end;
  DeleteWords:=s;
end;}

function MyShowChildWindows(SParentWindow:hWnd;
            var ArrayToSearch:TMySearchFWinArray;SSearchNode:Integer;
            var MaxFoundCount:Integer;STreeNode:TTreeNode=Nil):hWnd;
type
  TMyWindowsRec=Record
    NeedParent:hWnd;
    ChildWindows:TMyWindowsArray;
  end;
var p1,p2:Integer;
    p3,FoundWnd,NWnd: hWnd;
    NMaxFoundCount,NFoundCount:Integer;
    s1,s2:String;
    NTreeItem:TTreeNode;
    MyChildWindowsMasyv:TMyWindowsRec;
    pnt1:Pointer;
    NowIcon:TIcon;
    function MyEnumerateChildsProc(SChildWindow:hWnd;LParam:Integer):Boolean; stdcall;
    var sfp1:Cardinal;
        sfMyChildWindowsMasyvp:^TMyWindowsRec;
    begin
      sfMyChildWindowsMasyvp:=Pointer(LParam);
      sfp1:=GetParent(SChildWindow);
      if sfMyChildWindowsMasyvp^.NeedParent=sfp1 then
      begin
        sfp1:=Length(sfMyChildWindowsMasyvp^.ChildWindows);
        SetLength(sfMyChildWindowsMasyvp^.ChildWindows,sfp1+1);
        sfMyChildWindowsMasyvp^.ChildWindows[sfp1]:=SChildWindow;
      end;
      Result:=True;
    end;
begin
  if (STreeNode=Nil) and (ArrayToSearch=Nil) then
  begin
    Result:=0;
    Exit;
  end;
  SetLength(MyChildWindowsMasyv.ChildWindows,0);
  MyChildWindowsMasyv.NeedParent:=SParentWindow;
  pnt1:=@MyChildWindowsMasyv;
  EnumChildWindows(SParentWindow,@MyEnumerateChildsProc,Integer(pnt1));
  FoundWnd:=0;
  NMaxFoundCount:=0;
  NFoundCount:=0;
  p1:=Length(MyChildWindowsMasyv.ChildWindows);
  if STreeNode<>Nil then
  begin
    for p2:=0 to p1-1 do
    begin
      //MyClicksMessagesCriticalSection.Enter;
      s1:=MyGetWindowInfoString(MyChildWindowsMasyv.ChildWindows[p2]);
      //MyClicksMessagesCriticalSection.Leave;
      p3:=MyChildWindowsMasyv.ChildWindows[p2];
      NTreeItem:=TTreeView(STreeNode.TreeView).Items.AddChild(STreeNode,s1);
      NTreeItem.Data:=Pointer(p3);
      NowIcon:=TIcon.Create;
      NowIcon.Handle:=GetClassLong(p3,GCL_HICON);
      if NowIcon.Handle=0 then
      begin
        NowIcon.Free;
        NTreeItem.ImageIndex:=-1;
        NTreeItem.SelectedIndex:=-1;
      end
      else
      begin
        p1:=TTreeView(NTreeItem.TreeView).Images.AddIcon(NowIcon);
        NTreeItem.ImageIndex:=p1;
        NTreeItem.SelectedIndex:=p1;
      end;

      MyShowChildWindows(MyChildWindowsMasyv.ChildWindows[p2],ArrayToSearch,
        0,NFoundCount,NTreeItem);
    end;
  end
  else
  begin
    for p2:=0 to p1-1 do
    begin
      NFoundCount:=0;
      s1:=MyGetWindowInfoString(MyChildWindowsMasyv.ChildWindows[p2],
        bc_ShowWindowTitle);
      s2:=MyGetWindowInfoString(MyChildWindowsMasyv.ChildWindows[p2],
        bc_ShowClassName);
      if (MyPos(DeleteWords(ArrayToSearch[SSearchNode].FWindow,
        sc_MenuUnderlineIdn),s1)<>0) then
          NFoundCount:=NFoundCount+1;
      if (MyPos(ArrayToSearch[SSearchNode].FWndClass,
           s2)<>0) then NFoundCount:=NFoundCount+1;
      NWnd:=MyChildWindowsMasyv.ChildWindows[p2];
      if (Length(ArrayToSearch)>SSearchNode+1) and ((NFoundCount>0) or
         ((DeleteWords(ArrayToSearch[SSearchNode].FWindow,
           sc_MenuUnderlineIdn)='') and (ArrayToSearch[SSearchNode].FWndClass=''))) then
      begin
        NWnd:=MyShowChildWindows(MyChildWindowsMasyv.ChildWindows[p2],
          ArrayToSearch,SSearchNode+1,NFoundCount,Nil);
      end;
      if NMaxFoundCount<NFoundCount then
      begin
        NMaxFoundCount:=NFoundCount;
        FoundWnd:=NWnd;
      end;
    end;
  end;
  MaxFoundCount:=MaxFoundCount+NMaxFoundCount;
  Result:=FoundWnd;
end;

function MyShowWindowsWhichHaveOwner(SOwnerWindow:hWnd;
            var ArrayToSearch:TMySearchFWinArray;SSearchNode:Integer;
            var MaxFoundCount:Integer;
            STreeNode:TTreeNode=nil;
            ToShowChilds:Boolean=True;ToShowInvisible:Boolean=False;
            ToShowWithoutNames:Boolean=True):hWnd;
VAR
  Wnd,FoundWnd,NWnd: hWnd;
  NMaxFoundCount,NFoundCount:Integer;
  {buff: ARRAY [0..255] OF Char;}
  {buff:String;}
  NowNode:TTreeNode;
  NowIcon:TIcon;
  s1,s2:String;
  p1:Integer;
begin
  if (STreeNode=Nil) and (ArrayToSearch=Nil) then
  begin
    Result:=0;
    Exit;
  end;
  FoundWnd:=0;
  NMaxFoundCount:=0;
  NFoundCount:=0;
  Wnd := GetWindow(SOwnerWindow, gw_HWndFirst);
  WHILE Wnd <> 0 DO BEGIN
    IF ((IsWindowVisible(Wnd)) or
         (ToShowInvisible)) AND //-Невидимі вікна
       (GetWindow(Wnd, gw_Owner) = SOwnerWindow) AND //-Вікна, що мають власників (Owner - ів)
       (({GetWindowText(Wnd, PChar(buff), Length(buff))}
         SendMessage(Wnd,WM_GETTEXTLENGTH,0,0)<> 0) or
         (ToShowWithoutNames)) //-Вікна без заголовків
    THEN BEGIN
      if STreeNode<>Nil then
      begin
        //MyClicksMessagesCriticalSection.Enter;
        s1:=MyGetWindowInfoString(Wnd);
        //MyClicksMessagesCriticalSection.Leave;
        NowNode:=TTreeView(STreeNode.TreeView).Items.AddChild(STreeNode,
          {IntToStr(Wnd)+',- }{'"'+buff+'"; "'+s1+'"'}s1);
        NowNode.Data:=Pointer(Wnd);
        NowIcon:=TIcon.Create;
        NowIcon.Handle:=GetClassLong(Wnd,GCL_HICON);
        if NowIcon.Handle=0 then
        begin
          NowIcon.Free;
          NowNode.ImageIndex:=-1;
          NowNode.SelectedIndex:=-1;
        end
        else
        begin
          p1:=TTreeView(NowNode.TreeView).Images.AddIcon(NowIcon);
          NowNode.ImageIndex:=p1;
          NowNode.SelectedIndex:=p1;
        end;
        MyShowWindowsWhichHaveOwner(Wnd,ArrayToSearch,0,NFoundCount,NowNode,
          ToShowChilds,ToShowInvisible,ToShowWithoutNames);
      end
      else
      begin
        NFoundCount:=0;
        s1:=MyGetWindowInfoString(Wnd,bc_ShowWindowTitle);
        s2:=MyGetWindowInfoString(Wnd,bc_ShowClassName);
        if (MyPos(DeleteWords(ArrayToSearch[SSearchNode].FWindow,
          sc_MenuUnderlineIdn),s1)<>0) then
            NFoundCount:=NFoundCount+1;
        if (MyPos(ArrayToSearch[SSearchNode].FWndClass,
             s2)<>0)then
            NFoundCount:=NFoundCount+1;
        NWnd:=Wnd;
        if (Length(ArrayToSearch)>SSearchNode+1) and ((NFoundCount>0) or
           ((DeleteWords(ArrayToSearch[SSearchNode].FWindow,
          sc_MenuUnderlineIdn)='') and (ArrayToSearch[SSearchNode].FWndClass=''))) then
        begin
          NWnd:=MyShowWindowsWhichHaveOwner(Wnd,ArrayToSearch,SSearchNode+1,NFoundCount,nil,
            ToShowChilds,ToShowInvisible,ToShowWithoutNames);
        end;
        if NMaxFoundCount<NFoundCount then
        begin
          NMaxfoundCount:=NFoundCount;
          FoundWnd:=NWnd;
        end;
      end;
    END;
    Wnd := GetWindow(Wnd, gw_hWndNext);
  END;
  if ToShowChilds then
  begin
    NFoundCount:=0;
    NWnd:=MyShowChildWindows(SOwnerWindow,ArrayToSearch,SSearchNode,NFoundCount,
      STreeNode);
    if STreeNode=Nil then
      if NMaxFoundCount<NFoundCount then
      begin
        NMaxFoundCount:=NFoundCount;
        FoundWnd:=NWnd;
      end;
  end;
  MaxFoundCount:=MaxFoundCount+NMaxFoundCount;
  Result:=FoundWnd;
  {ListBox1.ItemIndex := 0;}
end;

function MyShowWindows(SBaseWindow:hWnd;
          ToShowChilds:Boolean=True;ToShowInvisible:Boolean=False;
          ToShowWithoutNames:Boolean=True;ToShowSelf:Boolean=True;
          ArrayToSearch:TMySearchFWinArray=Nil;STreeView:TTreeView=Nil):hWnd;
VAR
  Wnd,FoundWnd,NWnd: hWnd;
  MaxFoundCount,NFoundCount:Integer;
  NowNode:TTreeNode;
  NowIcon:TIcon;
  s1,s2:String;
  p1:Integer;
begin
  if (STreeView=Nil) and (ArrayToSearch=Nil) then
  begin
    Result:=0;
    Exit;
  end;
  if STreeView<>Nil then
  begin
    STreeView.Items.Clear;
    if STreeView.Images<>Nil then
      STreeView.Images.Clear;
  end;
  FoundWnd:=0;
  MaxFoundCount:=0;
  NFoundCount:=0;
  Wnd := GetWindow(SBaseWindow, gw_HWndFirst);
  WHILE Wnd <> 0 DO BEGIN
    IF ((Wnd <> Application.Handle) or
         (ToShowSelf)) AND //-Власне вікно
       ((IsWindowVisible(Wnd)) or
         (ToShowInvisible)) AND //-Невидимі вікна
       (GetWindow(Wnd, gw_Owner) = 0) AND //-Вікна, що не мають власників (Owner - ів)
       ((
         SendMessage(Wnd,WM_GETTEXTLENGTH,0,0)<> 0) or
         (ToShowWithoutNames)) //-Вікна без заголовків
    THEN BEGIN
      if STreeView<>Nil then
      begin
        //MyClicksMessagesCriticalSection.Enter;
        s1:=MyGetWindowInfoString(Wnd,bc_ShowAll);
        //MyClicksMessagesCriticalSection.Leave;
        NowNode:=STreeView.Items.Add(nil,s1);
        NowNode.Data:=Pointer(Wnd);
        NowIcon:=TIcon.Create;
        NowIcon.Handle:=GetClassLong(Wnd,GCL_HICON);
        if NowIcon.Handle=0 then
        begin
          NowIcon.Free;
          NowNode.ImageIndex:=-1;
          NowNode.SelectedIndex:=-1;
        end
        else
        begin
          p1:=TTreeView(NowNode.TreeView).Images.AddIcon(NowIcon);
          NowNode.ImageIndex:=p1;
          NowNode.SelectedIndex:=p1;
        end;
        MyShowWindowsWhichHaveOwner(Wnd,ArrayToSearch,0,NFoundCount,NowNode,
          ToShowChilds,ToShowInvisible,ToShowWithoutNames);
      end
      else
      begin
        NFoundCount:=0;
        s1:=MyGetWindowInfoString(Wnd,bc_ShowWindowTitle);
        s2:=MyGetWindowInfoString(Wnd,bc_ShowClassName);
        if (MyPos(DeleteWords(ArrayToSearch[0].FWindow,
          sc_MenuUnderlineIdn),s1)<>0) then
            NFoundCount:=NFoundCount+1;
        if (MyPos(ArrayToSearch[0].FWndClass,
          s2)<>0) then NFoundCount:=NFoundCount+1;
        NWnd:=Wnd;
        if (Length(ArrayToSearch)>1) and ((NFoundCount>0) or
           ((DeleteWords(ArrayToSearch[0].FWindow,sc_MenuUnderlineIdn)='')
             and (ArrayToSearch[0].FWndClass=''))) then
        begin
          NWnd:=MyShowWindowsWhichHaveOwner(Wnd,ArrayToSearch,1,NFoundCount,nil,
            ToShowChilds,ToShowInvisible,ToShowWithoutNames);
        end;
        if MaxFoundCount<NFoundCount then
        begin
          MaxfoundCount:=NFoundCount;
          FoundWnd:=NWnd;
        end;
      end;
      //if Self.CheckBox3.Checked then MyShowChildWindows(Wnd,NowNode);
    END;
    Wnd := GetWindow(Wnd, gw_hWndNext);
  END;
  Result:=FoundWnd;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  MyShowWindows(Self.Handle,Self.CheckBox3.Checked,Self.CheckBox2.Checked,
    Self.CheckBox4.Checked,Self.CheckBox1.Checked,Nil,Self.TreeView2);
end;

function MyShowChildMenus(SMenuItem:HMenu;var ArrayToSearch:MWords{TMyStringArray};
           SSearchNode:Integer;var MaxFoundCount:Integer;
           STreeNode:TTreeNode=Nil;SLabel:TLabel=Nil):TMyMenuItemRec;
var p1,p2:Integer;
    p3:Cardinal;
    s1:String;
    NTreeItem:TTreeNode;
    NMenu2{,NMenu}: hMenu;
    FoundMenu,NMenu:TMyMenuItemRec;
    NMaxFoundCount,NFoundCount:Integer;
    {NowItemInfo:tagMENUITEMINFOA;
    NowIcon:TBitmap;}
begin
  if (ArrayToSearch=Nil) and (STreeNode=Nil) then
  begin
    Result.Menu:=0;
    Result.ItemPos:=0;
    Exit;
  end;
  {if SMenuItem<>0 then
  begin}
    FoundMenu.Menu:=0;
    FoundMenu.ItemPos:=0;
    NMaxFoundCount:=0;
    NFoundCount:=0;
    p1:=GetMenuItemCount(SMenuItem);
    if p1<0 then
    begin
      {MessageDlg('Помилка при пошуку підменю у дереві меню!..',
        mtError,[mbOk],0);}
      if SLabel<>Nil then
      begin
        //MyClicksMessagesCriticalSection.Enter;
        SLabel.Caption:='Помилка при пошуку підменю у дереві меню!..';
        SLabel.Font.Color:=$0000C0;
        SLabel.Visible:=True;
        //MyClicksMessagesCriticalSection.Leave;
      end;
    end;
    for p2:=0 to p1-1 do
    begin
      SetLength(s1,GetMenuString(SMenuItem,p2,nil,
        0,MF_ByPosition)+1);
      SetLength(s1,GetMenuString(SMenuItem,p2,PChar(s1),
        Length(s1),MF_ByPosition));
      p3:=GetMenuItemID(SMenuItem,p2);
      s1:={IntToStr(p3)+',- }DeleteWords(s1,sc_MenuUnderlineIdn);
      NMenu2:=GetSubMenu(SMenuItem,p2);
      if STreeNode<>Nil then
      begin
        NTreeItem:=TTreeView(STreeNode.TreeView).Items.AddChild(STreeNode,
          '"'+s1+'"');
        NTreeItem.Data:=Pointer(p3);
        if NMenu2<>0 then
        begin
          MyShowChildMenus(NMenu2,ArrayToSearch,0,NFoundCount,NTreeItem,SLabel);
        end;
      end
      else
      begin
        NFoundCount:=0;
        {s1:=MyGetWindowInfoString(Wnd,bc_ShowWindowTitle);
        s2:=MyGetWindowInfoString(Wnd,bc_ShowClassName);}
        if (MyPos(DeleteWords(ArrayToSearch[SSearchNode],
          sc_MenuUnderlineIdn),s1)<>0) then
            NFoundCount:=NFoundCount+1;
        {if Pos(ArrayToSearch[0].FWndClass,s2)<>0 then
          NFoundCount:=NFoundCount+1;}
        NMenu.Menu:=SMenuItem;
        NMenu.ItemPos:=p2;
        if (Length(ArrayToSearch)>SSearchNode+1) and ((NFoundCount>0) or
           (DeleteWords(ArrayToSearch[SSearchNode],
          sc_MenuUnderlineIdn)='')) then
        begin
          if NMenu2<>0 then
          begin
            NMenu:=MyShowChildMenus(NMenu2,ArrayToSearch,SSearchNode+1,
              NFoundCount,Nil,SLabel);
          end
          else
          begin
            NMenu.Menu:=0;
            NMenu.ItemPos:=0;
          end;
        end;
        if NMaxFoundCount<NFoundCount then
        begin
          NMaxFoundCount:=NFoundCount;
          FoundMenu.Menu:=NMenu.Menu;
          FoundMenu.ItemPos:=Nmenu.ItemPos;
        end;
      end;
    end;
    MaxFoundCount:=MaxFoundCount+NMaxFoundCount;
    Result:=FoundMenu;
  {end;}
end;

{function MyFindNumberInString(SString:String;SDelimiter:String;
           var DNumberValue:Integer):Boolean;
var p1:Integer;
    s1:String;
begin
  p1:=pos(SDelimiter,SString);
  if p1>0 then
  begin
    s1:=Copy(SString,1,p1-1);
    try
      p1:=StrToInt(s1);
    except
      MessageDlg('Не можу прочитати число із рядка...',
        mtError,[mbOk],0);
      Result:=False;
      Exit;
    end;
    DNumberValue:=p1;
    Result:=True;
  end
  else Result:=False;
end;}

function MyShowMenu(SWindow:String;SWindowHandle:hWnd;
            ArrayToSearch:MWords{TMyStringArray}=Nil;STreeView:TTreeView=Nil;
            SLabel:TLabel=Nil):TMyMenuItemRec;
var s1:String;
    p1,p2:Integer;
    p3:Cardinal;
    NWindow1:hWnd;
    NMenu1,NMenu2: hMenu;
    FoundMenu,NMenu:TMyMenuItemRec;
    MaxFoundCount,NFoundCount:Integer;
    NTreeItem:TTreeNode;
    {NowItemInfo:tagMENUITEMINFOA;
    NowIcon:TBitmap;}
begin
  if (ArrayToSearch=Nil) and (STreeView=Nil) then
  begin
    Result.Menu:=0;
    Result.ItemPos:=0;
    Exit;
  end;
  if SWindowHandle<>0 then
  begin
    NWindow1:=SWindowHandle;
    if STreeView<>Nil then
    begin
      STreeView.Items.Clear;
      if STreeView.Images<>Nil then
        STreeView.Images.Clear;
    end;
    FoundMenu.Menu:=0;
    FoundMenu.ItemPos:=0;
    MaxFoundCount:=0;
    NFoundCount:=0;
    NMenu1:=GetMenu(NWindow1);
    if NMenu1<>0 then
    begin
      //MyClicksMessagesCriticalSection.Enter;
      if SLabel<>Nil then
      begin
        SLabel.Caption:='Виводжу меню для вікна '+
          SWindow+' ...';
        SLabel.Font.Color:=$000000;
        SLabel.Visible:=True;
        Application.ProcessMessages;
      end;
      //MyClicksMessagesCriticalSection.Leave;
      p1:=GetMenuItemCount(NMenu1);
      if p1<0 then
      begin
        if SLabel<>Nil then
        begin
          //MyClicksMessagesCriticalSection.Enter;
          SLabel.Caption:='Помилка при пошуку підменю!.. у вікна'+
            SWindow+' ...';
          SLabel.Font.Color:=$0000F0;
          SLabel.Visible:=True;
          //MyClicksMessagesCriticalSection.Leave;
        end;
        Result.Menu:=0;
        Result.ItemPos:=0;
        Exit;
      end;
      for p2:=0 to p1-1 do
      begin
        SetLength(s1,GetMenuString(NMenu1,p2,nil,0,MF_ByPosition)+1);
        SetLength(s1,GetMenuString(NMenu1,p2,PChar(s1),Length(s1),MF_ByPosition));
        p3:=GetMenuItemID(NMenu1,p2);
        s1:=DeleteWords(s1,sc_MenuUnderlineIdn);
        NMenu2:=GetSubMenu(NMenu1,p2);
        if STreeView<>Nil then
        begin
          NTreeItem:=STreeView.Items.Add(Nil,'"'+s1+'"');
          NTreeItem.Data:=Pointer(p3);
          if NMenu2<>0 then
          begin
            MyShowChildMenus(NMenu2,ArrayToSearch,0,NFoundCount,NTreeItem,SLabel);
          end;
        end
        else
        begin
          NFoundCount:=0;
          {s1:=MyGetWindowInfoString(Wnd,bc_ShowWindowTitle);
          s2:=MyGetWindowInfoString(Wnd,bc_ShowClassName);}
          if (MyPos(DeleteWords(ArrayToSearch[0],
            sc_MenuUnderlineIdn),s1)<>0) then
              NFoundCount:=NFoundCount+1;
          {if Pos(ArrayToSearch[0].FWndClass,s2)<>0 then
            NFoundCount:=NFoundCount+1;}
          NMenu.Menu:=NMenu1;
          NMenu.ItemPos:=p2;
          if (Length(ArrayToSearch)>1) and ((NFoundCount>0) or (DeleteWords(ArrayToSearch[0],
            sc_MenuUnderlineIdn)='')) then
          begin
            if NMenu2<>0 then
            begin
              NMenu:=MyShowChildMenus(NMenu2,ArrayToSearch,1,
                NFoundCount,Nil,SLabel);
            end
            else
            begin
              NMenu.Menu:=0;
              NMenu.ItemPos:=0;
            end;
          end;
          if MaxFoundCount<NFoundCount then
          begin
            MaxfoundCount:=NFoundCount;
            FoundMenu.Menu:=NMenu.Menu;
            FoundMenu.ItemPos:=NMenu.ItemPos;
          end;
        end;
      end;
      if SLabel<>Nil then
      begin
        //MyClicksMessagesCriticalSection.Enter;
        SLabel.Caption:='Меню виведено для вікна '+
          SWindow+' .';
        SLabel.Font.Color:=$D00000;
        SLabel.Visible:=True;
        //MyClicksMessagesCriticalSection.Leave;
      end;
    end
    else
    begin
      {MessageDlg('Не можу знайти меню у вікна...',
        mtError,[mbOk],0);}
      //MyClicksMessagesCriticalSection.Enter;
      if SLabel<>Nil then
      begin
        //MyClicksMessagesCriticalSection.Enter;
        Form1.Label1.Caption:='Не можу знайти меню у вікна '+
          SWindow+' ...';
        Form1.Label1.Font.Color:=$0000C0;
        Form1.Label1.Visible:=True;
        //MyClicksMessagesCriticalSection.Leave;
      end;
      Result.Menu:=0;
      Result.ItemPos:=0;
      Exit;
    end;
    Result:=FoundMenu;
  end
  else
  begin
    Result.Menu:=0;
    Result.ItemPos:=0;
  end;
end;

{procedure TForm1.ListBox1Click(Sender: TObject);
var NList1:TListBox;
begin
  if Sender<>Nil then
  begin
    if Sender is TListBox then
    begin
      NList1:=TListBox(Sender);
      if NList1.ItemIndex>=0 then
      begin
        MyShowMenu(NList1.Items[Nlist1.ItemIndex]);
      end;
    end;
  end;
end;}

procedure TForm1.TreeView1DblClick(Sender: TObject);
{var MyClickData:TMyClickCommand;}
begin
  if Sender<>Nil then
  begin
    if Sender is TTreeView then
    begin
      if TTreeView(Sender).Selected<>Nil then
      begin
        MyExecuteMenuItem(TTreeView(Sender).Selected.Text,
          Self.TreeView2.Selected.Text,Cardinal(TTreeView(Sender).Selected.Data),
          hWnd(Self.TreeView2.Selected.Data),True,Form1.Label1);
      end;
    end;
  end;
end;

{procedure MyStartClickThread(var SClickData:TMyClickCommand;
            ToWaitFor:Boolean=False;ToFreeOnTerminate:Boolean=True);
var NowClickThread:TMyClickWindowThread;
begin
  NowClickThread:=TMyClickWindowThread.Create(True);
  NowClickThread.MyClickData:=SClickData;
  NowClickThread.MyClickData.IndexInMasyv:=Length(MyClickThreads);
  SetLength(MyClickThreads,NowClickThread.MyClickData.IndexInMasyv+1);
  MyClickThreads[NowClickThread.MyClickData.IndexInMasyv]:=NowClickThread;
  if not ToWaitFor=True then
    NowClickThread.FreeOnTerminate:=ToFreeOnTerminate
  else NowClickThread.FreeOnTerminate:=False;
  NowClickThread.Resume;
  if ToWaitFor=True then
  begin
    NowClickThread.WaitFor;
    SClickData:=NowClickThread.MyClickData;
    NowClickThread.Terminate;
    MyClickThreads[NowClickThread.MyClickData.IndexInMasyv]:=Nil;
    NowClickThread.Free;
  end;
end;}

procedure TForm1.TreeView2DblClick(Sender: TObject);
var NList1:TTreeView;
begin
  if Sender<>Nil then
  begin
    if Sender is TTreeView then
    begin
      NList1:=TTreeView(Sender);
      if NList1.Selected<>Nil then
      begin
        MyClickWindow(hWnd(NList1.Selected.Data),'100');
      end;
    end;
  end;
end;

procedure TForm1.TreeView2Change(Sender: TObject; Node: TTreeNode);
var NList1:TTreeView;
begin
  if Sender<>Nil then
  begin
    if Sender is TTreeView then
    begin
      NList1:=TTreeView(Sender);
      if NList1.Selected<>Nil then
      begin
        MyShowMenu(NList1.Selected.Text,hWnd(NList1.Selected.Data),Nil,
          Form1.TreeView1,Form1.Label1);
      end;
    end;
  end;
end;

{function ThreadFunction(Data:Pointer):Integer; SafeCall;
begin
end;}

{function MyStartThread(SThreadProcedure:Pointer;var MyThreadHandle1:Cardinal):Byte;
var  MyThreadInd1,MyThreadExitCode:Cardinal;
     MyIpThreadAttributes:Pointer;
     p1p:^Cardinal;
     Error1:Boolean;
begin
  Error1:=False;
  if MyThreadHandle1<>0 then
  begin
    if not(GetExitCodeThread(MyThreadHandle1,MyThreadExitCode)=LongBool(0)) then
    begin
      if not(MyThreadExitCode=Still_Active) then
      begin
        CloseHandle(MyThreadHandle1);
      end
      else
      begin
        Result:=bc_IsStillRunning;
        Exit;
      end;
    end
    else
    begin
      Application.MessageBox(PChar('Попередній процес пошуку не відзивається,'+
        ' хоча він, певно, вже був...'),PChar('Далі можливі глюки!..'),0);
    end;
  end;
  p1p:=Nil;
  MyThreadInd1:=0;
  MyIpthreadAttributes:=Nil;
  MyThreadHandle1:=CreateThread(MyIpThreadAttributes,
    128,
    SThreadProcedure,
    p1p,
    0,
    MyThreadInd1);
  if MyThreadHandle1=0 then
  begin
    Result:=bc_CantCreateThread;
    Exit;
  end;
  if (SetThreadPriority(MyThreadHandle1,THREAD_PRIORITY_Normal))=LongBool(0) then
  begin
    Error1:=True;
  end;
  if Error1=True then
  begin
    Application.MessageBox(PChar('Не можу задати пріоритет'+
      ' для процеса...'),'Глюк...',0);
  end;
  Result:=bc_Ok;
end;}

{procedure MyFreeThread(var SThreadHandle:Cardinal);
var MyThreadExitCode:Cardinal;
begin
  if GetExitCodeThread(SThreadHandle,MyThreadExitCode)=LongBool(0) then Exit;
  if not(MyThreadExitCode=Still_Active) then
  begin
    CloseHandle(SThreadHandle);
  end
  else
  begin
    TerminateThread(SThreadHandle,MyThreadExitCode);
    CloseHandle(SThreadHandle);
  end;
  SThreadHandle:=0;
end;}

procedure TForm1.N8Click(Sender: TObject);
begin
  MyClickWindow(hWnd(TreeView2.Selected.Data),'100');
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  MyClickWindow(hWnd(TreeView2.Selected.Data),'001');
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  MyClickWindow(hWnd(TreeView2.Selected.Data),'010');
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  MyClickWindow(hWnd(TreeView2.Selected.Data),'200');
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  MyClickWindow(hWnd(TreeView2.Selected.Data),'002');
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  MyClickWindow(hWnd(TreeView2.Selected.Data),'020');
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  try
    Unit2.Form2:=Unit2.TForm2.Create(Form1);
    Unit2.Form2.Label1.Visible:=False;
    Unit2.Form2.Label2.Visible:=False;
    Unit2.Form2.Edit2.Visible:=False;
    if Unit2.Form2.ShowModal=mrOk then
    begin
      MyClickWindow(hWnd(TreeView2.Selected.Data),
        sc_AutoForcedSetOrSelTextIdent+Unit2.Form2.Edit1.Text);
      TreeView2.Selected.Text:=
        MyGetWindowInfoString(hWnd(TreeView2.Selected.Data),bc_ShowWindowTitle);
      TreeView2.Refresh;
    end;
  finally
    Unit2.Form2.Close;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FinishForm1:=0;
  Form1Waiting:=True;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1Waiting:=False;
  if FinishForm1<=0 then
  begin
    FinishForm1:=-1;
    Action:=caFree;
  end
  else Action:=caNone;
end;

Initialization
  WM_MyRomHookMessage:=RegisterWindowMessage(sc_MyHookMessage);
  WM_MyRomHookSyncMessage:=RegisterWindowMessage(sc_MyHookSyncMessage);
end.

