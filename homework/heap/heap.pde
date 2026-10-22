int[] arr = {29, 10, 14, 37, 13, 24, 11, 33};
int count = 0;

void setup() {
  printRow("초기     ", -1);
  heapSort();
  printRow("완료     ", -1);
  exit();
}

void heapSort() {
  int n = arr.length;

  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(i, n);
  }
  printRow("힙 완성  ", -1);

  for (int last = n - 1; last > 0; last--) {
    swap(0, last);
    heapify(0, last);
    count++;
    printRow("회차 " + nf(count, 2) + "  ", last);
  }
}

void heapify(int k, int n) {
  while (true) {
    int left = 2 * k + 1;
    int right = 2 * k + 2;
    int larger = k;
    if (left < n && arr[left] > arr[larger]) larger = left;
    if (right < n && arr[right] > arr[larger]) larger = right;
    if (larger == k) break;
    swap(k, larger);
    k = larger;
  }
}

void swap(int i, int j) {
  int t = arr[i];
  arr[i] = arr[j];
  arr[j] = t;
}

void printRow(String label, int fixedFrom) {
  String line = label + " : ";
  for (int k = 0; k < arr.length; k++) {
    if (k == fixedFrom) line += "| ";
    line += nf(arr[k], 2) + "  ";
  }
  println(line);
}
