#include <stdio.h>
#include <cs50.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

int main(void)
{

    // Get text for evaluation from the user.
    string text = get_string("Please input the text for grade evaluation: ");

    int text_length = strlen(text);
    int char_count = 0;
    int word_count = 0;
    int sent_count = 0;

    double L;
    double S;
    int index = 0;

    // Count the number of characters, words and sentences.
    for (int i = 0; i < text_length; i++)
    {
        if (isalpha(text[i]))
        {
            char_count++;
        }
        if (isblank(text[i]))
        {
            word_count++;
        }
        if ((text[i] == '.') || (text[i] == '!') || (text[i] == '?'))
        {
            sent_count++;
        }
    }

    word_count += 1;

    // Calculate the index of reading.
    L = (((double)char_count) * ((double)100)) / ((double)word_count);
    S = (((double)sent_count) * ((double)100)) / ((double)word_count);

    index = round(0.0588 * L - 0.296 * S - 15.8);

    if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade %i\n", index);
    }
}

