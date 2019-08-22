def car(arr):
    return arr[0]


def cdr(arr):
    return arr[1:]


def cons(a, arr):
    return [a] + arr


def atom(a):
    return And(type(a) is not list, Or(type(a) is int, Or(type(a) is float, type(a) is str)))


def eq(a, b):
    return And(atom(a), And(atom(b), And(type(a) is not int, And(type(b) is not int, a == b))))


def null(arr):
    return And(type(arr) is list, len(arr) == 0)


def lat(arr):
    if(null(arr)):
        return True
    return And(atom(car(arr)), lat(cdr(arr)))


def Or(a, b):
    return a or b


def And(a, b):
    return a and b


def member(a, arr):
    if(null(arr)):
        return False
    return Or(sequal(a, car(arr)), member(a, cdr(arr)))


def rember(a, arr):
    if(null(arr)):
        return arr
    elif(sequal(a, car(arr))):
        return cdr(arr)
    else:
        return cons(car(arr), rember(a, cdr(arr)))


def firsts(arr):
    if(null(arr)):
        return arr
    else:
        return cons(car(car(arr)), firsts(cdr(arr)))


def seconds(arr):
    if(null(arr)):
        return arr
    else:
        return cons(car(cdr(car(arr))), seconds(cdr(arr)))


def insertR(new, old, arr):
    if(null(arr)):
        return arr
    elif(eq(old, car(arr))):
        return cons(old, cons(new, cdr(arr)))
    else:
        return cons(car(arr), insertR(new, old, cdr(arr)))


def insertL(new, old, arr):
    if(null(arr)):
        return arr
    elif(eq(old, car(arr))):
        return cons(new, arr)
    else:
        return cons(car(arr), insertL(new, old, cdr(arr)))


def subst(new, old, arr):
    if(null(arr)):
        return arr
    elif(eq(old, car(arr))):
        return cons(new, cdr(arr))
    else:
        return cons(car(arr), subst(new, old, cdr(arr)))


def subst2(new, o1, o2, arr):
    if(null(arr)):
        return arr
    elif(Or(eq(o1, car(arr)), eq(o2, car(arr)))):
        return cons(new, cdr(arr))
    else:
        return cons(car(arr), subst2(new, o1, o2, cdr(arr)))


def multirember(a, arr):
    if(null(arr)):
        return arr
    elif(sequal(a, car(arr))):
        return multirember(a, cdr(arr))
    else:
        return cons(car(arr), multirember(a, cdr(arr)))


def multiinsertR(new, old, arr):
    if(null(arr)):
        return arr
    elif(eq(old, car(arr))):
        return cons(old, cons(new, multiinsertR(new, old, cdr(arr))))
    else:
        return cons(car(arr), multiinsertR(new, old, cdr(arr)))


def multiinsertL(new, old, arr):
    if(null(arr)):
        return arr
    elif(eq(old, car(arr))):
        return cons(new, cons(old, multiinsertL(new, old, cdr(arr))))
    else:
        return cons(car(arr), multiinsertL(new, old, cdr(arr)))


def multisubst(new, old, arr):
    if(null(arr)):
        return arr
    elif(eq(old, car(arr))):
        return cons(new, multisubst(new, old, cdr(arr)))
    else:
        return cons(car(arr), multisubst(new, old, cdr(arr)))


def add1(n):
    return n + 1


def sub1(n):
    return n - 1


def zero(n):
    return n == 0


def plus(n1, n2):
    if(zero(n2)):
        return n1
    else:
        return add1(plus(n1, sub1(n2)))


def minus(n1, n2):
    if(zero(n2)):
        return n1
    else:
        return sub1(minus(n1, sub1(n2)))


def num(n):
    return type(n) is int


def tup(arr):
    if(null(arr)):
        return True
    else:
        return And(num(car(arr)), tup(cdr(arr)))


def addtup(arr):
    if(null(arr)):
        return 0
    else:
        return plus(car(arr), addtup(cdr(arr)))


def multiply(n, m):
    if(zero(m)):
        return 0
    else:
        return plus(n, multiply(n, sub1(m)))


