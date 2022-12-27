unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  Buttons, ExtCtrls, Windows, Grafico;

type

  { TFormCalculo }

  TFormCalculo = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PararBusca: TSpeedButton;
    MostrarGraficoUm: TSpeedButton;
    IniciarBusca: TSpeedButton;
    LimparDadosUm: TSpeedButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    LimparDadosDois: TSpeedButton;
    IniciarCalculo: TSpeedButton;
    MostrarAjuda: TSpeedButton;
    PararCalculo: TSpeedButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure HabilitarBusca;
    procedure DesabilitarBusca;
    procedure HabilitarCalculo;
    procedure DesabilitarCalculo;
    procedure BuscaUniforme;
    procedure DivisaoMeio;
    procedure Edit1Change(Sender: TObject);
    procedure MostrarAjudaClick(Sender: TObject);
    procedure Newton;
    procedure NewtonAdaptado;
    procedure Cordas;
    procedure CordasAdaptado;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure Edit5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IniciarBuscaClick(Sender: TObject);
    procedure IniciarCalculoClick(Sender: TObject);
    procedure LimparDadosDoisClick(Sender: TObject);
    procedure LimparDadosUmClick(Sender: TObject);
    procedure MostrarGraficoUmClick(Sender: TObject);
    procedure PararBuscaClick(Sender: TObject);
    procedure PararCalculoClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private

  public

  end;

var
  FormCalculo: TFormCalculo;
  interromper, todasRaizes, mostrarIteracoes, mostrarGrafico: boolean;
  metodo, coluna, qtdIteracoes: integer;
  a, b, delta, epsilon: extended;
  f: string;

implementation

{$R *.lfm}

{ TFormCalculo }

function FxR1(f: string; x: extended; var y: extended): word;
  stdcall; external 'Interpretador.dll';

function derivadaPrimeira(x: extended; var y: extended): word;
var
  i: integer;
  h, p, q, erro: extended;
  y1, y2: extended;
begin
  erro := 100000000;
  h := 1024 * epsilon;

  if FxR1(f, x + h, y1) <> 0 then
    Exit(1);
  if FxR1(f, x - h, y2) <> 0 then
    Exit(1);
  p := (y1 - y2) / (2 * h);

  for i := 1 to 10 do
  begin
    q := p;
    h := h / 2;

    if FxR1(f, x + h, y1) <> 0 then
      Exit(1);
    if FxR1(f, x - h, y2) <> 0 then
      Exit(1);
    p := (y1 - y2) / (2 * h);

    if abs(p - q) < erro then
      erro := abs(p - q)
    else
    begin
      y := q;
      Exit(0);
    end;

    if abs(p - q) < epsilon then
    begin
      y := p;
      Exit(0);
    end;
  end;

  y := p;
  Exit(0);
end;

procedure TFormCalculo.HabilitarBusca;
begin
  Edit1.Enabled := True;
  Edit2.Enabled := True;
  Edit3.Enabled := True;
  Edit4.Enabled := True;
end;

procedure TFormCalculo.DesabilitarBusca;
begin
  Edit1.Enabled := False;
  Edit2.Enabled := False;
  Edit3.Enabled := False;
  Edit4.Enabled := False;
end;

procedure TFormCalculo.DesabilitarCalculo;
begin
  Label8.Enabled := False;
  GroupBox3.Enabled := False;
  Edit1.Enabled := False;
  Edit5.Enabled := False;
  Edit6.Enabled := False;
  Edit7.Enabled := False;
  CheckBox1.Enabled := False;
  CheckBox2.Enabled := False;
  CheckBox3.Enabled := False;
  StringGrid1.Enabled := False;
end;

procedure TFormCalculo.HabilitarCalculo;
begin
  GroupBox3.Enabled := True;
  Label8.Enabled := True;
  Edit1.Enabled := True;
  Edit5.Enabled := True;
  Edit6.Enabled := True;
  Edit7.Enabled := True;
  CheckBox1.Enabled := True;
  CheckBox2.Enabled := True;
  CheckBox3.Enabled := True;
  StringGrid1.Enabled := True;
end;

