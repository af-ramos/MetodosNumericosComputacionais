unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  Buttons, Grids, lclintf;

type
  VetorE = array of extended;
  VetorS = array of string;
  MatrizE = array of array of extended;

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    FloatSpinEdit1: TFloatSpinEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    BotaoSalvar: TSpeedButton;
    BotaoAbrir: TSpeedButton;
    BotaoCalcular: TSpeedButton;
    BotaoAjuda: TSpeedButton;
    BotaoLimpar: TSpeedButton;
    BotaoNovo: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    procedure BotaoAbrirClick(Sender: TObject);
    procedure BotaoAjudaClick(Sender: TObject);
    procedure BotaoCalcularClick(Sender: TObject);
    procedure BotaoLimparClick(Sender: TObject);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinEdit1EditingDone(Sender: TObject);
    procedure StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: integer;
      aState: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure mostrarMensagem(c, m: string; k: integer);
    function Newton(f: VetorS; var x: VetorE; it: integer; eps: extended): word;
    function NewtonModificado(f: VetorS; var x: VetorE; it: integer;
      eps: extended): word;
    function normaVetor(x, h: VetorE): extended;
    function derivadaParcial(f: string; x: VetorE; i: integer;
      var r: extended): word;
    function calcularGradiente(f: string; x: VetorE; var G: VetorE): word;
    function Gauss(A: MatrizE; b: VetorE; var x: VetorE): word;
  private

  public

  end;

var
  FormPrincipal: TFormPrincipal;
  n: integer;

implementation

{$R *.lfm}

{ TFormPrincipal }

function FxRn(f: string; x: VetorE; colchetes: boolean; var y: extended): word;
  stdcall; external 'Interpretador.dll';

// FUNÇÕES AUXILIARES

procedure TFormPrincipal.mostrarMensagem(c, m: string; k: integer);
var
  t: TMsgDlgType;
begin
  if k = 0 then
    t := mtInformation;
  if k = 1 then
    t := mtError;

  MessageDlg(c, m, t, [], 0);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var
  i: integer;
begin
  n := 2;
  SpinEdit1.EditingDone;

  with StringGrid1 do
  begin
    ColWidths[0] := 20;
    ColWidths[1] := 80;
    ColWidths[2] := 170;
    ColWidths[3] := 120;
    ColWidths[4] := 136;

    Cells[0, 0] := 'i';
    Cells[1, 0] := 'x[i] Inicial';
    Cells[2, 0] := 'f[i](x) {F(x) = 0}';
    Cells[3, 0] := 'x[i] Final';
    Cells[4, 0] := 'f[i](x) Final {F(x) = 0}';

    for i := 1 to 10 do
      Cells[0, i] := IntToStr(i);

    Row := 1;
    Col := 1;
    SetFocus;
  end;
end;

procedure TFormPrincipal.SpinEdit1EditingDone(Sender: TObject);
begin
  n := SpinEdit1.Value;
  StringGrid1.Refresh;
end;

procedure TFormPrincipal.StringGrid1PrepareCanvas(Sender: TObject;
  aCol, aRow: integer; aState: TGridDrawState);
{$warn 5024 off}
begin
  with StringGrid1 do
    if (aCol > 0) and (aRow > n) then
      Canvas.Brush.Color := $00F0F0F0;
end;

procedure TFormPrincipal.StringGrid1SelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  if (aRow > n) or (aCol > 2) then
    CanSelect := False;
end;

// FUNÇÕES DE BOTÃO

procedure TFormPrincipal.BotaoNovoClick(Sender: TObject);
var
  i, j: integer;
begin
  SpinEdit1.Value := 2;
  SpinEdit1.EditingDone;

  RadioButton1.Checked := True;

  SpinEdit2.Value := 10;
  FloatSpinEdit1.Value := 0.01;

  for i := 1 to 10 do
    for j := 1 to 4 do
      StringGrid1.Cells[j, i] := '';
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

