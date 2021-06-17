#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

void encrypt(int loop_count, string text, int key);

int main(int argc, string argv[])
{
    // Check if the number of args provided are correct.
    if (argc != 2)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
    else
    {
        // Check if the type of args provided is correct.
        int key = atoi(argv[1]);
        printf("%i\n", key);
        int key_len = strlen(argv[1]);
        for (int i = 0; i < key_len; i++)
        {
            if (!isdigit(argv[1][i]))
            {
                printf("Usage: ./caesar key\n");
                return 1;
            }
        }

        // Get text to encrypt from user.
        string plaintext = get_string("Plaintext: ");
        int plaintext_len = strlen(plaintext);

        // Caesar's Encryption in action.
        encrypt(plaintext_len, plaintext, key);
    }
}



// Function for Caesar's Encryption.
void encrypt(int loop_count, string text, int key)
{
    for (int i = 0; i < loop_count; i++)
    {
        if (isupper(text[i]))
        {
            text[i] = (((int)text[i] - 65 + key) % 26 + 65);
        }
        if (islower(text[i]))
        {
            text[i] = (((int)text[i] - 97 + key) % 26 + 97);
        }

    }
    printf("ciphertext: %s\n", text);
}