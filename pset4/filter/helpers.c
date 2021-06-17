#include "helpers.h"
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    int average = 0;

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            average = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            image[i][j].rgbtRed = average;
            image[i][j].rgbtGreen = average;
            image[i][j].rgbtBlue = average;
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    int sepiaRed = 0;
    int sepiaGreen = 0;
    int sepiaBlue = 0;

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            sepiaRed = round(0.393 * image[i][j].rgbtRed + 0.769 * image[i][j].rgbtGreen + 0.189 * image[i][j].rgbtBlue);
            sepiaGreen = round(0.349 * image[i][j].rgbtRed + 0.686 * image[i][j].rgbtGreen + 0.168 * image[i][j].rgbtBlue);
            sepiaBlue = round(0.272 * image[i][j].rgbtRed + 0.534 * image[i][j].rgbtGreen + 0.131 * image[i][j].rgbtBlue);

            if (sepiaRed > 255)
            {
                sepiaRed = 255;
            }
            if (sepiaGreen > 255)
            {
                sepiaGreen = 255;
            }
            if (image[i][j].rgbtBlue > 255)
            {
                image[i][j].rgbtRed = 255;
            }

            image[i][j].rgbtRed = sepiaRed;
            image[i][j].rgbtGreen = sepiaGreen;
            image[i][j].rgbtBlue = sepiaBlue;
        }
    }

    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    int half_width = width / 2;
    int temp[3];

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < half_width; j++)
        {
            temp[0] = image[i][j].rgbtRed;
            temp[1] = image[i][j].rgbtGreen;
            temp[2] = image[i][j].rgbtBlue;

            image[i][j].rgbtRed = image[i][width - j - 1].rgbtRed;
            image[i][j].rgbtGreen = image[i][width - j - 1].rgbtGreen;
            image[i][j].rgbtBlue = image[i][width - j - 1].rgbtBlue;

            image[i][width - j - 1].rgbtRed = temp[0];
            image[i][width - j - 1].rgbtGreen = temp[1];
            image[i][width - j - 1].rgbtBlue = temp[2];
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp[height][width];

    for (int row = 0; row < height; row++)
    {
        for (int col = 0; col < width; col++)
        {
            int indices[] = {-1, 0, 1};

            int newRed = 0;
            int newBlue = 0;
            int newGreen = 0;
            int count = 0;

            int length_of_indices = 3;

            for (int i = 0; i < length_of_indices; i++)
            {
                for (int j = 0; j < length_of_indices; j++)
                {
                    int calc_row = row + indices[i];
                    int calc_col = col + indices[j];
                    if (calc_row >= 0 && calc_row <= (height - 1) && calc_col >= 0 && calc_col <= (width - 1))
                    {
                        newRed += image[calc_row][calc_col].rgbtRed;
                        newBlue += image[calc_row][calc_col].rgbtBlue;
                        newGreen += image[calc_row][calc_col].rgbtGreen;
                        count++;
                    }
                }
            }

            temp[row][col].rgbtRed = round(newRed / (float) count);
            temp[row][col].rgbtBlue = round(newBlue / (float) count);
            temp[row][col].rgbtGreen = round(newGreen / (float) count);
        }
    }

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image[i][j].rgbtRed =  temp[i][j].rgbtRed;
            image[i][j].rgbtGreen =  temp[i][j].rgbtGreen;
            image[i][j].rgbtBlue =  temp[i][j].rgbtBlue;
        }
    }
    return;
}

