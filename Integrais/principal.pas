unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, Grids,
  ExtCtrls, Buttons, TAGraph, TASeries, lclintf;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    Bevel1: TBevel;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenDialog1: TOpenDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    C2: TRadioButton;
    C4: TRadioButton;
    C8: TRadioButton;
    C16: TRadioButton;
    C32: TRadioButton;
    C64: TRadioButton;
    C100: TRadioButton;
    BotaoNovo: TSpeedButton;
    BotaoAbrir: TSpeedButton;
    BotaoSalvar: TSpeedButton;
    BotaoCalcular: TSpeedButton;
    BotaoAjuda: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure BotaoAjudaClick(Sender: TObject);
    procedure BotaoCalcularClick(Sender: TObject);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure PontosHabilitados(k: integer);
    procedure LimparGradePontos;
    procedure FuncaoHabilitada(k: integer);
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure MontarGrade;
    procedure BotaoAbrirClick(Sender: TObject);
    procedure SpinEdit1EditingDone(Sender: TObject);
    procedure ordenarValores(x, y: array of extended);
    procedure GaussLegendre(x1, x2: extended; var w, t: array of extended; q: integer);
    function verificarEspacamento(x: array of extended): word;
    function verificarRepetidos(x: array of extended): word;
    function RetangulosEsquerda(y: array of extended; h: extended): extended;
    function RetangulosDireita(y: array of extended; h: extended): extended;
    function RegraTrapezios(y: array of extended; h: extended): extended;
    function UmTercoSimpson(y: array of extended; h: extended): extended;
    function TresOitavosSimpson(y: array of extended; h: extended): extended;
    function QuadraturaGauss(f: string; a, b: extended; q: integer;
      var integral: extended): word;
  private

  public

  end;

var
  FormPrincipal: TFormPrincipal;
  n: integer;

function FxR1(f: string; x: extended; var y: extended): word;
  stdcall; external 'Interpretador.dll';

implementation

{$R *.lfm}

{ TFormPrincipal }

// FUNÇÕES AUXILIARES

procedure TFormPrincipal.MontarGrade;
var
  i: integer;
begin
  StringGrid1.RowCount := n + 2;

  for i := 1 to n + 1 do
    StringGrid1.Cells[0, i] := IntToStr(i - 1);
end;

procedure TFormPrincipal.SpinEdit1EditingDone(Sender: TObject);
begin
  n := TSpinEdit(Sender).Value;
  MontarGrade;
end;

procedure TFormPrincipal.LimparGradePontos;
var
  i: integer;
begin
  for i := 1 to n + 1 do
  begin
    StringGrid1.Cells[1, i] := '';
    StringGrid1.Cells[2, i] := '';
  end;
end;

procedure TFormPrincipal.PontosHabilitados(k: integer);
begin
  if k = 1 then
  begin
    SpinEdit1.Enabled := True;
    StringGrid1.Options := StringGrid1.Options + [goEditing];
  end
  else
  begin
    SpinEdit1.Enabled := False;
    StringGrid1.Options := StringGrid1.Options - [goEditing];
  end;
end;

procedure TFormPrincipal.FuncaoHabilitada(k: integer);
begin
  if k = 1 then
  begin
    Edit1.Enabled := True;
    Edit2.Enabled := True;
    Edit3.Enabled := True;
    SpinEdit2.Enabled := True;
    CheckBox1.Enabled := True;

    C2.Enabled := True;
    C4.Enabled := True;
    C8.Enabled := True;
    C16.Enabled := True;
    C32.Enabled := True;
    C64.Enabled := True;
    C100.Enabled := True;
  end
  else
  begin
    Edit1.Enabled := False;
    Edit2.Enabled := False;
    Edit3.Enabled := False;
    SpinEdit2.Enabled := False;
    CheckBox1.Enabled := False;

    C2.Enabled := False;
    C4.Enabled := False;
    C8.Enabled := False;
    C16.Enabled := False;
    C32.Enabled := False;
    C64.Enabled := False;
    C100.Enabled := False;
  end;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  PontosHabilitados(1);
  FuncaoHabilitada(0);

  SpinEdit1.Value := 2;
  SpinEdit1.EditingDone;

  with StringGrid1 do
  begin
    ColWidths[0] := 35;
    Cells[0, 0] := 'i';
    Cells[1, 0] := 'x[i]';
    Cells[2, 0] := 'y[i]';
  end;

  with StringGrid2 do
  begin
    ColWidths[0] := 125;
    Cells[0, 0] := 'Método';
    Cells[0, 1] := 'Retângulos à Esquerda';
    Cells[0, 2] := 'Retângulos à Direita';
    Cells[0, 3] := 'Regra dos Trapézios';
    Cells[0, 4] := 'Regra 1/3 de Simpson';
    Cells[0, 5] := 'Regra 3/8 de Simpson';
    Cells[0, 6] := 'Quadratura de Gauss';
    Cells[1, 0] := 'Resultado';
  end;
