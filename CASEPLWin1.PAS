unit CaseplWin1;

INTERFACE
uses {RFonts,}SysUtils,Classes,MyObjects,ComCtrls{,Forms},Grids,Windows,Registry;

type CurrentFileProc=procedure(SFileName:String);
  TMyVariable=record
    Name:String;
    Value:String;
    VarType:TRegDataType;
  end;
  TMyRegsRecord=record
    Key:String;
    Variables:array of TMyVariable;
  end;
  TMyRegsArray=array of TMyRegsRecord;
  CurrentRegProc=procedure(SKey:String;SVar:String;SValue:String;
    SECRead:Integer;SECGoto:Integer);
  TOnDeleteCurRegProc=procedure(SKey:String;SVariable:String;
                      SECGoTo:Integer;SECDelKey:Integer;SECDelValue:Integer;
                      TotalDeleted:Integer);
const nothingdir=1;
	  exitdir=2;
	  normalname=3;
	  defectpath=4;
  sc_RootKeys:array [0..6] of String=('HKEY_CLASSES_ROOT',
  'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE','HKEY_USERS','HKEY_PERFORMANCE_DATA',
  'HKEY_CURRENT_CONFIG','HKEY_DYN_DATA');
  c_FindAll=0;
  c_FindWholeWordOnly=1;
  c_FindWholeStringOnly=2;
  Highing=1;
  Lowing=2;
  sc_DefaultVarName='(за змовчуванням)';
  sc_Key='Ключ';
  {Функції для перетворення ASCII-тексту (тексту DOS) у верхній чи
  нижній регістри:}
  function LoCase(s:char):char;
  function UpCase(s:char):char;
  function LoCaseStr(s:string):string;
  function UpCaseStr(s:string):string;

  function systemtoval(chyslo:string;chsystem:byte):real;
  function intosystem(chyslo:real;tosystem:byte):string;
  {Функція шукає логічні диски і видає імена їхніх кореневих
   каталогів у масиві рядків:}
  function MyGetRootDirsOfDrives(DoNotShowRemovable:Boolean=False):MWords;
  function FindFiles(MaskFiles,NameDrive{,WriteFile}:string;var error:boolean;
         ShowDirsWithFiles:Boolean=False;DirMessage:String='Каталог :';
         FileMessage:String='';SProgressBar:TProgressBar=Nil;
         ShowDirs:Boolean=True;SearchInSubdirectories:Boolean=True;
         SourceCurrentFileProcedure:CurrentFileProc=Nil;
         DoNotShowDirsWithoutFiles:Boolean=False):MWords;
  procedure FSplit(SPath:string;var Dir:String;var Name:String;var Ext:String);
  procedure csetnativedir(nativdir:string);
  function cgetnativedir:string;
  function testdirname(testdir:string):byte;
  function pislya_komy(x:extended;maxkomy:word):word;
  procedure PislyaKomyForWrite(x:extended;Maxkomy:Word;var m,s:Word);
  {Додані пройедури і функції:}
  {function GetWords(s,SubstringMarker:string):mwords;}
  {Перероблені, які були у інших модулях, які ще не переробляв.
  Треба і їх переробити і знову зробити так щоб цей модуль
  використовував ті модулі і ці функції їз них (якщо
  це буде розумно), тобто ці перероблені функції потім
  треба буде перемістити у перероблені модулі,
  де вони і були, якщо не придумається щось краще
  з ними зробити:}
  function plusndrob(checkst:string;EmptyIfStringEmpty:Boolean=False):string; {була у RFonts}
  procedure setnativedir(nativdir:string);   {у RFonts}
  function getnativedir:string;              {у RFonts}

  {Функції пошуку підрядків і слів у рядках:}
  function MyFindWordInString(SString:String;SWord:String):Integer;
  function MyFindStringInString(SString:String;SWord:String;FindType:Byte):Integer;
  {Процедури і функції для роботи з реєстрами Windows:}
  function GetRootKeyByName(SKey:String):HKEY;
  function GetNameOfRootKey(SKey:HKEY):String;
  function MyOpenKey(SRegistry:TRegistry;SKey:String;CanCreate:Boolean=False):Boolean;
  function ReadValue(SRegistry:TRegistry;ValueName:String;
          var GotValue:String; var GotVarType:TRegDataType):Boolean;
  function FindAndReadValue(SRegistry:TRegistry;SKey:String;
         ValueNameToFind:String;var Value:String):Boolean;
  function MyGetDataTypeName(SDataType:TRegDataType):String;
  procedure MyFillStringGridWithRegs(SRegArray:TMyRegsArray;
            SStringGrid:TStringGrid);
  procedure MySearchInRegistry(SRegistry:TRegistry;SString:String;
            var SFoundArray:TMyRegsArray;
            var ErrorsCantRead:Integer;var ErrorsCantGoToKey:Integer;
            FindType:Byte;SProcedure:CurrentRegProc=Nil);
  procedure MyDeleteSelectedRegistry(SRegistry:TRegistry;SStringGrid:TStringGrid;
          SProcedure:TOnDeleteCurRegProc);
  {Процедура, що встановлює таку ширину стовпців StringGrid-а, щоб
  було видно весь текст у кожній комірці:}
  procedure MyStringGridColWidth(SStringGrid:TStringGrid);
var
  {Ці глобальні змінні також раніше були у інших модулях:}
  NativeDir:String=''; {у RFonts}
Const
  {$IfDef MSWindows}
  DirDescriptor='\';
  {$EndIf}
  {$IfDef Linux}
  DirDescriptor='/';
  {$ENDIF}
  ExtDescriptor='.';


