unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus,Registry, ComCtrls,MyWinClicks_B,MyWinClicks;

type
  TForm4 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N11: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N12: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    StatusBar1: TStatusBar;
    N9: TMenuItem;
    N10: TMenuItem;
    N8: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function MyUserMessagesHandler(var Msg: TMessage):Boolean;
  end;
const
  sc_Enterprise1C='  enterprise';
  sc_Config1C='  config';
  sc_1CAutorization='Авторизация  доступа';
  sc_1CLogoWindow='Загрузка конфигурационной информации';
  sc_1COkButtonName='OK';sc_1CNoRButtonName='Нет';
  sc_1CNoEButtonName='No';sc_ConfiguratorWnd1C='Конфигуратор';
  sc_EnterpriseWindow1C='1С:Предприятие';
  sc_Starting1C='Запуск 1С:Предприятия';sc_SaveAsWnd='Сохранить как';
  sc_FileNameForConfig='Config1S.txt';
  bc_UserOpening1C=1;bc_OpeningConfig1C=2;bc_GettingConfig1C=3;
  bc_ClosingConfig1C=4;
  {bc_GetLastWindowActivated=1;bc_GetLastWindowClosed=2;}

var
  Form4: TForm4;
  UserName1C:String='';
  Password1C:String='';
  Path1C:String='';
  Configuration1CName:String='';
  NowConfigurator1CWnd:hWnd=0;
  MyCurrentHookTask:Byte=0;
  FinishMyApp:Integer=-1;
  MyAppWaiting:Boolean=False;

  Autorization1CIsDisplaying:Boolean=False;

implementation
uses Unit2,MyObjects,CasePlWin1;

{$R *.dfm}

procedure TForm4.N2Click(Sender: TObject);
begin
  Form1:=TForm1.Create(Application);
  Form1.ShowModal;
  Form1:=Nil;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MyAppWaiting:=False;
  if FinishMyApp<=0 then
  begin
    FinishMyApp:=-1;
    Action:=caFree;
    MyWinClicks.MyVarUnInstall;
    Application.UnhookMainWindow(Form4.MyUserMessagesHandler);
    {Application.OnMessage:=Nil;}
  end
  else Action:=caNone;
end;

procedure TForm4.N7Click(Sender: TObject);
begin
  Self.Close;
end;

function TForm4.MyUserMessagesHandler(var Msg: TMessage):Boolean;
var NowMsg:TMsg;
begin
  if (Msg.Msg=MyWinClicks.WM_MyRomHookMessage) then
  begin
    NowMsg:=MyWinClicks.MyGetVariable;
    Msg.Result:=MyWinClicks.MyGetMSGProc(NowMsg);
    Result:=True;
  end
  else Result:=False;
end;

function MyAnswerToUnknownDialog(SDialog:hWnd):Integer;
var NSearch:TMySearchFwinArray;
    NButton:hWnd;
    p1:Integer;
begin
  SetLength(NSearch,1);
  NSearch[0].FWndClass:=sc_ButtonClassName;
  NSearch[0].FWindow:=sc_1COkButtonName;
  p1:=0;
  NButton:=MyShowWindowsWhichHaveOwner(SDialog,NSearch,0,p1,Nil,True,True,True);
  if NButton=0 then
  begin
    NSearch[0].FWindow:=sc_1CNoRButtonName;
    p1:=0;
    NButton:=MyShowWindowsWhichHaveOwner(SDialog,NSearch,0,p1,Nil,True,True,True);
  end;
  if NButton=0 then
  begin
    NSearch[0].FWindow:=sc_1CNoEButtonName;
    p1:=0;
    NButton:=MyShowWindowsWhichHaveOwner(SDialog,NSearch,0,p1,Nil,True,True,True);
  end;
  if NButton<>0 then
  begin
    Result:=1;
    MyClickWindow(NButton,'100',False);
  end
  else Result:=0;
end;

