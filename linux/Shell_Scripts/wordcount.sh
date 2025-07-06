#!/bin/bash

# Define a string variable
x=mississipi

# Count the number of occurrences of the letter 's' in the string
# - grep -o "s" outputs each 's' on a new line
# - wc -l counts the number of lines (i.e., number of 's')
grep -o "s" <<<"$x" | wc -l
