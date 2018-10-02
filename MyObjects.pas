unit MyObjects;

interface
uses SysUtils,Classes,Math;

  type
    mwords=array of string;

  function GetWords(s,SubstringMarker:string):mwords;
  function DeleteWords(SourceString,SubstringMarker:string):string;
  function MakeNewName(Component:TComponent;FirstName:string):string;

implementation

function MakeNewName(Component:TComponent;FirstName:string):string;
// Отримує ім'я для компонента, і якщо воно не унікальне
// серед компонентів власника даного компонента, то змінює
// його так щоб воно було унікальне (додає число), і повертає
// вихідним параметром. Сама функція ім'я компоненту не присвоює.
var sname1:string;
    cnumber:integer;
begin
  sname1:=FirstName;
  cnumber:=0;
  while Component.Owner.FindComponent(sname1)<>nil do
  begin
    cnumber:=cnumber+1;
    sname1:=FirstName+'_'+inttostr(cnumber);
  end;
  MakeNewName:=sname1;
end;

function GetWords(s,SubstringMarker:string):mwords;
// Розділяє рядок "s" на масив рядків за рядками-розподільними знаками
// "SubstringMarker", що зустрічаються у рядку "s". Повертає цей масив.
var s1,thisword:string;
    p,nsymb,nword,CountRemainedMarker:integer;
    words:mwords;
begin
  s1:=s;
  p:=length(s1);
  nword:=0;
  while p>0 do
  begin
    nsymb:=pos(SubstringMarker{' '},s1);
    if nsymb=0 then
    begin
      nsymb:=p;
      thisword:=copy(s1,1,nsymb);
    end
    else thisword:=copy(s1,1,nsymb-1);
    if length(thisword)>0 then
    begin
      setlength(words,nword+1);
      words[nword]:=thisword;
      nword:=nword+1;
    end;
    CountRemainedMarker:=p-nsymb;
    if CountRemainedMarker>length(SubstringMarker)-1 then
      CountRemainedMarker:=length(SubstringMarker)-1;
    delete(s1,1,nsymb+CountRemainedMarker);
    p:=length(s1);
  end;
  GetWords:=words;
end;
function DeleteWords(SourceString,SubstringMarker:string):string;
// Видаляє із рядка "SourceString" усі рядки "SubstringMarker" і
// повертає цей рядок вихідним параметром.
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
end;

end.