procedure TFormPrincipal.BotaoAjudaClick(Sender: TObject);
begin
  mostrarMensagem('"Menu" de Ajuda',
    'Eu confio que o usuário saiba o suficiente sobre Sistemas de Equações Não-Lineares para compreender sozinho o programa.'
    + #13#10#13#10 +
    'Caso mesmo assim tenha dúvidas, segue um site que pode te ajudar (ou atrapalhar).',
    0);
  OpenURL('https://pt.wikipedia.org/wiki/Matem%C3%A1tica_n%C3%A3o-linear');
end;

procedure TFormPrincipal.BotaoCalcularClick(Sender: TObject);
{$warn 5091 off}
var
  f: VetorS;
  x: VetorE;
  i, j, it: integer;
  eps, fx: extended;
  erro: word;
begin
  for i := 1 to n do
    for j := 3 to 4 do
      StringGrid1.Cells[j, i] := '';

  SetLength(f, n + 1);
  SetLength(x, n + 1);

  with StringGrid1 do
  begin
    for i := 1 to n do
    begin
      try
        x[i] := StrToFloat(Cells[1, i]);
      except
        mostrarMensagem('Erro de valor', 'O valor de x[' + IntToStr(i) +
          '] é inválido!', 1);

        Col := 1;
        Row := i;
        SetFocus;

        Exit;
      end;

      f[i] := Trim(Cells[2, i]);
      if f[i] = '' then
      begin
        mostrarMensagem('Erro de equação', 'A equação f[' +
          IntToStr(i) + '] é inválida!', 1);

        Col := 2;
        Row := i;
        SetFocus;

        Exit;
      end;
    end;

    it := SpinEdit2.Value;
    eps := FloatSpinEdit1.Value;

    if RadioButton1.Checked then
      erro := Newton(f, x, it, eps)
    else
      erro := NewtonModificado(f, x, it, eps);

    if erro = 1 then
    begin
      for i := 1 to n do
        Cells[3, i] := 'Exceção';
      GroupBox5.Caption := 'Pontos Iniciais e Equações (Iterações = ERRO)';
    end

    else if erro = 2 then
    begin
      for i := 1 to n do
        Cells[3, i] := 'Iterações';
      GroupBox5.Caption := 'Pontos Iniciais e Equações (Iterações = LIMITE)';
    end

    else
      for i := 1 to n do
      begin
        Cells[3, i] := FloatToStr(x[i]);

        fx := 0;
        if FxRn(f[i], x, True, fx) <> 0 then
        begin
          mostrarMensagem('Erro de equação', 'Erro ao avaliar a equação (' +
            f[i] + ')!', 1);
          Exit;
        end;

        Cells[4, i] := FloatToStr(fx);
      end;
  end;
end;

procedure TFormPrincipal.BotaoLimparClick(Sender: TObject);
var
  i, j: integer;
begin
  for i := n + 1 to 10 do
    for j := 1 to 4 do
      StringGrid1.Cells[j, i] := '';
end;

// FUNÇÕES DE CÁLCULO

function TFormPrincipal.Newton(f: VetorS; var x: VetorE; it: integer;
  eps: extended): word;
{$warn 5057 off}
var
  J: MatrizE;
  h, G, Fx: VetorE;
  fi: extended;
  i, k, qtdIt: integer;
begin
  SetLength(J, n + 1, n + 1);

  SetLength(h, n + 1);
  SetLength(G, n + 1);
  SetLength(Fx, n + 1);

  for qtdIt := 1 to it + 1 do
  begin
    if qtdIt = it + 1 then
      Exit(2);

    for i := 1 to n do
    begin
      if calcularGradiente(f[i], x, G) <> 0 then
        Exit(1);
      for k := 1 to n do
        J[i, k] := G[k];
    end;

    for i := 1 to n do
    begin
      if FxRn(f[i], x, True, fi) <> 0 then
        Exit(1);
      Fx[i] := -fi;
    end;

    if Gauss(J, Fx, h) <> 0 then
      Exit(1);

    for i := 1 to n do
      x[i] := x[i] + h[i];

    if normaVetor(x, h) <= eps then
      Break;
  end;

  GroupBox5.Caption := 'Pontos Iniciais e Equações (Iterações = ' +
    IntToStr(qtdIt) + ')';
  Exit(0);
