int n = 8;
int xstep = 400;
int ystep = 65;
int radius = 34;

int mode = 0;
int traversal = 0;
int highlight = -1;

PFont font;
BTree tree = new BTree();

String message = "";
String traversalResult = "";

void setup() {
  size(1200, 600);

  font = createFont("Arial", 16);
  textFont(font);
  textAlign(CENTER, CENTER);

  stroke(192, 0, 0);

  newTree();
}

void draw() {
  background(200);

  tree.assignPosition();
  tree.drawTree();

  drawInfo();
}

void mousePressed() {
  if (mouseButton != LEFT) return;

  int value = (int)(100.0 * mouseX / width);

  if (mode == 0) {
    if (tree.insert(value)) {
      message = "Inserted: " + value;
      highlight = value;
    } else {
      message = "Already exists: " + value;
    }
    tree.printTree();
  } else if (mode == 1) {
    tree.findNode();
    if (tree.value != -1) {
      int target = tree.value;
      tree.remove(target);
      message = "Deleted: " + target;
      highlight = -1;
      tree.printTree();
    } else {
      message = "Click a node to delete";
    }
  } else {
    tree.findNode();
    if (tree.value != -1) value = tree.value;
    if (tree.contains(value)) {
      message = "Found: " + value;
      highlight = value;
    } else {
      message = "Not found: " + value;
      highlight = -1;
    }
  }
}

void keyPressed() {
  if (key == 'i') {
    mode = 0;
    message = "INSERT MODE";
  } else if (key == 'd') {
    mode = 1;
    message = "DELETE MODE";
  } else if (key == 's') {
    mode = 2;
    message = "SEARCH MODE";
  } else if (key == '1') {
    traversal = 0;
    tree.printTree();
  } else if (key == '2') {
    traversal = 1;
    tree.printTree();
  } else if (key == '3') {
    traversal = 2;
    tree.printTree();
  } else if (key == 'c') {
    tree.clear();
    traversalResult = "";
    highlight = -1;
    message = "Tree cleared";
  } else if (key == 'b') {
    newTree();
  } else if (key == 'v' || key == ' ') {
    tree.printTree();
  }
}

void newTree() {
  tree.clear();
  for (int i = 0; i < n; i++) {
    tree.insert((int)random(99));
  }
  highlight = -1;
  message = "New tree created";
  tree.printTree();
}

void drawInfo() {
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);

  if (mode == 0) text("MODE: INSERT  (click: insert value = mouseX)", 20, 30);
  else if (mode == 1) text("MODE: DELETE  (click a node)", 20, 30);
  else text("MODE: SEARCH  (click a node)", 20, 30);

  textSize(15);
  text("i:Insert  d:Delete  s:Search", 20, 480);
  text("1:Inorder  2:Preorder  3:Postorder", 20, 505);
  text("c:Clear  b:New Tree  v:Print", 20, 530);

  text(message, 20, 455);
  text(traversalResult, 20, 565);

  textAlign(CENTER, CENTER);
  textSize(16);
}

class BTree {
  Node root;
  int x, y, value, index;

  void clear() {
    root = null;
    value = -1;
  }

  boolean isEmpty() {
    return root == null;
  }

  boolean contains(int in) {
    return contains(in, root);
  }

  boolean contains(int in, Node curr) {
    if (curr == null) return false;
    if (in < curr.val) return contains(in, curr.left);
    else if (in > curr.val) return contains(in, curr.right);
    else return true;
  }

  boolean insert(int in) {
    if (contains(in)) return false;
    root = insert(in, root);
    return true;
  }

  Node insert(int in, Node curr) {
    if (curr == null) return new Node(in);
    if (in < curr.val) curr.left = insert(in, curr.left);
    else if (in > curr.val) curr.right = insert(in, curr.right);
    return curr;
  }

  void remove(int in) {
    root = remove(in, root);
  }