procedure TFormCalculo.FormShow(Sender: TObject);
begin
  metodo := 0;

  todasRaizes := False;
  mostrarIteracoes := False;
  mostrarGrafico := False;

  StringGrid1.Cells[0, 0] := 'i';
  StringGrid1.Cells[0, 1] := 'a[i]';
  StringGrid1.Cells[0, 2] := 'b[i]';
  StringGrid1.Cells[0, 3] := 'x[i]';
  StringGrid1.Cells[0, 4] := 'f(x[i])';

  Edit5.Text := 'min';
  Edit6.Text := 'max';
end;

procedure TFormCalculo.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then
  begin
    Edit5.Text := 'min';
    Edit6.Text := 'max';

    CheckBox1.Checked := False;
  end;

  todasRaizes := not todasRaizes;
end;

procedure TFormCalculo.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then
    CheckBox3.Checked := False;

  mostrarIteracoes := not mostrarIteracoes;
end;

procedure TFormCalculo.CheckBox2Change(Sender: TObject);
begin
  mostrarGrafico := not mostrarGrafico;
end;

procedure TFormCalculo.Edit5Click(Sender: TObject);
begin
  if todasRaizes then
    ShowMessage('Desmarque "Calcular todas as raizes" para poder selecionar na grade o intervalo desejado!')
  else
    ShowMessage('Selecione na grade o intervalo desejado!');
end;

procedure TFormCalculo.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked then
    metodo := 0
  else if RadioButton2.Checked then
    metodo := 1
  else if RadioButton3.Checked then
    metodo := 2
  else if RadioButton4.Checked then
    metodo := 3
  else if RadioButton5.Checked then
    metodo := 4
  else if RadioButton6.Checked then
    metodo := 5;
end;

procedure TFormCalculo.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  CellCol, CellRow: integer;
begin
  StringGrid1.MouseToCell(x, y, CellCol, CellRow);

  if (CellCol <> 0) and (todasRaizes = False) then
  begin
    coluna := CellCol;

    Edit5.Text := StringGrid1.Cells[CellCol, 1];
    Edit6.Text := StringGrid1.Cells[CellCol, 2];
  end;
end;

procedure TFormCalculo.Edit1Change(Sender: TObject);
begin
  StringGrid1.ColCount := 1;
  StringGrid1.Height := 114;

  Edit5.Text := 'min';
  Edit6.Text := 'max';
end;

// BUSCA DOS INTERVALOS DE RAÍZES

procedure TFormCalculo.IniciarBuscaClick(Sender: TObject);
var
  erroP, erroQ: word;
  p, q, f1, f2: extended;
  qtdRaizes: integer;
