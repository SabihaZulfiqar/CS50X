from cs50 import get_string
import string

text = get_string("Please input the text for grade evaluation: ")

text_length = len(text)
char_count = 0
word_count = 0
sent_count = 0
index = 0

for i in range(text_length):

    if text[i].isalpha():
        char_count += 1

    if text[i].isspace():
        word_count += 1

    if ((text[i] == '.') or (text[i] == '!') or (text[i] == '?')):
        sent_count += 1

word_count += 1

L = ((float(char_count)) * (float(100))) / (float(word_count))
S = ((float(sent_count)) * (float(100))) / (float(word_count))

index = round(0.0588 * L - 0.296 * S - 15.8)

if (index >= 16):
    print("Grade 16+\n")
elif (index < 1):
    print("Before Grade 1\n")
else:
    print("Grade {} \n".format(index))
