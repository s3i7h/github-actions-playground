import sys
import os  # unused import


def add(a: int, b: int) -> int:
    return a + b


def main():
    unused_variable = 1
    
    if len(sys.argv) <= 2:
        print("a and b is required")
        sys.exit(1)
    _, a, b, *_ = sys.argv
    print(add(*map(int, (a, b))))


if __name__ == "__main__":
    main()
