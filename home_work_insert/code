int[] arr = {29, 10, 14, 37, 13, 24, 11, 33};
int count = 0;

void setup() {
  printRow("초기   ", -1, 0);
  insertionSort();
  printRow("완료   ", -1, 0);
  exit();
}

void insertionSort() {
  for (int i = 1; i < arr.length; i++) {
    int newItem = arr[i];
    int loc = i - 1;
    while (loc >= 0) {
      count++;
      if (arr[loc] > newItem) {
        arr[loc + 1] = arr[loc];
        printRow("비교 " + nf(count, 2), loc, newItem);
        loc--;
      } else {
        printRow("비교 " + nf(count, 2), loc + 1, newItem);
        break;
      }
    }
    arr[loc + 1] = newItem;
  }
}

// gap 칸에 키(newItem)를 잠시 채워서 출력 (gap이 -1이면 배열 그대로 출력)
void printRow(String label, int gap, int newItem) {
  String line = label + " : ";
  for (int k = 0; k < arr.length; k++) {
    int v = arr[k];
    if (k == gap) v = newItem;
    line += nf(v, 2) + "  ";
  }
  println(line);
}
