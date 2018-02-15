def print_result(f):
    def f_with_print(*args):
        result = f(*args)
        print("LOG: ", result)
        return result
    return f_with_print

@print_result
def plus_one(x):
    return x + 1

print("RESULT: ", plus_one(3))

