unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

const
  COMMA_SIGN = '.';

type

  TOperation  = (opNone, opAdd, opSubstract, opMultiple, opDivide);

  { TfrmCalc }

  TfrmCalc = class(TForm)
    btn0: TButton;
    btn1: TButton;
    btnResult: TButton;
    btnDivide: TButton;
    btnComma: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btnMultiple: TButton;
    btnSign: TButton;
    btnClear: TButton;
    btnSubstract: TButton;
    btnAdd: TButton;
    edtDisplay: TEdit;
    procedure btnDigitClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnCommaClick(Sender: TObject);
    procedure btnOperateClick(Sender: TObject);
    procedure btnSignClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

  TCalc = class
    memory: real;
    number: TEdit;
    operation: TOperation;
    changed: boolean;

    constructor Create(Display: TEdit);
    procedure AddDigit(c: char);
    procedure AddComma;
    procedure ChangeSign;
    procedure Clear;
    procedure Operate(b: byte);
  end;

var
  frmCalc: TfrmCalc;

  Calc: TCalc;

implementation

{$R *.lfm}

{ TfrmCalc }

constructor TCalc.Create(Display: TEdit);
begin
  number := Display;
  Clear;
end;

procedure TCalc.AddDigit(c: char);
begin
  if (number.text = '0') or (not changed) then
    number.text := '';
  number.text := number.text + c;
  changed := true;
end;

procedure TCalc.AddComma;
begin
  if not changed then
    number.text := '0';
  if pos(COMMA_SIGN, number.text) = 0 then
    number.text := number.text + COMMA_SIGN;
  changed := true;
end;

procedure TCalc.ChangeSign;
begin
  if not changed then
    number.text := '0';
  if StrToFloat(number.text) <> 0 then
  begin
    if number.text[1] = '-' then
      number.text := copy(number.text, 2, length(number.text) - 1)
    else
      number.text := '-' + number.text;
  end;
  changed := true;
end;

procedure TCalc.Clear;
begin
  number.text := '0';
  memory := 0;
  operation := opNone;
  changed := false;
end;

procedure TCalc.Operate(b: byte);
var
  n: real;
begin
  if (operation = opNone) then
    memory := StrToFloat(number.text)
  else if changed then
  begin
    n := StrToFloat(number.text);
    case operation of
      opAdd: memory := memory + n;
      opSubstract: memory := memory - n;
      opMultiple: memory := memory * n;
      opDivide: begin
         if n = 0 then
         begin
           ShowMessage('Division by zero!');
           Exit;
         end;
         memory := memory / n;
      end;
    end;
    number.text := FloatToStr(memory);
  end;
  changed := false;
  operation := TOperation(b);
end;

procedure TfrmCalc.FormCreate(Sender: TObject);
begin
  Calc := TCalc.Create(edtDisplay);
  DefaultFormatSettings.DecimalSeparator := COMMA_SIGN;
end;

procedure TfrmCalc.btnDigitClick(Sender: TObject);
begin
  Calc.AddDigit((Sender as TButton).Caption[1]);
end;

procedure TfrmCalc.btnClearClick(Sender: TObject);
begin
  Calc.Clear;
end;

procedure TfrmCalc.btnCommaClick(Sender: TObject);
begin
  Calc.AddComma;
end;

procedure TfrmCalc.btnOperateClick(Sender: TObject);
begin
  Calc.Operate((Sender as TButton).Tag)
end;

procedure TfrmCalc.btnSignClick(Sender: TObject);
begin
  Calc.ChangeSign;
end;

end.

