int[] arr = {29, 10, 14, 37, 13};

void setup() {
  println("Before:");
  printArr();
  bubbleSorting();
  println("After:");
  printArr();
}

void printArr() {
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

void bubbleSorting() {
  int i, j;
  for (i = 0; i < arr.length - 1; i++) {
    for (j = 0; j < arr.length - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        swap(j, j + 1);
      }
    }
  }
}