IMPLEMENTATION

{uses strings;}
{var F:Text;}{Filtest:file;}
	{nativedir:string;}
function LoCase;
var ch:char;
begin
  ch:=s;
  if (ch>=chr(65)) and (ch<=chr(90)) then
  begin
	ch:=chr(ord(ch)+32);
  end
  else if (ch>=chr(128)) and (ch<=chr(143)) then
  begin
	ch:=chr(ord(ch)+32);
  end
  else if (ch>=chr(144)) and (ch<=chr(159)) then
  begin
	ch:=chr(ord(ch)+80);
  end
  else if (ch>=chr(240)) and (not(odd(ord(ch)))) then
		 ch:=chr(ord(ch)+1);
  LoCase:=ch;
end;
function LoCaseStr;
var dostri:string;{chrs:array[0..255] of char;}
	y,x:integer;
begin
  dostri:=s;
  y:=length(dostri);
  {strpcopy(chrs,dostri);}
  for x:=1 to y do
  begin
	dostri[x]:=LoCase(dostri[x]);
  end;
  {dostri:=StrPas(chrs);}
  LoCaseStr:=dostri;
end;
function UpCase;
var ch:char;
begin
  ch:=s;
  if (ch>=chr(97)) and (ch<=chr(122)) then
  begin
	ch:=chr(ord(ch)-32);
  end
  else if (ch>=chr(160)) and (ch<=chr(175)) then
  begin
	ch:=chr(ord(ch)-32);
  end
  else if (ch>=chr(224)) and (ch<=chr(239)) then
  begin
	ch:=chr(ord(ch)-80);
  end
  else if (ch>=chr(240)) and (odd(ord(ch))) then
		 ch:=chr(ord(ch)-1);
  UpCase:=ch;
end;
function UpCaseStr;
var dostri:string;{chrs:array[0..255] of char;}
	y,x:integer;
begin
  dostri:=s;
  y:=length(dostri);
  {strpcopy(chrs,dostri);}
  for x:=1 to y do
  begin
	dostri[x]:=UpCase(dostri[x]);
  end;
  {dostri:=StrPas(chrs);}
  UpCaseStr:=dostri;
end;
function systemtoval;
label 1;
var e,n:real;
	lenchyslo,c,n1,x:byte;
begin
  e:=0;
  chyslo:=SysUtils.AnsiUpperCase(Chyslo){UpCaseStr(chyslo)};
  lenchyslo:=length(chyslo);

  n1:=0;

  for c:=1 to lenchyslo do
  begin
	if (chyslo[c]>'9') then
	begin
	  chyslo[c]:=chr(-65+(ord(chyslo[c])+58));
	end;
	if not(chyslo[c]>='0') then
	begin
	  n1:=c-1;
	  goto 1;
	end;
  end;
1:for x:=1 to n1 do
  begin
	n:=1;
	for c:=1 to n1-x do
	begin
	  n:=n*chsystem;
	end;
	e:=e+((ord(chyslo[x])-48)*n);
  end;
  systemtoval:=e;
end;
function intosystem;
var a:string;
	c,n,x1:longint;
	x11:extended;
	x2,code2:real;
	x,chcode:byte;
	{code2,code3:extended;
	code1,cod3:real;}
begin
  {chyslo:=909987294.0;}
  x:=0;
  {x1:=1;}
  x2:=1;
  {c:=0;}
  repeat
  x:=x+1;
  x2:=x2*tosystem;
  c:=trunc(chyslo/x2);
  until c=0;
  for c:=1 to x do
  begin
	x11:=1;
	x1:=x-c;
	for n:=1 to trunc(x1) do
	begin
	  x11:=x11*tosystem;
	end;
        SetLength(a,c);
	{a[0]:=chr(c);}
	code2:=chyslo/(x11*tosystem);
	{code1:=code2;
	cod3:=trunc(code1);
	code3:=cod3*tosystem;}
	code2:=trunc(chyslo/(x11))-
	trunc({code1}code2)*tosystem{code3}+48;
	{code1:=code2;}
	chcode:=trunc({code1}code2);
	a[c]:=chr(chcode);
	if a[c]>chr(57) then a[c]:=chr(65+(ord(a[c])-48)-10);
  end;
  intosystem:=a;
end;
function pislya_komy(x:extended;maxkomy:word):word;
var tx,ttx:extended;
	cx,pislkomy:word;
begin
   tx:=x;
   for cx:=1 to maxkomy do
   begin
	 tx:=tx*10;
   end;
   tx:=int(tx);
   for cx:=1 to maxkomy do
   begin
	 tx:=tx/10;
   end;
   ttx:=trunc(tx);
   pislkomy:=0;
   if tx-ttx<>0 then
   begin
	 repeat
	   tx:=tx*10;
	   ttx:=int(tx);
	   pislkomy:=pislkomy+1;
	 until tx-ttx=0;
   end;
   if pislkomy>maxkomy then pislkomy:=maxkomy
   else pislkomy:=pislkomy;
   pislya_komy:=pislkomy;
end;
procedure PislyaKomyForWrite(x:extended;Maxkomy:Word;var m,s:Word);
var Z1:Byte;
begin
  s:=pislya_komy(x,Maxkomy);
  if s=0 then Z1:=1 else Z1:=2;
  if x<0 then Z1:=Z1+1;
  m:=s+Z1;
