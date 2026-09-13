# 835 - Image Overlap

Instead of trying every possible translation and counting overlaps naively (O(n⁴)),
extract the coordinates of all 1s from each image and compute translation vectors between every pair.

If `(x1, y1)` is a 1 in Img1 and `(x2, y2)` is a 1 in Img2, then shifting Img1 by `(dx, dy) = (x2-x1, y2-y1)` makes those two cells overlap.
The most frequent `(dx, dy)` across all pairs tells you the best shift — and its count is the answer.

## Approach

1. Extract 1-coordinates from each image → `M1`, `M2`
2. Generate all translation vectors: `[{X2-X1, Y2-Y1} || {X1,Y1} <- M1, {X2,Y2} <- M2]`
3. Count frequency of each vector using a map
4. Return the max frequency

## Complexity

- **Time**: O(k1 × k2) where k1, k2 are the number of 1s in each image (at most n²)
- **Space**: O(k1 × k2) for the translation list
