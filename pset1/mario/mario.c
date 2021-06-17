#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int height;

    // Get height of the pyramid from user. Repeat question if input is negative until user enters a positive integer.
    do
    {
        height = get_int("%s", "How high do you want your pyramids to be? Enter a positive integer: ");
    }
    while ((height < 1) || (height > 8));

    // Loop for generating the hash pattern.

    // First for loop for iterating rows.
    for (int i = 1; i <= height; i++)
    {
        // Second for loop for printing whitespaces.
        for (int k = 0; k < (height - i); k++)
        {
            printf(" ");
        }

        // Third for loop for printing the hashes.
        for (int j = 1; j <= i; j++)
        {
            printf("#");
        }

        // Fourth for loop for printing the spaces between pyramids.
        for (int a = 0; a < 2; a++)
        {
            printf(" ");
        }

        // Fifth for loop for printing the second pyramid.

        for (int b = 1; b <= i; b++)
        {
            printf("#");
        }

        printf("\n");



    }

}
