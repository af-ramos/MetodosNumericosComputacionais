unit metodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Math, Windows, Forms;

var
  qtdVariaveis, qtdIteracoes: integer;
  epsilon, determinante: extended;
  calcularSistema, calcularDeterminante, calcularInversa, mostrarMatrizAumentada,
  interromper, erro: boolean;
  A, AInv: array[1..20, 1..20] of extended;
  b, x, xIni: array[1..20] of extended;

procedure Gauss;
procedure GaussPivotamentoParcial;
procedure GaussPivotamentoTotal;
procedure GaussCompacto;
procedure DecomposicaoLU;
procedure Cholesky;
procedure JacobiRichardson;
procedure GaussSeidel;

implementation

function trocarValores(var a, b: integer): word;
var
  aux: integer;
begin
  aux := a;
  a := b;
  b := aux;

  Exit(0);
end;

function trocarLinhas(i, j: integer): word;
var
  aux: extended;
  k: integer;
begin
  for k := 1 to qtdVariaveis do
  begin
    aux := A[i, k];
    A[i, k] := A[j, k];
    A[j, k] := aux;
  end;

  aux := b[i];
  b[i] := b[j];
  b[j] := aux;

  Exit(0);
end;

function trocarColunas(i, j: integer): word;
var
  aux: extended;
  k: integer;
begin
  for k := 1 to qtdVariaveis do
  begin
    aux := A[k, i];
    A[k, i] := A[k, j];
    A[k, j] := aux;
  end;

  Exit(0);
end;

function calcularDistancia(var distancia: extended): word;
var
  i: integer;
  numerador, denominador: extended;
begin
  numerador := 0;
  denominador := 0;

  for i := 1 to qtdVariaveis do
  begin
    numerador := numerador + (x[i] - xIni[i]) * (x[i] - xIni[i]);
    denominador := denominador + (x[i] * x[i]);
  end;

  try
    distancia := Sqrt(numerador) / Sqrt(denominador);
  except
    Exit(1);
  end;

  Exit(0);
end;

procedure Gauss;
var
  i, j, k: integer;
  m, soma: extended;
begin
  for j := 1 to qtdVariaveis - 1 do
  begin
    for i := j + 1 to qtdVariaveis do
    begin
      try
        m := A[i, j] / A[j, j];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;

      for k := j to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        A[i, k] := A[i, k] - m * A[j, k];
      end;
      b[i] := b[i] - m * b[j];
    end;
  end;

  try
    x[qtdVariaveis] := b[qtdVariaveis] / A[qtdVariaveis, qtdVariaveis];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := qtdVariaveis - 1 downto 1 do
  begin
    soma := 0;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + A[i, j] * x[j];
    end;
    x[i] := (b[i] - soma) / A[i, i];
  end;

  if calcularDeterminante then
  begin
    determinante := 1;

    for i := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      determinante := determinante * A[i, i];
    end;
  end;

  erro := False;
end;

procedure GaussPivotamentoParcial;
var
  i, j, k, iMaior: integer;
  m, soma: extended;
begin
  for j := 1 to qtdVariaveis - 1 do
  begin
    iMaior := j;
    for k := j + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      if abs(A[k, j]) > abs(A[iMaior, j]) then
        iMaior := k;
    end;
    if iMaior <> j then
      trocarLinhas(iMaior, j);

    for i := j + 1 to qtdVariaveis do
    begin
      try
        m := A[i, j] / A[j, j];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;

      for k := j to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        A[i, k] := A[i, k] - m * A[j, k];
      end;

      b[i] := b[i] - m * b[j];
    end;
  end;

  try
    x[qtdVariaveis] := b[qtdVariaveis] / A[qtdVariaveis, qtdVariaveis];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := qtdVariaveis - 1 downto 1 do
  begin
    soma := 0;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + A[i, j] * x[j];
    end;
    x[i] := (b[i] - soma) / A[i, i];
  end;

  if calcularDeterminante then
  begin
    determinante := 1;

    for i := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      determinante := determinante * A[i, i];
    end;
  end;

  erro := False;
end;

procedure GaussPivotamentoTotal;
var
  i, j, k, l, iMaior, jMaior: integer;
  m, soma: extended;
  xTrocado: array[1..20] of integer;
  xAux: array[1..20] of extended;