def plustup(arr1, arr2):
    if(null(arr1)):
        return arr2
    elif(null(arr2)):
        return arr1
    else:
        return cons(plus(car(arr1), car(arr2)), plustup(cdr(arr1), cdr(arr2)))


def greater(n, m):
    if(zero(n)):
        return False
    elif(zero(m)):
        return True
    else:
        return greater(sub1(n), sub1(m))


def lesser(n, m):
    if(zero(m)):
        return False
    elif(zero(n)):
        return True
    else:
        return lesser(sub1(n), sub1(m))


def equal(n, m):
    if(zero(n)):
        return zero(m)
    elif(zero(m)):
        return False
    else:
        return equal(sub1(n), sub1(m))


def diffEqual(n, m):
    if(Or(lesser(n, m), greater(n, m))):
        return False
    else:
        return True


def power(n, m):
    if(zero(m)):
        return 1
    else:
        return multiply(n, power(n, sub1(m)))


def divide(n, m):
    if(lesser(n, m)):
        return 0
    else:
        return add1(divide(minus(n, m), m))


def length(arr):
    if(null(arr)):
        return 0
    else:
        return add1(length(cdr(arr)))


def pick(n, arr):
    if(zero(sub1(n))):
        return car(arr)
    else:
        return pick(sub1(n), cdr(arr))


def rempick(n, arr):
    if(zero(sub1(n))):
        return cdr(arr)
    else:
        return cons(car(arr), rempick(sub1(n), cdr(arr)))


def Number(n):
    return And(atom(n), type(n) is int)


def noNums(arr):
    if(null(arr)):
        return arr
    elif(Number(car(arr))):
        return noNums(cdr(arr))
    else:
        return cons(car(arr), noNums(cdr(arr)))


def allNums(arr):
    if(null(arr)):
        return arr
    elif(Number(car(arr))):
        return cons(car(arr), allNums(cdr(arr)))
    else:
        return allNums(cdr(arr))


def eqan(n, m):
    if(And(Number(n), Number(m))):
        return equal(n, m)
    else:
        return eq(n, m)


def occur(n, arr):
    if(null(arr)):
        return 0
    elif(eqan(n, car(arr))):
        return add1(occur(n, cdr(arr)))
    else:
        return occur(n, cdr(arr))


def one(n):
    return equal(1, n)


def rempickWithOne(n, arr):
    if(one(n)):
        return cdr(arr)
    else:
        return cons(car(arr), rempick(sub1(n), cdr(arr)))


def rember_star(a, arr):
    if(null(arr)):
        return []
    elif(atom(car(arr))):
        if(eq(car(arr), a)):
            return rember_star(a, cdr(arr))
        else:
            return cons(car(arr), rember_star(a, cdr(arr)))
    else:
        return cons(rember_star(a, car(arr)), rember_star(a, cdr(arr)))


def insertR_star(n, o, arr):
    if(null(arr)):
        return []
    elif(atom(car(arr))):
        if(eq(car(arr), o)):
            return cons(o, cons(n, insertR_star(n, o, cdr(arr))))
        else:
            return cons(car(arr), insertR_star(n, o, cdr(arr)))
    else:
        return cons(insertR_star(n, o, car(arr)), insertR_star(n, o, cdr(arr)))


def occur_star(a, arr):
    if(null(arr)):
        return 0
    elif(atom(car(arr))):
        if(eq(car(arr), a)):
            return add1(occur_star(a, cdr(arr)))
        else:
            return occur_star(a, cdr(arr))
    else:
        return plus(occur_star(a, car(arr)), occur_star(a, cdr(arr)))


def subst_star(n, o, arr):
    if(null(arr)):
        return []
    elif(atom(car(arr))):
        if(eq(car(arr), o)):
            return cons(n, subst_star(n, o, cdr(arr)))
        else:
            return cons(car(arr), subst_star(n, o, cdr(arr)))
    else:
        return cons(subst_star(n, o, car(arr)), subst_star(n, o, cdr(arr)))


