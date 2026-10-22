// 정렬 애니메이션
// 정렬이 진행되는 동안 배열의 상태를 단계마다 통째로 복사해 ArrayList에 모아 두고,
// 그 순서대로 다시 그려서 애니메이션처럼 보여 준다.
//
// 조작: SPACE 자동재생 켜기/끄기, a 빠르게, s 느리게, r 새 배열로 다시 시작
//       <- -> 또는 마우스 왼쪽/오른쪽 클릭: 한 단계씩 이동
//       1 bubble sort, 2 selection sort, 3 insertion sort

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

// 직전 단계의 배열을 복사해 새 단계를 만든다. i0, j0은 화면에 표시할 회차/위치.
SortArray newStep(int i0, int j0) {
  plist = lists.get(loop);
  return new SortArray(len, plist.arr, i0, j0);
}

void addStep(SortArray s) {
  lists.add(s);
  loop++;
}

// 버블 정렬: 이웃한 두 값을 비교해 왼쪽이 크면 교환. 한 회차가 끝나면 가장 큰 값이 오른쪽 끝에 확정.
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

// 선택 정렬: 아직 정렬되지 않은 구간에서 최댓값을 찾아 구간의 맨 뒤와 교환.
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

// 삽입 정렬: 왼쪽의 정렬된 묶음에 새 값을 끼워 넣는다. 여기서는 이웃 교환으로 한 칸씩 밀어 넣어 단계를 보여 준다.
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

  // 무작위 배열로 새로 만들기
  SortArray(int len, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    arr = new int[len];
    w = (width - 4) / len;

    shuffle();
  }

  // 기존 배열을 복사해서 만들기 (단계 저장용)
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
