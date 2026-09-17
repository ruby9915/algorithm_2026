int[] arr = {29, 10, 14, 37, 13, 24, 11, 33};
int[] tmp = new int[arr.length];
int count = 0;

void setup() {
  printLine("초기   ", arr);
  mergeSort(0, arr.length - 1);
  printLine("완료   ", arr);
  exit();
}

void mergeSort(int p, int r) {
  if (p < r) {
    int q = (p + r) / 2;
    mergeSort(p, q);
    mergeSort(q + 1, r);
    merge(p, q, r);
  }
}

void merge(int p, int q, int r) {
  int i = p;
  int j = q + 1;
  int t = p;
  while (i <= q && j <= r) {
    if (arr[i] <= arr[j]) {
      tmp[t] = arr[i];
      i++;
    } else {
      tmp[t] = arr[j];
      j++;
    }
    t++;
    count++;
    printMerging(p, r, i, q, j, t);
  }
  while (i <= q) {
    tmp[t] = arr[i];
    i++;
    t++;
  }
  while (j <= r) {
    tmp[t] = arr[j];
    j++;
    t++;
  }
  for (int k = p; k <= r; k++) {
    arr[k] = tmp[k];
  }
}

void printMerging(int p, int r, int i, int q, int j, int t) {
  int[] view = new int[arr.length];
  for (int k = 0; k < arr.length; k++) view[k] = arr[k];
  int w = p;
  for (int k = p; k < t; k++) { view[w] = tmp[k]; w++; }
  for (int k = i; k <= q; k++) { view[w] = arr[k]; w++; }
  for (int k = j; k <= r; k++) { view[w] = arr[k]; w++; }
  printLine("비교 " + nf(count, 2), view);
}

void printLine(String label, int[] a) {
  String line = label + " : ";
  for (int k = 0; k < a.length; k++) {
    line += nf(a[k], 2) + "  ";
  }
  println(line);
}