end;

function TFormPrincipal.NewtonModificado(f: VetorS; var x: VetorE;
  it: integer; eps: extended): word;
{$warn 5057 off}
var
  J: MatrizE;
  h, G, Fx: VetorE;
  fi: extended;
  i, k, qtdIt: integer;
begin
  SetLength(J, n + 1, n + 1);

  SetLength(h, n + 1);
  SetLength(G, n + 1);
  SetLength(Fx, n + 1);

  for qtdIt := 0 to it do
  begin
    if qtdIt = it then
      Exit(2);

    if (qtdIt mod 3) = 0 then
    begin
      for i := 1 to n do
      begin
        if calcularGradiente(f[i], x, G) <> 0 then
          Exit(1);
        for k := 1 to n do
          J[i, k] := G[k];
      end;
    end;

    for i := 1 to n do
    begin
      if FxRn(f[i], x, True, fi) <> 0 then
        Exit(1);
      Fx[i] := -fi;
    end;

    if Gauss(J, Fx, h) <> 0 then
      Exit(1);

    for i := 1 to n do
      x[i] := x[i] + h[i];

    if normaVetor(x, h) <= eps then
      Break;
  end;

  GroupBox5.Caption := 'Pontos Iniciais e Equações (Iterações = ' +
    IntToStr(qtdIt + 1) + ')';
  Exit(0);
end;

function TFormPrincipal.normaVetor(x, h: VetorE): extended;
var
  i: integer;
  somaX, somaH: extended;
begin
  somaX := 0;
  somaH := 0;

  for i := 1 to n do
  begin
    somaH := somaH + Sqr(h[i]);
    somaX := somaX + Sqr(x[i]);
  end;

  if Sqrt(somaX) > 1 then
    Exit(Sqrt(somaH) / Sqrt(somaX));

  Exit(Sqrt(somaH));
end;

function TFormPrincipal.Gauss(A: MatrizE; b: VetorE; var x: VetorE): word;
var
  i, j, k: integer;
  m, soma: extended;
begin
  for j := 1 to n - 1 do
  begin
    for i := j + 1 to n do
    begin
      try
        m := A[i, j] / A[j, j];
      except
        Exit(1);
      end;

      for k := j to n do
        A[i, k] := A[i, k] - m * A[j, k];
      b[i] := b[i] - m * b[j];
    end;
  end;

  try
    x[n] := b[n] / A[n, n];
  except
    Exit(1);
  end;

  for i := n - 1 downto 1 do
  begin
    soma := 0;

    for j := i + 1 to n do
      soma := soma + A[i, j] * x[j];
    x[i] := (b[i] - soma) / A[i, i];
  end;

  Exit(0);
end;

function TFormPrincipal.derivadaParcial(f: string; x: VetorE; i: integer;
  var r: extended): word;
{$warn 5057 off}
var
  j: integer;
  h, xi, f1, f2, p, q: extended;
begin
  h := 0.1024;
  xi := x[i];

  x[i] := xi + h;
  if FxRn(f, x, True, f1) <> 0 then
    Exit(1);

  x[i] := xi - h;
  if FxRn(f, x, True, f2) <> 0 then
    Exit(1);

  p := (f1 - f2) / (2 * h);

  for j := 1 to 10 do
  begin
    q := p;
    h := h / 2;

    x[i] := xi + h;
    if FxRn(f, x, True, f1) <> 0 then
      Exit(1);

    x[i] := xi - h;
    if FxRn(f, x, True, f2) <> 0 then
      Exit(1);

    p := (f1 - f2) / (2 * h);

    if abs(p - q) < 0.0001 then
      Break;
  end;

  x[i] := xi;
  r := p;

  Exit(0);
end;

function TFormPrincipal.calcularGradiente(f: string; x: VetorE; var G: VetorE): word;
{$warn 5057 off}
var
  i: integer;
  r: extended;
begin
  for i := 1 to n do
  begin
    if derivadaParcial(f, x, i, r) <> 0 then
      Exit(1);
    G[i] := r;
  end;

  Exit(0);
end;

end.
