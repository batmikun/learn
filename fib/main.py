def main(n):
    if (n == 0) or (n == 1):
        return 1

    return main(n - 1) + main(n - 2)

print(main(7))