end;
{function pislya_komy;
var tx,ttx:extended;
	cx,pislkomy:word;
begin
   tx:=x;
   for cx:=1 to maxkomy do
   begin
	 tx:=tx*10;
   end;
   tx:=int(tx);
   for cx:=1 to maxkomy do
   begin
	 tx:=tx/10;
   end;
   ttx:=int(tx);
   pislkomy:=0;
   if tx-ttx<>0 then
   begin
	 repeat
	   tx:=tx*10;
	   ttx:=int(tx);
	   pislkomy:=pislkomy+1;
	 until tx-ttx=0;
   end;
   pislkomy:=pislkomy;
   pislya_komy:=pislkomy;
end;}
function testdirname;
{const Point='.';}
var TestStr{,TestHalfName}:string;
    TestSymb:Char;
    x,y,numpoints{,place}:LongWord;
    Bukva:Boolean;

    Slash,Point1:String;
    Words1:MWords;
    p1:Integer;
begin
  Slash:=DirDescriptor;
  Point1:=ExtDescriptor;
  Words1:=nil;

  y:=Length(TestDir);
  {NumPoints:=0;}
  {for x:=1 to y do
  begin
	testsymb:=testdir[x];
	if testsymb=Point1 then numpoints:=numpoints+1;
  end;
  if numpoints=2 then testdirname:=exitdir
  else if numpoints=1 then
  begin}
  TestStr:=TestDir;
  {repeat
    Place:=Pos(Slash,TestStr);
    y:=Length(TestStr);
    if Place>0 then
    begin
      TestHalfName:=System.Copy(TestStr,1,Place);
      NumPoints:=0;
      for x:=1 to y do
      begin
	TestSymb:=TestHalfName[x];
	if TestSymb=Point1 then Numpoints:=Numpoints+1;
      end;
      //if Numpoints>1 then testdirname:=defectpath;
      TestStr:=System.Copy(TestStr,Place+1,y);
    end;
  Until Place=0;}
  if (Length(TestStr)=0) then TestDirName:=DefectPath
  else
  begin
    if (TestStr[Length(TestStr)]=Slash) {or (TestStr[High(TestStr)]=Point1)} then
      TestDirName:=DefectPath
    else
    begin
      Words1:=GetWords(TestStr,Slash);
      p1:=Length(Words1);
      TestStr:=Words1[p1-1];
      NumPoints:=0;
      for x:=1 to y do
      begin
        TestSymb:=TestStr[x];
        if TestSymb=Point1 then Numpoints:=Numpoints+1;
      end;
      {if NumPoints>2 then testdirname:=defectpath
      else }
      if NumPoints>=1 then {TestDirName:=ExitDir}
      {else if numpoints=1 then}
      begin
        y:=Length(TestStr);
        {place:=pos(Point1,teststr);
        place:=place-1;}
        bukva:=false;
        for x:=1 to {place}y do
        begin
          TestSymb:=TestStr[x];
          if not((testsymb=' ') or (testsymb=chr(0)) or
      	  (testsymb=chr(255)) or (TestSymb=Point1)) then
          begin
            Bukva:=True;
            Break;
          end;
        end;
        if not(bukva=true) then
        begin
          if NumPoints=1 then TestDirName:=nothingdir
            else if NumPoints=2 then TestDirName:=ExitDir
            else TestDirName:=DefectPath;
        end
        else TestDirName:=NormalName;
      end
      else if (Numpoints=0) and (Length(TestStr)>0) then TestDirName:=normalname
      else TestDirName:=DefectPath;
    end;
  end;
end;
function plusndrob(checkst:string;EmptyIfStringEmpty:Boolean=False):string;
var leng:integer;
begin
  CheckSt:=AnsiString(CheckSt);
  leng:=length(checkst);
  if leng=0 then
  begin
    if not(EmptyIfStringEmpty) then checkst:=checkst+'\';
  end
  else
  begin
    if checkst[leng]<>'\' then checkst:=checkst+'\'
    else checkst:=checkst;
  end;
  plusndrob:=checkst;
end;
procedure setnativedir(nativdir:string);
begin
  nativedir:=nativdir;
end;
function getnativedir:string;
begin
  getnativedir:=nativedir;
end;

procedure FSplit(SPath:string;var Dir:String;var Name:String;var Ext:String);
var s1,NameExt:string;
    Words1:MWords;
    p1:Integer;
    YeKrapky:Boolean;
begin
  Words1:=nil;
  s1:=SPath;
  if s1<>'' then
  begin
    s1:=PlusNDrob(s1);
    Words1:=GetWords(s1,DirDescriptor);
    p1:=Length(Words1);
    if p1>=1 then
    begin
      NameExt:=Words1[p1-1];
      SetLength(s1,Length(s1)-(Length(NameExt)+1));
      Dir:=s1;
    end
    else
    begin
      Name:='';
      Dir:='';
    end;
    YeKrapky:=False;
    for p1:=1 to Length(NameExt) do
    begin
      if NameExt[p1]=ExtDescriptor then
      begin
        YeKrapky:=True;
        Break;
      end;
    end;
    if YeKrapky=True then
    begin
      Words1:=GetWords(NameExt,ExtDescriptor);
      p1:=Length(Words1);
      if p1>=1 then
        Ext:=ExtDescriptor+Words1[p1-1]
      else Ext:=ExtDescriptor;
      SetLength(NameExt,Length(NameExt)-Length(Ext));
      Name:=NameExt;
    end
    else
    begin
      Name:=NameExt;
      Ext:='';
    end;
  end
  else
  begin
    Ext:='';
    Name:='';
    Dir:='';
  end;
