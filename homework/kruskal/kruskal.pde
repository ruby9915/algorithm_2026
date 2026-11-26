int V = 7;

int[][] edges = {
  {0, 1, 7}, {0, 3, 5}, {1, 2, 8}, {1, 3, 9}, {1, 4, 7}, {2, 4, 5},
  {3, 4, 15}, {3, 5, 6}, {4, 5, 8}, {4, 6, 9}, {5, 6, 11}
};
int E = edges.length;

int[][] pos = {
  {90, 150}, {290, 100}, {490, 150}, {190, 300}, {390, 300}, {280, 470}, {500, 460}
};

int[][] sorted = new int[E][3];
int[] status = new int[E];
int examined = 0;
int total = 0;

int[] parent = new int[V];
int[] rank = new int[V];

int step = 0;
boolean auto = false;
int lastTime = 0;
int interval = 900;

PFont font;

void setup() {
  size(900, 600);
  font = createFont("Arial", 18);
  textFont(font);
  kruskal();
}

void makeSet(int x) {
  parent[x] = x;
  rank[x] = 0;
}

int findSet(int x) {
  if (parent[x] != x) parent[x] = findSet(parent[x]);
  return parent[x];
}

void union(int x, int y) {
  int a = findSet(x);
  int b = findSet(y);
  if (a == b) return;
  if (rank[a] < rank[b]) {
    parent[a] = b;
  } else {
    parent[b] = a;
    if (rank[a] == rank[b]) rank[a]++;
  }
}

void kruskal() {
  for (int k = 0; k < E; k++) {
    for (int c = 0; c < 3; c++) sorted[k][c] = edges[k][c];
  }
  for (int i = 1; i < E; i++) {
    int[] item = sorted[i];
    int j = i - 1;
    while (j >= 0 && sorted[j][2] > item[2]) {
      sorted[j + 1] = sorted[j];
      j--;
    }
    sorted[j + 1] = item;
  }

  for (int x = 0; x < V; x++) makeSet(x);

  int picked = 0;
  total = 0;
  examined = 0;
  println("sorted edges");
  for (int k = 0; k < E; k++) {
    status[k] = 0;
    if (picked == V - 1) continue;

    int u = sorted[k][0];
    int v = sorted[k][1];
    int w = sorted[k][2];
    examined++;

    if (findSet(u) != findSet(v)) {
      union(u, v);
      status[k] = 1;
      picked++;
      total += w;
      println("  (" + u + ", " + v + ")  weight " + w + "  -> pick");
    } else {
      status[k] = 2;
      println("  (" + u + ", " + v + ")  weight " + w + "  -> skip (cycle)");
    }
  }
  println("total weight = " + total);
}

void keyPressed() {
  if (key == ' ' || (key == CODED && keyCode == RIGHT)) {
    if (step < examined) step++;
  } else if (key == CODED && keyCode == LEFT) {
    if (step > 0) step--;
  } else if (key == 'a') {
    auto = !auto;
    lastTime = millis();
  } else if (key == 'r') {
    step = 0;
    auto = false;
  }
}

void draw() {
  background(255);

  if (auto && step < examined && millis() - lastTime > interval) {
    step++;
    lastTime = millis();
  }

  fill(0);
  textAlign(LEFT);
  textSize(22);
  text("Minimum Spanning Tree - Kruskal's Algorithm", 30, 40);

  int sum = 0;
  for (int k = 0; k < E; k++) {
    int u = sorted[k][0];
    int v = sorted[k][1];
    int w = sorted[k][2];
    boolean seen = k < step;

    if (seen && status[k] == 1) {
      stroke(0, 150, 80);
      strokeWeight(6);
      sum += w;
    } else if (seen && status[k] == 2) {
      stroke(230, 150, 150);
      strokeWeight(2);
    } else {
      stroke(170);
      strokeWeight(2);
    }
    line(pos[u][0], pos[u][1], pos[v][0], pos[v][1]);

    int mx = (pos[u][0] + pos[v][0]) / 2;
    int my = (pos[u][1] + pos[v][1]) / 2;
    noStroke();
    fill(255);
    ellipse(mx, my, 30, 30);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(w, mx, my);
  }

  for (int x = 0; x < V; x++) {
    stroke(0);
    strokeWeight(2);
    fill(255, 225, 140);
    ellipse(pos[x][0], pos[x][1], 46, 46);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(x, pos[x][0], pos[x][1]);
  }

  textAlign(LEFT);
  textSize(16);
  fill(100);
  text("edges sorted by weight", 620, 100);
  for (int k = 0; k < E; k++) {
    int y = 130 + k * 28;
    String label = "(" + sorted[k][0] + ", " + sorted[k][1] + ")   " + sorted[k][2];
    if (k == step - 1) {
      noStroke();
      fill(235);
      rect(612, y - 19, 260, 26);
    }
    if (k >= step) {
      fill(150);
      text(label, 620, y);
    } else if (status[k] == 1) {
      fill(0, 150, 80);
      text(label, 620, y);
      text("pick", 760, y);
    } else if (status[k] == 2) {
      fill(210, 80, 80);
      text(label, 620, y);
      text("skip (cycle)", 760, y);
    }
  }

  fill(200, 60, 0);
  textSize(22);
  if (step == examined) text("total weight = " + sum + "  (done)", 620, 480);
  else text("total weight = " + sum, 620, 480);

  fill(120);
  textSize(14);
  text("SPACE or ->: next edge    <-: previous    a: auto    r: reset", 30, 580);
}
