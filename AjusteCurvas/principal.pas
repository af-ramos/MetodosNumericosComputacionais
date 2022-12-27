unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  Spin, Grids, ExtCtrls, CheckLst, TAGraph, TASeries, TARadialSeries, lclintf,
  Menus, Math;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    Chart1: TChart;
    C0: TCheckBox;
    C1: TCheckBox;
    C2: TCheckBox;
    C3: TCheckBox;
    C4: TCheckBox;
    C5: TCheckBox;
    Chart1LineSeries0: TLineSeries;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries10: TLineSeries;
    Chart1LineSeries11: TLineSeries;
    Chart1LineSeries12: TLineSeries;
    Chart1LineSeries13: TLineSeries;
    Chart1LineSeries14: TLineSeries;
    Chart1LineSeries15: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart1LineSeries5: TLineSeries;
    Chart1LineSeries6: TLineSeries;
    Chart1LineSeries7: TLineSeries;
    Chart1LineSeries8: TLineSeries;
    Chart1LineSeries9: TLineSeries;
    CheckListBox1: TCheckListBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    BotaoNovo: TSpeedButton;
    BotaoAjuda: TSpeedButton;
    BotaoAbrir: TSpeedButton;
    BotaoSalvar: TSpeedButton;
    BotaoGraficoPolinomio: TSpeedButton;
    BotaoCalculoPolinomio: TSpeedButton;
    BotaoCalculoCurvas: TSpeedButton;
    BotaoGraficoCurvas: TSpeedButton;
    BotaoCalculadora: TSpeedButton;
    BotaoCheckbox: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure BotaoAbrirClick(Sender: TObject);
    procedure BotaoAjudaClick(Sender: TObject);
    procedure BotaoCalculadoraClick(Sender: TObject);
    procedure BotaoCalculoCurvasClick(Sender: TObject);
    procedure BotaoCalculoPolinomioClick(Sender: TObject);
    procedure BotaoCheckboxClick(Sender: TObject);
    procedure BotaoGraficoCurvasClick(Sender: TObject);
    procedure BotaoGraficoPolinomioClick(Sender: TObject);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure C0Click(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MontarGradeDados;
    procedure SpinEdit1EditingDone(Sender: TObject);
    procedure AlterarCheckbox(const Checkbox: TCheckBox; const Check: boolean);
    procedure ResolverPolinomio(m: integer; x, y: array of real);
    procedure LimparGrafico;
    procedure DesenharPolinomio(SerieDados: TLineSeries; m: integer; x: array of real);
    function ResolverAjuste(x, y: array of real; var v: array of real): word;
    function lerDados(var x, y: array of real): word;
    procedure Ajuste1(x, y: array of real);
    procedure Ajuste2(x, y: array of real);
    procedure Ajuste3(x, y: array of real);
    procedure Ajuste4(x, y: array of real);
    procedure Ajuste5(x, y: array of real);
    procedure Ajuste6(x, y: array of real);
    procedure Ajuste7(x, y: array of real);
    procedure Ajuste8(x, y: array of real);
    procedure Ajuste9(x, y: array of real);
    procedure Ajuste10(x, y: array of real);
    procedure Ajuste11(x, y: array of real);
    procedure Ajuste12(x, y: array of real);
    procedure Ajuste13(x, y: array of real);
    procedure Ajuste14(x, y: array of real);
    procedure Ajuste15(x, y: array of real);
  private

  public

  end;

var
  FormPrincipal: TFormPrincipal;
  n: integer;

implementation

{$R *.lfm}

{ TFormPrincipal }

// FUNÇÕES AUXILIARES

procedure TFormPrincipal.SpinEdit1EditingDone(Sender: TObject);
begin
  n := SpinEdit1.Value;
  MontarGradeDados;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var
  i: integer;
begin
  BotaoNovo.Click;

  with StringGrid1 do
  begin
    ColWidths[0] := 25;

    Cells[0, 0] := 'i';
    Cells[1, 0] := 'x[i]';
    Cells[2, 0] := 'y[i]';
  end;

  with StringGrid2 do
  begin
    ColWidths[0] := 66;
    ColWidths[1] := 41;
    ColWidths[2] := 25;

    Cells[0, 0] := 'Polinômio';
    for i := 1 to 5 do
      Cells[0, i] := IntToStr(i);

    Cells[1, 0] := 'Grau';
    for i := 1 to 5 do
      Cells[1, i] := IntToStr(i + 1);

    for i := 0 to 6 do
      Cells[i + 3, 0] := 'a[' + IntToStr(i) + ']';
    Cells[10, 0] := 'R2';
  end;

  with StringGrid3 do
  begin
    ColWidths[0] := 115;

    Cells[0, 0] := 'Equação';
    Cells[0, 1] := 'y = a+b.x';
    Cells[0, 2] := 'y = a.e^(b.x)';
    Cells[0, 3] := 'y = 1/(1+e^(a+b.x))';
    Cells[0, 4] := 'y = a/(b+x)';
    Cells[0, 5] := 'y = a.b^x';
    Cells[0, 6] := 'y = e^(a+b.x)';
    Cells[0, 7] := 'y = 1+a.e^(b.x)';
    Cells[0, 8] := 'y = a.b/(b+x)';
    Cells[0, 9] := 'y = a.x^b';
    Cells[0, 10] := 'y = 1/(a+b.x)';
    Cells[0, 11] := 'y = a+b.ln(x)';
    Cells[0, 12] := 'y = a.x/(b+x)';
    Cells[0, 13] := 'y = a.b^(e.x)';
    Cells[0, 14] := 'y = x/(a+b.x)';
    Cells[0, 15] := 'y = a+b/x';

    Cells[1, 0] := 'a';
    Cells[2, 0] := 'b';
    Cells[3, 0] := 'R2';
  end;
end;

procedure TFormPrincipal.AlterarCheckBox(const CheckBox: TCheckBox;
  const Check: boolean);
var
  onClickHandler: TNotifyEvent;
begin
  with CheckBox do
  begin
    onClickHandler := onClick;
    onClick := nil;
    Checked := Check;
    onClick := onClickHandler;
  end;
end;

procedure TFormPrincipal.C0Click(Sender: TObject);
begin
  if not C0.Checked then
  begin
    AlterarCheckBox(C1, False);
    AlterarCheckBox(C2, False);
    AlterarCheckBox(C3, False);
    AlterarCheckBox(C4, False);
    AlterarCheckBox(C5, False);
  end
  else
  begin
    AlterarCheckBox(C1, True);
    AlterarCheckBox(C2, True);
    AlterarCheckBox(C3, True);
    AlterarCheckBox(C4, True);
    AlterarCheckBox(C5, True);
  end;
end;

procedure TFormPrincipal.CheckBoxClick(Sender: TObject);
begin
  if not TCheckBox(Sender).Checked then
    AlterarCheckBox(C0, False);
  if C1.Checked and C2.Checked and C3.Checked and C4.Checked and C5.Checked then
    AlterarCheckBox(C0, True);
end;

procedure TFormPrincipal.MontarGradeDados;
var
  i: integer;
begin
  StringGrid1.RowCount := n + 1;
  for i := 1 to n do
    StringGrid1.Cells[0, i] := IntToStr(i);

  StringGrid1.SetFocus;
  StringGrid1.Refresh;
end;

procedure TFormPrincipal.LimparGrafico;
begin
  Chart1LineSeries0.Clear;
  Chart1LineSeries1.Clear;
  Chart1LineSeries2.Clear;
  Chart1LineSeries3.Clear;
  Chart1LineSeries4.Clear;
  Chart1LineSeries5.Clear;
  Chart1LineSeries6.Clear;
  Chart1LineSeries7.Clear;
  Chart1LineSeries8.Clear;
  Chart1LineSeries9.Clear;
  Chart1LineSeries10.Clear;
  Chart1LineSeries11.Clear;
  Chart1LineSeries12.Clear;
  Chart1LineSeries13.Clear;
  Chart1LineSeries14.Clear;
  Chart1LineSeries15.Clear;

  Chart1LineSeries1.Legend.Visible := False;
  Chart1LineSeries2.Legend.Visible := False;
  Chart1LineSeries3.Legend.Visible := False;
  Chart1LineSeries4.Legend.Visible := False;
  Chart1LineSeries5.Legend.Visible := False;
  Chart1LineSeries6.Legend.Visible := False;
  Chart1LineSeries7.Legend.Visible := False;
  Chart1LineSeries8.Legend.Visible := False;
  Chart1LineSeries9.Legend.Visible := False;
  Chart1LineSeries10.Legend.Visible := False;
  Chart1LineSeries11.Legend.Visible := False;
  Chart1LineSeries12.Legend.Visible := False;
  Chart1LineSeries13.Legend.Visible := False;
  Chart1LineSeries14.Legend.Visible := False;
  Chart1LineSeries15.Legend.Visible := False;
end;

function TFormPrincipal.lerDados(var x, y: array of real): word;
var
  i, j: integer;
begin
  for i := 1 to n do
  begin
    try
      x[i - 1] := StrToFloat(StringGrid1.Cells[1, i]);
    except
      MessageDlg('Valor inválido',
        'O valor de x[' + IntToStr(i) + '] digitado é inválido!',
        mtError, [], 0);

      StringGrid1.Col := 1;
      StringGrid1.Row := i;
      StringGrid1.SetFocus;

      Exit(1);
    end;

    try
      y[i - 1] := StrToFloat(StringGrid1.Cells[2, i]);
    except
      MessageDlg('Valor inválido',
        'O valor de y[' + IntToStr(i) + '] digitado é inválido!',
        mtError, [], 0);

      StringGrid1.Col := 2;
      StringGrid1.Row := i;
      StringGrid1.SetFocus;

      Exit(1);
    end;
  end;

  for i := 0 to n - 2 do
  begin
    for j := i + 1 to n - 1 do
    begin
      if x[i] = x[j] then
      begin
        MessageDlg('Existem valores repetidos na tabela de dados!', mtError, [], 0);

        StringGrid1.Col := 1;
        StringGrid1.Row := j + 1;
        StringGrid1.SetFocus;

        Exit(1);
      end;
    end;
  end;

  Exit(0);
end;

// FUNÇÕES DE BOTÃO

procedure TFormPrincipal.BotaoCalculadoraClick(Sender: TObject);
begin
  OpenDocument('Calc.exe');
end;

procedure TFormPrincipal.BotaoAjudaClick(Sender: TObject);
begin
  MessageDlg('"Menu" de Ajuda',
    'Eu confio que o usuário saiba o suficiente sobre Ajustes de Curvas para realreender sozinho o programa.'
    + #13#10#13#10 +
    'Caso mesmo assim tenha dúvidas, segue um site que pode te ajudar (ou atrapalhar).',
    mtInformation, [], 0);
  OpenURL('https://pt.wikipedia.org/wiki/Ajuste_de_curvas');
end;

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

      SpinEdit1.Value := qtdLinhas;
      SpinEdit1.EditingDone;

      for i := 1 to qtdLinhas do
      begin
        Readln(f, strTemp);
        arrayTemp := strTemp.Split(' ');

        Cells[1, i] := arrayTemp[0];
        Cells[2, i] := arrayTemp[1];
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

      for i := 1 to n do
        Writeln(f, Cells[1, i] + ' ' + Cells[2, i]);
    end;

    CloseFile(f);
  end;
end;

procedure TFormPrincipal.BotaoCheckboxClick(Sender: TObject);
var
  i, k: integer;
begin
  k := 0;
  for i := 0 to CheckListBox1.Count - 1 do
    if CheckListBox1.Checked[i] then
      k := k + 1;

  for i := 0 to CheckListBox1.Count - 1 do
    if k = CheckListBox1.Count then
      CheckListBox1.Checked[i] := False
    else
      CheckListBox1.Checked[i] := True;
end;

procedure TFormPrincipal.BotaoNovoClick(Sender: TObject);
var
  i, j: integer;
begin
  LimparGrafico;

  SpinEdit1.Value := 2;
  SpinEdit1.EditingDone;

  for i := 1 to n do
    for j := 1 to n do
      StringGrid1.Cells[j, i] := '';

  StringGrid1.Row := 1;
  StringGrid1.Col := 1;
  StringGrid1.SetFocus;

  C0.Checked := True;
  C0.Checked := False;

  for i := 1 to 5 do
    for j := 3 to 10 do
      StringGrid2.Cells[j, i] := '';

  for i := 0 to CheckListBox1.Count - 1 do
    CheckListBox1.Checked[i] := False;

  for i := 1 to 15 do
    for j := 1 to 3 do
      StringGrid3.Cells[j, i] := '';
end;

procedure TFormPrincipal.BotaoCalculoPolinomioClick(Sender: TObject);
var
  x, y: array[0..100] of real;
  i, j: integer;
begin
  for i := 1 to 5 do
    for j := 3 to 10 do
      StringGrid2.Cells[j, i] := '';

  if lerDados(x, y) <> 0 then
    Exit;

  if C1.Checked then
    ResolverPolinomio(3, x, y);
  if C2.Checked then
    ResolverPolinomio(4, x, y);
  if C3.Checked then
    ResolverPolinomio(5, x, y);
  if C4.Checked then
    ResolverPolinomio(6, x, y);
  if C5.Checked then
    ResolverPolinomio(7, x, y);
end;

procedure TFormPrincipal.BotaoGraficoPolinomioClick(Sender: TObject);
var
  i: integer;
  x, y: array [0..100] of real;
begin
  LimparGrafico;

  if lerDados(x, y) <> 0 then
    Exit;

  for i := 0 to n - 1 do
    Chart1LineSeries0.AddXY(x[i], y[i]);

  if (C1.Checked) and (StringGrid2.Cells[3, 1] <> '') and (StringGrid2.Cells[3, 1] <> 'Exceção') then
    DesenharPolinomio(Chart1LineSeries1, 3, x);
  if (C2.Checked) and (StringGrid2.Cells[3, 2] <> '') and (StringGrid2.Cells[3, 2] <> 'Exceção') then
    DesenharPolinomio(Chart1LineSeries2, 4, x);
  if (C3.Checked) and (StringGrid2.Cells[3, 3] <> '') and (StringGrid2.Cells[3, 3] <> 'Exceção') then
    DesenharPolinomio(Chart1LineSeries3, 5, x);
  if (C4.Checked) and (StringGrid2.Cells[3, 4] <> '') and (StringGrid2.Cells[3, 4] <> 'Exceção') then
    DesenharPolinomio(Chart1LineSeries4, 6, x);
  if (C5.Checked) and (StringGrid2.Cells[3, 5] <> '') and (StringGrid2.Cells[3, 5] <> 'Exceção') then
    DesenharPolinomio(Chart1LineSeries5, 7, x);
end;

procedure TFormPrincipal.BotaoCalculoCurvasClick(Sender: TObject);
var
  i, j: integer;
  x, y: array[0..100] of real;
begin
  for i := 1 to 15 do
    for j := 1 to 3 do
      StringGrid3.Cells[j, i] := '';

  if lerDados(x, y) <> 0 then
    Exit;

  if CheckListBox1.Checked[0] then
    Ajuste1(x, y);
  if CheckListBox1.Checked[1] then
    Ajuste2(x, y);
  if CheckListBox1.Checked[2] then
    Ajuste3(x, y);
  if CheckListBox1.Checked[3] then
    Ajuste4(x, y);
  if CheckListBox1.Checked[4] then
    Ajuste5(x, y);
  if CheckListBox1.Checked[5] then
    Ajuste6(x, y);
  if CheckListBox1.Checked[6] then
    Ajuste7(x, y);
  if CheckListBox1.Checked[7] then
    Ajuste8(x, y);
  if CheckListBox1.Checked[8] then
    Ajuste9(x, y);
  if CheckListBox1.Checked[9] then
    Ajuste10(x, y);
  if CheckListBox1.Checked[10] then
    Ajuste11(x, y);
  if CheckListBox1.Checked[11] then
    Ajuste12(x, y);
  if CheckListBox1.Checked[12] then
    Ajuste13(x, y);
  if CheckListBox1.Checked[13] then
    Ajuste14(x, y);
  if CheckListBox1.Checked[14] then
    Ajuste15(x, y);
end;

procedure TFormPrincipal.BotaoGraficoCurvasClick(Sender: TObject);
var
  i: integer;
  x, y: array[0..100] of real;
  xMin, xMax, deltaX, a, b, xNovo, yNovo: real;
begin
  LimparGrafico;

  if lerDados(x, y) <> 0 then
    Exit;

  for i := 0 to n - 1 do
    Chart1LineSeries0.AddXY(x[i], y[i]);

  xMin := x[0];
  xMax := x[0];

  for i := 0 to n - 1 do
  begin
    if x[i] < xMin then
      xMin := x[i];
    if x[i] > xMax then
      xMax := x[i];
  end;

  deltaX := (xMax - xMin) / 100;

  if (CheckListBox1.Checked[0]) and (StringGrid3.Cells[1, 1] <> '') and (StringGrid3.Cells[1, 1] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 1]);
    b := StrToFloat(StringGrid3.Cells[2, 1]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a + b * xNovo;

      Chart1LineSeries1.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries1.Legend.Visible := True;
    Chart1LineSeries1.Title := 'y = a+b.x';
  end;

  if (CheckListBox1.Checked[1]) and (StringGrid3.Cells[1, 2] <> '') and (StringGrid3.Cells[1, 2] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 2]);
    b := StrToFloat(StringGrid3.Cells[2, 2]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a * Exp(b * xNovo);

      Chart1LineSeries2.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries2.Legend.Visible := True;
    Chart1LineSeries2.Title := 'y = a.e^(b.x)';
  end;

  if (CheckListBox1.Checked[2]) and (StringGrid3.Cells[1, 3] <> '') and (StringGrid3.Cells[1, 3] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 3]);
    b := StrToFloat(StringGrid3.Cells[2, 3]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := 1 / (1 + Exp(a + b * xNovo));

      Chart1LineSeries3.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries3.Legend.Visible := True;
    Chart1LineSeries3.Title := 'y = 1/(1+e^(a+b.x))';
  end;

  if (CheckListBox1.Checked[3]) and (StringGrid3.Cells[1, 4] <> '') and (StringGrid3.Cells[1, 4] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 4]);
    b := StrToFloat(StringGrid3.Cells[2, 4]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a / (b + xNovo);

      Chart1LineSeries4.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries4.Legend.Visible := True;
    Chart1LineSeries4.Title := 'y = a/(b+x)';
  end;

  if (CheckListBox1.Checked[4]) and (StringGrid3.Cells[1, 5] <> '') and (StringGrid3.Cells[1, 5] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 5]);
    b := StrToFloat(StringGrid3.Cells[2, 5]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a * Power(b, xNovo);

      Chart1LineSeries5.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries5.Legend.Visible := True;
    Chart1LineSeries5.Title := 'y = a.b^x';
  end;

  if (CheckListBox1.Checked[5]) and (StringGrid3.Cells[1, 6] <> '') and (StringGrid3.Cells[1, 6] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 6]);
    b := StrToFloat(StringGrid3.Cells[2, 6]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := Exp(a + b * xNovo);

      Chart1LineSeries6.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries6.Legend.Visible := True;
    Chart1LineSeries6.Title := 'y = e^(a+b.x)';
  end;

  if (CheckListBox1.Checked[6]) and (StringGrid3.Cells[1, 7] <> '') and (StringGrid3.Cells[1, 7] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 7]);
    b := StrToFloat(StringGrid3.Cells[2, 7]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := 1 + a * Exp(b * xNovo);

      Chart1LineSeries7.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries7.Legend.Visible := True;
    Chart1LineSeries7.Title := 'y = 1+a.e^(b.x)';
  end;

  if (CheckListBox1.Checked[7]) and (StringGrid3.Cells[1, 8] <> '') and (StringGrid3.Cells[1, 8] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 8]);
    b := StrToFloat(StringGrid3.Cells[2, 8]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := (a * b) / (b + xNovo);

      Chart1LineSeries8.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries8.Legend.Visible := True;
    Chart1LineSeries8.Title := 'y = a.b/(b+x)';
  end;

  if (CheckListBox1.Checked[8]) and (StringGrid3.Cells[1, 9] <> '') and (StringGrid3.Cells[1, 9] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 9]);
    b := StrToFloat(StringGrid3.Cells[2, 9]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a * Power(xNovo, b);

      Chart1LineSeries9.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries9.Legend.Visible := True;
    Chart1LineSeries9.Title := 'y = a.x^b';
  end;

  if (CheckListBox1.Checked[9]) and (StringGrid3.Cells[1, 10] <> '') and (StringGrid3.Cells[1, 10] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 10]);
    b := StrToFloat(StringGrid3.Cells[2, 10]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := 1 / (a + b * xNovo);

      Chart1LineSeries10.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries10.Legend.Visible := True;
    Chart1LineSeries10.Title := 'y = 1/(a+b.x)';
  end;

  if (CheckListBox1.Checked[10]) and (StringGrid3.Cells[1, 11] <> '') and (StringGrid3.Cells[1, 11] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 11]);
    b := StrToFloat(StringGrid3.Cells[2, 11]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a + b * Ln(xNovo);

      Chart1LineSeries11.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries11.Legend.Visible := True;
    Chart1LineSeries11.Title := 'y = a+b.ln(x)';
  end;

  if (CheckListBox1.Checked[11]) and (StringGrid3.Cells[1, 12] <> '') and (StringGrid3.Cells[1, 12] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 12]);
    b := StrToFloat(StringGrid3.Cells[2, 12]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := (a * xNovo) / (b + xNovo);

      Chart1LineSeries12.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries12.Legend.Visible := True;
    Chart1LineSeries12.Title := 'y = a.x/(b+x)';
  end;

  if (CheckListBox1.Checked[12]) and (StringGrid3.Cells[1, 13] <> '') and (StringGrid3.Cells[1, 13] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 13]);
    b := StrToFloat(StringGrid3.Cells[2, 13]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a * Power(b, 2.7182818 * xNovo);

      Chart1LineSeries13.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries13.Legend.Visible := True;
    Chart1LineSeries13.Title := 'y = a.b^(e.x)';
  end;

  if (CheckListBox1.Checked[13]) and (StringGrid3.Cells[1, 14] <> '') and (StringGrid3.Cells[1, 14] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 14]);
    b := StrToFloat(StringGrid3.Cells[2, 14]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := xNovo / (a + b * xNovo);

      Chart1LineSeries14.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries14.Legend.Visible := True;
    Chart1LineSeries14.Title := 'y = x/(a+b.x)';
  end;

  if (CheckListBox1.Checked[14]) and (StringGrid3.Cells[1, 15] <> '') and (StringGrid3.Cells[1, 15] <> 'Exceção') then
  begin
    a := StrToFloat(StringGrid3.Cells[1, 15]);
    b := StrToFloat(StringGrid3.Cells[2, 15]);

    for i := 0 to 100 do
    begin
      xNovo := xMin + i * deltaX;
      yNovo := a + b / xNovo;

      Chart1LineSeries15.AddXY(xNovo, yNovo);
    end;

    Chart1LineSeries15.Legend.Visible := True;
    Chart1LineSeries15.Title := 'y = a+b/x';
  end;
end;

// CÁLCULOS

procedure TFormPrincipal.ResolverPolinomio(m: integer; x, y: array of real);
var
  i, j, k: integer;
  soma, somaY, somaY2, somaErro, yAjuste, R2, c: real;
  A: array[0..6, 0..6] of real;
  b, v: array[0..6] of real;
begin
  // CRIAR MATRIZ E VETORES

  A[0, 0] := n;
  for i := 1 to m - 1 do
  begin
    soma := 0;

    for j := 0 to n - 1 do
      soma := soma + Power(x[j], i);
    A[0, i] := soma;
  end;

  for i := 1 to m - 1 do
  begin
    for j := 0 to m - 1 do
    begin
      soma := 0;

      for k := 0 to n - 1 do
        soma := soma + Power(x[k], i + j);
      A[i, j] := soma;
    end;
  end;

  for i := 0 to m - 1 do
  begin
    soma := 0;

    for j := 0 to n - 1 do
      soma := soma + Power(x[j], i) * y[j];
    b[i] := soma;
  end;

  // RESOLVER SISTEMA LINEAR (GAUSS)

  for j := 0 to m - 2 do
  begin
    for i := j + 1 to m - 1 do
    begin
      try
        c := A[i, j] / A[j, j];

        if IsNan(c) or IsInfinite(c) then
        begin
          StringGrid2.Cells[3, m - 2] := 'Exceção';
          Exit;
        end;
      except
        StringGrid2.Cells[3, m - 2] := 'Exceção';
        Exit;
      end;

      for k := j to m - 1 do
        A[i, k] := A[i, k] - c * A[j, k];
      b[i] := b[i] - c * b[j];
    end;
  end;

  try
    v[m - 1] := b[m - 1] / A[m - 1, m - 1];

    if IsNan(v[m - 1]) or IsInfinite(v[m - 1]) then
    begin
      StringGrid2.Cells[3, m - 2] := 'Exceção';
      Exit;
    end;
  except
    StringGrid2.Cells[3, m - 2] := 'Exceção';
    Exit;
  end;

  for i := m - 2 downto 0 do
  begin
    soma := 0;

    for j := i + 1 to m - 1 do
      soma := soma + A[i, j] * v[j];
    v[i] := (b[i] - soma) / A[i, i];
  end;

  // RETORNAR OS COEFICIENTES PARA A GRADE

  for i := 0 to m - 1 do
    StringGrid2.Cells[i + 3, m - 2] := FloatToStr(v[i]);

  // RETORNAR O COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
  begin
    yAjuste := 0;
    for j := 0 to m - 1 do
      yAjuste := yAjuste + v[j] * Power(x[i], j);

    somaErro := somaErro + Sqr(y[i] - yAjuste);
  end;

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid2.Cells[10, m - 2] := FloatToStr(R2);
end;

procedure TFormPrincipal.DesenharPolinomio(SerieDados: TLineSeries;
  m: integer; x: array of real);
var
  i, j: integer;
  xMax, xMin, deltaX, xNovo, yNovo, cAjuste: real;
begin
  xMax := x[0];
  xMin := x[0];

  for i := 0 to n - 1 do
  begin
    if x[i] > xMax then
      xMax := x[i];
    if x[i] < xMin then
      xMin := x[i];
  end;

  deltaX := (xMax - xMin) / 100;

  for i := 0 to 100 do
  begin
    xNovo := xMin + i * deltaX;

    yNovo := 0;
    for j := 0 to m - 1 do
    begin
      cAjuste := StrToFloat(StringGrid2.Cells[j + 3, m - 2]);
      yNovo := yNovo + cAjuste * Power(xNovo, j);
    end;

    SerieDados.AddXY(xNovo, yNovo);
  end;

  SerieDados.Legend.Visible := True;
  SerieDados.Title := 'p' + IntToStr(m - 1) + '(x)';
end;

function TFormPrincipal.ResolverAjuste(x, y: array of real; var v: array of real): word;
var
  i: integer;
  somaUm, somaDois, somaY, somaXY, c: real;
  A: array[0..1, 0..1] of real;
  b: array[0..1] of real;
begin
  // GERAR MATRIZ E VETORES

  somaUm := 0;
  somaDois := 0;
  somaY := 0;
  somaXY := 0;

  for i := 0 to n - 1 do
  begin
    somaUm := somaUm + x[i];
    somaDois := somaDois + Sqr(x[i]);

    somaY := somaY + y[i];
    somaXY := somaXY + x[i] * y[i];
  end;

  A[0, 0] := n;
  A[0, 1] := somaUm;
  A[1, 0] := somaUm;
  A[1, 1] := somaDois;

  b[0] := somaY;
  b[1] := somaXY;

  // RESOLVER SISTEMA LINEAR (GAUSS)

  try
    c := A[1, 0] / A[0, 0];
  except
    Exit(1);
  end;

  for i := 0 to 1 do
    A[1, i] := A[1, i] - c * A[0, i];
  b[1] := b[1] - c * b[0];

  try
    v[1] := b[1] / A[1, 1];
  except
    Exit(1);
  end;

  v[0] := (b[0] - v[1] * A[0, 1]) / A[0, 0];

  Exit(0);
end;

procedure TFormPrincipal.Ajuste1(x, y: array of real);
var
  i: integer;
  R2, somaY, somaY2, somaErro: real;
  v: array[0..1] of real;
begin
  v[0] := 0;
  v[1] := 0;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, y, v) <> 0 then
  begin
    StringGrid3.Cells[1, 1] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 1] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 1] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] + v[1] * x[i]));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 1] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste2(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(y[i]);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 2] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 2] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 2] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  v[0] := Exp(v[0]);

  StringGrid3.Cells[1, 2] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 2] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] * Exp(v[1] * x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 2] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste3(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(1 / y[i] - 1);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 3] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 3] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 3] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 3] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 3] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (1 / (1 + Exp(v[0] + v[1] * x[i]))));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 3] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste4(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  AAux, somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := 1 / y[i];

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 4] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 4] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 4] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  AAux := v[0];
  try
    v[0] := 1 / v[1];

    if IsNan(v[0]) or IsInfinite(v[0]) then
    begin
      StringGrid3.Cells[1, 4] := 'Exceção';
      Exit;
    end;
  except
    StringGrid3.Cells[1, 4] := 'Exceção';
    Exit;
  end;
  v[1] := v[0] * AAux;

  StringGrid3.Cells[1, 4] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 4] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] / (v[1] + x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 4] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste5(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(y[i]);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 5] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 5] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 5] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  v[0] := Exp(v[0]);
  v[1] := Exp(v[1]);

  StringGrid3.Cells[1, 5] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 5] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] * Power(v[1], x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 5] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste6(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(y[i]);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 6] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 6] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 6] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 6] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 6] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (Exp(v[0] + v[1] * x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 6] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste7(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(y[i] - 1);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 7] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 7] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 7] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  v[0] := Exp(v[0]);

  StringGrid3.Cells[1, 7] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 7] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (1 + v[0] * Exp(v[1] * x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 7] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste8(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := 1 / y[i];

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 8] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 8] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 8] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  try
    v[0] := 1 / v[0];

    if IsNan(v[0]) or IsInfinite(v[0]) then
    begin
      StringGrid3.Cells[1, 8] := 'Exceção';
      Exit;
    end;
  except
    StringGrid3.Cells[1, 8] := 'Exceção';
    Exit;
  end;

  try
    v[1] := 1 / (v[0] * v[1]);

    if IsNan(v[1]) or IsInfinite(v[1]) then
    begin
      StringGrid3.Cells[1, 8] := 'Exceção';
      Exit;
    end;
  except
    StringGrid3.Cells[1, 8] := 'Exceção';
    Exit;
  end;

  StringGrid3.Cells[1, 8] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 8] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - ((v[0] * v[1]) / (v[1] + x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 8] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste9(x, y: array of real);
var
  i: integer;
  yAlterado, xAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(y[i]);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 9] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 9] := 'Exceção';
      Exit;
    end;

    try
      xAlterado[i] := Ln(x[i]);

      if IsNan(xAlterado[i]) or IsInfinite(xAlterado[i]) then
      begin
        StringGrid3.Cells[1, 9] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 9] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(xAlterado, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 9] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  v[0] := Exp(v[0]);

  StringGrid3.Cells[1, 9] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 9] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] * Power(x[i], v[1])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 9] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste10(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := 1 / y[i];

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 10] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 10] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 10] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 10] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 10] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (1 / (v[0] + v[1] * x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 10] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste11(x, y: array of real);
var
  i: integer;
  xAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      xAlterado[i] := Ln(x[i]);

      if IsNan(xAlterado[i]) or IsInfinite(xAlterado[i]) then
      begin
        StringGrid3.Cells[1, 11] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 11] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(xAlterado, y, v) <> 0 then
  begin
    StringGrid3.Cells[1, 11] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 11] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 11] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] + v[1] * Ln(x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 11] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste12(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  AAux, somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := x[i] / y[i];

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 12] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 12] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 12] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  AAux := v[0];
  try
    v[0] := 1 / v[1];

    if IsNan(v[0]) or IsInfinite(v[0]) then
    begin
      StringGrid3.Cells[1, 12] := 'Exceção';
      Exit;
    end;
  except
    StringGrid3.Cells[1, 12] := 'Exceção';
    Exit;
  end;
  v[1] := v[0] * AAux;

  StringGrid3.Cells[1, 12] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 12] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - ((v[0] * x[i]) / (v[1] + x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 12] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste13(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := Ln(y[i]);

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 13] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 13] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 13] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  v[0] := Exp(v[0]);
  v[1] := Exp(v[1] / 2.7182818);

  StringGrid3.Cells[1, 13] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 13] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] * Power(v[1], 2.7182818 * x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 13] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste14(x, y: array of real);