end;
{Функція шукає логічні диски і видає імена їхніх кореневих
каталогів у масиві рядків:}
function MyGetRootDirsOfDrives(DoNotShowRemovable:Boolean=False):MWords;
var s1,s2:String;
    p1:Integer;
    p2:Cardinal;
    NowDrives:MWords;
begin
  SetLength(s1,GetLogicalDriveStrings(0,Nil)+1);
  SetLength(s1,GetLogicalDriveStrings(Length(s1),PChar(s1)));
  SetLength(NowDrives,0);
  while s1<>'' do
  begin
    p1:=Pos(Chr(0),s1);
    s2:=Copy(s1,1,p1-1);
    p2:=GetDriveType(PChar(s2));
    if p2<>1 then
    begin
      if (not(DoNotShowRemovable)) or (p2<>DRIVE_REMOVABLE) then
      begin
        SetLength(NowDrives,Length(NowDrives)+1);
        NowDrives[Length(NowDrives)-1]:=s2;
      end;  
    end;
    s1:=Copy(s1,1+p1,Length(s1)-p1);
  end;
  MyGetRootDirsOfDrives:=NowDrives;
end;
{Функція пошуку фацлів на заданому диску із заданими розширеннями,
з можливістю шукати у підкаталогах. Може видавати імена знайдених файлів
у вказану процедуру "SourceCurrentFileProcedure", має інші настройки:}
function FindFiles(MaskFiles,NameDrive{,WriteFile}:string;var error:boolean;
         ShowDirsWithFiles:Boolean=False;DirMessage:String='Каталог :';
         FileMessage:String='';SProgressBar:TProgressBar=Nil;
         ShowDirs:Boolean=True;SearchInSubdirectories:Boolean=True;
         SourceCurrentFileProcedure:CurrentFileProc=Nil;
         DoNotShowDirsWithoutFiles:Boolean=False):MWords;
const ExitDirStr='..'{+chr(0)+chr(0)};
var
  {sse,ssb:string;}
  FilsD:array {[0..90]} of {^}tsearchrec;
  FilsF:{^}tsearchrec;
  Path: String;Dir: String;
  Name: String;
  Ext: String;
  {mask2,}nowdir{,srch}:string;
  MaskDir,maskfil1:{pchar}string;
  {stupin,}Attr,Attr1{,testdirectory}:{word}Integer;
  Stupin,TestDirectory:LongWord;
  {LastF,}LastD,BegF,NextD,EndWork:boolean;

  DirFileList:MWords;
  p1,p2:Integer;
  WasFiles:Boolean;
