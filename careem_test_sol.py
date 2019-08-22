def getMinimumUniqueSum(arr):
    res = list(arr)
    for i in range(len(arr)):
        elem = arr[i]
        new_arr = list(res)
        new_arr.remove(elem)
        while elem in new_arr:
            elem += 1
        res[i] = elem
    return sum(res)


arr = [3, 2, 1, 2, 7, 3, 2, 4, 8, 1, 7]
ans = getMinimumUniqueSum(arr)
to_match = sum([3, 2, 1, 4, 7, 5, 6, 8, 9, 10, 11])
if ans != to_match:
    print("Error: getMinimumUniqueSum!")
else:
    print("Succes: getMinimumUniqueSum! Answer is: {}".format(ans))


def isPossible(a, b, c, d):
    f1 = a
    f2 = b

    ans = False
    while 1:
        f1 = f1 + f2 if f1 < c else f1
        if f1 >= c and f2 > d:
            if f1 == c and ((abs(d - f2)) % a == 0 or (abs(d - f2)) % b == 0):
                ans = True
            break
        elif f1 == c:
            f2 = f2 + f1
        elif f1 > c:
            f1 = a
            f2 = f2 + f1
        if f1 == c and f2 == d:
            ans = True
            break
    return ans


ans1 = isPossible(3, 7, 748, 2016)
to_match1 = True
ans2 = isPossible(3, 8, 748, 2016)
to_match2 = False
if ans1 != to_match1 and ans2 != to_match2:
    print("Error: isPossible!")
else:
    print("Succes: isPossible! Answers are: {} and {}".format(ans1, ans2))


def get_direction(arr):
    len_arr = len(arr)
    first_half = arr[0:int(len_arr / 2)]
    sec_half = arr[int(len_arr / 2): len_arr]
    return False if sum(sec_half) > sum(first_half) else True


def separatingStudents(arr):
    itr = 0
    ind = 0
    count = 0
    steps = 0
    rev = get_direction(arr)
    sorted_arr = sorted(arr, reverse=rev)
    new_arr = list(arr)
    mover = 1 if rev else 0
    anti_mover = 0 if rev else 1
    while new_arr != sorted_arr:
        if new_arr[itr] == mover and count != 0:
            steps += count
            count = 0
            temp = new_arr[ind]
            new_arr[ind] = new_arr[itr]
            new_arr[itr] = temp
            itr = ind
        elif new_arr[itr] == mover:
            ind += 1
            itr += 1
        elif new_arr[itr] == anti_mover:
            count += 1
            itr += 1
    return steps


arr1 = [0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1]
arr2 = [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1]
ans1 = separatingStudents(arr1)
ans2 = separatingStudents(arr2)
to_match1 = 16
to_match2 = 3
if ans1 != to_match1 or ans2 != to_match2:
    print("Error: separatingStudents!")
else:
    print("Succes: separatingStudents! Answers are: {} and {}".format(ans1, ans2))
