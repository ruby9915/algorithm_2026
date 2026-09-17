
int[] arr = {29, 10, 14, 37, 13, 24, 11, 33};
int count = 0;

void setup() {
  printRow("초기   ");
  quickSort(0, arr.length - 1);
  printRow("완료   ");
  exit();
}

void quickSort(int p, int r) {
  if (p < r) {
    int q = partition(p, r);
    quickSort(p, q - 1);
    quickSort(q + 1, r);
  }
}

int partition(int p, int r) {
  int x = arr[r];
  int i = p - 1;
  for (int j = p; j < r; j++) {
    if (arr[j] <= x) {
      i++;
      swap(i, j);
    }
    count++;
    printRow("비교 " + nf(count, 2));
  }
  swap(i + 1, r);
  return i + 1;
}

void swap(int i, int j) {
  int t = arr[i];
  arr[i] = arr[j];
  arr[j] = t;
}

void printRow(String label) {
  String line = label + " : ";
  for (int k = 0; k < arr.length; k++) {
    line += nf(arr[k], 2) + "  ";
  }
  println(line);
}
