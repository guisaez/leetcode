package main

// Notes:
//
// We can let dp[i][j] be the number of ways to choose exactly i segments
// using the points from 0..j.
//
// At each point j, we have two options:
//
//  1. Skip taking point j.
//     This basically means we remain with the count until j - 1:
//
//     dp[i][j-1]
//
// 2. We take point j, which means j is the end of an interval.
//
//	But how do we know which intervals before can end with j?
//
//	For example:
//
//	    0 ---> 1 ---> 2 ---> 3 ---> 4
//
//	If we are at point 3, we would need to consider the available ranges
//	that end at 3:
//
//	    (0,3)
//	    (1,3)
//	    (2,3)
//
//	But we don't want to count those segments directly.
//	Instead, we can ask:
//
//	Where could the previous i - 1 segments have ended before
//	the new segment starts?
//
//	    (0,3) --> before/at 0
//	    (1,3) --> before/at 1
//	    (2,3) --> before/at 2
//
//	So we need to know how many ways we could have selected the
//	previous i - 1 segments up to each of those points.
//
//	This gives us:
//
//	    dp[i-1][0] + dp[i-1][1] + dp[i-1][2]
//
//	We can call this the number of ways a segment can end at j.
//
//	Instead of computing the whole sum every time, we introduce a prefix
//	sum such that:
//
//	    prefix[i-1][j-1] = dp[i-1][0] + dp[i-1][2] + ...+ dp[i-1][j-1]
//
//	stores that sum.
//
//	So now the recurrence becomes:
//
//	    dp[i][j] = dp[i][j-1] + prefix[i-1][j-1]
func numberOfSets(n int, k int) int {
	const MOD = 1_000_000_007

	// dp[i][j] = number of ways to choose exactly i segments
	// using points 0..j
	dp := make([][]int, k+1)
	prefix := make([][]int, k+1)

	for i := 0; i <= k; i++ {
		dp[i] = make([]int, n)
		prefix[i] = make([]int, n)
	}

	// Base case: choose 0 segments.
	for j := range n {
		dp[0][j] = 1
		prefix[0][j] = j + 1
	}

	for i := 1; i <= k; i++ {
		// dp[i][0] remains 0:
		// can't choose i > 0 segments from a single point.

		for j := 1; j < n; j++ {
			// Skip point j, or make a segment ending at j.
			dp[i][j] = dp[i][j-1] + prefix[i-1][j-1]
			dp[i][j] %= MOD

			// Prefix sum for this row.
			prefix[i][j] = prefix[i][j-1] + dp[i][j]
			prefix[i][j] %= MOD
		}
	}

	return dp[k][n-1]
}
