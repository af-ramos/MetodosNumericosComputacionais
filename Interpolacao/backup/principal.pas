unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, Grids,
  Buttons, TAGraph, TASeries, Windows, lclintf, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    IniciarCalculo: TSpeedButton;
    LimparDados: TSpeedButton;
    MontarGrade: TSpeedButton;
    MostrarAjuda: TSpeedButton;
    ExemploUm: TSpeedButton;
    ExemploDois: TSpeedButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    procedure ExemploDoisClick(Sender: TObject);
    procedure ExemploUmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IniciarCalculoClick(Sender: TObject);
    procedure MontarGradeClick(Sender: TObject);
    procedure LimparDadosClick(Sender: TObject);
    procedure SpinEdit1EditingDone(Sender: TObject);
    procedure SpinEdit2EditingDone(Sender: TObject);
    procedure MostrarAjudaClick(Sender: TObject);
    procedure SistemaLinear(l: integer);
    procedure Newton(l: integer);
    procedure NewtonGregory(l: integer);
  private

  public

  end;

var
  Form1: TForm1;
  n, k: integer;
  z: extended;
  x, y, xTodos, yTodos, a, Delta0y: array [0..20] of extended;
  erro, interromper: boolean;

implementation

{$R *.lfm}

{ TForm1 }

// FUNÇÕES AUXILIARES

procedure TForm1.SpinEdit1EditingDone(Sender: TObject);
begin
  SpinEdit2.MaxValue := SpinEdit1.Value - 1;
  SpinEdit2.EditingDone;
end;

procedure TForm1.SpinEdit2EditingDone(Sender: TObject);
begin
  if SpinEdit2.Value < SpinEdit1.Value - 1 then
    Edit1.Enabled := True
  else
  begin
    Edit1.Enabled := False;
    Edit1.Text := '';
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LimparDados.Click;
end;

function dadosRepetidos: boolean;
var
  i, j: integer;
begin
  for i := 0 to n - 2 do
    for j := i + 1 to n - 1 do
      if x[i] = x[j] then
        Exit(True);
  Exit(False);
end;

function ordenarDados(l: integer): word;
var
  i, j: integer;
  aux: extended;
  k: boolean;
begin
  k := True;

  for i := 0 to l - 1 do
  begin
    if not k then
      Break;

    k := False;

    for j := 0 to l - 1 - i do
    begin
      if x[j] > x[j + 1] then
      begin
        aux := x[j];
        x[j] := x[j + 1];
        x[j + 1] := aux;

        aux := y[j];
        y[j] := y[j + 1];
        y[j + 1] := aux;

        k := True;
      end;
    end;
  end;

  Exit(0);
end;

function pontosProximos: word;
var
  indices: array[0..19] of byte;
  distancias: array[0..19] of extended;
  i, j: integer;
  trocou: boolean;
  auxiliarD: extended;
  auxiliarI: byte;
begin
  for i := 0 to n - 1 do
  begin
    distancias[i] := abs(z - x[i]);
    indices[i] := i;
  end;

  trocou := True;
  j := n - 2;

  while trocou do
  begin
    trocou := False;

    for i := 0 to j do
      if distancias[i] > distancias[i + 1] then
      begin
        auxiliarD := distancias[i];
        distancias[i] := distancias[i + 1];
        distancias[i + 1] := auxiliarD;

        auxiliarI := indices[i];
        indices[i] := indices[i + 1];
        indices[i + 1] := auxiliarI;

        trocou := True;
      end;
    j := j - 1;
  end;

  FillChar(x, SizeOf(x), 0);
  FillChar(y, SizeOf(y), 0);

  for i := 0 to k do
  begin
    x[i] := xTodos[indices[i]];
    y[i] := yTodos[indices[i]];
  end;

  Exit(0);
end;

// FUNÇÕES DE BOTÃO

procedure TForm1.MontarGradeClick(Sender: TObject);
var
  i: integer;
begin
  n := SpinEdit1.Value;

  with StringGrid1 do
  begin
    RowCount := n + 1;

    if RowCount > 8 then
      StringGrid1.Width := 278 + GetSystemMetrics(SM_CYHSCROLL)
    else
      StringGrid1.Width := 278;

    Cells[0, 0] := 'i';
    Cells[1, 0] := 'x[i]';
    Cells[2, 0] := 'f(x[i])';
    for i := 1 to n do
      Cells[0, i] := IntToStr(i - 1);
  end;
end;

procedure TForm1.LimparDadosClick(Sender: TObject);
var
  i: integer;
