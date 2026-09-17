class Solution:
    def minSumOfLengths(self, arr: List[int], target: int) -> int:

        start = 0
        end = 0

        best = [float('inf')] * len(arr)
        answer = float('inf')

        arr_sum = arr[0]

        while end < len(arr) and start < len(arr):

            if arr_sum == target:
                length = end - start + 1

                # Previous interval must end before start.
                if start > 0 and best[start - 1] != float('inf'):
                    answer = min(
                        answer,
                        best[start - 1] + length
                    )

                # Current interval can improve best[end].
                if end > 0:
                    best[end] = min(best[end - 1], length)
                else:
                    best[end] = length

                # Move start forward.
                arr_sum -= arr[start]
                start += 1

                # Start a new window if necessary.
                if start > end:
                    end = start

                    if start < len(arr):
                        arr_sum = arr[start]
                        best[end] = best[end - 1]

            elif arr_sum < target:

                # Expand window.
                end += 1

                if end < len(arr):
                    arr_sum += arr[end]

                    # IMPORTANT:
                    # Carry the previous best even though
                    # this window isn't necessarily valid.
                    best[end] = best[end - 1]

            else:

                # Shrink window.
                arr_sum -= arr[start]
                start += 1

                if start > end:
                    end = start

                    if start < len(arr):
                        arr_sum = arr[start]
                        best[end] = best[end - 1]

        return -1 if answer == float('inf') else answer