function MySendOrGet1CAutorization(SAutorizationWindow:hWnd;ToSend:Boolean=True):Integer;
var NSearch:TMySearchFwinArray;
    NComboBox,NEdit,NOkButton:hWnd;
    p1:Integer;
Label 1;
begin
  SetLength(NSearch,1);
  NSearch[0].FWndClass:=sc_ComboBoxClassName;
  p1:=0;
  NComboBox:=MyShowWindowsWhichHaveOwner(SAutorizationWindow,NSearch,
    0,p1,nil,True,True,True);
  NSearch[0].FWndClass:=sc_EditClassName;
  p1:=0;
  NEdit:=MyShowWindowsWhichHaveOwner(SAutorizationWindow,NSearch,
    0,p1,nil,True,True,True);
  NSearch[0].FWndClass:=sc_ButtonClassName;
  NSearch[0].FWindow:=sc_1COkButtonName;
  p1:=0;
  NOkButton:=MyShowWindowsWhichHaveOwner(SAutorizationWindow,NSearch,
    0,p1,nil,True,True,True);
  if ToSend then
  begin
    Result:=1;
    if NComboBox<>0 then
    begin
      MyClickWindow(NComboBox,sc_AutoSetOrSelTextIdent+UserName1C,False);
      if MyPos(UserName1C,
        MyGetWindowInfoString(NComboBox,bc_ShowWindowTitle))=0 then Goto 1;
    end
    else Goto 1;
    if NEdit<>0 then
    begin
      MyClickWindow(NEdit,sc_AutoSetOrSelTextIdent+Password1C,False);
      if (Password1C<>'') and (MyPos(Password1C,
        MyGetWindowInfoString(NEdit,bc_ShowWindowTitle))=0) then Goto 1;
    end
    else Goto 1;
    if NOkButton<>0 then
      MyClickWindow(NOkButton,'100',False)
    else Goto 1;
  end
  else
  begin
    Result:=0;
    if NComboBox<>0 then
      UserName1C:=MyGetWindowInfoString(NComboBox,bc_ShowWindowTitle);
    if NEdit<>0 then
      Password1C:=MyGetWindowInfoString(NEdit,bc_ShowWindowTitle);
  end;
  Exit;
1:Form4.StatusBar1.SimpleText:='Авторизація не вдалася... Введіть користувача і пароль самі...';
  Result:=0;
end;

function MyConfirmOrGetConfigurationName(SStart1CWindow:hWnd;
           ToConfirm:Boolean=True):Integer;
var NSearch:TMySearchFwinArray;
    NListBox:hWnd;
    p1:Integer;
    s1,s2:String;
    ConfigSelected:Boolean;
begin
  SetLength(NSearch,1);
  NSearch[0].FWndClass:=sc_ListBoxClassName;
  p1:=0;
  NListBox:=MyShowWindowsWhichHaveOwner(SStart1CWindow,NSearch,0,p1,Nil,
    True,True,True);
  if NListBox<>0 then
  begin
    if ToConfirm=True then
    begin
      {s1:=MyGetWindowInfoString(NListBox,bc_ShowWindowTitle);
      if AnsiUpperCase(Configuration1CName)=AnsiUpperCase(s1) then
        Result:=MyAnswerToUnknownDialog(SStart1CWindow)
      else
      begin}
        ConfigSelected:=False;
        if Configuration1CName<>'' then
        begin
          s2:=MyClickWindow(NListBox,sc_AutoSetOrSelTextIdent+Configuration1CName,False);
          if (AnsiUpperCase(s2)=AnsiUpperCase(Configuration1CName)) then ConfigSelected:=True;
        end;
        if not (ConfigSelected) then
        begin
          Form4.StatusBar1.SimpleText:='Підтвердіть вибір конфігурації: "'+
            s2+'" <> "'+Configuration1CName+'"';
          Result:=0;
        end
        else
        begin
          Form4.StatusBar1.SimpleText:='Послав натискання миші на пункт списка з конфігураціями...';
          Result:=MyAnswerToUnknownDialog(SStart1CWindow);
        end;
      {end;}
    end
    else
    begin
      s1:=MyGetWindowInfoString(NListBox,bc_ShowWindowTitle);
      if s1<>'' then
      begin
        Configuration1CName:=s1;
        Form4.StatusBar1.SimpleText:='Обрано конфігурацію "'+s1+'".';
      end;
      Result:=0;
    end;
  end
  else Result:=0;
