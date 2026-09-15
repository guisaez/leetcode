package main

import "sort"

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