var
  i: integer;
  yAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      yAlterado[i] := x[i] / y[i];

      if IsNan(yAlterado[i]) or IsInfinite(yAlterado[i]) then
      begin
        StringGrid3.Cells[1, 14] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 14] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(x, yAlterado, v) <> 0 then
  begin
    StringGrid3.Cells[1, 14] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 14] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 14] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (x[i] / (v[0] + v[1] * x[i])));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 14] := FloatToStr(R2);
end;

procedure TFormPrincipal.Ajuste15(x, y: array of real);
var
  i: integer;
  xAlterado: array[0..100] of real;
  v: array[0..1] of real;
  somaY, somaY2, somaErro, R2: real;
begin
  v[0] := 0;
  v[1] := 0;

  for i := 0 to n - 1 do
  begin
    try
      xAlterado[i] := 1 / x[i];

      if IsNan(xAlterado[i]) or IsInfinite(xAlterado[i]) then
      begin
        StringGrid3.Cells[1, 15] := 'Exceção';
        Exit;
      end;
    except
      StringGrid3.Cells[1, 15] := 'Exceção';
      Exit;
    end;
  end;

  // GERAR MATRIZ/VETORES E RESOLVER SISTEMA

  if ResolverAjuste(xAlterado, y, v) <> 0 then
  begin
    StringGrid3.Cells[1, 15] := 'Exceção';
    Exit;
  end;

  // RETORNAR COEFICIENTES DA FUNÇÃO

  StringGrid3.Cells[1, 15] := FloatToStr(v[0]);
  StringGrid3.Cells[2, 15] := FloatToStr(v[1]);

  // RETORNAR COEFICIENTE DE DETERMINAÇÃO

  somaY := 0;
  somaY2 := 0;
  for i := 0 to n - 1 do
  begin
    somaY := somaY + y[i];
    somaY2 := somaY2 + Sqr(y[i]);
  end;

  somaErro := 0;
  for i := 0 to n - 1 do
    somaErro := somaErro + Sqr(y[i] - (v[0] + v[1] / x[i]));

  R2 := 1 - (n * somaErro) / (n * somaY2 - Sqr(somaY));
  StringGrid3.Cells[3, 15] := FloatToStr(R2);
end;

end.