begin
  RadioButton1.Checked := True;
  Edit1.Enabled := False;

  SpinEdit1.Value := 4;
  SpinEdit2.Value := 3;

  Edit1.Text := '';
  Edit2.Text := '';

  MontarGrade.Click;

  for i := 1 to n do
  begin
    StringGrid1.Cells[1, i] := '';
    StringGrid1.Cells[2, i] := '';
  end;

  Chart1.Title.Text.Clear;
  Chart1LineSeries1.Clear;
  Chart1LineSeries2.Clear;
  Chart1LineSeries3.Clear;
end;

procedure TForm1.MostrarAjudaClick(Sender: TObject);
begin
  ShowMessage('Se o senhor procurava por uma ajuda, infelizmente não posso ajudar!' +
    #13#10 + #13#10 +
    'Então segue um site onde pode-se sanar todas as possíveis dúvidas...');
  OpenUrl('https://pt.wikipedia.org/wiki/Wikip%C3%A9dia:P%C3%A1gina_principal');
end;

procedure TForm1.IniciarCalculoClick(Sender: TObject);
var
  i, j: integer;
  passo, xGrafico, yGrafico: extended;
begin
  MontarGrade.Click;

  erro := True;

  FillChar(x, SizeOf(x), 0);
  FillChar(xTodos, SizeOf(xTodos), 0);
  FillChar(y, SizeOf(y), 0);
  FillChar(yTodos, SizeOf(yTodos), 0);

  k := SpinEdit2.Value;

  if k < n - 1 then
  begin
    try
      z := StrToFloat(Edit1.Text);
    except
      ShowMessage('Valor inválido para z!');
      Exit;
    end;
  end;

  for i := 0 to n - 1 do
  begin
    try
      x[i] := StrToFloat(StringGrid1.Cells[1, i + 1]);
    except
      ShowMessage('Valor inválido para x[' + IntToStr(i) + ']!');
      Exit;
    end;

    try
      y[i] := StrToFloat(StringGrid1.Cells[2, i + 1]);
    except
      ShowMessage('Valor inválido para y[' + IntToStr(i) + ']!');
      Exit;
    end;
  end;

  if dadosRepetidos then
  begin
    ShowMessage('Existem pontos repetidos na tabela, remova-os ou edite-os!');
    Exit;
  end;

  ordenarDados(n - 1);

  if RadioButton3.Checked then
  begin
    passo := x[1] - x[0];

    for i := 2 to n - 1 do
      if abs((x[i] - x[i - 1] - passo) / passo) > 1E-7 then
      begin
        ShowMessage(
          'Os pontos x não possuem o mesmo espaçamento, portanto não é possível utilizar esse método!');
        Exit;
      end;
  end;

  for i := 0 to n - 1 do
  begin
    xTodos[i] := x[i];
    yTodos[i] := y[i];
  end;

  if k < n - 1 then
  begin
    if (z < x[0]) or (z > x[n - 1]) then
    begin
      ShowMessage('O valor de z deve estar entre ' + FloatToStr(x[0]) +
        ' e ' + FloatToStr(x[n - 1]) + '!');
      Exit;
    end;
  end;

  pontosProximos;
  ordenarDados(k);

  if RadioButton1.Checked then       // SISTEMA LINEAR
  begin
    if k < n - 1 then
      SistemaLinear(k)
    else
      SistemaLinear(n - 1);

    if erro then
      Exit;

    Edit2.Text := 'p' + IntToStr(k) + '(x) = ';

    for i := 0 to n - 1 do
    begin
      if a[i] >= 0 then
        Edit2.Text := Edit2.Text + '+' + FloatToStr(a[i]) + '*x^' + IntToStr(i)
      else
        Edit2.Text := Edit2.Text + FloatToStr(a[i]) + '*x^' + IntToStr(i);
    end;

    Chart1.Title.Text.Clear;
    Chart1.Title.Text.Add('Polinômio p' + IntToStr(k) + '(x) com ' +
      IntToStr(k + 1) + ' pontos');

    Chart1LineSeries1.Clear;
    Chart1LineSeries2.Clear;
    Chart1LineSeries3.Clear;

    passo := (xTodos[n - 1] - xTodos[0]) / 1000;

    for i := 0 to 1000 do
    begin
      xGrafico := xTodos[0] + i * passo;
      yGrafico := 0;

      for j := 0 to n - 1 do
        yGrafico := yGrafico + a[j] * Power(xGrafico, j);
      Chart1LineSeries3.AddXY(xGrafico, yGrafico);
    end;

    for i := 0 to n - 1 do
      Chart1LineSeries2.AddXY(xTodos[i], yTodos[i]);
    for i := 0 to k do
      Chart1LineSeries1.AddXY(x[i], y[i]);
  end
  else if RadioButton2.Checked then  // NEWTON
  begin
    if k < n - 1 then
      Newton(k)
    else
      Newton(n - 1);

    if erro then
      Exit;

    Edit2.Text := 'p' + IntToStr(k) + '(x) = ' + FloatToStr(Delta0y[0]);
    for i := 0 to n - 2 do
    begin
      if x[i] < 0 then
        Edit2.Text := Edit2.Text + '+(x+' + FloatToStr(-x[i]) + ')*(' +
          FloatToStr(Delta0y[i + 1])
      else if x[i] = 0 then
        Edit2.Text := Edit2.Text + '+(x-' + FloatToStr(-x[i]) + ')*(' +
          FloatToStr(Delta0y[i + 1])
      else
        Edit2.Text := Edit2.Text + '+(x' + FloatToStr(-x[i]) + ')*(' +
          FloatToStr(Delta0y[i + 1]);
    end;
    for i := 0 to n - 2 do
      Edit2.Text := Edit2.Text + ')';

    Chart1.Title.Text.Clear;
    Chart1.Title.Text.Add('Polinômio p' + IntToStr(k) + '(x) com ' +
      IntToStr(k + 1) + ' pontos');

    Chart1LineSeries1.Clear;
    Chart1LineSeries2.Clear;
    Chart1LineSeries3.Clear;

    passo := (xTodos[n - 1] - xTodos[0]) / 1000;

    for i := 0 to 1000 do
    begin
      xGrafico := xTodos[0] + i * passo;
      yGrafico := Delta0y[k];

      for j := k - 1 downto 0 do
        yGrafico := yGrafico * (xGrafico - x[j]) + Delta0y[j];
      Chart1LineSeries3.AddXY(xGrafico, yGrafico);
    end;

    for i := 0 to n - 1 do
      Chart1LineSeries2.AddXY(xTodos[i], yTodos[i]);
    for i := 0 to k do
      Chart1LineSeries1.AddXY(x[i], y[i]);
  end
  else                               // NEWTON-GREGORY
  begin
    if k < n - 1 then
      NewtonGregory(k)
    else
      NewtonGregory(n - 1);

    if erro then
      Exit;

    Edit2.Text := 'p' + IntToStr(k) + '(x) = ' + FloatToStr(Delta0y[0]);
    for i := 0 to n - 2 do
    begin
      if x[i] < 0 then
        Edit2.Text := Edit2.Text + '+(x+' + FloatToStr(-x[i]) + ')*(' +
          FloatToStr(Delta0y[i + 1])
      else if x[i] = 0 then
        Edit2.Text := Edit2.Text + '+(x-' + FloatToStr(-x[i]) + ')*(' +
          FloatToStr(Delta0y[i + 1])
      else
        Edit2.Text := Edit2.Text + '+(x' + FloatToStr(-x[i]) + ')*(' +
          FloatToStr(Delta0y[i + 1]);
    end;
    for i := 0 to n - 2 do
      Edit2.Text := Edit2.Text + ')';

    Chart1.Title.Text.Clear;
    Chart1.Title.Text.Add('Polinômio p' + IntToStr(k) + '(x) com ' +
      IntToStr(k + 1) + ' pontos');

    Chart1LineSeries1.Clear;
    Chart1LineSeries2.Clear;
    Chart1LineSeries3.Clear;

    passo := (xTodos[n - 1] - xTodos[0]) / 1000;

    for i := 0 to 1000 do
    begin
      xGrafico := xTodos[0] + i * passo;
      yGrafico := Delta0y[k];

      for j := k - 1 downto 0 do
        yGrafico := yGrafico * (xGrafico - x[j]) + Delta0y[j];
      Chart1LineSeries3.AddXY(xGrafico, yGrafico);
    end;

    for i := 0 to n - 1 do
      Chart1LineSeries2.AddXY(xTodos[i], yTodos[i]);
    for i := 0 to k do
      Chart1LineSeries1.AddXY(x[i], y[i]);
  end;