end;

function MyDefHook1CProc(var SHookRec:TMyWaitForWindowHookRec;var SMsg:TMsg):Integer;
var s1,s2:String;
    NParent:hWnd;
    p1,p2:Integer;
begin
  Result:=0;
  if (SMsg.message=HCBT_ACTIVATE) and (SMsg.hwnd<>Application.Handle) and
     (SMsg.hwnd<>Form4.Handle) then
  begin
    NParent:=MyWinClicks.MyGetSuperGrandParentWindow(SMsg.hwnd,True);
    s1:=MyGetWindowInfoString(NParent,bc_ShowWindowTitle);
    s2:=MyGetWindowInfoString(SMsg.hwnd,bc_ShowWindowTitle);
    p1:=MyPos(sc_1CLogoWindow,s1);
    p2:=MyPos(sc_1CAutorization,s2);
    if (UserName1C<>'') and (not(Autorization1CIsDisplaying)) then
    begin
      if (p1<>0) and (p2<>0) then
      begin
        Autorization1CIsDisplaying:=True;
        Result:=MySendOrGet1CAutorization(SMsg.hwnd,True);
      end;
    end;
    if (p1<>0) and (p2=0) then Result:=MyAnswerToUnknownDialog(SMsg.hwnd);
    if p1=0 then
    begin
      p1:=MyPos(sc_ConfiguratorWnd1C,s1);
      if p1<>0 then
      begin
        if (NParent=SMsg.hwnd) and (MyCurrentHookTask=bc_OpeningConfig1C) then
        begin
          NowConfigurator1CWnd:=NParent;
          Form4.StatusBar1.SimpleText:='Активний Конфігуратор: "'+
            IntToStr(NowConfigurator1CWnd)+'"';
          Result:=1;
        end
        else if MyCurrentHookTask=bc_ClosingConfig1C then
               Result:=MyAnswerToUnknownDialog(SMsg.hwnd);
        if (MyCurrentHookTask=bc_OpeningConfig1C) or
           (MyCurrentHookTask=bc_GettingConfig1C) then
        begin
          MyWakeUpWindow(Form4.Handle,True);
          Result:=1;
        end;
      end;
    end;
    {if Configuration1CName<>'' then
    begin
      p1:=MyPos(sc_Starting1C,s2);
      if p1<>0 then Result:=MyConfirmOrGetConfigurationName(SMsg.hwnd);
    end;}
  end
  else if SMsg.message=HCBT_DESTROYWND then
  begin
    NParent:=MyWinClicks.MyGetSuperGrandParentWindow(SMsg.hwnd,True);
    s1:=MyGetWindowInfoString(NParent,bc_ShowWindowTitle);
    s2:=MyGetWindowInfoString(SMsg.hwnd,bc_ShowWindowTitle);
    p1:=MyPos(sc_1CLogoWindow,s1);
    p2:=MyPos(sc_1CAutorization,s2);
    if (p1<>0) and (p2<>0) then
    begin
      MySendOrGet1CAutorization(SMsg.hwnd,False);
      Autorization1CIsDisplaying:=False;
    end;
    p1:=MyPos(sc_Starting1C,s2);
    if p1<>0 then
    begin
      MyConfirmOrGetConfigurationName(SMsg.hwnd,False);
    end;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
var s1:String;
    NowFoundRec:TMyWaitForWindowHookRec;