end;

procedure TFormPrincipal.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1.Checked then
  begin
    PontosHabilitados(1);
    FuncaoHabilitada(0);
    SpinEdit1.EditingDone;
  end
  else
  begin
    PontosHabilitados(0);
    FuncaoHabilitada(1);
    SpinEdit2.EditingDone;
    LimparGradePontos;
  end;
end;

function TFormPrincipal.verificarEspacamento(x: array of extended): word;
var
  i: integer;
  h: extended;
begin
  h := abs(x[1] - x[0]);

  for i := 2 to n do
    if abs((x[i] - x[i - 1] - h) / h) > 1E-7 then
      Exit(1);

  Exit(0);
end;

function TFormPrincipal.verificarRepetidos(x: array of extended): word;
var
  i, j: integer;
begin
  for i := 0 to n - 1 do
    for j := i + 1 to n do
      if x[i] = x[j] then
        Exit(1);

  Exit(0);
end;

procedure TFormPrincipal.ordenarValores(x, y: array of extended);
var
  i, j, k: integer;
  aux: extended;
begin
  k := 1;

  for i := 0 to n do
  begin
    if k = 0 then
      Break;

    k := 0;
    for j := 0 to n - 1 - i do
    begin
      if x[j] > x[j + 1] then
      begin
        k := 1;

        aux := x[j];
        x[j] := x[j + 1];
        x[j + 1] := aux;

        aux := y[j];
        y[j] := y[j + 1];
        y[j + 1] := aux;
      end;
    end;
  end;
end;

procedure TFormPrincipal.GaussLegendre(x1, x2: extended;
  var w, t: array of extended; q: integer);
const
  Eps = 1.0E-18;
var
  m, j, i: integer;
  z1, z, xm, xl, pp, p3, p2, p1: extended;
begin
  m := (q + 1) div 2;
  xm := 0.5 * (x2 + x1);
  xl := 0.5 * (x2 - x1);

  for i := 1 to m do
  begin
    z := Cos(Pi * (i - 0.25) / (q + 0.5));
    repeat
      p1 := 1.0;
      p2 := 0.0;

      for j := 1 to q do
      begin
        p3 := p2;
        p2 := p1;
        p1 := ((2.0 * j - 1.0) * z * p2 - (j - 1.0) * p3) / j;
      end;

      pp := q * (z * p1 - p2) / (z * z - 1.0);
      z1 := z;
      z := z1 - p1 / pp;
    until (abs(z - z1) <= Eps);

    t[i - 1] := xm - xl * z;
    t[q - i] := xm + xl * z;
    w[i - 1] := 2.0 * xl / ((1.0 - z * z) * pp * pp);
    w[q - i] := w[i - 1];
  end;
end;

// FUNÇÕES DE BOTÃO

procedure TFormPrincipal.BotaoAbrirClick(Sender: TObject);
var
  f: TextFile;
  i, qtdLinhas: integer;
  strTemp: string;
  arrayTemp: TStringArray;
