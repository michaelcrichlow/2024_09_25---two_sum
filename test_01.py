def which_is_longer(s1: str, s2: str) -> int:
    if len(s1) == len(s2):
        return 0
    if len(s1) > len(s2):
        return 1
    if len(s1) < len(s2):
        return 2
    return -1


def longest_common_ending(s1: str, s2: str) -> str:
    # guard clause
    if len(s1) == 0 or len(s2) == 0:
        return ""

    res = ""
    longer = which_is_longer(s1, s2)
    if longer != -1:
        match longer:
            # baseline test
            case 0:
                for i, val in enumerate(s1):
                    if val == s2[i]:
                        res += val
                    else:
                        res = ""
            case 1:
                # trim s1 to length of s2
                idx = len(s1) - len(s2)
                s1_test = s1[idx:]

                # same as case 0
                for i, val in enumerate(s1_test):
                    if val == s2[i]:
                        res += val
                    else:
                        res = ""
            case 2:
                # trim s2 to length of s1
                idx = len(s2) - len(s1)
                s2_test = s2[idx:]

                # same as case 0
                for i, val in enumerate(s1):
                    if val == s2_test[i]:
                        res += val
                    else:
                        res = ""

    return res


def main() -> None:
    val_02 = "coding"
    val_01 = "reading"

    val = longest_common_ending(val_01, val_02)
    print(val)
    # OUTPUT: ding


if __name__ == '__main__':
    main()
