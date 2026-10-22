# algorithm_2026

고급알고리즘 (2026-2) 과제 저장소. 모든 코드는 Processing 스케치(`homework/이름/이름.pde`)입니다.

## 과제 1 — 정렬 (Selection, Bubble, Insertion, Merge, Quick, Heap)

[selection](homework/selection/selection.pde)
---
<img width="420" height="540" alt="selection sort" src="https://github.com/user-attachments/assets/afcaa14a-71f6-4b1d-930c-3518ec3b4a30" />

[bubble](homework/bubble/bubble.pde)
---
<img width="420" height="540" alt="bubble sort" src="https://github.com/user-attachments/assets/e608f4e2-753f-4776-989a-31eadf415d61" />

[insertion](homework/insertion/insertion.pde)
---
<img width="420" height="540" alt="insertion sort" src="https://github.com/user-attachments/assets/34a7625e-05b9-4184-845a-f5fcd3de3255" />

[merge](homework/merge/merge.pde)
---
<img width="420" height="540" alt="merge sort" src="https://github.com/user-attachments/assets/15788011-ff3a-4a96-8e34-17dec545e2e9" />

[quick](homework/quick/quick.pde)
---
<img width="420" height="540" alt="quick sort" src="https://github.com/user-attachments/assets/d80e9c83-9a27-460a-9b88-fe8b66285416" />

[heap](homework/heap/heap.pde)
---
최대 힙을 만든 뒤 뿌리(최댓값)를 맨 뒤와 맞바꾸고 힙 크기를 하나 줄여 가며 정렬합니다. `|` 오른쪽이 확정된 부분입니다.

```
초기      : 29  10  14  37  13  24  11  33
힙 완성   : 37  33  24  29  13  14  11  10
회차 01   : 33  29  24  10  13  14  11  | 37
회차 02   : 29  13  24  10  11  14  | 33  37
회차 03   : 24  13  14  10  11  | 29  33  37
회차 04   : 14  13  11  10  | 24  29  33  37
회차 05   : 13  10  11  | 14  24  29  33  37
회차 06   : 11  10  | 13  14  24  29  33  37
회차 07   : 10  | 11  13  14  24  29  33  37
완료      : 10  11  13  14  24  29  33  37
```

(실행 캡처 추가 예정)

## 과제 2 — 정렬 애니메이션

[animation](homework/animation/animation.pde)
---
정렬 중 배열의 상태를 단계마다 `ArrayList`에 복사해 두고 순서대로 다시 그립니다.

- `SPACE` 자동 재생 켜기/끄기, `a` 빠르게, `s` 느리게, `r` 새 배열로 다시 시작
- `←` `→` 또는 마우스 왼쪽/오른쪽 클릭으로 한 단계씩 이동
- `1` bubble sort, `2` selection sort, `3` insertion sort

(실행 캡처 추가 예정)

## 과제 3 — Binary Search Tree

[bst](homework/bst/bst.pde)
---
insert / delete / search 와 inorder / preorder / postorder 순회.

- `i` 삽입 모드: 화면을 클릭하면 마우스 x 위치(0~99)에 해당하는 값을 삽입
- `d` 삭제 모드, `s` 검색 모드: 노드를 클릭
- `1` inorder, `2` preorder, `3` postorder (결과는 화면 아래와 콘솔에 출력)
- `c` 트리 비우기, `b` 새 트리 만들기, `v` 현재 순회 결과 다시 출력
- 삭제는 자식 수에 따라 세 경우로 처리합니다. 자식이 둘이면 오른쪽 서브트리의 최솟값을 올립니다.

(실행 캡처 추가 예정)

## 그 밖의 파일

- [sketch_20201673_2026_09_03.pde](sketch_20201673_2026_09_03.pde): 9/3 실습 (선택 정렬 시간 측정)
- [sketch_20201673_09_10.pde](sketch_20201673_09_10.pde): 9/10 실습
- [Sorting_table](Sorting_table/readMe.md): 정렬 단계 표