begin
  Application.HookMainWindow(Form4.MyUserMessagesHandler);
  {Application.OnMessage:=Form4.MyUserMessagesHandler;}

  System.GetDir(0,s1);
  CasePlWin1.setnativedir(s1);
  FinishMyApp:=0;
  MyAppWaiting:=True;
  SetLength(NowFoundRec.SSearching,1);
  NowFoundRec.SSearching[0].SParent:=0;
  NowFoundRec.SSearching[0].SWindow:=0;
  NowFoundRec.SSearching[0].FWindow:='';
  NowFoundRec.SSearching[0].FWndClass:='';
  MyWinClicks.MyStartWindowHook(NowFoundRec,HCBT_ACTIVATE,MyDefHook1CProc);
end;

procedure TForm4.N12Click(Sender: TObject);
begin
  try
    Unit2.Form2:=Unit2.TForm2.Create(Application);
    Unit2.Form2.Label1.Caption:='Введіть ім''я користувача:';
    Unit2.Form2.Label2.Caption:='Введіть пароль:';
    Unit2.Form2.Caption:='Задайте ідентифікацію за змовчуванням:';
    Unit2.Form2.Edit1.Text:=UserName1C;
    Unit2.Form2.Edit2.Text:=PassWord1C;
    if Unit2.Form2.ShowModal=mrOk then
    begin
      UserName1C:=Unit2.Form2.Edit1.Text;
      Password1C:=Unit2.Form2.Edit2.Text;
    end;
  finally
    Unit2.Form2.Close;
  end;
end;

function MyFound1C(SStatusBar:TStatusBar=Nil;ForceSearchingOnDisk:Boolean=False):String;
var Now1CPath:String;
    NowDrives,NowFiles:MWords;
    p1:Integer;
    NError:Boolean;
    NowRegistry:TRegistry;
begin
  Now1CPath:='';
  NowRegistry:=TRegistry.Create;
  SetLength(NowDrives,0);
  SetLength(NowFiles,0);
  try
    if SSTatusBar<>Nil then
    begin
      SStatusBar.SimpleText:='Шукаю 1С...';
      Application.ProcessMessages;
    end;
    if (ForceSearchingOnDisk=True) or
       (not (CasePlWin1.FindAndReadValue(NowRegistry,
        'HKEY_LOCAL_MACHINE\Software\1C\1Cv7\7.7\1С:Предприятие','1CPath',Now1CPath))) then
    begin
      if (SStatusBar<>Nil) and (ForceSearchingOnDisk=True) then
      begin
        SStatusBar.SimpleText:='У реєстрах Windows НЕ знайшов... шукаю на дисках...';
        Application.ProcessMessages;
      end;
      NowDrives:=CasePlWin1.MyGetRootDirsOfDrives(True);
      Now1CPath:='';
      for p1:=0 to Length(NowDrives)-1 do
      begin
        NowFiles:=FindFiles('1Cv7*.exe',NowDrives[p1],NError,True,'','',
          Nil,False,True,Nil);
        if Length(NowFiles)>0 then
        begin
          Now1CPath:=NowFiles[0];
          Break;
        end;
      end;
      if (Now1CPath='') and (SStatusBar<>Nil) then
      begin
        SStatusBar.SimpleText:='НЕ МОЖУ ЗНАЙТИ 1С...';
        Application.ProcessMessages;
      end;
    end;
  finally
    NowRegistry.Free;
  end;
  if (SStatusBar<>Nil) and (Now1CPath<>'') then
  begin
    SStatusBar.SimpleText:='Знайшов: "'+Now1CPath+'"';
    Application.ProcessMessages;
  end;
  Result:=Now1CPath;
end;