def insertL_star(n, o, arr):
    if(null(arr)):
        return arr
    elif(atom(car(arr))):
        if(eq(car(arr), o)):
            return cons(n, cons(o, insertL_star(n, o, cdr(arr))))
        else:
            return cons(car(arr), insertL_star(n, o, cdr(arr)))
    else:
        return cons(insertL_star(n, o, car(arr)), insertL_star(n, o, cdr(arr)))


def member_star(a, arr):
    if(null(arr)):
        return False
    elif(atom(car(arr))):
        if(eq(car(arr), a)):
            return True
        else:
            return member_star(a, cdr(arr))
    else:
        return Or(member_star(a, car(arr)), member_star(a, cdr(arr)))


def leftmost(arr):
    if(atom(car(arr))):
        return car(arr)
    else:
        return leftmost(car(arr))


def eqlist(arr1, arr2):
    if(And(null(arr1), null(arr2))):
        return True
    elif(Or(null(arr1), null(arr2))):
        return False
    elif(And(atom(car(arr1)), atom(car(arr2)))):
        if(eqan(car(arr1), car(arr2))):
            return eqlist(cdr(arr1), cdr(arr2))
        else:
            return False
    elif(Or(atom(car(arr1)), atom(car(arr2)))):
        return False
    else:
        return And(eqlist(car(arr1), car(arr2)), eqlist(cdr(arr1), cdr(arr2)))


def sequal(s1, s2):
    if(And(atom(s1), atom(s2))):
        if(eqan(s1, s2)):
            return True
        else:
            return False
    elif(Or(atom(s1), atom(s2))):
        return False
    else:
        return eqlist1(s1, s2)


def eqlist1(arr1, arr2):
    if(And(null(arr1), null(arr2))):
        return True
    elif(Or(null(arr1), null(arr2))):
        return False
    else:
        return And(sequal(car(arr1), car(arr2)), eqlist1(cdr(arr1), cdr(arr2)))


def srember(s, arr):
    if(null(arr)):
        return arr
    elif(sequal(s, car(arr))):
        return cdr(arr)
    else:
        return cons(car(arr), srember(s, cdr(arr)))


def ops(o):
    return Or(eq(o, '+'), Or(eq(o, '*'), Or(eq(o, '-'), Or(eq(o, '/'), eq(o, '^')))))

############################# For expression in any format ###########################################


def numberExp(exp):
    if(null(exp)):
        return True
    elif(atom(car(exp))):
        if(Number(car(exp))):
            if(null(cdr(exp))):
                return True
            elif(ops(car(cdr(exp)))):
                return And(True, numberExp(cdr(cdr(exp))))
            else:
                return False
        elif(ops(car(exp))):
            return And(True, numberExp(cdr(exp)))
        else:
            return False
    elif(null(cdr(exp))):
        return True
    elif(ops(car(cdr(exp)))):
        return And(numberExp(car(exp)), numberExp(cdr(exp)))
    else:
        return False
######################################################################################################

#################### For expression in correct (brackets) format #####################################


def numberExp2(exp):
    if(atom(exp)):
        return Number(exp)
    elif(ops(car(cdr(exp)))):
        return And(numberExp2(car(exp)), numberExp2(car(cdr(cdr(exp)))))
    else:
        return False


def value(exp):
    if(And(atom(exp), Number(exp))):
        return exp
    elif(eq(car(cdr(exp)), '+')):
        return plus(value(car(exp)), value(car(cdr(cdr(exp)))))
    elif(eq(car(cdr(exp)), '-')):
        return minus(value(car(exp)), value(car(cdr(cdr(exp)))))
    elif(eq(car(cdr(exp)), '*')):
        return multiply(value(car(exp)), value(car(cdr(cdr(exp)))))
    elif(eq(car(cdr(exp)), '/')):
        return divide(value(car(exp)), value(car(cdr(cdr(exp)))))
    elif(eq(car(cdr(exp)), '^')):
        return power(value(car(exp)), value(car(cdr(cdr(exp)))))