begin
  if OpenDialog1.Execute then
  begin
    BotaoNovo.Click;

    AssignFile(f, OpenDialog1.FileName);
    Reset(f);

    with StringGrid1 do
    begin
      Readln(f, qtdLinhas);
      Readln(f, strTemp);

      if strTemp = 'Pontos' then
      begin
        RadioButton1.Checked := True;

        SpinEdit1.Value := qtdLinhas;
        SpinEdit1.EditingDone;

        for i := 1 to qtdLinhas + 1 do
        begin
          Readln(f, strTemp);
          arrayTemp := strTemp.Split(' ');

          Cells[1, i] := arrayTemp[0];
          Cells[2, i] := arrayTemp[1];
        end;
      end
      else
      begin
        RadioButton2.Checked := True;

        SpinEdit2.Value := qtdLinhas;
        SpinEdit2.EditingDone;

        Readln(f, strTemp);
        Edit1.Text := strTemp;

        Readln(f, strTemp);
        Edit2.Text := strTemp;

        Readln(f, strTemp);
        Edit3.Text := strTemp;

        Readln(f, strTemp);

        if strTemp = '2' then
          C2.Checked := True
        else if strTemp = '4' then
          C4.Checked := True
        else if strTemp = '8' then
          C8.Checked := True
        else if strTemp = '16' then
          C16.Checked := True
        else if strTemp = '32' then
          C32.Checked := True
        else if strTemp = '64' then
          C64.Checked := True
        else if strTemp = '100' then
          C100.Checked := True;
      end;
    end;

    CloseFile(f);
  end;
end;

procedure TFormPrincipal.BotaoSalvarClick(Sender: TObject);
var
  f: TextFile;
  i: integer;
begin
  if SaveDialog1.Execute then
  begin
    AssignFile(f, SaveDialog1.FileName);
    Rewrite(f);

    with StringGrid1 do
    begin
      Writeln(f, n);

      if RadioButton1.Checked then
      begin
        Writeln(f, 'Pontos');
        for i := 1 to n + 1 do
          Writeln(f, Cells[1, i] + ' ' + Cells[2, i]);
      end
      else
      begin
        Writeln(f, 'Função');

        Writeln(f, Edit1.Text);
        Writeln(f, Edit2.Text);
        Writeln(f, Edit3.Text);

        if C2.Checked then
          Writeln(f, '2')
        else if C4.Checked then
          Writeln(f, '4')
        else if C8.Checked then
          Writeln(f, '8')
        else if C16.Checked then
          Writeln(f, '16')
        else if C32.Checked then
          Writeln(f, '32')
        else if C64.Checked then
          Writeln(f, '64')
        else
          Writeln(f, '100');
      end;
    end;

    CloseFile(f);
  end;
end;

procedure TFormPrincipal.BotaoNovoClick(Sender: TObject);
begin
  SpinEdit1.Value := 2;
  if (not RadioButton1.Checked) then
    RadioButton1.Checked := True
  else
    SpinEdit1.EditingDone;
  LimparGradePontos;

  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  CheckBox1.Checked := False;
  C2.Checked := True;
  SpinEdit2.Value := 2;

  with StringGrid2 do
  begin
    Cells[1, 1] := '';
    Cells[1, 2] := '';
    Cells[1, 3] := '';
    Cells[1, 4] := '';
    Cells[1, 5] := '';
    Cells[1, 6] := '';
  end;

  Chart1LineSeries1.Clear;
  Chart1LineSeries2.Clear;
  Chart1AreaSeries1.Clear;
end;

procedure TFormPrincipal.BotaoAjudaClick(Sender: TObject);
begin
  MessageDlg('"Menu" de Ajuda',
    'Eu confio que o usuário saiba o suficiente sobre Integral Numérica para compreender sozinho o programa.'
    + #13#10#13#10 +
    'Caso mesmo assim tenha dúvidas, segue um site que pode te ajudar (ou atrapalhar).',
    mtInformation, [], 0);
  OpenURL('https://pt.wikipedia.org/wiki/Integra%C3%A7%C3%A3o_num%C3%A9rica');
end;

procedure TFormPrincipal.BotaoCalcularClick(Sender: TObject);
var
  i, q: integer;
  h, a, b, fx: extended;
  x, y: array[0..1000] of extended;
  f: string;
  erro: boolean;
