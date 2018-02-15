def takes_all(a, b, *args, **kwargs):
    print("a=%s" % a)
    print("b=%s" % b)

    if len(args) > 0:
        for i in range(0, len(args) - 1):
            print("args[%s]=%s" % (i, args[i]))
    else:
        print("args is empty")

    if len(kwargs) > 0:
        for k in kwargs:
            print("kwargs[%s]=%s" % (k, kwargs[k]))
    else:
        print("kwargs is empty")

print("** takes_all(1, 2) **")
takes_all(1, 2)

print("** takes_all(1, 2, 3, 4, 5, foo=6, bar=7) **")
takes_all(1, 2, 3, 4, 5, foo=6, bar=7)

print("** takes_all(1, 2, foo=6, bar=7) **")
takes_all(1, 2, 3, foo=6, bar=7)

print("** takes_all(1, 2, 3, 4, 5) **")
takes_all(1, 2, 3, 4, 5)

