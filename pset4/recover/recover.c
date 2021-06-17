// Libraries
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Global Variables
typedef uint8_t BYTE;
const int Chunk_Size = 512;

// User-Defined Functions
void extract_images(FILE *diskImage);

// Main Program
int main(int argc, char *argv[])
{
    // Checking Command Line Arguments
    if (argc != 2)
    {
        printf("Usage: ./recover diskImageFileName");
        return 1;
    }
    else
    {
        // Reading input file
        FILE *diskImage = fopen(argv[1], "r");

        // Checking File Status
        if (diskImage == NULL)
        {
            printf("Could not open disk image for reading!");
            return 1;
        }
        else
        {
            extract_images(diskImage);
        }

        fclose(diskImage);
    }
}

void extract_images(FILE *diskImage)
{
    int flag = 0;
    FILE *img = NULL;
    BYTE img_buffer[Chunk_Size];
    char filename[8];
    int count = 0;

    FILE *text = NULL;
    text = fopen("text.txt", "w");

    // Checking return value of fread() to equal 1, if it can't read the desired bytes it will return less than 1.
    while (fread(img_buffer, sizeof(img_buffer), 1, diskImage) == 1)
    {
        if ((img_buffer[0] == 0xff) && (img_buffer[1] == 0xd8) && (img_buffer[2] == 0xff) && ((img_buffer[3] & 0xf0) == 0xe0))
        {
            if (flag == 1)
            {
                flag = 0;
                fclose(img);
            }

            if (flag == 0)
            {
                sprintf(filename, "%03i.jpg", count);
                img = fopen(filename, "w");
                fwrite(img_buffer, sizeof(img_buffer), 1, img);
                flag = 1;
                count++;
            }
        }
        else
        {
            if (flag == 1)
            {
                fwrite(img_buffer, sizeof(img_buffer), 1, img);
            }

            if (flag == 0)
            {
                fwrite(img_buffer, sizeof(img_buffer), 1, text);
            }
        }

    }

    fclose(img);
}