begin
  for j := 1 to qtdVariaveis do
    xTrocado[j] := j;

  for j := 1 to qtdVariaveis - 1 do
  begin
    iMaior := j;
    jMaior := j;

    for k := j to qtdVariaveis do
      for l := j to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        if abs(A[k, l]) > abs(A[iMaior, jMaior]) then
        begin
          iMaior := k;
          jMaior := l;
        end;
      end;

    if iMaior <> j then
      trocarLinhas(iMaior, j);
    if jMaior <> j then
    begin
      trocarColunas(jMaior, j);
      trocarValores(xTrocado[jMaior], xTrocado[j]);
    end;

    for i := j + 1 to qtdVariaveis do
    begin
      try
        m := A[i, j] / A[j, j];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;

      for k := j to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        A[i, k] := A[i, k] - m * A[j, k];
      end;

      b[i] := b[i] - m * b[j];
    end;
  end;

  try
    x[qtdVariaveis] := b[qtdVariaveis] / A[qtdVariaveis, qtdVariaveis];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := qtdVariaveis - 1 downto 1 do
  begin
    soma := 0;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + A[i, j] * x[j];
    end;
    x[i] := (b[i] - soma) / A[i, i];
  end;

  for j := 1 to qtdVariaveis do
    xAux[xTrocado[j]] := x[j];
  for j := 1 to qtdVariaveis do
    x[j] := xAux[j];

  if calcularDeterminante then
  begin
    determinante := 1;

    for i := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      determinante := determinante * A[i, i];
    end;
  end;

  erro := False;
end;

procedure GaussCompacto;
var
  i, j, k: integer;
  somaLU, somaB: extended;
  LU: array[1..20, 1..20] of extended;
begin
  for i := 1 to qtdVariaveis do
    for j := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      LU[i, j] := 0;
    end;

  for i := 1 to qtdVariaveis do
  begin
    somaB := 0;

    for j := i to qtdVariaveis do
    begin
      somaLU := 0;

      for k := 1 to i - 1 do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        somaLU := somaLU + LU[i, k] * LU[k, j];
      end;

      LU[i, j] := A[i, j] - somaLU;
    end;

    for j := i + 1 to qtdVariaveis do
    begin
      somaLU := 0;

      for k := 1 to i - 1 do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        somaLU := somaLU + LU[j, k] * LU[k, i];
      end;

      try
        LU[j, i] := (A[j, i] - somaLU) / LU[i, i];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;
    end;

    for k := 1 to i - 1 do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      somaB := somaB + LU[i, k] * b[k];
    end;
    b[i] := b[i] - somaB;
  end;

  try
    x[qtdVariaveis] := b[qtdVariaveis] / LU[qtdVariaveis, qtdVariaveis];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := qtdVariaveis - 1 downto 1 do
  begin
    somaLU := 0;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      somaLU := somaLU + LU[i, j] * x[j];
    end;

    try
      x[i] := (b[i] - somaLU) / LU[i, i];
    except
      ShowMessage('Erro ao dividir por 0!');
      Exit;
    end;
  end;

  if calcularDeterminante then
  begin
    determinante := 1;

    for i := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      determinante := determinante * LU[i, i];
    end;
  end;

  erro := False;
end;

procedure DecomposicaoLU;
var
  i, j, k: integer;
  soma: extended;
  L, U, Id: array[1..20, 1..20] of extended;
  y: array[1..20] of extended;
