# works, but inelegant and too slow
def two_sum(nums: list[int], target: int) -> list[int]:
    local_list = []
    for i in range(len(nums) - 1):
        idx = i + 1
        while idx < len(nums):
            if (nums[i] + nums[idx]) != target:
                if idx + 1 < len(nums):
                    idx += 1
                else:
                    break
            if nums[i] + nums[idx] == target:
                local_list.append(i)
                local_list.append(idx)
                return local_list

    return []


# ended up going with this one. It's nice and fast.
def two_sum_new(nums: list[int], target: int) -> list[int]:
    # make a dictionary of values
    num_dict: dict[int, int] = {}
    final_list = []

    # as you build dictionary, check to see if 'target - val' is already in it
    for i, val in enumerate(nums):
        if (target - val) in num_dict:
            # index of this specific 'val'
            final_list.append(i)
            # index of value already in dictionary
            final_list.append(num_dict[target - val])
            break
        num_dict[val] = i

    return final_list


def main() -> None:
    val = two_sum_new([2, 7, 11, 15], 9)
    print(val)


if __name__ == '__main__':
    main()
