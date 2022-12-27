unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Windows, Dialogs, Spin, StdCtrls,
  Buttons, Grids, Metodos, Solucao;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    PreencherZero: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    FloatSpinEdit1: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    IniciarCalculo: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MostrarAjuda: TSpeedButton;
    LimparDados: TSpeedButton;
    PararCalculo: TSpeedButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    MontarGrade: TSpeedButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    StringGrid1: TStringGrid;
    procedure PreencherZeroClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IniciarCalculoClick(Sender: TObject);
    procedure LimparDadosClick(Sender: TObject);
    procedure MontarGradeClick(Sender: TObject);
    procedure MostrarAjudaClick(Sender: TObject);
    procedure PararCalculoClick(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
  private

  public

  end;

var
  FormPrincipal: TFormPrincipal;
  metodoUsado: integer;

implementation

{$R *.lfm}

{ TFormPrincipal }

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  ControlStyle := ControlStyle + [csOpaque];
  DoubleBuffered := True;

  MontarGrade.Click;
  StringGrid1.SetFocus;

  CheckBox1.Checked := True;
  RadioButton1.Checked := True;

  calcularSistema := True;
  calcularDeterminante := False;
  calcularInversa := False;
  mostrarMatrizAumentada := False;
end;

procedure TFormPrincipal.IniciarCalculoClick(Sender: TObject);
var
  i, j: integer;
begin
  interromper := False;

  FormSolucao.LimparDados;
  FormSolucao.Close;

  MontarGrade.Click;

  epsilon := FloatSpinEdit1.Value;
  qtdIteracoes := SpinEdit2.Value;

  for i := 1 to qtdVariaveis do
  begin
    for j := 1 to qtdVariaveis do
    begin
      try
        A[i, j] := StrToFloat(StringGrid1.Cells[j, i]);
      except
        ShowMessage('O valor de A[' + IntToStr(i) + ', ' + IntToStr(j) +
          '] não é um número válido!');

        StringGrid1.Col := j;
        StringGrid1.Row := i;
        StringGrid1.SetFocus;

        Exit;
      end;
    end;

    try
      b[i] := StrToFloat(StringGrid1.Cells[qtdVariaveis + 1, i]);
    except
      ShowMessage('O valor de b[' + IntToStr(i) + '] não é um número válido!');

      StringGrid1.Col := qtdVariaveis + 1;
      StringGrid1.Row := i;
      StringGrid1.SetFocus;

      Exit;
    end;

    if RadioButton7.Checked or RadioButton8.Checked then
    begin
      try
        xIni[i] := StrToFloat(StringGrid1.Cells[i, qtdVariaveis + 1]);
      except
        ShowMessage('O valor de xIni[' + IntToStr(i) + '] não é um número válido!');

        StringGrid1.Col := qtdVariaveis + 1;
        StringGrid1.Row := i;
        StringGrid1.SetFocus;

        Exit;
      end;
    end;
  end;

  if not (calcularSistema or calcularDeterminante or calcularInversa or
    mostrarMatrizAumentada) then
  begin
    ShowMessage(
      'Não foi selecionado nenhuma informação de cálculo (Sistema, Determinante, Inversa ou Triangular), portanto nada será feito!');
    Exit;
  end;

  erro := True;

  if RadioButton1.Checked then
    Gauss
  else if RadioButton2.Checked then
    GaussPivotamentoParcial
  else if RadioButton3.Checked then
    GaussPivotamentoTotal
  else if RadioButton4.Checked then
    GaussCompacto
  else if RadioButton5.Checked then
    DecomposicaoLU
  else if RadioButton6.Checked then
    Cholesky
  else if RadioButton7.Checked then
    JacobiRichardson
  else if RadioButton8.Checked then
    GaussSeidel;

  if erro then
    Exit;

  with FormSolucao do
  begin
    StringGrid1.ColCount := qtdVariaveis + 1;

    StringGrid1.Cells[0, 0] := 'i';
    StringGrid1.Cells[0, 1] := 'x[i]';
    for i := 1 to qtdVariaveis do
      StringGrid1.Cells[i, 0] := IntToStr(i);

    StringGrid2.ColCount := qtdVariaveis + 1;
    StringGrid2.RowCount := qtdVariaveis + 1;

    StringGrid2.Cells[0, 0] := 'A-1';
    for i := 1 to qtdVariaveis do
    begin
      StringGrid2.Cells[0, i] := IntToStr(i);
      StringGrid2.Cells[i, 0] := IntToStr(i);
    end;

    StringGrid3.ColCount := qtdVariaveis + 2;
    StringGrid3.RowCount := qtdVariaveis + 1;

    StringGrid3.Cells[0, 0] := 'A';
    StringGrid3.Cells[qtdVariaveis + 1, 0] := 'b';
    for i := 1 to qtdVariaveis do
    begin
      StringGrid3.Cells[0, i] := IntToStr(i);
      StringGrid3.Cells[i, 0] := IntToStr(i);
    end;

    if calcularSistema then
      for i := 1 to qtdVariaveis do
        StringGrid1.Cells[i, 1] := FloatToStr(x[i])
    else
      GroupBox1.Caption := 'Solução do Sistema - CÁLCULO NÃO PEDIDO';

    if calcularDeterminante then
      Label2.Caption := FloatToStr(determinante)
    else
      GroupBox2.Caption := 'Determinante - CÁLCULO NÃO PEDIDO';

    if calcularInversa then
      for i := 1 to qtdVariaveis do
        for j := 1 to qtdVariaveis do
          StringGrid2.Cells[j, i] := FloatToStr(AInv[i, j])
    else
      GroupBox3.Caption := 'Matriz Inversa - CÁLCULO NÃO PEDIDO';

    if mostrarMatrizAumentada then
      for i := 1 to qtdVariaveis do
      begin
        for j := 1 to qtdVariaveis do
          StringGrid3.Cells[j, i] := FloatToStr(A[i, j]);
        StringGrid3.Cells[qtdVariaveis + 1, i] := FloatToStr(b[i]);
      end
    else
      GroupBox4.Caption := 'Matriz Aumentada (A | b) - CÁLCULO NÃO PEDIDO';

    Show;
  end;
end;

procedure TFormPrincipal.LimparDadosClick(Sender: TObject);
var
  i, j: integer;
begin
  SpinEdit1.Value := 3;
  SpinEdit2.Value := 10;
  FloatSpinEdit1.Value := 0.001;

  RadioButton1.Checked := True;
  CheckBox1.Checked := True;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;

  MontarGrade.Click;
  for i := 1 to qtdVariaveis do
    for j := 1 to qtdVariaveis + 1 do
      StringGrid1.Cells[j, i] := '';
end;

procedure TFormPrincipal.MontarGradeClick(Sender: TObject);
var
  i: integer;
begin
  qtdVariaveis := SpinEdit1.Value;

  if qtdVariaveis > 7 then
  begin
    StringGrid1.Height := 164 + GetSystemMetrics(SM_CYHSCROLL);
    StringGrid1.Width := 580 + GetSystemMetrics(SM_CXVSCROLL);
  end
  else
  begin
    StringGrid1.Height := 164;
    StringGrid1.Width := 580;
  end;

  if RadioButton7.Checked or RadioButton8.Checked then
  begin
    if qtdVariaveis > 7 then
      StringGrid1.Height := 184 + GetSystemMetrics(SM_CYHSCROLL)
    else
      StringGrid1.Height := 184;

    StringGrid1.RowCount := qtdVariaveis + 2;
    StringGrid1.Cells[0, qtdVariaveis + 1] := 'x inicial';
  end
  else
    StringGrid1.RowCount := qtdVariaveis + 1;

  StringGrid1.ColCount := qtdVariaveis + 2;
  StringGrid1.Cells[qtdVariaveis + 1, 0] := 'b';

  StringGrid1.Cells[0, 0] := 'A';
  for i := 1 to qtdVariaveis do
  begin
    StringGrid1.Cells[i, 0] := IntToStr(i);
    StringGrid1.Cells[0, i] := IntToStr(i);
  end;
end;

procedure TFormPrincipal.MostrarAjudaClick(Sender: TObject);
begin
  ShowMessage(
    'Por enquanto não posso te ajudar, mas acredito que conheça o suficiente sobre Métodos Numéricos para usar esse programa por si só!' +
    #13#10#13#10 +
    'Qualquer dúvida, pode consultar nosso professor de MNC da Unesp de Bauru :D');
end;

procedure TFormPrincipal.PararCalculoClick(Sender: TObject);
begin
  interromper := True;
end;

procedure TFormPrincipal.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1.Checked then
    metodoUsado := 1
  else if RadioButton2.Checked then
    metodoUsado := 2
  else if RadioButton3.Checked then
    metodoUsado := 3
  else if RadioButton4.Checked then
    metodoUsado := 4
  else if RadioButton5.Checked then
    metodoUsado := 5
  else if RadioButton6.Checked then
    metodoUsado := 6
  else if RadioButton7.Checked then
    metodoUsado := 7
  else if RadioButton8.Checked then
    metodoUsado := 8;

  if not RadioButton5.Checked then
  begin
    CheckBox3.Checked := False;
    CheckBox3.Enabled := False;
  end
  else
    CheckBox3.Enabled := True;

  if RadioButton7.Checked or RadioButton8.Checked then
  begin
    CheckBox2.Checked := False;
    CheckBox2.Enabled := False;
  end
  else
    CheckBox2.Enabled := True;

  MontarGrade.Click;
end;

procedure TFormPrincipal.StringGrid1SelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  if RadioButton7.Checked or RadioButton8.Checked then
    if (aCol = StringGrid1.RowCount - 1) and (aRow = StringGrid1.RowCount - 1) then
      CanSelect := False;
end;

procedure TFormPrincipal.CheckBox1Change(Sender: TObject);
begin
  if calcularSistema <> CheckBox1.Checked then
    calcularSistema := not calcularSistema
  else if calcularDeterminante <> CheckBox2.Checked then
    calcularDeterminante := not calcularDeterminante
  else if calcularInversa <> CheckBox3.Checked then
    calcularInversa := not calcularInversa
  else if mostrarMatrizAumentada <> CheckBox4.Checked then
    mostrarMatrizAumentada := not mostrarMatrizAumentada;
end;

procedure TFormPrincipal.PreencherZeroClick(Sender: TObject);
var
  i, j: integer;
begin
  MontarGrade.Click;

  if RadioButton7.Checked or RadioButton8.Checked then
  begin
    for i := 1 to qtdVariaveis + 1 do
      for j := 1 to qtdVariaveis + 1 do
        if (StringGrid1.Cells[j, i] = '') then
          StringGrid1.Cells[j, i] := '0';
    StringGrid1.Cells[qtdVariaveis + 1, qtdVariaveis + 1] := '';
  end
  else
  begin
    for i := 1 to qtdVariaveis do
      for j := 1 to qtdVariaveis + 1 do
        if StringGrid1.Cells[j, i] = '' then
          StringGrid1.Cells[j, i] := '0';
  end;
end;

end.
