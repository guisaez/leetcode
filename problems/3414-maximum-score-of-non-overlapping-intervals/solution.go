package main

import "sort"

// NOTES:
//
// In this case, each interval has a specific score (weight) that we are
// trying to maximize.
//
// So, if we go over all the intervals, for each interval we need to consider
// two possibilities:
//
//  1. Take the interval.
//  2. Skip the interval because another combination of non-overlapping
//     intervals may provide a better total weight.
//
// It is important that we process the intervals in an order that allows us
// to determine which previous intervals are compatible with the current one.
//
// We sort the intervals by their ending position.
// If two intervals have the same ending position, we use their original
// index as a tie-breaker. We keep the original index because the problem
// requires us to return the selected intervals' original indices.
//
// After sorting, suppose:
//
//	interval i = (start, finish, weight)
//
// If we decide to take interval i, we need to find the latest interval
// before i that is compatible with it.
//
// Since intervals cannot overlap, the previous interval must satisfy:
//
//	previous.finish < current.start
//
// We therefore find the largest index p such that:
//
//	finish[p] < start
//
// Because the intervals are sorted by finish time, we can find p using
// binary search.
//
// -------------------------------------------------------------------------
//
// DP:
//
// Let:
//
//	dp[j][i]
//
// represent the best state we can obtain by choosing exactly j intervals
// from the first i intervals in the sorted list.
//
// For example:
//
//	dp[2][5]
//
// means:
//
//	"The best way to choose exactly 2 non-overlapping intervals from
//	 sorted[0..4]."
//
// At dp[j][i], we have two choices:
//
// 1. Skip interval i.
//
//	Then we simply keep the best result we had using the first i-1
//	intervals:
//
//	    dp[j][i-1]
//
// 2. Take interval i.
//
//	Suppose interval i is:
//
//	    (start, finish, weight)
//
//	We need to find the latest previous interval p whose finish time
//	is before start.
//
//	Then the best solution before taking the current interval is:
//
//	    dp[j-1][p]
//
//	and after taking the current interval:
//
//	    dp[j-1][p] + weight
//
//	So the recurrence is:
//
//	    dp[j][i] = max(
//	        dp[j][i-1],              // skip current interval
//	        dp[j-1][p] + weight      // take current interval
//	    )
//
// -------------------------------------------------------------------------
//
// There is one additional requirement in this problem:
//
// If two solutions have the same total weight, we need to choose the
// lexicographically smaller list of original indices.
//
// Because of that, dp cannot store just the maximum weight.
//
// Instead, each DP state stores:
//
//	state {
//	    w   int      // total weight
//	    idx []int    // original indices of selected intervals
//	}
//
// When comparing two states:
//
//  1. The state with the larger weight wins.
//  2. If the weights are equal, the state with the lexicographically
//     smaller index list wins.
//
// -------------------------------------------------------------------------
//
// We only need to keep the previous DP row and the current DP row.
//
//	prev = results for choosing j-1 intervals
//	cur  = results for choosing j intervals
//
// This gives us:
//
//	prev[p+1]
//
// because p can be -1 when there is no compatible previous interval.
// The +1 lets us use:
//
//	index 0 -> no previous interval
//	index 1 -> sorted[0]
//	index 2 -> sorted[1]
//	...
//
// -------------------------------------------------------------------------
//
// Finally, we repeat the DP K times because the problem allows us to
// select at most 4 intervals.
//
// For each j:
//
//	j = 1
//	j = 2
//	j = 3
//	j = 4
//
// we compute the best solution for exactly j intervals.
//
// The final answer is the best state among those possibilities, using
// the same "higher weight, then lexicographically smaller indices" rule.
func maximumWeight(intervals [][]int) []int {
	n := len(intervals)
	type interval struct{ s, f, w, idx int }
	sorted := make([]interval, n)
	for i, iv := range intervals {
		sorted[i] = interval{iv[0], iv[1], iv[2], i}
	}
	sort.Slice(sorted, func(a, b int) bool {
		if sorted[a].f != sorted[b].f {
			return sorted[a].f < sorted[b].f
		}
		return sorted[a].idx < sorted[b].idx
	})

	finish := make([]int, n)
	for i, iv := range sorted {
		finish[i] = iv.f
	}

	// findPrev: largest index i in [0,n) such that finish[i] < start; -1 if none
	findPrev := func(start int) int {
		lo, hi := 0, n-1
		res := -1
		for lo <= hi {
			mid := (lo + hi) / 2
			if finish[mid] < start {
				res = mid
				lo = mid + 1
			} else {
				hi = mid - 1
			}
		}
		return res
	}

	type state struct {
		w   int
		idx []int
	}
	better := func(a, b state) state {
		if a.w > b.w {
			return a
		}
		if b.w > a.w {
			return b
		}
		// equal weight: lexicographically smaller index list wins
		for i := 0; i < len(a.idx) && i < len(b.idx); i++ {
			if a.idx[i] < b.idx[i] {
				return a
			}
			if a.idx[i] > b.idx[i] {
				return b
			}
		}
		return a
	}

	K := 4
	// dp[j][i] = best state picking exactly j intervals from sorted[0..i]
	// We use 1-indexed intervals: dp[j][0] = zero state
	empty := state{0, []int{}}
	prev := make([]state, n+1)
	for i := range prev {
		prev[i] = empty
	}

	var best state
	for j := 0; j < K; j++ {
		cur := make([]state, n+1)
		cur[0] = empty
		for i := 1; i <= n; i++ {
			iv := sorted[i-1]
			skip := cur[i-1]
			p := findPrev(iv.s) // index in sorted (0-based), or -1
			prevState := prev[p+1]
			newIdx := make([]int, len(prevState.idx)+1)
			copy(newIdx, prevState.idx)
			newIdx[len(prevState.idx)] = iv.idx
			sort.Ints(newIdx)
			take := state{prevState.w + iv.w, newIdx}
			cur[i] = better(take, skip)
		}
		best = better(best, cur[n])
		prev = cur
	}

	return best.idx
}
