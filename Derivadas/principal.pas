unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Grids, ComCtrls, Windows;

type
  Vetor = array of extended;
  Matriz = array of array of extended;

  { TForm1 }

  TForm1 = class(TForm)
    CalcularJacobiano: TSpeedButton;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CalcularUmaVariavel: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    CalcularMaisVariaveis: TSpeedButton;
    Label9: TLabel;
    LimparJacobiano: TSpeedButton;
    MontarGradeGH: TSpeedButton;
    LimparMaisVariaveis: TSpeedButton;
    LimparUmaVariavel: TSpeedButton;
    MontarGradeJ: TSpeedButton;
    PageControl1: TPageControl;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    StringGrid6: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure CalcularJacobianoClick(Sender: TObject);
    procedure CalcularMaisVariaveisClick(Sender: TObject);
    procedure CalcularUmaVariavelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LimparJacobianoClick(Sender: TObject);
    procedure LimparMaisVariaveisClick(Sender: TObject);
    procedure MontarGradeGHClick(Sender: TObject);
    procedure LimparUmaVariavelClick(Sender: TObject);
    procedure MontarGradeJClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  n, m, erroGrade: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  LimparUmaVariavel.Click;
  LimparMaisVariaveis.Click;
  LimparJacobiano.Click;

  StringGrid1.Cells[0, 0] := 'i';
  StringGrid1.Cells[0, 1] := 'x[i]';
  StringGrid2.Cells[0, 0] := 'i';
  StringGrid2.Cells[0, 1] := 'G[i]';
  StringGrid3.Cells[0, 0] := 'H[i, j]';

  StringGrid4.Cells[0, 0] := 'i';
  StringGrid4.Cells[0, 1] := 'x[i]';
  StringGrid5.Cells[0, 0] := 'i';
  StringGrid5.Cells[1, 0] := 'f[i]';
  StringGrid6.Cells[0, 0] := 'J[i, j]';

  PageControl1.ActivePage := TabSheet1;
end;

// CÁLCULO DE DERIVADAS PARA FUNÇÕES DE UMA VARIÁVEL

function FxR1(f: string; x: extended; var y: extended): word;
  stdcall; external 'Interpretador.dll';

function derivadaPrimeira(f: string; x: extended; epsilon: extended;
  var r: extended): word;
var
  i: integer;
  h, p, q, erro: extended;
  y1, y2: extended;
begin
  erro := 100000000;
  h := 1024 * epsilon;

  if FxR1(f, x + h, y1) <> 0 then
    Exit(0);
  if FxR1(f, x - h, y2) <> 0 then
    Exit(0);
  p := (y1 - y2) / (2 * h);

  for i := 1 to 10 do
  begin
    q := p;
    h := h / 2;

    if FxR1(f, x + h, y1) <> 0 then
      Exit(0);
    if FxR1(f, x - h, y2) <> 0 then
      Exit(0);
    p := (y1 - y2) / (2 * h);

    if abs(p - q) < erro then
      erro := abs(p - q)
    else
    begin
      r := q;
      Exit(1);
    end;

    if abs(p - q) < epsilon then
    begin
      r := p;
      Exit(1);
    end;
  end;

  r := p;
  Exit(1);
end;

function derivadaSegunda(f: string; x: extended; epsilon: extended;
  var r: extended): word;
var
  i: integer;
  h, p, q, erro: extended;
  y1, y2, y3: extended;
begin
  erro := 100000000;
  h := 1024 * epsilon;

  if FxR1(f, x + 2 * h, y1) <> 0 then
    Exit(0);
  if FxR1(f, x, y2) <> 0 then
    Exit(0);
  if FxR1(f, x - 2 * h, y3) <> 0 then
    Exit(0);
  p := (y1 - 2 * y2 + y3) / (4 * h * h);

  for i := 1 to 10 do
  begin
    q := p;
    h := h / 2;

    if FxR1(f, x + 2 * h, y1) <> 0 then
      Exit(0);
    if FxR1(f, x, y2) <> 0 then
      Exit(0);
    if FxR1(f, x - 2 * h, y3) <> 0 then
      Exit(0);
    p := (y1 - 2 * y2 + y3) / (4 * h * h);

    if abs(p - q) < erro then
      erro := abs(p - q)
    else
    begin
      r := q;
      Exit(1);
    end;

    if abs(p - q) < epsilon then
    begin
      r := p;
      Exit(1);
    end;
  end;

  r := p;
  Exit(1);
