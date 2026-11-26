// 과제 5 - 조약돌 놓기 문제 (동적 계획법)
//
// 3행 n열 표의 각 칸에 숫자가 적혀 있다. 조약돌을 놓은 칸의 숫자 합이 가장 크게 하려 한다.
// 조건 1) 가로나 세로로 붙어 있는 두 칸에 동시에 돌을 놓을 수 없다.
// 조건 2) 모든 열에 적어도 하나의 돌을 놓아야 한다.
//
// 한 열에 돌을 놓는 방법(패턴)은 4가지뿐이다.
//   패턴 1: 위 칸만   패턴 2: 가운데 칸만   패턴 3: 아래 칸만   패턴 4: 위 칸과 아래 칸
// 옆 열과 가로로 겹치면 안 되므로 서로 이웃할 수 있는 패턴이 정해져 있다.
//   1 옆에는 2, 3 / 2 옆에는 1, 3, 4 / 3 옆에는 1, 2 / 4 옆에는 2
//
// c[i][p] = 0열부터 i열까지 놓되 i열을 패턴 p로 놓았을 때 얻을 수 있는 가장 큰 합
// c[i][p] = (i열을 패턴 p로 놓은 점수) + (p와 이웃할 수 있는 패턴 q 가운데 c[i-1][q]가 가장 큰 값)
// 왼쪽 열부터 차례로 채우면 같은 계산을 되풀이하지 않는다.
//
// 조작: r 새로운 무작위 표, o 처음의 예제 표로 되돌리기

int[][] example = {
  { 6,  7, 12, -5,  5,  3, 11,  3},
  {-8, 10, 14,  9,  7, 13,  8,  5},
  {11, 12,  7,  4,  8, -2,  9,  4}
};

int n = 8;
int[][] w = new int[3][n];      // 표의 숫자

// pattern[p][r] : 패턴 p가 r행에 돌을 놓는가
boolean[][] pattern = {
  {true, false, false},
  {false, true, false},
  {false, false, true},
  {true, false, true}
};

// compatible[p][q] : 패턴 p와 q가 옆 열에 나란히 올 수 있는가
boolean[][] compatible = {
  {false, true, true, false},
  {true, false, true, true},
  {true, true, false, false},
  {false, true, false, false}
};

int[][] c = new int[n][4];       // 동적 계획법 표
int[][] from = new int[n][4];    // c[i][p]를 만들 때 고른 앞 열의 패턴 (거꾸로 따라가기 위한 기록)
int[] chosen = new int[n];       // 최적해에서 각 열이 쓰는 패턴
int best;                        // 최대 합

PFont font;

void setup() {
  size(900, 600);
  font = createFont("Arial", 18);
  textFont(font);
  useExample();
}

void useExample() {
  for (int r = 0; r < 3; r++) {
    for (int i = 0; i < n; i++) w[r][i] = example[r][i];
  }
  solve();
}

void keyPressed() {
  if (key == 'r') {
    for (int r = 0; r < 3; r++) {
      for (int i = 0; i < n; i++) w[r][i] = (int) random(-10, 16);
    }
    solve();
  } else if (key == 'o') {
    useExample();
  }
}

// i열을 패턴 p로 놓았을 때 그 열에서 얻는 점수
int score(int i, int p) {
  int sum = 0;
  for (int r = 0; r < 3; r++) {
    if (pattern[p][r]) sum += w[r][i];
  }
  return sum;
}

void solve() {
  // 첫 열은 앞 열이 없으므로 그 열의 점수가 그대로 답이다.
  for (int p = 0; p < 4; p++) {
    c[0][p] = score(0, p);
    from[0][p] = -1;
  }

  // 둘째 열부터는 바로 앞 열의 값만 보면 된다.
  for (int i = 1; i < n; i++) {
    for (int p = 0; p < 4; p++) {
      int bestQ = -1;
      for (int q = 0; q < 4; q++) {
        if (!compatible[p][q]) continue;
        if (bestQ == -1 || c[i - 1][q] > c[i - 1][bestQ]) bestQ = q;
      }
      c[i][p] = c[i - 1][bestQ] + score(i, p);
      from[i][p] = bestQ;
    }
  }

  // 마지막 열의 네 값 가운데 가장 큰 것이 답이다.
  int last = 0;
  for (int p = 1; p < 4; p++) {
    if (c[n - 1][p] > c[n - 1][last]) last = p;
  }
  best = c[n - 1][last];

  // 기록해 둔 from을 마지막 열부터 거꾸로 따라가면 실제로 돌을 놓는 위치가 나온다.
  int p = last;
  for (int i = n - 1; i >= 0; i--) {
    chosen[i] = p;
    p = from[i][p];
  }

  printResult();
}

void printResult() {
  println("table");
  for (int r = 0; r < 3; r++) {
    String line = "  ";
    for (int i = 0; i < n; i++) line += pad(w[r][i]) + " ";
    println(line);
  }
  println("c[i][p]");
  for (int p = 0; p < 4; p++) {
    String line = "  pattern " + (p + 1) + " : ";
    for (int i = 0; i < n; i++) line += pad(c[i][p]) + " ";
    println(line);
  }
  String line = "chosen pattern : ";
  for (int i = 0; i < n; i++) line += (chosen[i] + 1) + " ";
  println(line);
  println("max sum = " + best);
  println("");
}

// 숫자를 네 칸 너비로 맞춘다.
String pad(int v) {
  String s = "" + v;
  while (s.length() < 4) s = " " + s;
  return s;
}

void draw() {
  background(255);
  int left = 190;
  int cell = 80;

  fill(0);
  textAlign(LEFT);
  textSize(22);
  text("Pebble Placement Problem (dynamic programming)", 30, 40);

  // 위쪽: 숫자 표와 돌을 놓은 칸
  int top = 70;
  int rowH = 60;
  textSize(16);
  fill(100);
  text("table", 30, top + 35);
  for (int r = 0; r < 3; r++) {
    for (int i = 0; i < n; i++) {
      int x = left + i * cell;
      int y = top + r * rowH;
      stroke(0);
      strokeWeight(1);
      fill(255);
      rect(x, y, cell, rowH);
      boolean stone = pattern[chosen[i]][r];
      if (stone) {
        noStroke();
        fill(255, 200, 60);
        ellipse(x + cell / 2, y + rowH / 2, 48, 48);
      }
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(20);
      text(w[r][i], x + cell / 2, y + rowH / 2);
    }
  }

  // 아래쪽: c[i][p] 표. 최적해가 지나간 칸을 색으로 표시한다.
  int top2 = 310;
  int rowH2 = 46;
  textAlign(LEFT);
  textSize(16);
  fill(100);
  text("c[i][p]", 30, top2 - 12);
  for (int i = 0; i < n; i++) {
    textAlign(CENTER);
    text("i=" + (i + 1), left + i * cell + cell / 2, top2 - 12);
  }
  for (int p = 0; p < 4; p++) {
    textAlign(LEFT);
    fill(100);
    text("pattern " + (p + 1), 30, top2 + p * rowH2 + 29);
    for (int i = 0; i < n; i++) {
      int x = left + i * cell;
      int y = top2 + p * rowH2;
      stroke(0);
      strokeWeight(1);
      if (chosen[i] == p) fill(255, 225, 140);
      else fill(255);
      rect(x, y, cell, rowH2);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(18);
      text(c[i][p], x + cell / 2, y + rowH2 / 2);
    }
  }

  textAlign(LEFT);
  fill(200, 60, 0);
  textSize(22);
  text("max sum = " + best, 30, 540);

  fill(120);
  textSize(14);
  text("r: random table    o: original example", 30, 580);
}
