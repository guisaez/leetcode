**NOTES**

In this case we just need to make sure that the second rectangle starts before the first rectangle interval ends.

Given, (X1, Y1) and (X2, Y2) for the first rectangle and (X3, Y3) and (X4, Y4) for the second rectangle we just need to  ensure that:
1. X1 < X4 (The first rectangle starts before the seconds rectangle ends)
2. X3 < X2 (The second rectangle starts before the first rectangle ends)
3. Y1 < Y4 (The first rectangle starts before the second rectangle ends)
4. Y3 < Y2 (This second rectangle starts before the first rectangle ends)

If all this conditions apply, then it is an overlap.
