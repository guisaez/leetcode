package main

func countCommas(n int) int {

	tiers := floorLog1000(n)

	count := 0
	for tier := 1; tier <= tiers; tier++ {

		bottom := pow1000(tier)
		top := min(n, pow1000(tier+1)-1)

		count += tier * (top - bottom + 1)
	}

	return count
}

func pow1000(tier int) int {
	result := 1
	for range tier {
		result *= 1000
	}
	return result
}

func floorLog1000(n int) int {
	if n < 1000 {
		return 0
	}

	return 1 + floorLog1000(n/1000)
}
