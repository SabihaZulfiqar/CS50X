// Implements a dictionary's functionality
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <stdbool.h>
#include <ctype.h>

#include "dictionary.h"
// Global variable for the size of the dictionary
int DICT_SIZE = 0;
int TABLE_SIZE = 0;

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 1000000;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    int size = strlen(word);
    char word_array[size + 1];
    word_array[size] = '\0';

    for (int i = 0; i < size; i++)
    {
        word_array[i] = word[i];
    }

    unsigned int hashed = hash(word_array);
    node *cursor = table[hashed];

    while (cursor != NULL)
    {
        if (strcasecmp(word, cursor->word) == 0)
        {
            return true;
        }
        else
        {
            cursor = cursor->next;
        }

    }

    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    int hash = 7;
    for (int i = 0; i < strlen(word); i++)
    {
        hash = 21 * (hash + tolower(word[i])) % N;
    }
    return hash;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // Opening the dictionary for reading
    FILE *dict = fopen(dictionary, "r");

    // Case: Unsuccessful Reading
    if (dict == NULL)
    {
        printf("Error Opening Dictionary");
        return false;
    }

    // Buffer for reading one word at a time from the dictionary
    char input_word[LENGTH + 1];

    // Reading dictionary until end of file is reached
    while ((fscanf(dict, "%s", input_word)) != EOF)
    {

        // Allocating memory for nodes
        node *item = malloc(sizeof(node));

        // Case: Unsuccessful Memory Allocation
        if (item == NULL)
        {
            printf("Error Allocating Memory");
            return false;
        }

        // Copying one word from dictionary into one node in memory, and assigning the pointer to next item
        strcpy(item -> word, input_word);
        item -> next = NULL;

        // Stores the return value of hash() to be used as the index of hashtable
        unsigned int index = 0;

        // Getting the hash value
        index = hash(item -> word);

        // Defining head of linked list
        node *head = table[index];

        // Using hash value as index of hashtable
        if (head == NULL)
        {
            table[index] = item;
            DICT_SIZE++;
        }
        else
        {
            item -> next = table[index];
            table[index] = item;
            DICT_SIZE++;
        }
    }
    fclose(dict);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    return DICT_SIZE;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {

        node *cursor = table[i];
        node *tmp = cursor;

        while (cursor != NULL)
        {
            cursor = cursor->next;
            free(tmp);
            tmp = cursor;

        }
    }
    return true;
}
