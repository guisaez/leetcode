## Notes

The first approach that comes to mind is brute force: generate all possible 3-digit numbers `XYZ` and keep track of those that satisfy:

- `X > 0` (no leading zeros)
- `Z rem 2 == 0` (even number)
- `XYZ` has not been counted before

### My Approach

Instead of brute-forcing, I fix the values of `X` (hundreds) and `Z` (units) and count all valid values for `Y` (tens) based on the remaining digit frequencies.

**Steps:**

1. Build a frequency map to track how many times each digit appears.
2. Iterate over the frequency map, locking a value for `X` by decrementing its frequency by 1.
3. Iterate again over the updated map, locking a value for `Z` — it must be an even digit with remaining frequency > 0. Decrement its frequency by 1 as well.
4. Count available middle digits: any digit with frequency ≥ 1 after steps 2 and 3.

**Complexity:** O(N) to build the frequency map + O(D³) for the triple iteration where D ≤ 10 (distinct digits 0–9), so effectively O(N) overall.
