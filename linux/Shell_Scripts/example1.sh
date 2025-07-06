#!/bin/bash

#########################
# Script to print numbers from 1 to 100 that are divisible by 3 or 5,
# but NOT divisible by 15
#########################

# Loop through numbers 1 to 100
for i in {1..100}; do 
    # Check if divisible by 3 OR 5, AND NOT divisible by 15
    if ([ `expr $i % 3` == 0 ] || [ `expr $i % 5` == 0 ]) && [ `expr $i % 15` != 0 ]; then 
        echo $i  # Print the number
    fi
done
