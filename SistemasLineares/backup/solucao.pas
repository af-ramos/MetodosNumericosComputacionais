unit solucao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { TFormSolucao }

  TFormSolucao = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure LimparDados;
  private

  public

  end;

var
  FormSolucao: TFormSolucao;

implementation

{$R *.lfm}

{ TFormSolucao }

procedure TFormSolucao.LimparDados;
var
  i, j: integer;
begin
  GroupBox1.Caption := 'Solução do Sistema';
  StringGrid1.ColCount := 4;
  for i := 1 to 3 do
    StringGrid1.Cells[i, 1] := '';

  GroupBox2.Caption := 'Determinante';
  Label2.Caption := '0';

  GroupBox3.Caption := 'Matriz Inversa';
  StringGrid2.RowCount := 4;
  StringGrid2.ColCount := 4;
  for i := 1 to 3 do
    for j := 1 to 3 do
      StringGrid2.Cells[j, i] := '';

  GroupBox4.Caption := 'Matriz Aumentada';
  StringGrid3.RowCount := 4;
  StringGrid3.ColCount := 5;
  for i := 1 to 3 do
  begin
    for j := 1 to 3 do
      StringGrid3.Cells[j, i] := '';
    StringGrid3.Cells[4, i] := '';
  end;
end;

procedure TFormSolucao.FormShow(Sender: TObject);
begin
  ControlStyle := ControlStyle + [csOpaque];
  DoubleBuffered := True;
end;

end.


