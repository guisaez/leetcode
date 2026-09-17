class Solution:
    def maxPalindromes(self, s: str, k: int) -> int:

        # Find palindrome ranges
        palindromeRanges = self.expandAroundCenters(s, k)

        # Group ranges by their ending position
        ending_at = [[] for _ in range(len(s))]

        for start, end in palindromeRanges:
            ending_at[end].append(start)

        # dp[i] = maximum number of non-overlapping
        # palindromes using positions 0..i
        dp = [0] * len(s)

        for end in range(len(s)):
            # Don't take a palindrome ending at `end`
            dp[end] = dp[end - 1] if end > 0 else 0

            # Try every palindrome ending at `end`
            for start in ending_at[end]:
                previous = dp[start - 1] if start > 0 else 0
                # Do I skip this palindrom or do I take it?
                dp[end] = max(dp[end], previous + 1)

        return dp[-1]

    def expandAroundCenters(self, s: str, k: int):
        points = []

        for i in range(len(s)):
            expand1 = self.expandAroundCenter(s, i, i, k)
            expand2 = self.expandAroundCenter(s, i, i + 1, k)

            if expand1 is not None:
                points.append(expand1)

            if expand2 is not None:
                points.append(expand2)

        return points

    def expandAroundCenter(self, s: str, left: int, right: int, k: int):
        while left >= 0 and right < len(s) and s[left] == s[right]:
            if right - left + 1 >= k:
                return [left, right]

            left -= 1
            right += 1

        return None
