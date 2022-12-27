unit grafico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, TAGraph, TASeries;

type

  { TFormGrafico }

  TFormGrafico = class(TForm)
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  FormGrafico: TFormGrafico;

implementation

{$R *.lfm}

{ TFormGrafico }

procedure TFormGrafico.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  Chart1LineSeries1.Clear;
  Chart1LineSeries2.Clear;
end;

end.