begin
  Edit5.Text := 'min';
  Edit6.Text := 'max';

  interromper := False;
  qtdRaizes := 0;

  erroP := 0;
  erroQ := 0;

  StringGrid1.ColCount := 1;
  StringGrid1.Height := 114;

  f := Trim(Edit1.Text);
  if f = '' then
  begin
    ShowMessage('Insira uma função!');
    Edit1.SetFocus;
    Exit;
  end;

  try
    a := StrToFloat(Edit2.Text);
  except
    ShowMessage('Valor de "a" inválido!');
    Edit2.SetFocus;
    Exit;
  end;

  try
    b := StrToFloat(Edit3.Text);

    if a >= b then
    begin
      ShowMessage('O valor de "b" tem que ser maior que o valor de "a"!');
      Edit3.SetFocus;
      Exit;
    end;
  except
    ShowMessage('Valor de "b" inválido!');
    Edit3.SetFocus;
    Exit;
  end;

  try
    delta := StrToFloat(Edit4.Text);

    if (delta < (b - a) / 1000) or (delta > (b - a) / 20) then
    begin
      ShowMessage('Delta inválido (entre ' + FloatToStr((b - a) / 1000) +
        ' [(b - a)/1000] e ' + FloatToStr((b - a) / 20) + ' [(b - a)/20)]!');
      Edit4.SetFocus;
      Exit;
    end;
  except
    ShowMessage('Valor de delta (variação de "x") inválido!');
    Edit4.SetFocus;
    Exit;
  end;

  DesabilitarBusca;

  p := a;
  q := a + delta;

  erroP := FxR1(f, p, f1);
  if erroP = 5 then
    ShowMessage('Erro (divisão por 0) ao avaliar a função para o ponto: ' +
      FloatToStr(p))
  else if erroP <> 0 then
  begin
    ShowMessage('Erro ao avaliar a função!');
    HabilitarBusca;
    Exit;
  end;

  erroQ := FxR1(f, q, f2);
  if erroQ = 5 then
    ShowMessage('Erro (divisão por 0) ao avaliar a função para o ponto: ' +
      FloatToStr(q))
  else if erroQ <> 0 then
  begin
    ShowMessage('Erro ao avaliar a função!');
    HabilitarBusca;
    Exit;
  end;

  while (p <= b) do
  begin
    Application.ProcessMessages;
    if interromper then
      Break;

    if ((f1 * f2) <= 0) and (erroP <> 5) and (erroQ <> 5) then
    begin
      qtdRaizes := qtdRaizes + 1;
      StringGrid1.ColCount := qtdRaizes + 1;

      if qtdRaizes > 5 then
        StringGrid1.Height := 114 + GetSystemMetrics(SM_CYHSCROLL);

      StringGrid1.Cells[qtdRaizes, 0] := IntToStr(qtdRaizes);
      StringGrid1.Cells[qtdRaizes, 1] := FloatToStr(p);
      StringGrid1.Cells[qtdRaizes, 2] := FloatToStr(q);

      if f2 = 0 then
      begin
        q := q + delta;

        erroQ := FxR1(f, q, f2);
        if erroQ = 5 then
          ShowMessage('Erro (divisão por 0) ao avaliar a função para o ponto: ' +
            FloatToStr(q))
        else if erroQ <> 0 then
        begin
          ShowMessage('Erro ao avaliar a função!');
          HabilitarBusca;
          Exit;
        end;
      end;
    end;

    p := q;
    f1 := f2;
    erroP := erroQ;

    q := p + delta;
    erroQ := FxR1(f, q, f2);
    if erroQ = 5 then
      ShowMessage('Erro (divisão por 0) ao avaliar a função para o ponto: ' +
        FloatToStr(q))
    else if erroQ <> 0 then
    begin
      ShowMessage('Erro ao avaliar a função!');
      HabilitarBusca;
      Exit;
    end;
  end;

  if qtdRaizes = 0 then
    ShowMessage('Nenhum intervalo com possível raiz encontrado!');

  HabilitarBusca;
end;

procedure TFormCalculo.PararBuscaClick(Sender: TObject);
begin
  interromper := True;
  HabilitarBusca;
end;

procedure TFormCalculo.LimparDadosUmClick(Sender: TObject);
begin
  PararBusca.Click;

  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';

  StringGrid1.ColCount := 1;
  StringGrid1.Height := 114;
end;

procedure TFormCalculo.MostrarGraficoUmClick(Sender: TObject);
var
  i: integer;
  erro: word;
  x, y: extended;
begin
  f := Trim(Edit1.Text);
  if f = '' then
  begin
    ShowMessage('Insira uma função!');
    Edit1.SetFocus;
    Exit;
  end;

  try
    a := StrToFloat(Edit2.Text);
  except
    ShowMessage('Valor de "a" inválido!');
    Edit2.SetFocus;
    Exit;
  end;

  try
    b := StrToFloat(Edit3.Text);

    if a >= b then
    begin
      ShowMessage('O valor de "b" tem que ser maior que o valor de "a"!');
      Edit3.SetFocus;
      Exit;
    end;
  except
    ShowMessage('Valor de "b" inválido!');
    Edit3.SetFocus;
    Exit;
  end;

  with FormGrafico do
  begin
    Chart1.Title.Text[0] := 'Gráfico da função: ' + f;

    delta := (b - a) / 1000;
    for i := 0 to 1000 do
    begin
      x := a + i * delta;

      erro := FxR1(f, x, y);
      if (erro <> 0) and (erro <> 5) then
      begin
        ShowMessage('Erro ao avaliar a função!');
        Exit;
      end;

      Chart1LineSeries1.AddXY(x, y, '');
    end;
  end;

  FormGrafico.Show;
