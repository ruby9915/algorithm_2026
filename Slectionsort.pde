
int[] list = new int [10000];
int i, j, max, index, tmp;

println(list.length);
for (i = 0; i < list.length; i++) {
  list[i] = (int)random(1000);
}
println();

long startTime = System.nanoTime();

for (i = 0; i < list.length; i++) {
  max = index = -1;
  for (j = 0; j < list.length - i - 1; j++) {
    if (max < list[j]) {
      max = list[j];
      index = j;
    }
  }
  if (index != -1) {
    tmp = list[j];
    list[j] = max;
    list[index] = tmp;
  }
}

for (i = 0; i < list.length; i++) {
  print(list[i], " ");
}
println();

long elapsed = millis() - startTime;
println("정렬 시간: " + elapsed + " ms");