end;

procedure TForm1.CalcularUmaVariavelClick(Sender: TObject);
var
  f: string;
  x, epsilon, r: extended;
begin
  f := Trim(Edit1.Text);

  if f = '' then
  begin
    ShowMessage('Função inválida ou vazia!');
    Edit1.SetFocus;
    Exit;
  end;

  try
    x := StrToFloat(Edit2.Text);
  except
    ShowMessage('Ponto "x" inválido ou vazio!');
    Edit2.SetFocus;
    Exit;
  end;

  try
    epsilon := StrToFloat(Edit3.Text);

    if (epsilon > 0.001 + 10E-10) or (epsilon < 0.0000001 - 10E-10) then
    begin
      ShowMessage('Aproximação inválida (entre 1E-3 e 1E-7)!');
      Edit3.SetFocus;
      Exit;
    end;
  except
    ShowMessage('Aproximação inválida ou vazia!');
    Edit3.SetFocus;
    Exit;
  end;

  if derivadaPrimeira(f, x, epsilon, r) <> 0 then
    Edit4.Text := FloatToStr(r)
  else
    ShowMessage('Erro ao avaliar a derivada primeira!');

  if derivadaSegunda(f, x, epsilon, r) <> 0 then
    Edit5.Text := FloatToStr(r)
  else
    ShowMessage('Erro ao avaliar a derivada segunda!');
end;