end;

// MÉTODOS PARA CÁLCULO

procedure TFormCalculo.BuscaUniforme;
var
  k: integer;
  p, q, fp, fq, r, fr: extended;
begin
  k := 1;

  StringGrid2.ColCount := 5;

  StringGrid2.Cells[0, 0] := 'k';
  StringGrid2.Cells[1, 0] := 'p';
  StringGrid2.Cells[2, 0] := 'f(p)';
  StringGrid2.Cells[3, 0] := 'q';
  StringGrid2.Cells[4, 0] := 'f(q)';

  p := a;
  q := a + epsilon;

  if FxR1(f, p, fp) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(p);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  if FxR1(f, q, fq) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(q);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  StringGrid2.RowCount := k + 1;

  StringGrid2.Cells[0, k] := IntToStr(k);
  StringGrid2.Cells[1, k] := FloatToStr(p);
  StringGrid2.Cells[2, k] := FloatToStr(fp);
  StringGrid2.Cells[3, k] := FloatToStr(q);
  StringGrid2.Cells[4, k] := FloatToStr(fq);

  while (p <= b) and (fp * fq > 0) do
  begin
    Application.ProcessMessages;
    if interromper then
      Exit;

    if FxR1(f, q, fq) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(q);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    k := k + 1;
    qtdIteracoes := qtdIteracoes + 1;

    p := q;
    fp := fq;

    q := p + epsilon;
    if FxR1(f, q, fq) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(q);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    StringGrid2.RowCount := k + 1;

    StringGrid2.Cells[0, k] := IntToStr(k);
    StringGrid2.Cells[1, k] := FloatToStr(p);
    StringGrid2.Cells[2, k] := FloatToStr(fp);
    StringGrid2.Cells[3, k] := FloatToStr(q);
    StringGrid2.Cells[4, k] := FloatToStr(fq);
  end;

  r := (p + q) / 2;
  StringGrid1.Cells[coluna, 3] := FloatToStr(r);

  if FxR1(f, r, fr) <> 0 then
    StringGrid1.Cells[coluna, 4] := 'ERRO'
  else
  begin
    StringGrid1.Cells[coluna, 4] := FloatToStr(fr);

    if mostrarGrafico then
      FormGrafico.Chart1LineSeries2.AddXY(r, fr, '');
  end;

  if mostrarIteracoes then
    StringGrid2.AutoFillColumns := True;
end;

procedure TFormCalculo.DivisaoMeio;
var
  k: integer;
  fa, p, fp, r, fr: extended;
begin
  k := 1;
  p := (a + b) / 2;

  StringGrid2.ColCount := 6;

  StringGrid2.Cells[0, 0] := 'k';
  StringGrid2.Cells[1, 0] := 'a';
  StringGrid2.Cells[2, 0] := 'f(a)';
  StringGrid2.Cells[3, 0] := 'b';
  StringGrid2.Cells[4, 0] := 'p';
  StringGrid2.Cells[5, 0] := 'f(p)';

  if FxR1(f, a, fa) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(a);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  if FxR1(f, p, fp) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(p);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  StringGrid2.RowCount := k + 1;

  StringGrid2.Cells[0, k] := IntToStr(k);
  StringGrid2.Cells[1, k] := FloatToStr(a);
  StringGrid2.Cells[2, k] := FloatToStr(fa);
  StringGrid2.Cells[3, k] := FloatToStr(b);
  StringGrid2.Cells[4, k] := FloatToStr(p);
  StringGrid2.Cells[5, k] := FloatToStr(fp);

  while (abs(b - a) > epsilon) and (abs(fp) > epsilon) do
  begin
    Application.ProcessMessages;
    if interromper then
      Exit;

    if (fp * fa) < 0 then
      b := p
    else
    begin
      a := p;
      fa := fp;
    end;

    k := k + 1;
    qtdIteracoes := qtdIteracoes + 1;

    p := (a + b) / 2;

    if FxR1(f, p, fp) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(p);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    StringGrid2.RowCount := k + 1;

    StringGrid2.Cells[0, k] := IntToStr(k);
    StringGrid2.Cells[1, k] := FloatToStr(a);
    StringGrid2.Cells[2, k] := FloatToStr(fa);
    StringGrid2.Cells[3, k] := FloatToStr(b);
    StringGrid2.Cells[4, k] := FloatToStr(p);
    StringGrid2.Cells[5, k] := FloatToStr(fp);
  end;

  r := p;
  StringGrid1.Cells[coluna, 3] := FloatToStr(r);

  if FxR1(f, r, fr) <> 0 then
    StringGrid1.Cells[coluna, 4] := 'ERRO'
  else
  begin
    StringGrid1.Cells[coluna, 4] := FloatToStr(fr);

    if mostrarGrafico then
      FormGrafico.Chart1LineSeries2.AddXY(r, fr, '');
  end;

  if mostrarIteracoes then
    StringGrid2.AutoFillColumns := True;
