// 과제 4 - 스택을 이용한 중위 표기식 -> 후위 표기식 변환 계산기
//
// 중위 표기식(infix)  : 연산자가 두 숫자 사이에 있다.   예) (1+2)*3
// 후위 표기식(postfix): 연산자가 두 숫자 뒤에 있다.     예) 1 2 + 3 *
//
// 1) 변환: 숫자는 바로 출력하고, 연산자는 스택에 잠시 넣어 두었다가
//          자기보다 우선순위가 낮은 연산자가 올 때까지 기다린 뒤 꺼낸다.
// 2) 계산: 후위 표기식을 앞에서부터 읽으며 숫자는 스택에 넣고,
//          연산자를 만나면 숫자 두 개를 꺼내 계산한 결과를 다시 넣는다.
//
// 조작: 식을 입력하고 ENTER, BACKSPACE 한 글자 지우기, DELETE 전부 지우기
// 지원: + - * / ^ ( ), 여러 자리 수, 소수, 음수 부호(후위 표기식에서는 ~ 로 표시)

String input = "(1+2)*3-8/4";
String infixText = "";
String postfixText = "";
String resultText = "";
String errorText = "";

// 변환 과정을 한 줄씩 기록한다. {읽은 토큰, 그때의 스택, 그때까지의 출력}
ArrayList<String[]> trace = new ArrayList<String[]>();

PFont font;

void setup() {
  size(900, 660);
  font = createFont("Arial", 18);
  textFont(font);
  calculate();
}

void draw() {
  background(255);
  textAlign(LEFT);

  fill(0);
  textSize(22);
  text("Infix to Postfix Calculator (using stack)", 30, 40);

  // 입력 칸
  stroke(0);
  strokeWeight(1);
  fill(245);
  rect(30, 58, 840, 40);
  fill(0);
  textSize(20);
  String cursor = "";
  if ((frameCount / 30) % 2 == 0) cursor = "_";
  text(input + cursor, 42, 85);

  // 결과
  textSize(18);
  fill(100);
  text("Infix", 30, 135);
  text("Postfix", 30, 165);
  text("Result", 30, 195);
  fill(0);
  text(infixText, 130, 135);
  fill(0, 110, 60);
  text(postfixText, 130, 165);
  fill(200, 60, 0);
  text(resultText, 130, 195);

  if (errorText.length() > 0) {
    fill(220, 0, 0);
    text("Error: " + errorText, 30, 225);
  }

  drawTrace();

  fill(120);
  textSize(14);
  text("ENTER: calculate    BACKSPACE: delete one    DELETE: clear    ( ~ means unary minus )", 30, 645);
}

// 변환 과정 표: 토큰 하나를 읽을 때마다 스택과 출력이 어떻게 바뀌는지 보여 준다.
void drawTrace() {
  int top = 265;
  int rowH = 22;
  int maxRows = 15;

  fill(100);
  textSize(16);
  text("Token", 30, top);
  text("Stack (bottom -> top)", 130, top);
  text("Output", 420, top);
  stroke(180);
  line(30, top + 8, 870, top + 8);

  fill(0);
  for (int i = 0; i < trace.size() && i < maxRows; i++) {
    String[] row = trace.get(i);
    int y = top + 30 + i * rowH;
    text(row[0], 30, y);
    text(row[1], 130, y);
    text(row[2], 420, y);
  }
  if (trace.size() > maxRows) {
    fill(120);
    text("... (see the console for all " + trace.size() + " steps)", 30, top + 30 + maxRows * rowH);
  }
}

void keyPressed() {
  if (key == CODED) return;

  if (key == ENTER || key == RETURN) {
    calculate();
  } else if (key == BACKSPACE) {
    if (input.length() > 0) input = input.substring(0, input.length() - 1);
  } else if (key == DELETE) {
    input = "";
  } else if ("0123456789.+-*/^() ".indexOf(key) >= 0 && input.length() < 60) {
    input += key;
  }
}

