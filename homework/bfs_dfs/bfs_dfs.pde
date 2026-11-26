int V = 8;

int[][] edges = {
  {0, 1}, {0, 2}, {1, 3}, {1, 4}, {2, 5}, {2, 6}, {3, 7}, {4, 7}, {5, 6}, {4, 5}
};

int[][] pos = {
  {300, 110}, {170, 230}, {430, 230}, {90, 370}, {250, 370}, {380, 370}, {520, 370}, {170, 500}
};

ArrayList<ArrayList<Integer>> adj = new ArrayList<ArrayList<Integer>>();

boolean[] visited = new boolean[V];
int[] parent = new int[V];
int[] order = new int[V];
int count = 0;

int start = 0;
String mode = "BFS";

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

void bfs(int s) {
  int[] queue = new int[V];
  int head = 0;
  int tail = 0;

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
        visited[v] = true;
        parent[v] = u;
        queue[tail] = v;
        tail++;
      }
    }
  }
}

void dfs(int u) {
  visited[u] = true;
  order[count] = u;
  count++;

  for (int k = 0; k < adj.get(u).size(); k++) {
    int v = adj.get(u).get(k);
    if (!visited[v]) {
      parent[v] = u;
      dfs(v);
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