  Node remove(int in, Node curr) {
    if (curr == null) return null;

    if (in < curr.val) {
      curr.left = remove(in, curr.left);
    } else if (in > curr.val) {
      curr.right = remove(in, curr.right);
    } else {
      if (curr.left == null && curr.right == null) return null;
      if (curr.left == null) return curr.right;
      if (curr.right == null) return curr.left;
      Node succ = findMin(curr.right);
      curr.val = succ.val;
      curr.right = remove(succ.val, curr.right);
    }
    return curr;
  }

  Node findMin(Node curr) {
    if (curr == null) return null;
    while (curr.left != null) curr = curr.left;
    return curr;
  }

  Node findMax(Node curr) {
    if (curr == null) return null;
    while (curr.right != null) curr = curr.right;
    return curr;
  }

  int treeHeight(Node curr) {
    if (curr == null) return -1;
    return 1 + max(treeHeight(curr.left), treeHeight(curr.right));
  }

  void assignPosition() {
    if (!isEmpty()) assignPosition(root, 0, 0);
  }

  void assignPosition(Node curr, float dx, float dy) {
    if (curr == null) return;
    assignPosition(curr.left, dx - 1.0 / pow(2.0, dy + 1), dy + 1);
    curr.x = dx;
    curr.y = dy;
    assignPosition(curr.right, dx + 1.0 / pow(2.0, dy + 1), dy + 1);
  }

  void printTree() {
    index = 0;
    traversalResult = "";

    if (isEmpty()) {
      traversalResult = "The tree is empty";
      println(traversalResult);
      return;
    }

    if (traversal == 0) traversalResult = "Inorder: ";
    else if (traversal == 1) traversalResult = "Preorder: ";
    else traversalResult = "Postorder: ";

    printTree(root);
    println(traversalResult);
  }

  void printTree(Node curr) {
    if (curr == null) return;

    if (traversal == 0) {
      printTree(curr.left);
      visit(curr);
      printTree(curr.right);
    } else if (traversal == 1) {
      visit(curr);
      printTree(curr.left);
      printTree(curr.right);
    } else {
      printTree(curr.left);
      printTree(curr.right);
      visit(curr);
    }
  }

  void visit(Node curr) {
    traversalResult += curr.val + " ";
    index++;
  }

  void findNode() {
    x = y = value = -1;
    if (!isEmpty()) findNode(root);
  }

  void findNode(Node curr) {
    if (curr == null || value != -1) return;

    findNode(curr.left);

    int cx = (int)(curr.x * xstep + width / 2);
    int cy = (int)(curr.y * ystep + radius);
    int dx = mouseX - cx;
    int dy = mouseY - cy;

    if (dx * dx + dy * dy < radius * radius / 4) {
      x = cx;
      y = cy;
      value = curr.val;
      return;
    }

    findNode(curr.right);
  }

  void drawTree() {
    if (!isEmpty()) {
      drawTreeLine(root);
      drawTree(root);
    }
  }

  void drawTreeLine(Node curr) {
    if (curr == null) return;

    float px = curr.x * xstep + width / 2;
    float py = curr.y * ystep + radius;

    if (curr.left != null) {
      line(px, py, curr.left.x * xstep + width / 2, curr.left.y * ystep + radius);
    }
    if (curr.right != null) {
      line(px, py, curr.right.x * xstep + width / 2, curr.right.y * ystep + radius);
    }

    drawTreeLine(curr.left);
    drawTreeLine(curr.right);
  }

  void drawTree(Node curr) {
    if (curr == null) return;

    drawTree(curr.left);

    float px = curr.x * xstep + width / 2;
    float py = curr.y * ystep + radius;

    if (curr.val == highlight) fill(255, 220, 120);
    else fill(255);
    ellipse(px, py, radius, radius);

    fill(0);
    text(curr.val, px, py);

    drawTree(curr.right);
  }
}

class Node {
  int val;
  float x, y;
  Node left;
  Node right;

  Node(int v) {
    val = v;
  }

  public String toString() {
    if (left == null && right == null) return "N(" + val + ")";
    return "N(" + val + ", " + left + ", " + right + ")";
  }
}