void calculate() {
  infixText = "";
  postfixText = "";
  resultText = "";
  errorText = "";
  trace.clear();

  try {
    ArrayList<String> tokens = tokenize(input);
    infixText = joinTokens(tokens);

    ArrayList<String> postfix = infixToPostfix(tokens);
    postfixText = joinTokens(postfix);

    double value = evaluate(postfix);
    resultText = formatNumber(value);

    println("infix   : " + infixText);
    println("postfix : " + postfixText);
    println("result  : " + resultText);
    for (int i = 0; i < trace.size(); i++) {
      String[] row = trace.get(i);
      println("  [" + row[0] + "]  stack: " + row[1] + "   output: " + row[2]);
    }
    println("");
  }
  catch (RuntimeException e) {
    errorText = e.getMessage();
    println("error   : " + errorText);
  }
}

// ------------------------------------------------------------
// 1. 글자들을 토큰(숫자 하나, 연산자 하나, 괄호 하나)으로 나눈다.
// ------------------------------------------------------------
ArrayList<String> tokenize(String expr) {
  ArrayList<String> tokens = new ArrayList<String>();
  int i = 0;

  while (i < expr.length()) {
    char c = expr.charAt(i);

    if (c == ' ') {
      i++;
    } else if (isDigitChar(c)) {
      // 숫자나 소수점이 이어지는 동안 한 덩어리로 읽는다.
      String number = "";
      int dots = 0;
      while (i < expr.length() && isDigitChar(expr.charAt(i))) {
        if (expr.charAt(i) == '.') dots++;
        number += expr.charAt(i);
        i++;
      }
      if (dots > 1 || number.equals(".")) throw new RuntimeException("bad number " + number);
      tokens.add(number);
    } else if (c == '-' || c == '+') {
      // 식의 맨 앞, 여는 괄호 뒤, 다른 연산자 뒤에 나온 - 는 뺄셈이 아니라 부호다.
      boolean unary = tokens.size() == 0;
      if (!unary) {
        String prev = tokens.get(tokens.size() - 1);
        unary = prev.equals("(") || isOperator(prev);
      }
      if (!unary) tokens.add(str(c));
      else if (c == '-') tokens.add("~");   // 부호 + 는 아무 일도 하지 않으므로 버린다.
      i++;
    } else if (c == '*' || c == '/' || c == '^' || c == '(' || c == ')') {
      tokens.add(str(c));
      i++;
    } else {
      throw new RuntimeException("unknown character " + c);
    }
  }

  if (tokens.size() == 0) throw new RuntimeException("empty expression");
  return tokens;
}

boolean isDigitChar(char c) {
  return (c >= '0' && c <= '9') || c == '.';
}

boolean isOperator(String t) {
  return t.equals("+") || t.equals("-") || t.equals("*") || t.equals("/") || t.equals("^") || t.equals("~");
}

// 우선순위: 숫자가 클수록 먼저 계산한다.
int priority(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  if (op.equals("~")) return 3;
  if (op.equals("^")) return 4;
  return 0;
}

