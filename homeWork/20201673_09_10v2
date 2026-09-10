int[] arr = {29, 10, 14, 37, 13};

void setup() {
  println("Before:");
  printArray();
  selectionSorting();
  println("After:");
  printArray();
}

void printArray() {
  for (int i = 0; i < arr.length; i++) {
    print(arr[i] + " ");
  }
  println();
}

void swap(int a, int b) {
  int tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}

void selectionSorting() {
  int i, j, max, index;
  for (i = 0; i < arr.length; i++) {
    max = index = -1;
    for (j = 0; j < arr.length - i; j++) {
      if (max < arr[j]) {
        index = j;
        max = arr[j];
      }
    }
    swap(index, arr.length - i - 1);
  }
}
