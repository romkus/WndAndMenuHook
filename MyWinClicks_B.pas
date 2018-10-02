unit MyWinClicks_B;

interface
uses Windows;
const MyHookName='MyRomHooks9';
      sc_MyHookMessage='WM_MyRomHookMessage';
      sc_MyHookSyncMessage='WM_MyRomHookSyncMessage';
      sc_CodeWord='Код:';
type
  TMySearchFWinRecord=record
    FWindow:String;
    FWndClass:String;
  end;
  TMySearchFWinArray=array of TMySearchFWinRecord;
  TMySearchFWinRecordWithParent=record
    FWindow:String;
    FWndClass:String;
    SParent:hWnd;
    SWindow:hWnd;
  end;
  TMySearchFWinArrayWithParent=array of TMySearchFWinRecordWithParent;
  {TMyStringArray=array of String;}
  TMyWindowsArray=array of hWnd;
  TMyMenuArray=array of hMenu;
  TMyMenuItemRec=record
    Menu:hMenu;
    ItemPos:Cardinal;
  end;
  TMyWaitForWindowHookRec=record
    SSearching:TMySearchFWinArrayWithParent;
    WaitingForAction:Cardinal;
    {WaitingForMyExAction:Cardinal;}
    SResultWindow:hWnd;
    FoundNames:Integer;
    FoundOnMessage:Cardinal;
  end;
  TMyHookGData=record
    MyNativeWnd:hWnd;
    MyNativeThreadId:Cardinal;
    MyHook:HHook;
    {NeedMsg:Cardinal;}
    Msg:TMsg;
  end;
  TMyGDataPnt=^TMyHookGData;
  PMyShortBool=^Boolean;
  TMyHookWindowExProc=function(var SHookRec:TMyWaitForWindowHookRec;
    var SMsg:TMsg):Integer;
  {PMyHookWindowExProc=^TMyHookWindowExProc;}

implementation

end.