end;

procedure TFormCalculo.Cordas;
var
  k: integer;
  fa, fb, p, fp, r, fr: extended;
begin
  k := 1;

  StringGrid2.ColCount := 7;

  StringGrid2.Cells[0, 0] := 'k';
  StringGrid2.Cells[1, 0] := 'a';
  StringGrid2.Cells[2, 0] := 'f(a)';
  StringGrid2.Cells[3, 0] := 'b';
  StringGrid2.Cells[4, 0] := 'f(b)';
  StringGrid2.Cells[5, 0] := 'p';
  StringGrid2.Cells[6, 0] := 'f(p)';

  if FxR1(f, a, fa) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(a);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  if FxR1(f, b, fb) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(b);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  p := (a * fb - b * fa) / (fb - fa);

  if FxR1(f, p, fp) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(p);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  StringGrid2.RowCount := k + 1;

  StringGrid2.Cells[0, k] := IntToStr(k);
  StringGrid2.Cells[1, k] := FloatToStr(a);
  StringGrid2.Cells[2, k] := FloatToStr(fa);
  StringGrid2.Cells[3, k] := FloatToStr(b);
  StringGrid2.Cells[4, k] := FloatToStr(fb);
  StringGrid2.Cells[5, k] := FloatToStr(p);
  StringGrid2.Cells[6, k] := FloatToStr(fp);

  while (abs(b - a) > epsilon) and (abs(fp) > epsilon) do
  begin
    Application.ProcessMessages;
    if interromper then
      Exit;

    if (fp * fa) < 0 then
    begin
      b := p;
      fb := fp;
    end
    else
    begin
      a := p;
      fa := fp;
    end;

    k := k + 1;
    qtdIteracoes := qtdIteracoes + 1;

    p := (a * fb - b * fa) / (fb - fa);

    if FxR1(f, p, fp) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(p);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    StringGrid2.RowCount := k + 1;

    StringGrid2.Cells[0, k] := IntToStr(k);
    StringGrid2.Cells[1, k] := FloatToStr(a);
    StringGrid2.Cells[2, k] := FloatToStr(fa);
    StringGrid2.Cells[3, k] := FloatToStr(b);
    StringGrid2.Cells[4, k] := FloatToStr(fb);
    StringGrid2.Cells[5, k] := FloatToStr(p);
    StringGrid2.Cells[6, k] := FloatToStr(fp);
  end;

  r := p;
  StringGrid1.Cells[coluna, 3] := FloatToStr(r);

  if FxR1(f, r, fr) <> 0 then
    StringGrid1.Cells[coluna, 4] := 'ERRO'
  else
  begin
    StringGrid1.Cells[coluna, 4] := FloatToStr(fr);

    if mostrarGrafico then
      FormGrafico.Chart1LineSeries2.AddXY(r, fr, '');
  end;

  if mostrarIteracoes then
    StringGrid2.AutoFillColumns := True;
end;

procedure TFormCalculo.CordasAdaptado;
var
  k: integer;
  qtdA, qtdB: integer;
  fa, fb, p, fp, r, fr: extended;
