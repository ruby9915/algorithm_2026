ArrayList<SortArray> lists;
SortArray list, plist;

int napTime = 100;
int len = 16;
int index = 0;
int loop = 0;
int algo = 0;
String[] names = {"bubbleSort", "selectionSort", "insertionSort"};

boolean autoFlag = true;
PFont f;

void setup() {
  size(900, 600);
  f = createFont("Arial", 24);
  textFont(f);
  run();
}

void draw() {
  background(200);

  list = lists.get(index);
  list.draw();

  fill(0);
  text(names[algo] + "   (1/2/3: change algorithm)", 20, 40);
  text(
    "(" + nf(list.i0, 2) + "," + nf(list.j0, 2) + ") - "
    + index + "/" + loop
    + "  napTime:" + napTime + "(a/s)  SPACE:auto  r:reset",
    20, height - 20
  );

  if (autoFlag) {
    nextStep();
  }
}

void nextStep() {
  if (index == 0) {
    delay(10 * napTime);
  } else {
    delay(napTime);
  }

  if (index < loop) {
    index++;
  } else {
    index = 0;
  }
}

void keyPressed() {
  if (key == ' ') {
    autoFlag = !autoFlag;
  } else if (key == 'a') {
    if (napTime > 100) {
      napTime -= 100;
    }
  } else if (key == 's') {
    napTime += 100;
  } else if (key == 'r') {
    run();
  } else if (key == '1') {
    algo = 0;
    run();
  } else if (key == '2') {
    algo = 1;
    run();
  } else if (key == '3') {
    algo = 2;
    run();
  } else if (key == CODED) {
    autoFlag = false;

    if (keyCode == LEFT && index > 0) {
      index--;
    } else if (keyCode == RIGHT && index < loop) {
      index++;
    }
  }
}

void mousePressed() {
  autoFlag = false;

  if (mouseButton == LEFT && index > 0) {
    index--;
  } else if (mouseButton == RIGHT && index < loop) {
    index++;
  }
}

void run() {
  loop = 0;
  index = 0;

  lists = new ArrayList<SortArray>();
  lists.add(new SortArray(len, 0, -1));

  list = lists.get(0);
  list.printArray();

  if (algo == 0) {
    bubbleSort();
  } else if (algo == 1) {
    selectionSort();
  } else {
    insertionSort();
  }

  list = lists.get(loop);
  list.printArray();
}

SortArray newStep(int i0, int j0) {
  plist = lists.get(loop);
  return new SortArray(len, plist.arr, i0, j0);
}

void addStep(SortArray s) {
  lists.add(s);
  loop++;
}

void bubbleSort() {
  for (int j = 0; j < len - 1; j++) {
    for (int i = 0; i < len - j - 1; i++) {
      list = newStep(j + 1, i + 1);
      if (list.arr[i] > list.arr[i + 1]) {
        swap(list.arr, i, i + 1);
      }
      addStep(list);
    }
  }
}

void selectionSort() {
  for (int j = 0; j < len - 1; j++) {
    int last = len - 1 - j;
    int maxIdx = 0;
    for (int i = 1; i <= last; i++) {
      list = newStep(j + 1, i);
      if (list.arr[i] > list.arr[maxIdx]) {
        maxIdx = i;
      }
      addStep(list);
    }
    list = newStep(j + 1, last);
    swap(list.arr, maxIdx, last);
    addStep(list);
  }
}

void insertionSort() {
  for (int i = 1; i < len; i++) {
    int j = i;
    list = newStep(i, j);
    addStep(list);
    while (j > 0 && list.arr[j - 1] > list.arr[j]) {
      list = newStep(i, j - 1);
      swap(list.arr, j - 1, j);
      addStep(list);
      j--;
    }
  }
}

void swap(int[] arr, int i, int j) {
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

class SortArray {
  int i0, j0, len, max, w;
  int[] arr;

  SortArray(int len, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    arr = new int[len];
    w = (width - 4) / len;

    shuffle();
  }

  SortArray(int len, int[] arr, int i0, int j0) {
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    this.arr = new int[len];
    w = (width - 4) / len;

    for (int i = 0; i < len; i++) {
      this.arr[i] = arr[i];
    }
  }

  void draw() {
    for (int i = 0; i < len; i++) {
      if (j0 == i) {
        fill(64);
      } else {
        fill(128);
      }

      int x = i * w + 2;
      int h = arr[i];
      int y = height - 5 * h - 60;

      rect(x, y, w, 5 * h);
    }
  }

  void shuffle() {
    for (int i = 0; i < len; i++) {
      arr[i] = (int) random(max);
    }
  }

  void printArray() {
    print("(" + nf(i0, 2) + "," + nf(j0, 2) + ")- ");

    for (int i = 0; i < len; i++) {
      print(nf(arr[i], 2) + " ");
    }

    println();
  }
}
