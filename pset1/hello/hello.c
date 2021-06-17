#include <stdio.h>
#include <cs50.h>
#include <string.h>

int main(void)
{
    // A program for displaying username taken from a user as input.
    string username = get_string("Hi there, please enter your name: ");
    printf("Welcome, %s.\n", username);

    // Uses the string.h library for a function called "strlen" to get the length of a string.
    int length = strlen(username);
    printf("There are %d characters in your name!\n", length);
}