procedure TForm1.LimparUmaVariavelClick(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := 'Resultado da derivada primeira!';
  Edit5.Text := 'Resultado da derivada segunda!';
end;

// CÁLCULO DE DERIVADAS PARA FUNÇÕES DE MAIS VARIÁVEIS

function FxRn(f: string; x: Vetor; colchetes: boolean; var y: extended): word;
  stdcall; external 'Interpretador.dll';

function derivadaParcial(f: string; x: Vetor; epsilon: extended;
  i: integer; var r: extended): word;
var
  j: integer;
  h, xi, f1, f2, p, q: extended;
begin
  h := 1024 * epsilon;
  xi := x[i];

  x[i] := xi + h;
  if FxRn(f, x, True, f1) <> 0 then
    Exit(0);

  x[i] := xi - h;
  if FxRn(f, x, True, f2) <> 0 then
    Exit(0);

  p := (f1 - f2) / (2 * h);

  for j := 1 to 10 do
  begin
    q := p;
    h := h / 2;

    x[i] := xi + h;
    if FxRn(f, x, True, f1) <> 0 then
      Exit(0);

    x[i] := xi - h;
    if FxRn(f, x, True, f2) <> 0 then
      Exit(0);

    p := (f1 - f2) / (2 * h);

    if abs(p - q) < epsilon then
      Break;
  end;

  r := p;
  Exit(1);
end;

function derivadaParcialSegunda(f: string; x: Vetor; epsilon: extended;
  i: integer; j: integer; var r: extended): word;
var
  k: integer;
  h, xi, xj, p, q, f1, f2, f3, f4: extended;
begin
  h := 1024 * epsilon;

  xi := x[i];
  xj := x[j];

  if i <> j then
  begin
    x[i] := xi + h;
    x[j] := xj + h;
    if FxRn(f, x, True, f1) <> 0 then
      Exit(0);

    x[j] := xj - h;
    if FxRn(f, x, True, f2) <> 0 then
      Exit(0);

    x[i] := xi - h;
    if FxRn(f, x, True, f4) <> 0 then
      Exit(0);

    x[j] := xj + h;
    if FxRn(f, x, True, f3) <> 0 then
      Exit(0);

    p := (f1 - f2 - f3 + f4) / (4 * h * h);
  end
  else
  begin
    x[i] := xi + 2 * h;
    if FxRn(f, x, True, f1) <> 0 then
      Exit(0);

    x[i] := xi - 2 * h;
    if FxRn(f, x, True, f3) <> 0 then
      Exit(0);

    x[i] := xi;
    if FxRn(f, x, True, f2) <> 0 then
      Exit(0);

    p := (f1 - 2 * f2 + f3) / (4 * h * h);
  end;

  for k := 1 to 10 do
  begin
    q := p;
    h := h / 2;

    if i <> j then
    begin
      x[i] := xi + h;
      x[j] := xj + h;
      if FxRn(f, x, True, f1) <> 0 then
        Exit(0);

      x[j] := xj - h;
      if FxRn(f, x, True, f2) <> 0 then
        Exit(0);

      x[i] := xi - h;
      if FxRn(f, x, True, f4) <> 0 then
        Exit(0);

      x[j] := xj + h;
      if FxRn(f, x, True, f3) <> 0 then
        Exit(0);

      p := (f1 - f2 - f3 + f4) / (4 * h * h);
    end
    else
    begin
      x[i] := xi + 2 * h;
      if FxRn(f, x, True, f1) <> 0 then
        Exit(0);

      x[i] := xi - 2 * h;
      if FxRn(f, x, True, f3) <> 0 then
        Exit(0);

      x[i] := xi;
      if FxRn(f, x, True, f2) <> 0 then
        Exit(0);

      p := (f1 - 2 * f2 + f3) / (4 * h * h);
    end;

    if abs(p - q) < epsilon then
      Break;
  end;

  r := p;
  Exit(1);
end;

function calcularGradiente(f: string; x: Vetor; epsilon: extended; var G: Vetor): word;
var
  i: integer;
  r: extended;
begin
  for i := 1 to n do
  begin
    if derivadaParcial(f, x, epsilon, i, r) = 0 then
      Exit(0);
    G[i] := r;
  end;

  Exit(1);
end;

// ERRO NO CÁLCULO DA HESSIANA (?) [eu acho que tá errado, pelo menos]

function calcularHessiana(f: string; x: Vetor; epsilon: extended; var H: Matriz): word;
var
  i, j: integer;
  r: extended;
begin
  for i := 1 to n do
  begin
    for j := 1 to n do
    begin
      if derivadaParcialSegunda(f, x, epsilon, i, j, r) = 0 then
        Exit(0);
      H[i, j] := r;
    end;
  end;

  for i := 2 to n do
    for j := 1 to i - 1 do
      H[i, j] := H[j, i];

  Exit(1);
end;

procedure TForm1.MontarGradeGHClick(Sender: TObject);
var
  i, j: integer;
begin
  try
    n := StrToInt(Edit6.Text);
  except
    ShowMessage('Quantidade de variáveis (n) inválida!');
    Edit6.SetFocus;
    erroGrade := 1;
    Exit;
  end;

  if (n < 2) or (n > 20) then
  begin
    ShowMessage('Essa região calcula funções com quantidade de variáveis no intervalo [2, 20]!');
    Edit6.SetFocus;
    erroGrade := 1;
    Exit;
  end;

  StringGrid1.ColCount := n + 1;
  StringGrid2.ColCount := n + 1;
  StringGrid3.ColCount := n + 1;
  StringGrid3.RowCount := n + 1;

  if n > 8 then
  begin
    StringGrid1.Height := 48 + GetSystemMetrics(SM_CYHSCROLL);
    StringGrid2.Height := 48 + GetSystemMetrics(SM_CYHSCROLL);
    StringGrid3.Height := 202 + GetSystemMetrics(SM_CYHSCROLL);
    StringGrid3.Width := 571 + GetSystemMetrics(SM_CYVSCROLL);
  end
  else
  begin
    StringGrid1.Height := 48;
    StringGrid2.Height := 48;
    StringGrid3.Height := 202;
    StringGrid3.Width := 571;
  end;

  for i := 1 to n do
  begin
    StringGrid1.Cells[i, 0] := IntToStr(i);
    StringGrid2.Cells[i, 0] := IntToStr(i);
    StringGrid3.Cells[i, 0] := IntToStr(i);
    StringGrid3.Cells[0, i] := IntToStr(i);
  end;
end;

procedure TForm1.CalcularMaisVariaveisClick(Sender: TObject);
var
  f: string;
  x, G: Vetor;
  H: Matriz;
  epsilon, d: extended;
  i, j: integer;
begin
  erroGrade := 0;
  MontarGradeGH.Click;
  if erroGrade <> 0 then
    Exit;

  f := Trim(Edit7.Text);

  if f = '' then
  begin
    ShowMessage('Função inválida ou vazia!');
    Edit7.SetFocus;
    Exit;
  end;

  try
    epsilon := StrToFloat(Edit8.Text);

    if (epsilon > 0.001 + 10E-10) or (epsilon < 0.0000001 - 10E-10) then
    begin
      ShowMessage('Aproximação inválida (entre 1E-3 e 1E-7)!');
      Edit8.SetFocus;
      Exit;
    end;
  except
    ShowMessage('Aproximação inválida ou vazia!');
    Edit8.SetFocus;
    Exit;
  end;

  SetLength(x, n + 1);
  SetLength(G, n + 1);
  SetLength(H, n + 1, n + 1);

  for i := 1 to n do
  begin
    try
      x[i] := StrToFloat(StringGrid1.Cells[i, 1]);
    except
      ShowMessage('Valor inválido para x[' + IntToStr(i) + ']!');
      StringGrid1.SetFocus;
      Exit;
    end;
  end;

  if calcularGradiente(f, x, epsilon, G) <> 0 then
  begin
    for i := 1 to n do
      StringGrid2.Cells[i, 1] := FloatToStr(G[i]);
  end
  else
  begin
    for i := 1 to n do
      StringGrid2.Cells[i, 1] := '';
    ShowMessage('Erro ao calcular o gradiente!');
    Exit;
  end;

  if calcularHessiana(f, x, epsilon, H) <> 0 then
  begin
    for i := 1 to n do
      for j := 1 to n do
        StringGrid3.Cells[j, i] := FloatToStr(H[i, j]);
  end
  else
  begin
    for i := 1 to n do
      for j := 1 to n do
        StringGrid3.Cells[j, i] := '';
    ShowMessage('Erro ao calcular a hessiana!');
    Exit;
  end;
end;

procedure TForm1.LimparMaisVariaveisClick(Sender: TObject);
var
  i, j: integer;
begin
  Edit6.Text := '2';
  MontarGradeGH.Click;

  for i := 1 to n do
  begin
    StringGrid1.Cells[i, 1] := '';
    StringGrid2.Cells[i, 1] := '';
    for j := 1 to n do
      StringGrid3.Cells[i, j] := '';
  end;

  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
end;

// CÁLCULO DE DERIVADAS PARA VÁRIAS FUNÇÕES DE VÁRIAS VARIÁVEIS

procedure TForm1.MontarGradeJClick(Sender: TObject);
var
  i: integer;
begin
  try
    m := StrToInt(Edit9.Text);
  except
    ShowMessage('Valor inválido para quantidade de funções!');
    Edit9.SetFocus;
    erroGrade := 1;
    Exit;
  end;

  try
    n := StrToInt(Edit10.Text);
  except
    ShowMessage('Valor inválido para quantidade de variáveis!');
    Edit10.SetFocus;
    erroGrade := 1;
    Exit;
  end;

  if (n < 2) or (n > 20) then
  begin
    ShowMessage('Quantidade de variáveis fora do intervalo [2, 20]!');
    Edit9.SetFocus;
    erroGrade := 1;
    Exit;
  end;

  if (m < 2) or (m > 20) then
  begin
    ShowMessage('Quantidade de funções fora do intervalo [2, 20]!');
    Edit10.SetFocus;
    erroGrade := 1;
    Exit;
  end;

  StringGrid4.ColCount := n + 1;
  StringGrid5.RowCount := m + 1;

  StringGrid6.ColCount := n + 1;
  StringGrid6.RowCount := m + 1;

  if m > 8 then
  begin
    StringGrid5.Width := 580 + GetSystemMetrics(SM_CYVSCROLL);
    StringGrid6.Width := 580 + GetSystemMetrics(SM_CYVSCROLL);
  end
  else
  begin
    StringGrid5.Width := 580;
    StringGrid6.Width := 580;
  end;

  if n > 8 then
  begin
    StringGrid4.Height := 44 + GetSystemMetrics(SM_CYHSCROLL);
    StringGrid6.Height := 184 + GetSystemMetrics(SM_CYVSCROLL);
  end
  else
  begin
    StringGrid4.Height := 44;
    StringGrid6.Height := 184;
  end;

  for i := 1 to n do
  begin
    StringGrid4.Cells[i, 0] := IntToStr(i);
    StringGrid6.Cells[i, 0] := IntToStr(i);
  end;

  for i := 1 to m do
  begin
    StringGrid5.Cells[0, i] := IntToStr(i);
    StringGrid6.Cells[0, i] := IntToStr(i);
  end;
end;

procedure TForm1.CalcularJacobianoClick(Sender: TObject);
var
  f: string;
  x, G: Vetor;
  epsilon: extended;
  i, j, k: integer;
begin
  erroGrade := 0;
  MontarGradeJ.Click;
  if erroGrade <> 0 then
    Exit;

  try
    epsilon := StrToFloat(Edit11.Text);

    if (epsilon > 0.001 + 10E-10) or (epsilon < 0.0000001 - 10E-10) then
    begin
      ShowMessage('Aproximação inválida (entre 1E-3 e 1E-7)!');
      Edit11.SetFocus;
      Exit;
    end;
  except
    ShowMessage('Aproximação inválida ou vazia!');
    Edit11.SetFocus;
    Exit;
  end;

  SetLength(x, n + 1);
  SetLength(G, n + 1);

  for i := 1 to n do
  begin
    try
      x[i] := StrToFloat(StringGrid4.Cells[i, 1]);
    except
      ShowMessage('Valor inválido para x[' + IntToStr(i) + ']!');
      Exit;
    end;
  end;

  for i := 1 to m do
  begin
    f := Trim(StringGrid5.Cells[1, i]);
    if f = '' then
    begin
      ShowMessage('Função vazia em f[' + IntToStr(i) + ']!');
      Exit;
    end;

    if calcularGradiente(f, x, epsilon, G) <> 0 then
    begin
      for j := 1 to n do
        StringGrid6.Cells[j, i] := FloatToStr(G[j]);
    end
    else
    begin
      for j := 1 to n do
        for k := 1 to m do
          StringGrid6.Cells[j, k] := '';
      ShowMessage('Erro ao calcular o jacobiano!');
      Exit;
    end;
  end;
end;

procedure TForm1.LimparJacobianoClick(Sender: TObject);
var
  i, j: integer;
begin
  Edit9.Text := '2';
  Edit10.Text := '2';
  MontarGradeJ.Click;

  for i := 1 to n do
  begin
    StringGrid4.Cells[i, 1] := '';
  end;

  for i := 1 to m do
  begin
    StringGrid5.Cells[1, i] := '';
  end;

  for i := 1 to n do
    for j := 1 to m do
      StringGrid6.Cells[j, i] := '';

  Edit9.Text := '';
  Edit10.Text := '';
  Edit11.Text := '';
end;

end.
