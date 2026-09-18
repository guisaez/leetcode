# Notes
#
# In this problem, we first need to understand the range
# that each letter covers: its first and last occurrence.
#
# The key piece is understanding what those ranges represent.
#
# Even though the range for a letter looks like a valid candidate, it might not
# actually be valid because the range can contain another letter whose
# occurrences extend outside of it.
#
# For that reason, we need to find the smallest valid range for each letter.
#
# A candidate [i..j] is invalid if some letter inside the candidate has its
# first occurrence before i. In that case, we would need to include an
# occurrence that is outside the candidate,
# so the candidate can never be valid.
#
# However, when we encounter a letter whose last occurrence is after j, we can
# expand the right boundary to include it. We continue scanning because
# expanding the right boundary can introduce more letters that also need to
# be checked.
#
# Once we have all valid candidates, we sort them by their end position and
# greedily select non-overlapping candidates.
#
# By choosing the candidate that ends earliest, we leave the most space
# available for subsequent candidates, which allows us to maximize the
# number of non-overlapping substrings.eep those that do not overlap.
# By sorting them be end point we keep the lowest length

class Solution:
    def maxNumOfSubstrings(self, s: str) -> list[str]:

        items = {}
        for idx, c in enumerate(s):
            (curr_start, curr_end) = items.get(c, (idx, idx))
            items[c] = (curr_start, idx)

        candidates = []

        for c, (left, right) in items.items():
            valid = True

            i = left

            while i <= right:
                letter = s[i]

                (letter_start, letter_end) = items[letter]

                if letter_start < left:
                    valid = False
                    break
                if letter_end > right:
                    right = letter_end

                i += 1

            if valid:
                candidates.append((left, right))

        candidates = sorted(candidates, key=lambda point: point[1])

        result = []
        last_right = -1
        for (left, right) in candidates:
            if left > last_right:
                result.append(s[left:right+1])
                last_right = right

        return result