begin
  erro := False;

  with StringGrid2 do
    for i := 1 to 6 do
      Cells[1, i] := '';

  Chart1LineSeries1.Clear;
  Chart1LineSeries2.Clear;
  Chart1AreaSeries1.Clear;

  if RadioButton1.Checked then
  begin
    with StringGrid1 do
    begin
      for i := 0 to n do
      begin
        try
          x[i] := StrToFloat(Cells[1, i + 1]);
        except
          MessageDlg('Erro', 'O valor de x[' + IntToStr(i) +
            '] é inválido, redigite...',
            mtError, [], 0);

          Row := i + 1;
          Col := 1;
          SetFocus;

          Exit;
        end;

        try
          y[i] := StrToFloat(Cells[2, i + 1]);
        except
          MessageDlg('Erro', 'O valor de y[' + IntToStr(i) +
            '] é inválido, redigite...',
            mtError, [], 0);

          Row := i + 1;
          Col := 2;
          SetFocus;

          Exit;
        end;
      end;
    end;

    if verificarEspacamento(x) <> 0 then
    begin
      MessageDlg('Erro',
        'O espaçamento dos valores de "x" não é constante, redigite...',
        mtError, [], 0);

      StringGrid1.Row := 1;
      StringGrid1.Col := 1;
      SetFocus;

      Exit;
    end;

    if verificarRepetidos(x) <> 0 then
    begin
      MessageDlg('Erro',
        'Existem valores repetidos de "x", redigite...',
        mtError, [], 0);

      StringGrid1.Row := 1;
      StringGrid1.Col := 1;
      SetFocus;

      Exit;
    end;

    ordenarValores(x, y);
    h := (x[n] - x[0]) / n;
  end
  else
  begin
    f := Trim(Edit1.Text);
    if f = '' then
    begin
      MessageDlg('Erro', 'A função digitada é inválida, redigite...',
        mtError, [], 0);

      Edit1.SetFocus;
      Exit;
    end;

    try
      a := StrToFloat(Edit2.Text);
    except
      MessageDlg('Erro', 'O valor de "a" é inválido, redigite...',
        mtError, [], 0);

      Edit2.SetFocus;
      Exit;
    end;

    try
      b := StrToFloat(Edit3.Text);
    except
      MessageDlg('Erro', 'O valor de "b" é inválido, redigite...',
        mtError, [], 0);

      Edit3.SetFocus;
      Exit;
    end;

    h := (b - a) / n;

    for i := 0 to n do
    begin
      x[i] := a + i * h;

      if FxR1(f, x[i], fx) <> 0 then
      begin
        MessageDlg('Erro', 'Erro ao avaliar a função no ponto x[' +
          IntToStr(i) + '] = ' + FloatToStr(x[i]) + ' (Método 1 - 5)',
          mtError, [], 0);

        erro := True;
        Break;
      end
      else
        y[i] := fx;

      if CheckBox1.Checked then
      begin
        StringGrid1.Cells[1, i + 1] := FloatToStr(x[i]);
        StringGrid1.Cells[2, i + 1] := FloatToStr(y[i]);
      end;
    end;
  end;

  with StringGrid2 do
  begin
    if erro = False then
    begin
      Cells[1, 1] := FloatToStr(RetangulosEsquerda(y, h));
      Cells[1, 2] := FloatToStr(RetangulosDireita(y, h));
      Cells[1, 3] := FloatToStr(RegraTrapezios(y, h));
      Cells[1, 4] := FloatToStr(UmTercoSimpson(y, h));
      Cells[1, 5] := FloatToStr(TresOitavosSimpson(y, h));

      for i := 0 to n do
      begin
        Chart1LineSeries1.AddXY(x[i], y[i]);
        Chart1LineSeries2.AddXY(x[i], y[i]);
        Chart1AreaSeries1.AddXY(x[i], y[i]);
      end;
    end
    else
    begin
      for i := 1 to 5 do
        Cells[1, i] := 'Exceção';
    end;

    if RadioButton1.Checked then
      Cells[1, 6] := 'Apenas com uso de "funções conhecidas"'
    else
    begin
      if C2.Checked then
        q := 2
      else if C4.Checked then
        q := 4
      else if C8.Checked then
        q := 8
      else if C16.Checked then
        q := 16
      else if C32.Checked then
        q := 32
      else if C64.Checked then
        q := 64
      else
        q := 100;

      if QuadraturaGauss(f, a, b, q, fx) <> 0 then
        Cells[1, 6] := 'Exceção'
      else
        Cells[1, 6] := FloatToStr(fx);
    end;
  end;
