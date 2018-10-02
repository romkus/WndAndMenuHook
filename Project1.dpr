program Project1;

uses
  Forms,
  MyWinClicks in 'MyWinClicks.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  UMain in 'UMain.pas' {Form4},
  MyWinClicks_B in 'MyWinClicks_B.pas',
  CasePlWin1 in 'CasePlWin1.pas',
  MyObjects in 'MyObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  {Application.CreateForm(TForm1, Form1);}
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