end;

procedure TForm1.ExemploUmClick(Sender: TObject);
begin
  LimparDados.Click;

  RadioButton1.Checked := True;

  SpinEdit1.Value := 6;
  SpinEdit1.EditingDone;
  SpinEdit2.Value := 5;
  SpinEdit2.EditingDone;

  MontarGrade.Click;

  with StringGrid1 do
  begin
    Cells[1, 1] := '-2';
    Cells[2, 1] := '1';

    Cells[1, 2] := '-1';
    Cells[2, 2] := '2,5';

    Cells[1, 3] := '0,5';
    Cells[2, 3] := '1,5';

    Cells[1, 4] := '2';
    Cells[2, 4] := '1';

    Cells[1, 5] := '3,5';
    Cells[2, 5] := '-1';

    Cells[1, 6] := '4';
    Cells[2, 6] := '0,5';
  end;
end;

procedure TForm1.ExemploDoisClick(Sender: TObject);
begin
  LimparDados.Click;

  RadioButton3.Checked := True;

  SpinEdit1.Value := 7;
  SpinEdit1.EditingDone;
  SpinEdit2.Value := 6;
  SpinEdit2.EditingDone;

  MontarGrade.Click;

  with StringGrid1 do
  begin
    Cells[1, 1] := '-2';
    Cells[2, 1] := '1';

    Cells[1, 2] := '-1';
    Cells[2, 2] := '2,5';

    Cells[1, 3] := '0';
    Cells[2, 3] := '1,6';

    Cells[1, 4] := '1';
    Cells[2, 4] := '1,5';

    Cells[1, 5] := '2';
    Cells[2, 5] := '1';

    Cells[1, 6] := '3';
    Cells[2, 6] := '-0,7';

    Cells[1, 7] := '4';
    Cells[2, 7] := '0,5';
  end;
