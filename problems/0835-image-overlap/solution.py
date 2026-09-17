class Solution:
    def largestOverlap(self, img1: list[list[int]], img2: list[list[int]]) -> int:
        pts1 = self.extractPoints(img1)
        pts2 = self.extractPoints(img2)

        translationfreq = {}

        max_freq = 0
        for point1 in pts1:
            for point2 in pts2:
                translation = self.findTranslation(point1, point2)
                curr = translationfreq.get(translation, 0) + 1
                translationfreq[translation] = curr
                max_freq = max(max_freq, curr)

        return max_freq

    def findTranslation(self, p1, p2):
        return (p1[0] - p2[0], p1[1] - p2[1])

    def extractPoints(self, img: list[list[int]]):
        points = []
        for r, row in enumerate(img):
            for c, value in enumerate(row):
                if value == 1:
                    points.append([r, c])
        return points