begin
  for i := 1 to qtdVariaveis do
    for j := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      U[i, j] := 0;
    end;

  for i := 1 to qtdVariaveis do
    L[i, i] := 1;

  for i := 1 to qtdVariaveis do
  begin
    for j := i to qtdVariaveis do
    begin
      soma := 0;

      for k := 1 to i - 1 do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        soma := soma + L[i, k] * U[k, j];
      end;
      U[i, j] := A[i, j] - soma;
    end;

    for j := i + 1 to qtdVariaveis do
    begin
      soma := 0;

      for k := 1 to i - 1 do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        soma := soma + L[j, k] * U[k, i];
      end;

      try
        L[j, i] := (A[j, i] - soma) / U[i, i];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;
    end;
  end;

  y[1] := b[1];
  for i := 2 to qtdVariaveis do
  begin
    soma := 0;

    for j := 1 to i - 1 do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + L[i, j] * y[j];
    end;
    y[i] := b[i] - soma;
  end;

  try
    x[qtdVariaveis] := y[qtdVariaveis] / U[qtdVariaveis, qtdVariaveis];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := qtdVariaveis - 1 downto 1 do
  begin
    soma := 0;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + U[i, j] * x[j];
    end;

    try
      x[i] := (y[i] - soma) / U[i, i];
    except
      ShowMessage('Erro ao dividir por 0!');
      Exit;
    end;
  end;

  if calcularDeterminante then
  begin
    determinante := 1;

    for i := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      determinante := determinante * U[i, i];
    end;
  end;

  if calcularInversa then
  begin
    for i := 1 to qtdVariaveis do
      for j := 1 to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        Id[i, j] := IfThen(i = j, 1, 0);
      end;

    for k := 1 to qtdVariaveis do
    begin
      begin
        y[1] := Id[1, k];
        for i := 2 to qtdVariaveis do
        begin
          soma := 0;

          for j := 1 to i - 1 do
          begin
            Application.ProcessMessages;
            if interromper then
              Exit;

            soma := soma + L[i, j] * y[j];
          end;
          y[i] := Id[i, k] - soma;
        end;

        AInv[qtdVariaveis, k] := y[qtdVariaveis] / U[qtdVariaveis, qtdVariaveis];
        for i := qtdVariaveis - 1 downto 1 do
        begin
          soma := 0;

          for j := i + 1 to qtdVariaveis do
          begin
            Application.ProcessMessages;
            if interromper then
              Exit;

            soma := soma + U[i, j] * AInv[j, k];
          end;
          AInv[i, k] := (y[i] - soma) / U[i, i];
        end;
      end;
    end;
  end;

  erro := False;
end;

procedure Cholesky;
var
  i, j, k: integer;
  soma: extended;
  G: array[1..20, 1..20] of extended;
  y: array[1..20] of extended;
begin
  for i := 1 to qtdVariaveis - 1 do
  begin
    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      if A[i, j] <> A[j, i] then
      begin
        ShowMessage('A matriz A não é simétrica!');
        Exit;
      end;
    end;
  end;

  for i := 1 to qtdVariaveis do
    for j := 1 to qtdVariaveis do
      G[i, j] := 0;

  for i := 1 to qtdVariaveis do
  begin
    soma := 0;

    for j := 1 to i - 1 do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + (G[i, j] * G[i, j]);
    end;

    try
      G[i, i] := Sqrt(A[i, i] - soma);
    except
      ShowMessage('Erro ao extrair raiz negativa!');
      Exit;
    end;

    for k := i + 1 to qtdVariaveis do
    begin
      soma := 0;

      for j := 1 to i - 1 do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        soma := soma + G[k, j] * G[i, j];
      end;

      try
        G[k, i] := (A[k, i] - soma) / G[i, i];
      except
        ShowMessage('Erro ao dividir por 0!');
        Exit;
      end;
    end;
  end;

  for i := 1 to qtdVariaveis - 1 do
    for j := i + 1 to qtdVariaveis do
      G[i, j] := G[j, i];

  try
    y[1] := b[1] / G[1, 1];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := 2 to qtdVariaveis do
  begin
    soma := 0;

    for j := 1 to i - 1 do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + G[i, j] * y[j];
    end;

    try
      y[i] := (b[i] - soma) / G[i, i];
    except
      ShowMessage('Erro ao dividir por 0!');
      Exit;
    end;
  end;

  try
    x[qtdVariaveis] := y[qtdVariaveis] / G[qtdVariaveis, qtdVariaveis];
  except
    ShowMessage('Erro ao dividir por 0!');
    Exit;
  end;

  for i := qtdVariaveis - 1 downto 1 do
  begin
    soma := 0;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      soma := soma + G[i, j] * x[j];
    end;

    try
      x[i] := (y[i] - soma) / G[i, i];
    except
      ShowMessage('Erro ao dividir por 0!');
      Exit;
    end;
  end;

  if calcularDeterminante then
  begin
    determinante := 1;

    for i := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      determinante := determinante * G[i, i];
    end;
    determinante := determinante * determinante;
  end;

  erro := False;
