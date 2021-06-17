#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>

bool is_repetitive(string key, int key_length);
bool is_alphabetical(string key, int key_length);

typedef struct
{
    string alphabet;
    string replacement;
}
encrypt;

int main(int argc, string argv[])
{
    if (!(argc == 2))
    {
        printf("Usage: ./substitution 26-letter-non-repetitive-alphabetical-key\n");
        return 1;
    }
    else
    {
        string key = argv[1];
        int key_length = strlen(key);
        if ((!(key_length == 26)) || (is_repetitive(key, key_length)) || (is_alphabetical(key, key_length)))
        {
            printf("Usage: ./substitution 26-letter-non-repetitive-alphabetical-key\n");
            return 1;
        }

        encrypt encryption[1];
        encryption[0].alphabet = "abcdefghijklmnopqrstuvwxyz";
        encryption[0].replacement = key;

        string plaintext = get_string("Plaintext:");

        int text_length = strlen(plaintext);

        char ciphertext[text_length];

        for (int i = 0; i < text_length; i++)
        {
            if (isalpha(plaintext[i]))
            {
                for (int j = 0; j < 26; j++)
                {
                    if (tolower(plaintext[i]) == encryption[0].alphabet[j])
                    {
                        if (isupper(plaintext[i]))
                        {
                            ciphertext[i] = toupper(encryption[0].replacement[j]);
                            break;
                        }
                        else if (islower(plaintext[i]))
                        {
                            ciphertext[i] = tolower(encryption[0].replacement[j]);
                            break;
                        }
                    }
                }
            }

            if (!isalpha(plaintext[i]))
            {
                ciphertext[i] = plaintext[i];
            }

        }

        ciphertext[text_length] = '\0';
        printf("ciphertext: %s\n", ciphertext);

    }

}

bool is_repetitive(string key, int key_length)
{
    string alphabets = "abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 26; i++)
    {
        int duplicate_count = 0;
        for (int j = 0; j < key_length; j++)
        {
            if (alphabets[i] == tolower(key[j]))
            {
                duplicate_count++;
            }

            if (duplicate_count > 1)
            {
                return true;
            }
        }
    }

    return false;
}

bool is_alphabetical(string key, int key_length)
{
    for (int i = 0; i < key_length; i++)
    {
        if (!isalpha(key[i]))
        {
            return true;
        }
    }
    return false;
}