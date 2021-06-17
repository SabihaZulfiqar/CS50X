from cs50 import get_float

while True:
    change = get_float("Please enter the amount owed: ")
    if change > 0:
        break

cents = round(change * 100)

coin_counter = 0

while (cents >= 25):
    coin_counter += 1
    cents -= 25

while (cents >= 10):
    coin_counter += 1
    cents -= 10


while (cents >= 5):
    coin_counter += 1
    cents -= 5

while (cents >= 1):

    coin_counter += 1
    cents -= 1


print("This is the minimum number of coins needed:")
print(coin_counter)