import csv
import sys

# Function to get the maximum number of counts the STR repeats within a sequence


def get_Max_STR_Count(sequence, STR):
    sequence_length = len(sequence)
    STR_length = len(STR)

    max_STR_count = 0
    STR_count = 0

    for i in range(sequence_length):

        if STR == sequence[i:i + STR_length]:
            if(sequence[i: i + STR_length] == sequence[i - STR_length: i] and sequence[i: i + STR_length] == STR):

                STR_count += 1
                i = i + STR_length
            else:
                if max_STR_count < STR_count:
                    max_STR_count = STR_count
                STR_count = 1
                i = i + STR_length

            if max_STR_count < STR_count:
                max_STR_count = STR_count

    return max_STR_count


# require CLAs for dict and seq else error
# open the CSV file and store its contents
# open the seq into memory
# compute longest combination of STRs
# match the calculated STRs with the DATABASE

# Ensure correct usage
if len(sys.argv) != 3:
    sys.exit("Usage: python dna.py database.csv sequence.txt")

# List for Storing Database
database = []

# Opening .csv file for manipulation
with open(sys.argv[1]) as file:
    reader = csv.DictReader(file)
    for row in file:
        # Removing White Spaces
        item = row.split()

        # Converting item (list) into String to use the .split() method
        string = ' '.join([str(elem) for elem in item])

        # Storing comma separated items a different elements in database list item
        db_element = string.split(",")
        database.append(db_element)


# Number of STRs in the Database
number_of_STRs = len(database[0]) - 1

# Removing header from the Database
header = database.pop(0)

# Converting STRs in Database from strings to ints
for item in database:
    for i in range(1, number_of_STRs + 1):
        item[i] = int(item[i])

sequence = ""

# Loading the sequence to be tested and storing as a string
with open(sys.argv[2]) as file:
    reader = csv.reader(file)
    for row in reader:
        sequence = ' '.join([str(elem) for elem in row])


# Creating and Initializing a dictionary for keeping count of substrings

STR_count_dict = {}

for item in header[1:]:
    if item not in STR_count_dict.keys():
        STR_count_dict[item] = 0


# Computing Substrings
for i in range(1, len(header)):
    max_STR_Count = get_Max_STR_Count(sequence, header[i])
    STR_count_dict[header[i]] = max_STR_Count


# STR counts dict to list
STR_count_list = []
for item in STR_count_dict:
    STR_count_list.append(STR_count_dict[item])

# Matching DNAs
for item in database:
    if item[1:] == STR_count_list:
        print(item[0])
        exit()
print("No Match")

