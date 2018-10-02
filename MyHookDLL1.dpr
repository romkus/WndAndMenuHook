library MyHookDLL1;

uses
  SysUtils,
  Windows,Messages,
    MyWinClicks_B in 'MyWinClicks_B.pas';

{$R *.res}

var NowHookRec:TMyGDataPnt=nil;
    NowFileHandle:THandle=0;
    WM_MyRomHookMessage:Cardinal=0;
    WM_MyRomHookSyncMessage:Cardinal=0;
    MyVarsInstalled:Boolean=False;
function OpenGlobalData:Boolean;
begin
  WM_MyRomHookMessage:=RegisterWindowMessage(sc_MyHookMessage);
  WM_MyRomHookSyncMessage:=RegisterWindowMessage(sc_MyHookSyncMessage);
  NowFileHandle:=CreateFileMapping(INVALID_HANDLE_VALUE,Nil,
    PAGE_READWRITE,0,SizeOf(TMyHookGData),MyHookName);
  if NowFileHandle=0 then
  begin
    MessageBox(0,PChar(sc_CodeWord+IntToStr(GetLastError)),
      'Помилка створення або відкривання глобального буфера...',mb_ok);
    Result:=False;
    Exit;
  end;
  NowHookRec:=MapViewOfFile(NowFileHandle,FILE_MAP_ALL_ACCESS,0,
    0,SizeOf(TMyHookGData));
  if NowHookRec=nil then
  begin
    MessageBox(0,PChar(sc_CodeWord+IntToStr(GetLastError)),
      'Помилка відображення буфера у пам''ять процеса...',mb_ok);
    CloseHandle(NowFileHandle);
    Result:=False;
    Exit;
  end;
  Result:=True;
end;

procedure CloseGlobalData;
begin
  if NowHookRec=Nil then Beep(50,1000)
  else
    UnmapViewOfFile(NowHookRec);
  CloseHandle(NowFileHandle);
  NowHookRec:=Nil;
end;

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: OpenGlobalData;
    DLL_PROCESS_DETACH: CloseGlobalData;
  end;
end;
function MyGetMSGProc_Dll(SHookCode:Integer;SwParam:WParam;
           SlParam:LParam):Integer; stdcall;
var NowMSGRec:TMSG;
begin
  if NowHookRec=Nil then
  begin
    Beep(50,100);
    MessageBox(0,'Змінна не задана, а функція перехоплювача викликана...',
      'Отакої...',mb_Ok);
    (* Result:=CallNextHookEx(0,SHookCode,
      SwParam,LParam(SlParam)); *)
    Result:=0;   {передаємо повідомлення цільовому вікну}
    Exit;
  end;
  if (SHookCode<0) then
  begin
    Result:=CallNextHookEx(NowHookRec^.MyHook,SHookCode,
      SwParam,LParam(SlParam));
    Exit;
  end;
  NowMSGRec.message:=Cardinal(SHookCode);
  NowMSGRec.wParam:=SwParam;
  NowMSGRec.lParam:=SlParam;
  if (NowMSGRec.message<>WM_MyRomHookMessage) and
     (NowMSGRec.message<>WM_MyRomHookSyncMessage){ and ((NowHookRec^.NeedMsg=Infinite) or
       (NowMSGRec.message=NowHookRec^.NeedMsg))} then
  begin
    if (NowMSGRec.message in [HCBT_ACTIVATE,HCBT_CREATEWND,
      HCBT_DESTROYWND,HCBT_MINMAX,HCBT_MOVESIZE,HCBT_SETFOCUS]) then
    begin
      NowMSGRec.hwnd:=SwParam;
        {  Головна програма може зараз обробляти повідомлення від іншої копії
         модуля. Тому почекаємо, доки вона прочитає дані, що дала та копія,
         звільниться, і обробить повідомлення синхронізації:}
      while not (PostThreadMessage(NowHookRec^.MyNativeThreadId,
        WM_MyRomHookSyncMessage,0,0)) do
      begin
        Sleep(10);
      end;
        {потім запишемо повідомлення в глобальний запис:}
      NowHookRec^.Msg:=NowMsgRec;
        {  І надішлемо повідомлення програмі про те, що є нове перехоплене
         повідомлення:}
      Result:=SendMessage(NowHookRec^.MyNativeWnd,WM_MyRomHookMessage, SwParam,
        SlParam);

      {Result:=0;
      PostMessage(NowHookRec^.MyNativeWnd,WM_MyRomHookMessage,SwParam,SlParam);}
    end
    else Result:=0;
    {else NowMSGRec.hwnd:=0;}
    {if Result<>0 then
    begin
      Beep(1000,1000);
      MessageBox(0,PChar(IntToStr(Result)),'Результат обробки пастки:',mb_Ok);
    end;}
  end
  else Result:=0;
  CallNextHookEx(NowHookRec^.MyHook,SHookCode,
      SwParam,LParam(SlParam));
end;
function MyVarInstall(SNativeWindow:hWnd;SNativeThreadId:Cardinal{;NeedMsg:Cardinal=Infinite}):Boolean; stdcall;
begin
  if NowHookRec=Nil then
  begin
    Beep(100,1000);
    if not(OpenGlobalData) then
    begin
      Result:=False;
      Exit;
    end;
  end;
  if not(MyVarsInstalled) then
  begin
    NowHookRec^.MyNativeWnd:=SNativeWindow;
    NowHookRec^.MyNativeThreadId:=SNativeThreadId;
    {NowHookRec^.NeedMsg:=NeedMsg;}
    NowHookRec^.MyHook:=SetWindowsHookEx(WH_CBT,@MyGetMSGProc_Dll,
      hInstance,0);
    if NowHookRec^.MyHook=0 then
    begin
      MessageBox(0,PChar(sc_CodeWord+IntToStr(GetLastError)),
        'Не можу встановити перехоплювач...',mb_ok);
      Result:=False;
      Exit;
    end;
    MyVarsInstalled:=True;
  end;
  Result:=True;
end;

procedure MyVarUnInstall; stdcall;
begin
  If NowHookRec=Nil then Beep(30,2000)
  else
  begin
    if MyVarsInstalled then
    begin
      UnHookWindowsHookEx(NowHookRec^.MyHook);
      MyVarsInstalled:=False;
    end;
  end;
end;
function MyGetVariable:TMsg; stdcall;
begin
  if NowHookRec<>Nil then
    Result:=NowHookRec^.Msg
  else
    Result.message:=Infinite;
end;

exports MyGetMSGProc_Dll,MyVarInstall,MyVarUnInstall,MyGetVariable;

begin
  DLLProc:= @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