procedure MyStart1C(SParamString:String='');
var p1:Cardinal;
begin
  if Path1C='' then Path1C:=MyFound1C(Form4.StatusBar1,False);
  if Path1C<>'' then
  begin
    Form4.StatusBar1.SimpleText:='Запускаю 1С із '+Path1C;
    p1:=WinExec(PChar(Path1C+SParamString),SW_SHOW);
    if (p1=ERROR_FILE_NOT_FOUND) or (p1=ERROR_PATH_NOT_FOUND) then
    begin
      Form4.StatusBar1.SimpleText:='У реєстрах файл вказано невірно! Шукаю на дисках...';
      Path1C:=MyFound1C(Form4.StatusBar1,True);
      if Path1C<>'' then WinExec(PChar(Path1C+SParamString),SW_Show);
    end;
  end;
end;

procedure TForm4.N11Click(Sender: TObject);

begin
  Configuration1CName:='';
  MyStart1C(sc_Enterprise1C);
end;

procedure TForm4.N8Click(Sender: TObject);
const sc_1='Введіть назву конфігурації.';
begin
  try
    Unit2.Form2:=Unit2.TForm2.Create(Application);
    Unit2.Form2.Label1.Caption:=sc_1+
      ' Вона буде обрана при вході в 1С:';
    Unit2.Form2.Label2.Caption:='якщо хочете обрати конфігурацію при вході '+
      'самі, то натисніть "Відмінити"';
    Unit2.Form2.Caption:=sc_1;
    Unit2.Form2.Edit1.Text:=Configuration1CName;
    Unit2.Form2.Edit2.Visible:=False;
    if Unit2.Form2.ShowModal=mrOk then
    begin
      Configuration1CName:=Unit2.Form2.Edit1.Text;
    end
    else Configuration1CName:='';
  finally
    Unit2.Form2.Close;
  end;
end;

function MyGetConfigurator1C:hWnd;
var NFoundRec:TMyWaitForWindowHookRec;
    NFoundWin:TMySearchFWinArray;
    NowWindow:hWnd;
    s2:String;
    p1:Integer;
begin
  if (NowConfigurator1CWnd=0) or (not(IsWindow(NowConfigurator1CWnd))) then
  begin
    SetLength(NFoundWin,1);
    NFoundWin[0].FWindow:=sc_ConfiguratorWnd1C;
    NFoundWin[0].FWndClass:='';
    NowConfigurator1CWnd:=MyShowWindows(Application.Handle,True,
      False,True,False,NFoundWin,Nil);
    if not(IsWindow(NowConfigurator1CWnd)) then
    begin
      SetLength(NFoundRec.SSearching,2);
      MyCurrentHookTask:=bc_OpeningConfig1C;
      NFoundRec.SSearching[0].SParent:=0;
      NFoundRec.SSearching[0].SWindow:=0;
      NFoundRec.SSearching[0].FWndClass:='Afx';
      NFoundRec.SSearching[0].FWindow:=sc_ConfiguratorWnd1C;
      NFoundRec.SSearching[1].SParent:=0;
      NFoundRec.SSearching[1].SWindow:=0;
      NFoundRec.SSearching[1].FWndClass:='';
      NFoundRec.SSearching[1].FWindow:=sc_Starting1C;
      MyStartWindowHook(NFoundRec,HCBT_ACTIVATE);
      NowConfigurator1CWnd:=0;
      MyStart1C(sc_Config1C);
      repeat
        NowWindow:=MyWaitForWindow(NFoundRec,@MyAppWaiting);
        if Configuration1CName<>'' then
        begin
          s2:=MyGetWindowInfoString(NowWindow,bc_ShowWindowTitle);
          p1:=MyPos(sc_Starting1C,s2);
          if p1<>0 then MyConfirmOrGetConfigurationName(NowWindow,True);
          NFoundRec.FoundNames:=-1;
          MyStartWindowHook(NFoundRec,HCBT_ACTIVATE,Nil,True);
        end;
      until NowConfigurator1CWnd<>0;
      MyCurrentHookTask:=0;
      if not (IsWindow(NowConfigurator1CWnd)) then
      begin
        Result:=0;
        Exit;
      end;
    end;
    Form4.StatusBar1.SimpleText:='Отримав важіль Конфігуратора: "'+
      IntToStr(NowConfigurator1CWnd)+'"';
  end;
  Result:=NowConfigurator1CWnd;