end;

procedure JacobiRichardson;
var
  i, j, it: integer;
  CDL, CDC: boolean;
  maximo, soma, distancia: extended;
begin
  maximo := 0;
  for i := 1 to qtdVariaveis do
  begin
    soma := 0;

    for j := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      if i <> j then
        soma := soma + abs(A[i, j]);
    end;

    try
      soma := soma / abs(A[i, i]);
    except
      ShowMessage('Erro ao dividir por 0!');
      Exit;
    end;

    if maximo < soma then
      maximo := soma;
  end;
  CDL := maximo < 1;

  maximo := 0;
  for i := 1 to qtdVariaveis do
  begin
    soma := 0;

    for j := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      if i <> j then
        soma := soma + abs(A[j, i]);
    end;
    soma := soma / abs(A[i, i]);

    if maximo < soma then
      maximo := soma;
  end;
  CDC := maximo < 1;

  if not (CDL or CDC) then
  begin
    ShowMessage('A matriz não atende ao critério das linhas e ao critério das colunas!');
    Exit;
  end;

  it := 0;
  while True do
  begin
    distancia := 0;
    it := it + 1;

    if it > qtdIteracoes then
      Break;

    for i := 1 to qtdVariaveis do
    begin
      soma := 0;

      for j := 1 to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        if j <> i then
          soma := soma + A[i, j] * xIni[j];
      end;

      x[i] := (b[i] - soma) / A[i, i];
    end;

    if calcularDistancia(distancia) <> 0 then
    begin
      ShowMessage('Erro ao calcular distância entre x e xIni!');
      Exit;
    end;

    if distancia < epsilon then
      Break;

    for i := 1 to qtdVariaveis do
      xIni[i] := x[i];
  end;

  erro := False;
end;

procedure GaussSeidel;
var
  i, j, it: integer;
  maximo, soma, distancia: extended;
  beta: array[1..20] of extended;
  CDL, CDS: boolean;
begin
  maximo := 0;
  for i := 1 to qtdVariaveis do
  begin
    soma := 0;

    for j := 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      if i <> j then
        soma := soma + abs(A[i, j]);
    end;

    try
      soma := soma / abs(A[i, i]);
    except
      ShowMessage('Erro ao dividir por 0!');
      Exit;
    end;

    if maximo < soma then
      maximo := soma;
  end;
  CDL := maximo < 1;

  maximo := 0;
  for i := 1 to qtdVariaveis do
  begin
    beta[i] := 0;

    for j := 1 to i - 1 do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      beta[i] := beta[i] + abs(A[i, j] / A[i, i]) * beta[j];
    end;

    for j := i + 1 to qtdVariaveis do
    begin
      Application.ProcessMessages;
      if interromper then
        Exit;

      beta[i] := beta[i] + abs(A[i, j] / A[i, i]);
    end;

    if maximo < beta[i] then
      maximo := beta[i];
  end;
  CDS := maximo < 1;

  if not (CDL or CDS) then
  begin
    ShowMessage('A matriz não atende ao critério das linhas e ao critério de Sassenfeld!');
    Exit;
  end;

  for i := 1 to qtdVariaveis do
    x[i] := xIni[i];

  it := 0;
  while (True) do
  begin
    distancia := 0;
    it := it + 1;

    if it > qtdIteracoes then
      Break;

    for i := 1 to qtdVariaveis do
    begin
      soma := 0;

      for j := 1 to qtdVariaveis do
      begin
        Application.ProcessMessages;
        if interromper then
          Exit;

        if j <> i then
          soma := soma + A[i, j] * x[j];
      end;

      x[i] := (b[i] - soma) / A[i, i];
    end;

    if calcularDistancia(distancia) <> 0 then
    begin
      ShowMessage('Erro ao calcular a distância entre x e xIni!');
      Exit;
    end;

    if distancia < epsilon then
      Break;

    for i := 1 to qtdVariaveis do
      xIni[i] := x[i];
  end;

  erro := False;
end;

end.