begin
  k := 1;

  StringGrid2.ColCount := 7;

  StringGrid2.Cells[0, 0] := 'k';
  StringGrid2.Cells[1, 0] := 'a';
  StringGrid2.Cells[2, 0] := 'f(a)';
  StringGrid2.Cells[3, 0] := 'b';
  StringGrid2.Cells[4, 0] := 'f(b)';
  StringGrid2.Cells[5, 0] := 'p';
  StringGrid2.Cells[6, 0] := 'f(p)';

  qtdA := 0;
  qtdB := 0;

  if FxR1(f, a, fa) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(a);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  if FxR1(f, b, fb) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(b);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  p := (a * fb - b * fa) / (fb - fa);

  if FxR1(f, p, fp) <> 0 then
  begin
    StringGrid1.Cells[coluna, 3] := FloatToStr(p);
    StringGrid1.Cells[coluna, 4] := 'ERRO';
    Exit;
  end;

  StringGrid2.RowCount := k + 1;

  StringGrid2.Cells[0, k] := IntToStr(k);
  StringGrid2.Cells[1, k] := FloatToStr(a);
  StringGrid2.Cells[2, k] := FloatToStr(fa);
  StringGrid2.Cells[3, k] := FloatToStr(b);
  StringGrid2.Cells[4, k] := FloatToStr(fb);
  StringGrid2.Cells[5, k] := FloatToStr(p);
  StringGrid2.Cells[6, k] := FloatToStr(fp);

  while (abs(b - a) > epsilon) and (abs(fp) > epsilon) do
  begin
    Application.ProcessMessages;
    if interromper then
      Exit;

    if (fp * fa) < 0 then
    begin
      b := p;
      fb := fp;

      qtdA := qtdA + 1;
      qtdB := 0;
    end
    else
    begin
      a := p;
      fa := fp;

      qtdB := qtdB + 1;
      qtdA := 0;
    end;

    k := k + 1;
    qtdIteracoes := qtdIteracoes + 1;

    if qtdA = 3 then
    begin
      p := (a * fb / 2 - b * fa) / (fb / 2 - fa);
      qtdA := 0;
    end
    else if qtdB = 3 then
    begin
      p := (a * fb - b * fa / 2) / (fb - fa / 2);
      qtdB := 0;
    end
    else
      p := (a * fb - b * fa) / (fb - fa);

    if FxR1(f, p, fp) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(p);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    StringGrid2.RowCount := k + 1;

    StringGrid2.Cells[0, k] := IntToStr(k);
    StringGrid2.Cells[1, k] := FloatToStr(a);
    StringGrid2.Cells[2, k] := FloatToStr(fa);
    StringGrid2.Cells[3, k] := FloatToStr(b);
    StringGrid2.Cells[4, k] := FloatToStr(fb);
    StringGrid2.Cells[5, k] := FloatToStr(p);
    StringGrid2.Cells[6, k] := FloatToStr(fp);
  end;

  r := p;
  StringGrid1.Cells[coluna, 3] := FloatToStr(r);

  if FxR1(f, r, fr) <> 0 then
    StringGrid1.Cells[coluna, 4] := 'ERRO'
  else
  begin
    StringGrid1.Cells[coluna, 4] := FloatToStr(fr);

    if mostrarGrafico then
      FormGrafico.Chart1LineSeries2.AddXY(r, fr, '');
  end;

  if mostrarIteracoes then
    StringGrid2.AutoFillColumns := True;
end;

procedure TFormCalculo.Newton;
var
  k, maxIte: integer;
  p, q, fP, dP, r, fR: extended;