end;

// FUNÇÕES DE CÁLCULO

procedure TForm1.SistemaLinear(l: integer);
var
  Mx: array[0..19, 0..19] of extended;
  Vy, Va: array [0..19] of extended;
  i, j, k: integer;
  m, soma: extended;
begin
  FillChar(Mx, SizeOf(Mx), 0);
  FillChar(Vy, SizeOf(Vy), 0);
  FillChar(Va, SizeOf(Va), 0);

  for i := 0 to l do
  begin
    for j := 0 to l do
      Mx[i, j] := Power(x[i], j);
    Vy[i] := y[i];
  end;

  for j := 0 to l - 1 do
  begin
    for i := j + 1 to l do
    begin
      try
        m := Mx[i, j] / Mx[j, j];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;

      for k := j to l do
        Mx[i, k] := Mx[i, k] - m * Mx[j, k];
      Vy[i] := Vy[i] - m * Vy[j];
    end;
  end;

  try
    Va[l] := Vy[l] / Mx[l, l];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := l - 1 downto 0 do
  begin
    soma := 0;

    for j := i + 1 to l do
      soma := soma + Mx[i, j] * Va[j];
    Va[i] := (Vy[i] - soma) / Mx[i, i];
  end;

  FillChar(a, SizeOf(a), 0);
  for i := 0 to l do
    a[i] := Va[i];

  erro := False;
end;

procedure TForm1.Newton(l: integer);
var
  i, j: integer;
  Del: array[0..19, 0..19] of extended;
begin
  FillChar(Del, SizeOf(Del), 0);

  for i := 0 to l do
    Del[i, 0] := y[i];

  for i := 1 to l do
    for j := 0 to l - i do
      Del[j, i] := (Del[j + 1, i - 1] - Del[j, i - 1]) / (x[j + i] - x[j]);

  FillChar(Delta0y, SizeOf(Delta0y), 0);
  for i := 0 to l do
    Delta0y[i] := Del[0, i];

  erro := False;
end;

procedure TForm1.NewtonGregory(l: integer);
var
  i, j: integer;
  fatorial, distancia: extended;
  Del: array[0..19, 0..19] of extended;
begin
  FillChar(Del, SizeOf(Del), 0);

  for i := 0 to l do
    Del[i, 0] := y[i];

  for i := 1 to l do
    for j := 0 to l - i do
      Del[j, i] := Del[j + 1, i - 1] - Del[j, i - 1];

  distancia := x[1] - x[0];
  fatorial := 1;

  FillChar(Delta0y, SizeOf(Delta0y), 0);

  Delta0y[0] := Del[0, 0];
  for i := 1 to l do
  begin
    Delta0y[i] := Del[0, i] / (fatorial * distancia);

    distancia := distancia * distancia;
    fatorial := fatorial * (i + 1);
  end;

  erro := False;
end;

end.
