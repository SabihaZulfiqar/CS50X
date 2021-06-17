#include <stdio.h>
#include <cs50.h>
#include <math.h>

void get_card_number(void);
int get_card_length(long user_card_number);
long find_first_digit(int digit_count, long original_card_number);
long find_second_digit(int digit_count, long original_card_number);
void card_type(long starting_first, long starting_second, int digit_count, int checksum);
long card_number = 0;

int main(void)
{
    // Get the card number from user
    get_card_number();
    // Backup copy of card number.
    long original_card_number = card_number;
    // Get the digit_count
    int digit_count = get_card_length(card_number);
    // Calculate Checksum.
    int checksum = 0;
    int digit = 0;
    for (int i = 1; i < digit_count; i += 2)
    {
        long checksum_divisor = pow(10, i);
        digit = ((original_card_number / checksum_divisor) % 10);
        digit *= 2;

        int part_digit = 0;
        int sum = 0;

        while (!((digit >= 0) && (digit <= 9)))
        {
            part_digit = digit % 10;
            sum += part_digit;
            digit /= 10;
        }

        if ((digit >= 0) && (digit <= 9))
        {
            sum += digit;
        }

        checksum += sum;
    }

    for (int i = 0; i < digit_count; i += 2)
    {
        long checksum_divisor = pow(10, i);
        digit = ((original_card_number / checksum_divisor) % 10);
        checksum += digit;
    }


    // Function for checking starting digits.
    long starting_first = find_first_digit(digit_count, original_card_number);
    long starting_second = find_second_digit(digit_count, original_card_number);

    // Function for printing type of credit card.
    card_type(starting_first, starting_second, digit_count, checksum);

}

// GETS CARD NUMBER FROM USER

void get_card_number(void)
{
    do
    {
        card_number = get_long("Please enter your credit card number: ");
    }
    while (card_number < 0);
}

// GETS CARD LENGTH

int get_card_length(long user_card_number)
{
    int digit_count = 0;
    while (user_card_number > 0)
    {
        user_card_number /= 10;
        digit_count++;
    }
    return digit_count;
}

// GETS FIRST DIGIT

long find_first_digit(int digit_count, long original_card_number)
{
    long power_for_first = digit_count - 1;
    long divisor_first = pow(10, power_for_first);
    long starting_first = (original_card_number / divisor_first);
    return starting_first;
}

// GETS SECOND DIGIT

long find_second_digit(int digit_count, long original_card_number)
{
    long power_for_second = digit_count - 2;
    long divisor_second = pow(10, power_for_second);
    long starting_second = (original_card_number / divisor_second);

    starting_second %= 10;
    return starting_second;
}

// PRINTS CREDIT CARD TYPE

void card_type(long starting_first, long starting_second, int digit_count, int checksum)
{
    switch (starting_first)
    {
        case 3:
            if ((starting_second == 4 | starting_second == 7) & (digit_count == 15) & ((checksum % 10) == 0))
            {
                printf("AMEX\n");
            }
            else
            {
                printf("INVALID\n");
            }
            break;
        case 4:
            if ((digit_count == 13 | digit_count == 16) & ((checksum % 10) == 0))
            {
                printf("VISA\n");
            }
            else
            {
                printf("INVALID\n");
            }
            break;
        case 5:
            if ((starting_second == 1 | starting_second == 2 | starting_second == 3 | starting_second == 4 | starting_second == 5) &
                (digit_count == 16) & ((checksum % 10) == 0))
            {
                printf("MASTERCARD\n");
            }
            else
            {
                printf("INVALID\n");
            }
            break;
        default:
            printf("INVALID\n");
    }
}