begin
  maxIte := 100;
  k := 0;
  qtdIteracoes := 0;

  StringGrid2.ColCount := 5;

  StringGrid2.Cells[0, 0] := 'i';
  StringGrid2.Cells[1, 0] := 'p';
  StringGrid2.Cells[2, 0] := 'f(p)';
  StringGrid2.Cells[3, 0] := 'd(p)';
  StringGrid2.Cells[4, 0] := 'q';

  p := a;
  q := p;

  repeat
    Application.ProcessMessages;
    if interromper then
      Exit;

    if FxR1(f, p, fP) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(p);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    repeat
      Application.ProcessMessages;
      if interromper then
        Exit;

      if derivadaPrimeira(p, dP) <> 0 then
      begin
        StringGrid1.Cells[coluna, 3] := FloatToStr(p);
        StringGrid1.Cells[coluna, 4] := 'ERRO';
        Exit;
      end;

      if dP = 0 then
        p := p + epsilon;
    until dP <> 0;

    k := k + 1;
    qtdIteracoes := qtdIteracoes + 1;

    StringGrid2.RowCount := k + 1;

    StringGrid2.Cells[0, k] := IntToStr(k);
    StringGrid2.Cells[1, k] := FloatToStr(p);
    StringGrid2.Cells[2, k] := FloatToStr(fP);
    StringGrid2.Cells[3, k] := FloatToStr(dP);
    StringGrid2.Cells[4, k] := FloatToStr(q);

    q := p;
    p := p - fP / dP;
  until (abs(p - q) < epsilon) or (k = maxIte);

  r := p;
  StringGrid1.Cells[coluna, 3] := FloatToStr(r);

  if FxR1(f, r, fR) <> 0 then
    StringGrid1.Cells[coluna, 4] := 'ERRO'
  else
  begin
    StringGrid1.Cells[coluna, 4] := FloatToStr(fR);

    if mostrarGrafico then
      FormGrafico.Chart1LineSeries2.AddXY(r, fr, '');
  end;

  if mostrarIteracoes then
    StringGrid2.AutoFillColumns := True;
end;

procedure TFormCalculo.NewtonAdaptado;
var
  k, maxIte: integer;
  p, q, fP, dP, r, fR: extended;
begin
  maxIte := 10;
  k := 0;
  qtdIteracoes := 0;

  p := a;
  q := p;

  StringGrid2.ColCount := 5;

  StringGrid2.Cells[0, 0] := 'k';
  StringGrid2.Cells[1, 0] := 'p';
  StringGrid2.Cells[2, 0] := 'f(p)';
  StringGrid2.Cells[3, 0] := 'd(p)';
  StringGrid2.Cells[4, 0] := 'q';

  repeat
    Application.ProcessMessages;
    if interromper then
      Exit;

    if FxR1(f, p, fP) <> 0 then
    begin
      StringGrid1.Cells[coluna, 3] := FloatToStr(p);
      StringGrid1.Cells[coluna, 4] := 'ERRO';
      Exit;
    end;

    if (k mod 5) = 0 then
    begin
      repeat
        Application.ProcessMessages;
        if interromper then
          Exit;

        if derivadaPrimeira(p, dP) <> 0 then
        begin
          StringGrid1.Cells[coluna, 3] := FloatToStr(p);
          StringGrid1.Cells[coluna, 4] := 'ERRO';
          Exit;
        end;

        if dP = 0 then
          p := p + epsilon;
      until dP <> 0;
    end;

    k := k + 1;
    qtdIteracoes := qtdIteracoes + 1;

    StringGrid2.RowCount := k + 1;

    StringGrid2.Cells[0, k] := IntToStr(k);
    StringGrid2.Cells[1, k] := FloatToStr(p);
    StringGrid2.Cells[2, k] := FloatToStr(fP);
    StringGrid2.Cells[3, k] := FloatToStr(dP);
    StringGrid2.Cells[4, k] := FloatToStr(q);

    q := p;
    p := p - fP / dP;
  until (abs(p - q) < epsilon) or (k = maxIte);

  r := p;
  StringGrid1.Cells[coluna, 3] := FloatToStr(r);

  if FxR1(f, r, fR) <> 0 then
    StringGrid1.Cells[coluna, 4] := 'ERRO'
  else
  begin
    StringGrid1.Cells[coluna, 4] := FloatToStr(fR);

    if mostrarGrafico then
      FormGrafico.Chart1LineSeries2.AddXY(r, fr, '');
  end;

  if mostrarIteracoes then
    StringGrid2.AutoFillColumns := True;
end;

// CÁLCULO DAS RAÍZES

procedure TFormCalculo.IniciarCalculoClick(Sender: TObject);
var
  i: integer;
