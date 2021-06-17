#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <math.h>

int main(void)
{

    float change = 0;

    do
    {
        // Ask user for change owed.
        change = get_float("Please enter the amount owed: ");
    }
    while (change < 0);


    // Convert float value into int for precision of calculation.
    int cents = round(change * 100);

    // Print minimum number of coins needed.
    // printf("This is the amount of cents owed: %i\n", cents);

    int coin_counter = 0;

    // While loop for calculating 25cent coins.
    while (cents >= 25)
    {
        coin_counter++;
        cents -= 25;
    }
    // While loop for calculating 10cent coins.
    while (cents >= 10)
    {
        coin_counter++;
        cents -= 10;
    }

    // While loop for calculating 5cent coins.
    while (cents >= 5)
    {
        coin_counter++;
        cents -= 5;
    }

    // While loop for calculating 1cent coins.
    while (cents >= 1)
    {
        coin_counter++;
        cents -= 1;
    }

    // Print minimum number of coins needed.
    printf("This is the minimum number of coins needed: %i\n", coin_counter);

}