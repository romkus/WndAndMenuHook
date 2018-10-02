unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=Chr(13) then
  begin
    if (Self.Edit2.Visible) and (Self.Edit2.Enabled) then
      Self.Edit2.SetFocus
    else Self.Button1.SetFocus;
  end;
end;

procedure TForm2.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=Chr(13) then
  begin
    Self.Button1.SetFocus;
  end;
end;

end.