begin
  interromper := False;
  FormGrafico.Chart1LineSeries2.Clear;
  Label8.Caption := '0';

  StringGrid2.RowCount := 1;
  StringGrid2.ColCount := 1;
  FormCalculo.Height := 374;

  qtdIteracoes := 1;

  for i := 1 to StringGrid1.ColCount - 1 do
  begin
    StringGrid1.Cells[i, 3] := '';
    StringGrid1.Cells[i, 4] := '';
  end;

  f := Trim(Edit1.Text);
  if f = '' then
  begin
    ShowMessage('Insira uma função!');
    Edit1.SetFocus;
    Exit;
  end;

  if todasRaizes then
  begin
    for coluna := 1 to StringGrid1.ColCount - 1 do
    begin
      Application.ProcessMessages;
      if interromper then
        Break;

      a := StrToFloat(StringGrid1.Cells[coluna, 1]);
      b := StrToFloat(StringGrid1.Cells[coluna, 2]);

      try
        epsilon := StrToFloat(Edit7.Text);

        if (epsilon > (b - a) / 20) then
        begin
          ShowMessage('Aproximação inválida (menor que ' + FloatToStr(
            (b - a) / 20) + ' [(b - a)/20])!');
          Edit7.SetFocus;
          Exit;
        end;
      except
        ShowMessage('Valor de aproximação inválido!');
        Edit7.SetFocus;
        Exit;
      end;

      DesabilitarCalculo;

      if metodo = 0 then
        BuscaUniforme
      else if metodo = 1 then
        DivisaoMeio
      else if metodo = 2 then
        Cordas
      else if metodo = 3 then
        Newton
      else if metodo = 4 then
        CordasAdaptado
      else if metodo = 5 then
        NewtonAdaptado;
    end;
  end
  else
  begin
    try
      a := StrToFloat(Edit5.Text);
    except
      ShowMessage('Selecione um intervalo na grade!');
      Exit;
    end;

    try
      b := StrToFloat(Edit6.Text);
    except
      ShowMessage('Selecione um intervalo na grade!');
      Exit;
    end;

    try
      epsilon := StrToFloat(Edit7.Text);

      if (epsilon > (b - a) / 20) then
      begin
        ShowMessage('Aproximação inválida (menor que ' + FloatToStr(
          (b - a) / 20) + ' [(b - a)/20])!');
        Edit7.SetFocus;
        Exit;
      end;
    except
      ShowMessage('Valor de aproximação inválido!');
      Edit7.SetFocus;
      Exit;
    end;

    DesabilitarCalculo;

    if metodo = 0 then
      BuscaUniforme
    else if metodo = 1 then
      DivisaoMeio
    else if metodo = 2 then
      Cordas
    else if metodo = 3 then
      Newton
    else if metodo = 4 then
      CordasAdaptado
    else if metodo = 5 then
      NewtonAdaptado;
  end;

  Label8.Caption := IntToStr(qtdIteracoes);

  if mostrarGrafico then
    MostrarGraficoUm.Click;
  if mostrarIteracoes then
    FormCalculo.Height := 562;

  HabilitarCalculo;
end;

procedure TFormCalculo.PararCalculoClick(Sender: TObject);
begin
  interromper := True;
  HabilitarCalculo;
end;

procedure TFormCalculo.LimparDadosDoisClick(Sender: TObject);
var
  i: integer;
begin
  PararCalculo.Click;

  RadioButton1.Checked := True;

  Edit5.Text := 'min';
  Edit6.Text := 'max';
  Edit7.Text := '';
  Label8.Caption := '0';

  StringGrid2.RowCount := 1;
  StringGrid2.ColCount := 1;
  FormCalculo.Height := 374;

  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;

  for i := 1 to StringGrid1.ColCount - 1 do
  begin
    StringGrid1.Cells[i, 3] := '';
    StringGrid1.Cells[i, 4] := '';
  end;
end;

procedure TFormCalculo.MostrarAjudaClick(Sender: TObject);
begin
  ShowMessage('Imagine que aqui existe um menu de ajuda que ainda será implementado em versões futuras do programa ;)'
    + #13#10 +
    'Então acredito que o atual usuário (você) sabe métodos numéricos o suficiente para poder usar essa aplicação!');
end;

end.