begin
  Error:=False;
  Path:=Getnativedir;
  Path:=Plusndrob(path);

  SetLength(DirFileList,0);

  {DirFileList:=TStringList.Create;}

  {System.Assign(f,path+writefile);
  rewrite(f);}
  {LastF:=False;}{LastD:=False;}
  MaskFil1:=MaskFiles;
  {StrPCopy(maskfil1,maskfiles);}

  {path:=maskfiles;
  FSplit(path,Dir,Name,Ext);
  StrPCopy(maskdir,dir+'*.*');}

  {$I-}
  System.ChDir(PlusNDrob(NameDrive));
  if System.IOResult<>0 then
  begin
    Error:=True;
    FindFiles:=Nil;
    Exit;
  end;
  {$I+}

  if SProgressBar<>Nil then
  begin
    SProgressBar.Min:=0;
    SProgressBar.Position:=0;
    p2:=0;
    p1:=FindFirst('*.*',faAnyFile,FilsF);
    while p1=0 do
    begin
      Attr1:=FileGetAttr(FilsF.Name);
      if ((Attr1 and faVolumeID)<>faVolumeID) and
         ((Attr1 and faDirectory)=faDirectory) and (Attr1<>-1) and
         (FilsF.Name<>'.') and (FilsF.Name<>'..') then
      begin
        p2:=p2+1;
      end;
      p1:=FindNext(FilsF);
    end;
    SysUtils.FindClose(FilsF);
    SProgressBar.Max:=p2;
  end;

  if ShowDirs=True then
  begin
    WasFiles:=False;
    if DoNotShowDirsWithoutFiles then
    begin
      p1:=FindFirst(MaskFil1,faAnyFile,FilsF);
      while p1=0 do
      begin
        Attr1:=FileGetAttr(FilsF.Name);
        if ((Attr1 and faVolumeID)<>faVolumeID) and ((Attr1 and faDirectory)<>faDirectory) and
          (Attr1<>-1) then
        begin
          WasFiles:=True;
          Break;
        end;
        p1:=findnext(Filsf);
      end;
      SysUtils.FindClose(FilsF);
    end
    else WasFiles:=True;
    if WasFiles=True then
    begin
      SetLength(DirFileList,Length(DirFileList)+1);
      System.GetDir(0,NowDir);
      DirFileList[Length(DirFileList)-1]:=DirMessage+NowDir;
      if @SourceCurrentFileProcedure<>Nil then
      begin
        SourceCurrentFileProcedure(DirFileList[Length(DirFileList)-1]);
      end;
    end;
  end;

  maskdir:='*.*';
  stupin:=0;
  BegF:=true;
  EndWork:=false;
  repeat
  if BegF=True then
  begin
	{new(filsf);}
    p1:=FindFirst(MaskFil1,faAnyFile{faarchive+fahidden+fareadonly+fasysfile},FilsF);
    while p1=0 do
    begin
      Attr1:=FileGetAttr(FilsF.Name);
      if ((Attr1 and faVolumeID)<>faVolumeID) and ((Attr1 and faDirectory)<>faDirectory) and
         (Attr1<>-1) then
      begin
        Path:=FilsF.Name;
        FSplit(path,Dir,Name,Ext);
        path:=name+ext;
        {path:=AnsiLowerCase(path);}
        System.GetDir(0,NowDir);
        NowDir:=PlusNDrob(nowdir);

        SetLength(DirFileList,Length(DirFileList)+1);
        if ShowDirsWithFiles=True then
          DirFileList[Length(DirFileList)-1]:=FileMessage+NowDir+Path
        else
          DirFileList[Length(DirFileList)-1]:=FileMessage+Path;
        if @SourceCurrentFileProcedure<>Nil then
        begin
          SourceCurrentFileProcedure(DirFileList[Length(DirFileList)-1]);
        end;
        {if (SProgressBar<>Nil) And (Stupin=0) then
        begin
          SProgressBar.Position:=SProgressBar.Position+1;
        end;}
        {DirFileList.Add(nowdir+path);}
        {write(f,nowdir+path+chr(13)+chr(10));}
      end;
      p1:=findnext(FilsF);
    end;
    {if maskfiles='' then write(f,'<Ok>'+chr(13)+chr(10));}
    SysUtils.FindClose(FilsF);
    {dispose(filsf);}
  end;
  LastD:=False;
  NextD:=False;
  repeat
    if BegF=True then
    begin
      SetLength(FilsD,Stupin+1);
      {new(filsd[stupin]);}
      p1:=FindFirst(MaskDir,faAnyFile,FilsD[stupin]);
      BegF:=False;
    end
    else p1:=FindNext(FilsD[stupin]);
    if p1=0 then
    begin
      Path:=FilsD[stupin].Name;
      FSplit(Path,Dir,Name,Ext);
      Path:=Name+Ext;
      {assign(filtest,path);}
      Attr:=FileGetAttr({FilTest}Path);
      if {(DosError = 0) and (}(Attr and faDirectory)=faDirectory{)} then
      begin
	TestDirectory:=TestDirName(Path);
	if TestDirectory=NormalName then
	begin
	  System.GetDir(0,NowDir);
	  NowDir:=PlusNDrob(NowDir);

	  if SearchInSubdirectories=True then ChDir(NowDir+Path);

	  if System.IOResult<>0 then
          begin
            Error:=true;
            FindFiles:=Nil;
            Exit;
          end;

          if ShowDirs=True then
          begin
            WasFiles:=False;
            if DoNotShowDirsWithoutFiles then
            begin
              p1:=FindFirst(MaskFil1,faAnyFile,FilsF);
              while p1=0 do
              begin
                Attr1:=FileGetAttr(FilsF.Name);
                if ((Attr1 and faVolumeID)<>faVolumeID) and ((Attr1 and faDirectory)<>faDirectory) and
                  (Attr1<>-1) then
                begin
                  WasFiles:=True;
                  Break;
                end;
                p1:=findnext(Filsf);
              end;
              SysUtils.FindClose(FilsF);
            end
            else WasFiles:=True;
            if WasFiles=True then
            begin
              SetLength(DirFileList,Length(DirFileList)+1);
              DirFileList[Length(DirFileList)-1]:=DirMessage+NowDir+Path;
              if @SourceCurrentFileProcedure<>Nil then
              begin
                SourceCurrentFileProcedure(DirFileList[Length(DirFileList)-1]);
              end;
            end;
          end;

          if (SProgressBar<>Nil) And (Stupin=0) then
          begin
            SProgressBar.Position:=SProgressBar.Position+1;
          end;
          {DirFileList.Add(NowDir+Path);}

          Lastd:=False;
          If SearchInSubdirectories=True then
          begin
            Stupin:=Stupin+1;
            SetLength(FilsD,Stupin+1);

	    Begf:=True;
            Nextd:=true;
          end;
        end;
      end;
	  {end;}
    end
    else LastD:=True;
  until (Lastd=True) or (Nextd=True);
  if Lastd=True then
  begin
    {Dispose(filsd[stupin]);}
    SysUtils.FindClose(FilsD[Stupin]);
    System.GetDir(0,NowDir);
    NowDir:=PlusNDrob(NowDir);
    ChDir(NowDir+ExitDirStr);
    if Stupin>0 then
    begin
      Stupin:=Stupin-1;
      SetLength(FilsD,Stupin+1);
    end
    else EndWork:=true;
    Begf:=False;
    {Lastd:=False;}
  end;
  until endwork=true;
  {close(f);}
  FindFiles:=DirFileList;
end;
procedure csetnativedir;
begin
  setnativedir(nativdir);
end;
function cgetnativedir;
begin
  cgetnativedir:=getnativedir;
end;

{Функції пошуку підрядків і слів у рядках:}

function MyFindWordInString(SString:String;SWord:String):Integer;
var p2:Integer;
    s1:String;
begin
  p2:=Pos(AnsiLowerCase(SWord),AnsiLowerCase(SString));
  if p2>0 then
  begin
    s1:='';
    if p2>1 then s1:=Copy(SString,p2-1,1);
    if p2+Length(SWord)<=Length(SString) then
      s1:=s1+Copy(SString,p2+Length(SWord),1);
    if AnsiLowerCase(s1)<>AnsiUpperCase(s1) then p2:=0;
  end;
  MyFindWordInString:=p2;
