import sys


def add(a: int, b: int) -> int:
    return a + b


def main():
    if len(sys.argv) <= 2:
        print("a and b is required")
        sys.exit(1)
    _, a, b, *_ = sys.argv
    print(add(*map(int, (a, b))))


if __name__ == "__main__":
    main()