// ------------------------------------------------------------
// 2. 중위 표기식 -> 후위 표기식 (연산자 스택 사용)
// ------------------------------------------------------------
ArrayList<String> infixToPostfix(ArrayList<String> tokens) {
  ArrayList<String> output = new ArrayList<String>();
  StringStack stack = new StringStack();

  for (int i = 0; i < tokens.size(); i++) {
    String t = tokens.get(i);

    if (t.equals("(")) {
      // 여는 괄호는 무조건 스택에 넣는다.
      stack.push(t);
    } else if (t.equals(")")) {
      // 닫는 괄호: 여는 괄호가 나올 때까지 스택의 연산자를 모두 출력으로 옮긴다.
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        output.add(stack.pop());
      }
      if (stack.isEmpty()) throw new RuntimeException("missing (");
      stack.pop();   // 여는 괄호는 출력하지 않고 버린다.
    } else if (t.equals("~")) {
      // 부호는 뒤에 오는 값에 붙으므로 앞의 연산자를 꺼내지 않고 넣기만 한다.
      stack.push(t);
    } else if (isOperator(t)) {
      // 스택 맨 위 연산자가 나보다 먼저 계산되어야 하면 출력으로 옮긴다.
      // 우선순위가 같으면 왼쪽부터 계산하므로 옮기되, ^ 는 오른쪽부터 계산하므로 옮기지 않는다.
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        int p = priority(stack.peek());
        int q = priority(t);
        if (p > q || (p == q && !t.equals("^"))) output.add(stack.pop());
        else break;
      }
      stack.push(t);
    } else {
      // 숫자는 바로 출력한다.
      output.add(t);
    }

    String[] row = {t, stack.show(), joinTokens(output)};
    trace.add(row);
  }

  // 남아 있는 연산자를 모두 출력으로 옮긴다.
  while (!stack.isEmpty()) {
    String op = stack.pop();
    if (op.equals("(")) throw new RuntimeException("missing )");
    output.add(op);
  }
  String[] last = {"end", "", joinTokens(output)};
  trace.add(last);

  return output;
}

// ------------------------------------------------------------
// 3. 후위 표기식 계산 (숫자 스택 사용)
// ------------------------------------------------------------
double evaluate(ArrayList<String> postfix) {
  NumberStack stack = new NumberStack();

  for (int i = 0; i < postfix.size(); i++) {
    String t = postfix.get(i);

    if (t.equals("~")) {
      if (stack.size() < 1) throw new RuntimeException("operand is missing");
      stack.push(-stack.pop());
    } else if (isOperator(t)) {
      if (stack.size() < 2) throw new RuntimeException("operand is missing");
      double b = stack.pop();   // 나중에 넣은 것이 오른쪽 숫자
      double a = stack.pop();
      if (t.equals("+")) stack.push(a + b);
      else if (t.equals("-")) stack.push(a - b);
      else if (t.equals("*")) stack.push(a * b);
      else if (t.equals("/")) {
        if (b == 0) throw new RuntimeException("division by zero");
        stack.push(a / b);
      } else stack.push(Math.pow(a, b));
    } else {
      stack.push(Double.parseDouble(t));
    }
  }

  if (stack.size() != 1) throw new RuntimeException("operator is missing");
  return stack.pop();
}

String joinTokens(ArrayList<String> list) {
  String s = "";
  for (int i = 0; i < list.size(); i++) {
    if (i > 0) s += " ";
    s += list.get(i);
  }
  return s;
}

// 정수로 떨어지면 정수로, 아니면 소수점 아래 6자리까지 보여 준다.
String formatNumber(double v) {
  if (Double.isNaN(v) || Double.isInfinite(v)) return "not a number";
  if (v == Math.rint(v) && Math.abs(v) < 1e15) return "" + (long) v;
  String s = String.format("%.6f", v);
  while (s.endsWith("0")) s = s.substring(0, s.length() - 1);
  return s;
}

// ------------------------------------------------------------
// 스택: 배열 하나와 맨 위 위치(top)만으로 만든다. 나중에 넣은 것이 먼저 나온다.
// ------------------------------------------------------------
class StringStack {
  String[] data = new String[100];
  int top = -1;          // 비어 있으면 -1

  void push(String s) {
    top++;
    data[top] = s;
  }

  String pop() {
    String s = data[top];
    top--;
    return s;
  }

  String peek() {
    return data[top];
  }

  boolean isEmpty() {
    return top == -1;
  }

  String show() {
    String s = "";
    for (int i = 0; i <= top; i++) s += data[i] + " ";
    return s;
  }
}

class NumberStack {
  double[] data = new double[100];
  int top = -1;

  void push(double v) {
    top++;
    data[top] = v;
  }

  double pop() {
    double v = data[top];
    top--;
    return v;
  }

  int size() {
    return top + 1;
  }
}