end;
function MyFindStringInString(SString:String;SWord:String;FindType:Byte):Integer;
var p2:Integer;
begin
  if SWord<>'' then
  begin
    if FindType=c_FindWholeWordOnly then
      p2:=MyFindWordInString(SString,SWord)
    else
    begin
      p2:=Pos(AnsiLowerCase(SWord),AnsiLowerCase(SString));
      if FindType=c_FindWholeStringOnly then
      begin
        if (Length(SString)<>Length(SWord)) then p2:=0;
      end;
    end;
  end
  else p2:=1;
  MyFindStringInString:=p2;
end;

{Процедури і функції для роботи з реєстрами Windows:}

function GetRootKeyByName(SKey:String):HKEY;
begin
  if AnsiUpperCase(SKey)=sc_RootKeys[0] then
    Result:=HKEY_CLASSES_ROOT
  else if AnsiUpperCase(SKey)=sc_RootKeys[1] then
    Result:=HKEY_CURRENT_USER
  else if AnsiUpperCase(SKey)=sc_RootKeys[2] then
    Result:=HKEY_LOCAL_MACHINE
  else if AnsiUpperCase(SKey)=sc_RootKeys[3] then
    Result:=HKEY_USERS
  else if AnsiUpperCase(SKey)=sc_RootKeys[4] then
    Result:=HKEY_PERFORMANCE_DATA
  else if AnsiUpperCase(SKey)=sc_RootKeys[5] then
    Result:=HKEY_CURRENT_CONFIG
  else if AnsiUpperCase(SKey)=sc_RootKeys[6] then
    Result:=HKEY_DYN_DATA
  else Result:=0;
end;

function GetNameOfRootKey(SKey:HKEY):String;
begin
  if SKey=HKEY_CLASSES_ROOT then
    Result:=sc_RootKeys[0]
  else if SKey=HKEY_CURRENT_USER then
    Result:=sc_RootKeys[1]
  else if SKey=HKEY_LOCAL_MACHINE then
    Result:=sc_RootKeys[2]
  else if SKey=HKEY_USERS then
    Result:=sc_RootKeys[3]
  else if SKey=HKEY_PERFORMANCE_DATA then
    Result:=sc_RootKeys[4]
  else if SKey=HKEY_CURRENT_CONFIG then
    Result:=sc_RootKeys[5]
  else if SKey=HKEY_DYN_DATA then
    Result:=sc_RootKeys[6]
  else Result:='';
end;

function MyOpenKey(SRegistry:TRegistry;SKey:String;CanCreate:Boolean=False):Boolean;
var p1:Integer;
    s1:String;
