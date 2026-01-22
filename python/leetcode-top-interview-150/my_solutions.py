from typing import List


class Solution:

    def hIndex(self, citations: List[int]) -> int:
        """
            EXPLANATION:
                - This is one of the interesting question in Leetcode's Top Interview 150 question series
                - We have to find the researcher's h-index, The h-index is defined as the maximum value of h such that the given researcher has published at least h papers that have each been cited at least h times.
                - Sounds very confusing so I thought like I will just find the median by sorting the citation index and I am good but then saw a test case of [0,0,0,100] and I am like, Hmm, Not that easy LOL!
                - So it can be solved using the citation_mapper where I am tracking the citation_count_freq which is surpassing the length of citations!
                - Think it in reverse way, You have to find the maximum value of h that has atleast h paper so by creating the citation_count_freq, all the major values would be at the right side of the list, now track back and wherever the h_counter is greater than equal to the index, that index is your h-index!
        """
        citation_count = [0] * (len(citations) + 1)
        for citation in citations:
            if citation >= len(citations):
                citation_count[len(citations)] += 1
            else:
                citation_count[citation] += 1
        h = 0
        for i in range(len(citations), -1, -1):
            h += citation_count[i]
            if h >= i:
                return i
    
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        prefix = suffix = 1
        answer = [0] * len(nums)

        for i in range(len(nums)):
            answer[i] = prefix
            prefix *= nums[i]

        for j in range(len(nums)-1, -1, -1):
            answer[j] *= suffix
            suffix *= nums[j]
        
        return answer


if __name__ == "__main__":
    sol = Solution()
    #print(sol.hIndex([1, 2, 3, 4, 5]))