end;

// FUNÇÕES DE CÁLCULO

function TFormPrincipal.RetangulosEsquerda(y: array of extended; h: extended): extended;

var
  i: integer;
  soma: extended;
begin
  soma := 0;

  for i := 0 to n - 1 do
    soma := soma + y[i];

  Exit(soma * h);
end;

function TFormPrincipal.RetangulosDireita(y: array of extended; h: extended): extended;
var
  i: integer;
  soma: extended;
begin
  soma := 0;

  for i := 1 to n do
    soma := soma + y[i];

  Exit(soma * h);
end;

function TFormPrincipal.RegraTrapezios(y: array of extended; h: extended): extended;
var
  i: integer;
  soma: extended;
begin
  soma := 0;

  for i := 0 to n - 1 do
    soma := soma + (y[i] + y[i + 1]);

  Exit(soma * h / 2);
end;

function TFormPrincipal.UmTercoSimpson(y: array of extended; h: extended): extended;
var
  i: integer;
  A2, A4, integral: extended;
begin
  A2 := 0;
  A4 := 0;

  if (n mod 2) = 0 then
  begin
    for i := 1 to n - 1 do
    begin
      if (i mod 2) <> 0 then
        A4 := A4 + y[i]
      else
        A2 := A2 + y[i];
    end;

    integral := (y[0] + y[n] + A2 * 2 + A4 * 4) * h / 3;
  end
  else
  begin
    for i := 1 to n - 2 do
    begin
      if (i mod 2) <> 0 then
        A4 := A4 + y[i]
      else
        A2 := A2 + y[i];
    end;

    integral := ((y[0] + y[n - 1] + A2 * 2 + A4 * 4) * h / 3) +
      ((y[n - 1] + y[n]) * h / 2);
  end;

  Exit(integral);
end;

function TFormPrincipal.TresOitavosSimpson(y: array of extended; h: extended): extended;
var
  i, resto: integer;
  A2, A3, integral: extended;
begin
  A2 := 0;
  A3 := 0;

  resto := n mod 3;

  if resto = 0 then
  begin
    for i := 1 to n - 1 do
    begin
      if (i mod 3) <> 0 then
        A3 := A3 + y[i]
      else
        A2 := A2 + y[i];
    end;

    integral := (y[0] + y[n] + A2 * 2 + A3 * 3) * h * 3 / 8;
  end
  else if resto = 1 then
  begin
    for i := 1 to n - 2 do
    begin
      if (i mod 3) <> 0 then
        A3 := A3 + y[i]
      else
        A2 := A2 + y[i];
    end;

    integral := ((y[0] + y[n - 1] + A2 * 2 + A3 * 3) * h * 3 / 8) +
      ((y[n - 1] + y[n]) * h / 2);
  end
  else
  begin
    for i := 1 to n - 3 do
    begin
      if (i mod 3) <> 0 then
        A3 := A3 + y[i]
      else
        A2 := A2 + y[i];
    end;

    integral := ((y[0] + y[n - 2] + A2 * 2 + A3 * 3) * h * 3 / 8) +
      ((y[n - 2] + y[n] + y[n - 1] * 4) * h / 3);
  end;

  Exit(integral);
end;

function TFormPrincipal.QuadraturaGauss(f: string; a, b: extended;
  q: integer; var integral: extended): word;
var
  i: integer;
  w, t: array of extended;
  x, fx, soma: extended;
begin
  SetLength(w, q);
  SetLength(t, q);
  GaussLegendre(-1.0, 1.0, w, t, q);

  soma := 0;

  for i := 0 to q - 1 do
  begin
    x := (a * (1 - t[i]) + b * (1 + t[i])) / 2;

    if FxR1(f, x, fx) <> 0 then
    begin
      MessageDlg('Erro', 'Erro ao avaliar a função no ponto x[' +
        IntToStr(i) + '] = ' + FloatToStr(x) + ' (Método 6)',
        mtError, [], 0);
      Exit(1);
    end;

    soma := soma + w[i] * fx;
  end;

  integral := (b - a) * soma / 2;

  Exit(0);
end;

end.
