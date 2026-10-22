int[] arr = {29, 10, 14, 37, 13, 24, 11, 33};
int count = 0;

void setup() {
  printRow("초기     ", -1);
  heapSort();
  printRow("완료     ", -1);
  exit();
}

// 최대 힙(부모 >= 자식)을 써서 오름차순으로 정렬한다.
// 강의자료(ch03 26p)의 heapSort는 최소 힙이라 결과가 내림차순이 되는데,
// 비교 방향만 반대이고 절차(힙 만들기 -> 뿌리와 마지막을 맞바꾸고 내려보내기)는 같다.
void heapSort() {
  int n = arr.length;

  // 1) 힙 만들기: 자식이 있는 마지막 노드(n/2 - 1)부터 뿌리(0)까지 거꾸로 내려보내기
  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(i, n);
  }
  printRow("힙 완성  ", -1);

  // 2) 꺼내기: 뿌리(최댓값)와 힙의 마지막을 맞바꾸고, 힙 크기를 하나 줄인 뒤 뿌리를 내려보내기
  for (int last = n - 1; last > 0; last--) {
    swap(0, last);
    heapify(0, last);
    count++;
    printRow("회차 " + nf(count, 2) + "  ", last);
  }
}

// k번 노드를 크기 n인 힙 안에서 내려보낸다. (0번부터 세므로 자식은 2k+1, 2k+2)
void heapify(int k, int n) {
  while (true) {
    int left = 2 * k + 1;
    int right = 2 * k + 2;
    int larger = k;
    if (left < n && arr[left] > arr[larger]) larger = left;
    if (right < n && arr[right] > arr[larger]) larger = right;
    if (larger == k) break;      // 두 자식보다 크면 멈춤
    swap(k, larger);             // 더 큰 자식과 맞바꾸고 그 자리에서 계속
    k = larger;
  }
}

void swap(int i, int j) {
  int t = arr[i];
  arr[i] = arr[j];
  arr[j] = t;
}

// fixedFrom 자리부터는 확정된 부분이므로 '|' 로 구분해서 출력한다.
void printRow(String label, int fixedFrom) {
  String line = label + " : ";
  for (int k = 0; k < arr.length; k++) {
    if (k == fixedFrom) line += "| ";
    line += nf(arr[k], 2) + "  ";
  }
  println(line);
}