end;

function MyDeleteFile(SFileName:String):Boolean;
var f1:File;
    p1:Integer;
begin
  System.Assign(f1,SFileName);
  {$I-}
  System.Reset(f1);
  p1:=IOResult;
  System.Close(f1);
  System.Erase(f1);
  if p1<>0 then
  begin
    IOResult;
    Result:=True;
    Exit;
  end;
  if IOResult<>0 then Result:=False
    else Result:=True;
  {$I+}
end;

function MyGetConfigurationDescribe:Byte;
var NSearch:MWords;
    NSearchWin:TMySearchFWinArray;
    NMenuItem:TMyMenuItemRec;
    NFoundRec:TMyWaitForWindowHookRec;
    NWindow:hWnd;
    NSaveDlgWindow:hWnd;
begin
  if Not(MyDeleteFile(PlusNDrob(CasePlWin1.getnativedir)+sc_FileNameForConfig)) then
  begin
    Result:=1;
    Exit;
  end;
  MyCurrentHookTask:=bc_GettingConfig1C;
  SetLength(NFoundRec.SSearching,1);
  {NFoundRec.SSearching[0].SParent:=0;
  NFoundRec.SSearching[0].SWindow:=NowConfigurator1CWnd;
  NFoundRec.SSearching[0].FWndClass:='';
  NFoundRec.SSearching[0].FWindow:='';
  MyHookAndWaitForWindow(NFoundRec,@MyAppWaiting,HCBT_Activate);}
  SetLength(NSearch,2);
  NSearch[0]:='Конфигурация';
  NSearch[1]:='Описание структуры метаданных';
  NMenuItem:=MyShowMenu('',NowConfigurator1CWnd,NSearch,Nil,Nil);
  if (NMenuItem.Menu=0) and (NMenuItem.ItemPos=0) then
  begin
    MyCurrentHookTask:=0;
    Result:=2;
    Exit;
  end;
  NMenuItem.ItemPos:=GetMenuItemId(NMenuItem.Menu,NMenuItem.ItemPos);

  {NFoundRec.SSearching[0].SParent:=NowConfigurator1CWnd;
  NFoundRec.SSearching[0].SWindow:=0;
  NFoundRec.SSearching[0].FWndClass:='';
  NFoundRec.SSearching[0].FWindow:='';
  MyStartWindowHook(NFoundRec,HCBT_CREATEWND);}

  MyExecuteMenuItem('','',NMenuItem.ItemPos,NowConfigurator1CWnd,False);
  Application.ProcessMessages;
  {if MyWaitForWindow(NFoundRec,@MyAppWaiting)=0 then
  begin
    Result:=2;
    Exit;
  end;}
  SetLength(NSearch,2);
  NSearch[0]:='Файл';
  NSearch[1]:='Сохранить как';
  NMenuItem:=MyShowMenu('',NowConfigurator1CWnd,NSearch,Nil,Nil);
  if (NMenuItem.Menu=0) and (NMenuItem.ItemPos=0) then
  begin
    MyCurrentHookTask:=0;
    Result:=3;
    Exit;
  end;
  NMenuItem.ItemPos:=GetMenuItemId(NMenuItem.Menu,NMenuItem.ItemPos);

  NFoundRec.SSearching[0].SParent:=NowConfigurator1CWnd;
  NFoundRec.SSearching[0].SWindow:=0;
  NFoundRec.SSearching[0].FWndClass:='';
  NFoundRec.SSearching[0].FWindow:=sc_SaveAsWnd;
  MyStartWindowHook(NFoundRec,HCBT_ACTIVATE);

  MyExecuteMenuItem('','',NMenuItem.ItemPos,NowConfigurator1CWnd,False);
  Application.ProcessMessages;
  NSaveDlgWindow:=MyWaitForWindow(NFoundRec,@MyAppWaiting);
  if NSaveDlgWindow=0 then
  begin
    Result:=4;
    Exit;
  end;
  SetLength(NSearchWin,3);
  NSearchWin[0].FWindow:=sc_ConfiguratorWnd1C;
  NSearchWin[1].FWindow:=sc_SaveAsWnd;
  NSearchWin[2].FWndClass:=sc_EditClassName;
  NSearchWin[2].FWindow:=''{'Описание'};
  NWindow:=MyShowWindows(Application.Handle,True,True,True,False,NSearchWin,Nil);
  if NWindow=0 then
  begin
    MyCurrentHookTask:=0;
    Result:=5;
    Exit;
  end;
  MyClickWindow(NWindow,sc_AutoForcedSetOrSelTextIdent+
    PlusNDrob(CasePlWin1.getnativedir)+sc_FileNameForConfig,False);
  Application.ProcessMessages;
  SetLength(NSearchWin,3);
  NSearchWin[0].FWindow:=sc_ConfiguratorWnd1C;
  NSearchWin[1].FWindow:=sc_SaveAsWnd;
  NSearchWin[2].FWndClass:=sc_ButtonClassName;
  NSearchWin[2].FWindow:='Сохранить';
  NWindow:=MyShowWindows(Application.Handle,True,True,True,False,NSearchWin,Nil);
  if NWindow=0 then
  begin
    MyCurrentHookTask:=0;
    Result:=6;
    Exit;
  end;

  NFoundRec.SSearching[0].SParent:=0;
  NFoundRec.SSearching[0].SWindow:=NSaveDlgWindow;
  NFoundRec.SSearching[0].FWndClass:='';
  NFoundRec.SSearching[0].FWindow:='';
  MyStartWindowHook(NFoundRec,HCBT_DESTROYWND);

  MyClickWindow(NWindow,'100',False);
  Application.ProcessMessages;

  Form4.StatusBar1.SimpleText:='Послав зберегти файл...';
  Application.ProcessMessages;
  {MyClickwindow(NowConfigurator1CWnd,'100',True);
  Form4.StatusBar1.SimpleText:='Послав натискання миші...';
  Application.ProcessMessages;}

  MyWaitForWindow(NFoundRec,@MyAppWaiting);
  Form4.StatusBar1.SimpleText:='Діждався закриття діалогу...';
  Application.ProcessMessages;

  MyCurrentHookTask:=bc_ClosingConfig1C;
  SetLength(NSearch,2);
  NSearch[0]:='Файл';
  NSearch[1]:='Выход';
  NMenuItem:=MyShowMenu('',NowConfigurator1CWnd,NSearch,Nil,Nil);
  if (NMenuItem.Menu=0) and (NMenuItem.ItemPos=0) then
  begin
    MyCurrentHookTask:=0;
    Result:=7;
    Exit;
  end;
  NMenuItem.ItemPos:=GetMenuItemId(NMenuItem.Menu,NMenuItem.ItemPos);
  Form4.StatusBar1.SimpleText:='Командую вийти...';
  Application.ProcessMessages;
  MyExecuteMenuItem('','',NMenuItem.ItemPos,NowConfigurator1CWnd,False);
  Form4.StatusBar1.SimpleText:='Скомандував вийти...';
  Application.ProcessMessages;
  Result:=0;
  NowConfigurator1CWnd:=0;
  MyCurrentHookTask:=0;
end;

procedure TForm4.N4Click(Sender: TObject);
var p1:Byte;
begin
  if MyCurrentHookTask=0 then
  begin
    Form4.N4.Enabled:=False;
    MyGetConfigurator1C;
    p1:=MyGetConfigurationDescribe;
    if p1<>0 then
      Form4.StatusBar1.SimpleText:='Не вдалося дістати опис конфігурації... '+IntToStr(p1);
    Form4.N4.Enabled:=True;
  end;
end;

end.
