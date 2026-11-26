// 과제 6 - 그래프의 너비 우선 탐색(BFS)과 깊이 우선 탐색(DFS)
//
// 그래프는 인접 리스트로 표현한다. adj.get(u) 는 정점 u와 간선으로 이어진 정점들의 목록이다.
//
// BFS: 시작 정점에서 가까운 정점부터 차례로 방문한다. 큐(먼저 넣은 것이 먼저 나옴)를 쓴다.
// DFS: 한 방향으로 갈 수 있는 데까지 들어갔다가, 막히면 되돌아와 다른 방향으로 간다. 재귀 호출을 쓴다.
// 두 방법 모두 방문한 정점에 표시를 해 두어 같은 정점을 두 번 방문하지 않는다.
//
// 조작: b BFS, d DFS, 정점을 클릭하면 그 정점이 시작 정점이 된다, r 처음부터 다시 보기

int V = 8;

// 간선 목록 {정점, 정점}. 방향이 없는 그래프이므로 양쪽 인접 리스트에 모두 넣는다.
int[][] edges = {
  {0, 1}, {0, 2}, {1, 3}, {1, 4}, {2, 5}, {2, 6}, {3, 7}, {4, 7}, {5, 6}, {4, 5}
};

// 화면에 그릴 정점의 위치
int[][] pos = {
  {300, 110}, {170, 230}, {430, 230}, {90, 370}, {250, 370}, {380, 370}, {520, 370}, {170, 500}
};

ArrayList<ArrayList<Integer>> adj = new ArrayList<ArrayList<Integer>>();

boolean[] visited = new boolean[V];
int[] parent = new int[V];     // 이 정점을 어느 정점에서 발견했는가 (탐색 트리의 간선)
int[] order = new int[V];      // 방문 순서대로 정점 번호를 적어 둔다.
int count = 0;                 // 지금까지 방문한 정점 수

int start = 0;
String mode = "BFS";

// 애니메이션: order에 적힌 정점을 일정 시간마다 하나씩 화면에 드러낸다.
int shown = 0;
int lastTime = 0;
int interval = 700;

PFont font;

void setup() {
  size(900, 600);
  font = createFont("Arial", 18);
  textFont(font);
  buildGraph();
  search();
}

void buildGraph() {
  for (int u = 0; u < V; u++) adj.add(new ArrayList<Integer>());
  for (int k = 0; k < edges.length; k++) {
    int u = edges[k][0];
    int v = edges[k][1];
    adj.get(u).add(v);
    adj.get(v).add(u);
  }
  // 번호가 작은 이웃부터 방문하도록 각 리스트를 오름차순으로 정리한다.
  for (int u = 0; u < V; u++) java.util.Collections.sort(adj.get(u));

  println("adjacency list");
  for (int u = 0; u < V; u++) println("  " + u + " : " + adj.get(u));
}

void search() {
  for (int u = 0; u < V; u++) {
    visited[u] = false;
    parent[u] = -1;
  }
  count = 0;

  if (mode.equals("BFS")) bfs(start);
  else dfs(start);

  String line = mode + " from " + start + " : ";
  for (int k = 0; k < count; k++) line += order[k] + " ";
  println(line);

  shown = 0;
  lastTime = millis();
}

// ------------------------------------------------------------
// 너비 우선 탐색
// ------------------------------------------------------------
void bfs(int s) {
  int[] queue = new int[V];   // 정점은 큐에 한 번씩만 들어가므로 크기 V면 충분하다.
  int head = 0;               // 다음에 꺼낼 위치
  int tail = 0;               // 다음에 넣을 위치

  visited[s] = true;
  queue[tail] = s;
  tail++;

  while (head < tail) {
    int u = queue[head];
    head++;
    order[count] = u;
    count++;

    for (int k = 0; k < adj.get(u).size(); k++) {
      int v = adj.get(u).get(k);
      if (!visited[v]) {
        visited[v] = true;    // 큐에 넣는 순간 표시해야 같은 정점이 두 번 들어가지 않는다.
        parent[v] = u;
        queue[tail] = v;
        tail++;
      }
    }
  }
}

// ------------------------------------------------------------
// 깊이 우선 탐색
// ------------------------------------------------------------
void dfs(int u) {
  visited[u] = true;
  order[count] = u;
  count++;

  for (int k = 0; k < adj.get(u).size(); k++) {
    int v = adj.get(u).get(k);
    if (!visited[v]) {
      parent[v] = u;
      dfs(v);                 // v에서 갈 수 있는 곳을 모두 본 뒤에야 u의 다음 이웃으로 넘어간다.
    }
  }
}

void keyPressed() {
  if (key == 'b') {
    mode = "BFS";
    search();
  } else if (key == 'd') {
    mode = "DFS";
    search();
  } else if (key == 'r') {
    shown = 0;
    lastTime = millis();
  }
}

void mousePressed() {
  for (int u = 0; u < V; u++) {
    if (dist(mouseX, mouseY, pos[u][0], pos[u][1]) < 26) {
      start = u;
      search();
    }
  }
}

// 정점 u가 몇 번째로 방문되었는지 돌려준다. 아직 화면에 드러나지 않았으면 -1.
int visitNumber(int u) {
  for (int k = 0; k < shown; k++) {
    if (order[k] == u) return k + 1;
  }
  return -1;
}

void draw() {
  background(255);

  if (shown < count && millis() - lastTime > interval) {
    shown++;
    lastTime = millis();
  }

  fill(0);
  textAlign(LEFT);
  textSize(22);
  text(mode + " from vertex " + start, 30, 40);

  // 간선: 탐색이 실제로 지나간 간선(탐색 트리)은 굵게 그린다.
  for (int k = 0; k < edges.length; k++) {
    int u = edges[k][0];
    int v = edges[k][1];
    boolean tree = (parent[v] == u && visitNumber(v) != -1) || (parent[u] == v && visitNumber(u) != -1);
    if (tree) {
      stroke(230, 120, 0);
      strokeWeight(5);
    } else {
      stroke(170);
      strokeWeight(2);
    }
    line(pos[u][0], pos[u][1], pos[v][0], pos[v][1]);
  }

  // 정점: 방문한 정점은 색을 칠하고 방문 순서를 옆에 적는다.
  for (int u = 0; u < V; u++) {
    int num = visitNumber(u);
    stroke(0);
    strokeWeight(2);
    if (num == -1) fill(255);
    else if (num == shown && shown < count) fill(255, 120, 80);
    else fill(255, 210, 110);
    ellipse(pos[u][0], pos[u][1], 48, 48);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(u, pos[u][0], pos[u][1]);

    if (num != -1) {
      fill(200, 60, 0);
      textSize(15);
      text("#" + num, pos[u][0] + 36, pos[u][1] - 26);
    }
  }

  // 오른쪽: 인접 리스트
  textAlign(LEFT);
  fill(100);
  textSize(16);
  text("adjacency list", 640, 110);
  fill(0);
  for (int u = 0; u < V; u++) {
    String line = u + " :";
    for (int k = 0; k < adj.get(u).size(); k++) line += "  " + adj.get(u).get(k);
    text(line, 640, 140 + u * 26);
  }

  // 방문 순서
  fill(100);
  text("visit order", 640, 390);
  String line = "";
  for (int k = 0; k < shown; k++) line += order[k] + "  ";
  fill(200, 60, 0);
  textSize(20);
  text(line, 640, 420);

  fill(120);
  textSize(14);
  text("b: BFS    d: DFS    click a vertex: start there    r: replay", 30, 580);
}
