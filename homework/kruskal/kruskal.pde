// 과제 7 - 최소 신장 트리: 크루스칼(Kruskal) 알고리즘
//
// 신장 트리      : 그래프의 모든 정점을 사이클 없이 잇는 간선들의 모음. 정점이 V개면 간선은 V-1개다.
// 최소 신장 트리 : 신장 트리 가운데 간선 가중치의 합이 가장 작은 것.
//
// 크루스칼 알고리즘
//   1) 모든 간선을 가중치가 작은 순서로 정렬한다.
//   2) 작은 간선부터 하나씩 본다. 그 간선의 두 끝 정점이 아직 서로 다른 무리에 속해 있으면
//      간선을 고르고 두 무리를 하나로 합친다. 이미 같은 무리라면 사이클이 생기므로 버린다.
//   3) 간선을 V-1개 고르면 끝난다.
// "같은 무리인가"와 "두 무리를 합친다"는 서로소 집합(Disjoint Set, Union-Find)으로 처리한다.
//
// 조작: SPACE 또는 -> 다음 간선, <- 이전 간선, a 자동 진행 켜기/끄기, r 처음으로

int V = 7;

// 간선 목록 {정점, 정점, 가중치}
int[][] edges = {
  {0, 1, 7}, {0, 3, 5}, {1, 2, 8}, {1, 3, 9}, {1, 4, 7}, {2, 4, 5},
  {3, 4, 15}, {3, 5, 6}, {4, 5, 8}, {4, 6, 9}, {5, 6, 11}
};
int E = edges.length;

// 화면에 그릴 정점의 위치
int[][] pos = {
  {90, 150}, {290, 100}, {490, 150}, {190, 300}, {390, 300}, {280, 470}, {500, 460}
};

int[][] sorted = new int[E][3];   // 가중치 순으로 정렬한 간선
int[] status = new int[E];        // 정렬된 간선마다: 1 고름, 2 버림(사이클), 0 볼 필요 없었음
int examined = 0;                 // 알고리즘이 실제로 살펴본 간선 수
int total = 0;                    // 최소 신장 트리의 가중치 합

// 서로소 집합
int[] parent = new int[V];        // parent[x] == x 이면 x가 그 무리의 대표
int[] rank = new int[V];          // 무리(트리)의 대략적인 높이

int step = 0;                     // 화면에 드러낸 간선 수
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

// ------------------------------------------------------------
// 서로소 집합 (Union-Find)
// ------------------------------------------------------------
void makeSet(int x) {
  parent[x] = x;
  rank[x] = 0;
}

// x가 속한 무리의 대표를 찾는다. 찾는 길에 만난 정점들을 대표에 바로 붙여 다음 검색을 빠르게 한다.
int findSet(int x) {
  if (parent[x] != x) parent[x] = findSet(parent[x]);
  return parent[x];
}

// 두 무리를 합친다. 낮은 쪽을 높은 쪽 아래에 붙여 트리가 불필요하게 높아지지 않게 한다.
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

// ------------------------------------------------------------
// 크루스칼 알고리즘
// ------------------------------------------------------------
void kruskal() {
  // 1) 간선을 가중치 순으로 정렬한다. (삽입 정렬)
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

  // 2) 처음에는 모든 정점이 혼자서 한 무리다.
  for (int x = 0; x < V; x++) makeSet(x);

  // 3) 작은 간선부터 살펴본다.
  int picked = 0;
  total = 0;
  examined = 0;
  println("sorted edges");
  for (int k = 0; k < E; k++) {
    status[k] = 0;
    if (picked == V - 1) continue;    // 이미 V-1개를 골랐으면 남은 간선은 볼 필요가 없다.

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

  // 간선
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

    // 가중치는 간선의 가운데에 적는다.
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

  // 정점
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

  // 오른쪽: 정렬된 간선 목록과 판정
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