def value2(exp):
    if(And(atom(exp), Number(exp))):
        return exp
    elif(eq(operator(exp), '+')):
        return plus(value2(firstExp(exp)), value2(secondExp(exp)))
    elif(eq(operator(exp), '-')):
        return minus(value2(firstExp(exp)), value2(secondExp(exp)))
    elif(eq(operator(exp), '*')):
        return multiply(value2(firstExp(exp)), value2(secondExp(exp)))
    elif(eq(operator(exp), '/')):
        return divide(value2(firstExp(exp)), value2(secondExp(exp)))
    elif(eq(operator(exp), '^')):
        return power(value2(firstExp(exp)), value2(secondExp(exp)))


def firstExp(exp):
    return car(cdr(exp))


def secondExp(exp):
    return car(cdr(cdr(exp)))


def operator(exp):
    return car(exp)


def sero(s):
    return null(s)


def sadd1(s):
    return cons([], s)


def ssub1(s):
    return cdr(s)


def splus(n, m):
    if(sero(m)):
        return n
    else:
        return sadd1(splus(n, ssub1(m)))
######################################################################################################


def set(arr):
    if(null(arr)):
        return True
    elif(member(car(arr), cdr(arr))):
        return False
    else:
        return set(cdr(arr))


def makeset1(arr):
    if(null(arr)):
        return arr
    else:
        return cons(car(arr), makeset1(multirember(car(arr), cdr(arr))))


def makeset(arr):
    if(null(arr)):
        return arr
    elif(member(car(arr), cdr(arr))):
        return makeset(cdr(arr))
    else:
        return cons(car(arr), makeset(cdr(arr)))


def subset(s1, s2):
    if(null(s1)):
        return True
    else:
        return And(member(car(s1), s2), subset(cdr(s1), s2))


def eqset1(s1, s2):
    if(And(null(s1), null(s2))):
        return True
    elif(Or(null(s1), null(s2))):
        return False
    else:
        return eqset1(rember(car(s1), s1), rember(car(s1), s2))


def eqset(s1, s2):
    return And(subset(s1, s2), subset(s2, s1))


def isIntersect(s1, s2):
    if(null(s1)):
        return False
    else:
        return Or(member(car(s1), s2), isIntersect(cdr(s1), s2))


def intersect(s1, s2):
    if(null(s1)):
        return []
    elif(member(car(s1), s2)):
        return cons(car(s1), intersect(cdr(s1), s2))
    else:
        return intersect(cdr(s1), s2)


def union(s1, s2):
    if(null(s1)):
        return s2
    elif(member(car(s1), s2)):
        return union(cdr(s1), s2)
    else:
        return cons(car(s1), union(cdr(s1), s2))


def setDiff(s1, s2):
    if(null(s1)):
        return []
    elif(member(car(s1), s2)):
        return setDiff(cdr(s1), s2)
    else:
        return cons(car(s1), setDiff(cdr(s1), s2))


def intersectAll(s):
    if(null(cdr(s))):
        return car(s)
    else:
        return intersectAll(cons(intersect(car(s), car(cdr(s))), cdr(cdr(s))))


def intersectAll1(s):
    if(null(cdr(s))):
        return car(s)
    else:
        return intersect(car(s), intersectAll1(cdr(s)))


def isPair(s):
    if(null(s)):
        return False
    elif(atom(s)):
        return False
    elif(null(cdr(s))):
        return False
    elif(null(cdr(cdr(s)))):
        return True
    else:
        return False


def pairFirst(s):
    return car(s)


def pairSecond(s):
    return (car(cdr(s)))


def buildPair(s1, s2):
    return cons(s1, cons(s2, []))


def rel(p):
    if(null(p)):
        return True
    elif(set(p)):
        return And(isPair(car(p)), rel(cdr(p)))
    else:
        return False


def fun(rel):
    return set(firsts(rel))


def revpair(p):
    return buildPair(pairSecond(p), pairFirst(p))


def revrel(rel):
    if(null(rel)):
        return []
    else:
        return cons(revpair(car(rel)), revrel(cdr(rel)))


def fullFun(rel):
    return And(fun(rel), set(seconds(rel)))


def remberF(func, a, arr):
    return func(a, arr)


exp = [[[4, '-', 1], '*', 7], '-', 8]
ccc = value(exp)
print(ccc)