begin
  p1:=Pos('\',SKey);
  s1:=Copy(SKey,1,p1-1);
  SKey:=Copy(SKey,p1+1,Length(SKey)-p1);
  SRegistry.RootKey:=GetRootKeyByName(s1);
  SRegistry.OpenKey('\',False);
  MyOpenKey:=SRegistry.OpenKey('\'+SKey,CanCreate);
end;

function ReadValue(SRegistry:TRegistry;ValueName:String;
          var GotValue:String; var GotVarType:TRegDataType):Boolean;
var p2,p3:Integer;
    s1:String;
begin
  GotVarType:=SRegistry.GetDataType(ValueName);
  if GotVarType=rdString then
    s1:=SRegistry.ReadString(ValueName)
  else if GotVarType=rdExpandString then
    s1:=SRegistry.ReadString(ValueName)
  else if GotVarType=rdInteger then
    s1:=IntToStr(SRegistry.ReadInteger(ValueName))
  else
  begin
    p2:=SRegistry.GetDataSize(ValueName);
    if p2>0 then
    begin
      SetLength(s1,p2+1);
      p3:=SRegistry.ReadBinaryData(ValueName,(PChar(s1))^,p2);
      SetLength(s1,p3);
      if p3<>p2 then
      begin
        ReadValue:=False;
        Exit;
      end;
    end
    else s1:='';
  end;
  GotValue:=s1;
  ReadValue:=True;
end;

function FindAndReadValue(SRegistry:TRegistry;SKey:String;
         ValueNameToFind:String;var Value:String):Boolean;
var NowStrings:TStrings;
    p1:Integer;
    s1:String;
    MyDataType:TRegDataType;
begin
  if MyOpenKey(SRegistry,SKey,False)=True then
  begin
    NowStrings:=TStringList.Create;
    SRegistry.GetValueNames(NowStrings);
    if NowStrings<>Nil then
    begin
      for p1:=0 to NowStrings.Count-1 do
      begin
        if AnsiLowerCase(NowStrings[p1])=AnsiLowerCase(ValueNameToFind) then
        begin
          if ReadValue(SRegistry,NowStrings[p1],s1,MyDataType)=True then
          begin
            Value:=s1;
            FindAndReadValue:=True;
          end
          else FindAndReadValue:=False;
          NowStrings.Free;
          Exit;
        end;
      end;
      FindAndReadValue:=False;
      NowStrings.Free;
    end
    else
    begin
      FindAndReadValue:=False;
      NowStrings.Free;
    end;
  end
  else
  begin
    FindAndReadValue:=False;
  end;
end;

function MyGetDataTypeName(SDataType:TRegDataType):String;
begin
  if SDataType=rdString then
    MyGetDataTypeName:='Рядок'
  else if SDataType=rdExpandString then
    MyGetDataTypeName:='Рядок зі змінними'
  else if SDataType=rdInteger then
    MyGetDataTypeName:='Ціле число'
  else if SDataType=rdBinary then
    MyGetDataTypeName:='Двійкові дані'
  else if SDataType=rdUnknown then
    MyGetDataTypeName:='Невідомий тип'
  else MyGetDataTypeName:='Вав! Тип зовсім невизначений';
end;

procedure MyFillStringGridWithRegs(SRegArray:TMyRegsArray;
            SStringGrid:TStringGrid);
var p1,p2:Integer;
begin
  SStringGrid.Visible:=False;
  SStringGrid.RowCount:=2;
  SStringGrid.Cells[0,1]:='';
  SStringGrid.Cells[1,1]:='';
  SStringGrid.Cells[2,1]:='';
  SStringGrid.Cells[3,1]:='';
  for p1:=0 to Length(SRegArray)-1 do
  begin
    if Length(SRegArray[p1].Variables)>0 then
    begin
      for p2:=0 to Length(SRegArray[p1].Variables)-1 do
      begin
        SStringGrid.Cells[0,SStringGrid.RowCount-1]:=SRegArray[p1].Key;
        if Length(SRegArray[p1].Variables[p2].Name)>0 then
          SStringGrid.Cells[1,SStringGrid.RowCount-1]:=
            SRegArray[p1].Variables[p2].Name
        else SStringGrid.Cells[1,SStringGrid.RowCount-1]:=sc_DefaultVarName;
        SStringGrid.Cells[2,SStringGrid.RowCount-1]:=
          SRegArray[p1].Variables[p2].Value;
        SStringGrid.Cells[3,SStringGrid.RowCount-1]:=
          MyGetDataTypeName(SRegArray[p1].Variables[p2].VarType);
        SStringGrid.RowCount:=SStringGrid.RowCount+1;
      end;
    end
    else
    begin
      SStringGrid.Cells[0,SStringGrid.RowCount-1]:=SRegArray[p1].Key;
      SStringGrid.Cells[1,SStringGrid.RowCount-1]:='';
      SStringGrid.Cells[2,SStringGrid.RowCount-1]:='';
      SStringGrid.Cells[3,SStringGrid.RowCount-1]:=sc_Key;
      SStringGrid.RowCount:=SStringGrid.RowCount+1;
    end;
  end;
  if SStringGrid.RowCount>2 then SStringGrid.RowCount:=SStringGrid.RowCount-1;
  SStringGrid.Visible:=True;
end;

procedure GoMySearchInRegistry(var SRegistry:TRegistry;var SString:String;
          var SFoundArray:TMyRegsArray;
          var ErrorsCantRead:Integer; var ErrorsCantGoToKey:Integer;
          var FindType:Byte;var SProcedure:CurrentRegProc);
var NowStrings,NowKeys:TStrings;
    p1,p2:Integer;
    NowValue,NowPath:String;
    NowVarType:TRegDataType;
    KeyAdded:Boolean;
begin
  NowStrings:=TStringList.Create;
  SRegistry.GetValueNames(NowStrings);
  NowValue:='';
  NowVarType:=rdUnknown;
  KeyAdded:=False;
  for p1:=0 to NowStrings.Count-1 do
  begin
    if not (ReadValue(SRegistry,NowStrings[p1],NowValue,NowVarType))=True then
      ErrorsCantRead:=ErrorsCantRead+1
    else
    begin
      if (MyFindStringInString(NowValue,SString,FindType)>0) or
         (MyFindStringInString(NowStrings[p1],SString,FindType)>0) then
      begin
        if not(KeyAdded)=True then
        begin
          SetLength(SFoundArray,Length(SFoundArray)+1);
          SFoundArray[Length(SFoundArray)-1].Key:=
            PlusNDrob(GetNameOfRootKey(SRegistry.RootKey),True)+
            SRegistry.CurrentPath;
          SetLength(SFoundArray[Length(SFoundArray)-1].Variables,0);
          KeyAdded:=True;
        end;
        p2:=Length(SFoundArray[Length(SFoundArray)-1].Variables);
        SetLength(SFoundArray[Length(SFoundArray)-1].Variables,p2+1);
        SFoundArray[Length(SFoundArray)-1].Variables[p2].Name:=NowStrings[p1];
        SFoundArray[Length(SFoundArray)-1].Variables[p2].Value:=NowValue;
        SFoundArray[Length(SFoundArray)-1].Variables[p2].VarType:=NowVarType;
        if @SProcedure<>Nil then
        begin
          SProcedure(SFoundArray[Length(SFoundArray)-1].Key,
            NowStrings[p1],NowValue,ErrorsCantRead,ErrorsCantGoToKey);
        end;
      end;
    end;
  end;
  NowStrings.Free;
  NowKeys:=TStringList.Create;
  SRegistry.GetKeyNames(NowKeys);
  NowPath:=SRegistry.CurrentPath;
  for p1:=0 to NowKeys.Count-1 do
  begin
    if MyFindStringInString(NowKeys[p1],SString,FindType)>0 then
    begin
      SetLength(SFoundArray,Length(SFoundArray)+1);
      SFoundArray[Length(SFoundArray)-1].Key:=
        PlusNDrob(GetNameOfRootKey(SRegistry.RootKey),True)+
        PlusNDrob(NowPath,True)+NowKeys[p1];
      SetLength(SFoundArray[Length(SFoundArray)-1].Variables,0);
      if @SProcedure<>Nil then
      begin
        SProcedure(SFoundArray[Length(SFoundArray)-1].Key,'','',
          ErrorsCantRead,ErrorsCantGoToKey);
      end;
    end;
    if MyOpenKey(SRegistry,PlusNDrob(GetNameOfRootKey(SRegistry.RootKey),True)+
       PlusNDrob(NowPath,TRue)+NowKeys[p1],False)=True then
    begin
      GoMySearchInRegistry(SRegistry,SString,SFoundArray,ErrorsCantRead,
        ErrorsCantGoToKey,FindType,SProcedure);
    end
    else
    begin
      ErrorsCantGoToKey:=ErrorsCantGoToKey+1;
    end;
  end;
  NowKeys.Free;
end;

procedure MySearchInRegistry(SRegistry:TRegistry;SString:String;
            var SFoundArray:TMyRegsArray;
            var ErrorsCantRead:Integer;var ErrorsCantGoToKey:Integer;
            FindType:Byte;SProcedure:CurrentRegProc=Nil);
var p1:Integer;
begin
  SetLength(SFoundArray,0);
  ErrorsCantRead:=0;
  ErrorsCantGoToKey:=0;
  for p1:=0 to Length(sc_RootKeys)-1 do
  begin
    SRegistry.RootKey:=GetRootKeyByName(sc_RootKeys[p1]);
    {GoMySearchInRegistry(SRegistry,SString,SFoundArray,
        ErrorsCantRead,ErrorsCantGoToKey,FindType);}
    if SRegistry.OpenKey('\',False)=True then
    begin
      GoMySearchInRegistry(SRegistry,SString,SFoundArray,
        ErrorsCantRead,ErrorsCantGoToKey,FindType,SProcedure);
    end
    else
    begin
      ErrorsCantGoToKey:=ErrorsCantGoToKey+1;
      GoMySearchInRegistry(SRegistry,SString,SFoundArray,
        ErrorsCantRead,ErrorsCantGoToKey,FindType,SProcedure);
    end;
  end;
end;

procedure MyDeleteSelectedRegistry(SRegistry:TRegistry;SStringGrid:TStringGrid;
          SProcedure:TOnDeleteCurRegProc);
var From1,To1:Integer;
    p1,p2:Integer;
    NowKey,WasKey:String;
    NowVariable:String;
    s1,s2:String;
    ErrorsCantGoToKey,ErrorsCantDeleteKey,ErrorsCantDeleteVariable,
      TotalDeleted:Integer;
    LastWasKey:Boolean;
begin
  {sc_DefaultVarName sc_Key}
  From1:=SStringGrid.Selection.Top;
  To1:=SStringGrid.Selection.Bottom;
  ErrorsCantGoToKey:=0;
  ErrorsCantDeleteKey:=0;
  ErrorsCantDeleteVariable:=0;
  TotalDeleted:=0;
  WasKey:='';
  LastWasKey:=False;
  for p1:=From1 to To1 do
  begin
    NowKey:=SStringGrid.Cells[0,p1];
    NowVariable:=SStringGrid.Cells[1,p1];
    if SStringGrid.Cells[3,p1]=sc_Key then
    begin
      s1:=NowKey;
      p2:=Pos('\',s1);
      while p2<>0 do
      begin
        s1:=Copy(s1,p2+1,Length(s1)-p2);
        p2:=Pos('\',s1);
      end;
      s2:=Copy(NowKey,1,Length(NowKey)-Length(s1));
      if Not(MyOpenKey(SRegistry,s2,False))=True then
        ErrorsCantGoToKey:=ErrorsCantGoToKey+1
      else
      begin
        if not (SRegistry.DeleteKey(s1))=True then
        begin
          ErrorsCantDeleteKey:=ErrorsCantDeleteKey+1;
        end
        else TotalDeleted:=TotalDeleted+1;
        LastWasKey:=True;
      end;
      if @SProcedure<>Nil then
        SProcedure(NowKey,NowVariable,ErrorsCantGoToKey,ErrorsCantDeleteKey,
          ErrorsCantDeleteVariable,TotalDeleted);
    end
    else
    begin
      if NowVariable=sc_DefaultVarName then NowVariable:='';
      if Not(MyOpenKey(SRegistry,NowKey,False))=True then
        ErrorsCantGoToKey:=ErrorsCantGoToKey+1
      else if (not (LastWasKey)=True) or (WasKey<>NowKey) then
      begin
        if not (SRegistry.DeleteValue(NowVariable))=True then
        begin
          ErrorsCantDeleteVariable:=ErrorsCantDeleteVariable+1;
        end
        else TotalDeleted:=TotalDeleted+1;
        LastWasKey:=False;
      end;
      if @SProcedure<>Nil then
        SProcedure(NowKey,NowVariable,ErrorsCantGoToKey,ErrorsCantDeleteKey,
          ErrorsCantDeleteVariable,TotalDeleted);
    end;
    WasKey:=NowKey
  end;
end;
{Процедура, що встановлює таку ширину стовпців StringGrid-а, щоб
було видно весь текст у кожній комірці:}
procedure MyStringGridColWidth(SStringGrid:TStringGrid);
var pRows,pCols,p1,p2,p3:Integer;
    NowWidth:Integer;
begin
  pRows:=SStringGrid.RowCount;
  pCols:=SStringGrid.ColCount;
  for p1:=0 to pCols-1 do
  begin
    NowWidth:=SStringGrid.Canvas.TextWidth(SStringGrid.Cells[p1,0]);
    for p2:=1 to pRows-1 do
    begin
      p3:=SStringGrid.Canvas.TextWidth(SStringGrid.Cells[p1,p2]);
      if NowWidth<p3 then NowWidth:=p3;
    end;
    SStringGrid.ColWidths[p1]:=NowWidth+SStringGrid.GridLineWidth+5;
  end;
end;

end.