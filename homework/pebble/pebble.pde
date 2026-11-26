int[][] example = {
  { 6,  7, 12, -5,  5,  3, 11,  3},
  {-8, 10, 14,  9,  7, 13,  8,  5},
  {11, 12,  7,  4,  8, -2,  9,  4}
};

int n = 8;
int[][] w = new int[3][n];

boolean[][] pattern = {
  {true, false, false},
  {false, true, false},
  {false, false, true},
  {true, false, true}
};

boolean[][] compatible = {
  {false, true, true, false},
  {true, false, true, true},
  {true, true, false, false},
  {false, true, false, false}
};

int[][] c = new int[n][4];
int[][] from = new int[n][4];
int[] chosen = new int[n];
int best;

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

int score(int i, int p) {
  int sum = 0;
  for (int r = 0; r < 3; r++) {
    if (pattern[p][r]) sum += w[r][i];
  }
  return sum;
}

void solve() {
  for (int p = 0; p < 4; p++) {
    c[0][p] = score(0, p);
    from[0][p] = -1;
  }

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

  int last = 0;
  for (int p = 1; p < 4; p++) {
    if (c[n - 1][p] > c[n - 1][last]) last = p;
  }
  best = c[n - 1][last];

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
