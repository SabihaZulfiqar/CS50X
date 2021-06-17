from cs50 import get_int

while True:
    height = get_int("Please enter a height between 1 to 8 inclusive: ")
    if (height > 0 and height < 9):
        break

for i in range(1, height+1):
    for j in range(1, (height+1)-i):
        print(" ", end="")
    for k in range(0, i):
        print("#", end="")
    print()

