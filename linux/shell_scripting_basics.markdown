# Linux Shell Scripting Basics

This document covers the fundamentals of Bash shell scripting: variables, conditionals, loops, and functions. Each section includes a description, common syntax, and practical examples to help you write and understand basic shell scripts effectively.

## 1. Variables
- **Description**: Store data (strings, numbers) for use in scripts. Variables are case-sensitive and don’t require type declaration.
- **Syntax**:
  - Assign: `variable_name=value` (no spaces around `=`).
  - Access: `$variable_name` or `${variable_name}`.
- **Common Practices**:
  - Use uppercase for environment variables (e.g., `PATH`).
  - Use lowercase for user-defined variables.
  - Quote variables (`"$var"`) to handle spaces or empty values.
- **Examples**:
  ```bash
  # Define variables
  name="Alice"
  age=25

  # Access variables
  echo "Name: $name, Age: $age"
  # Output: Name: Alice, Age: 25

  # Use variables in commands
  file="myfile.txt"
  touch "$file"
  echo "Created $file"

  # Environment variable
  export MY_VAR="Hello"
  echo $MY_VAR
  ```
- **Note**: Use `export` to make variables available to child processes. Use `unset variable_name` to remove a variable.

## 2. Conditionals
- **Description**: Execute code based on conditions using `if`, `elif`, `else`.
- **Syntax**:
  ```bash
  if [ condition ]; then
      commands
  elif [ condition ]; then
      commands
  else
      commands
  fi
  ```
- **Common Test Operators**:
  - Strings: `=`, `!=`, `-z` (empty), `-n` (non-empty).
  - Numbers: `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`.
  - Files: `-f` (file exists), `-d` (directory exists), `-r` (readable).
- **Examples**:
  ```bash
  # Check if a variable is set
  name="Bob"
  if [ -n "$name" ]; then
      echo "Name is set: $name"
  else
      echo "Name is empty"
  fi
  # Output: Name is set: Bob

  # Compare numbers
  age=20
  if [ $age -gt 18 ]; then
      echo "Adult"
  else
      echo "Minor"
  fi
  # Output: Adult

  # Check if file exists
  if [ -f "myfile.txt" ]; then
      echo "File exists"
  else
      echo "File does not exist"
  fi
  ```

## 3. Loops
- **Description**: Repeat commands using `for`, `while`, or `until` loops.
- **Types**:
  - **For Loop**: Iterates over a list or range.
  - **While Loop**: Runs while a condition is true.
  - **Until Loop**: Runs until a condition is true.
- **Syntax**:
  - For:
    ```bash
    for item in list; do
        commands
    done
    ```
  - While:
    ```bash
    while [ condition ]; do
        commands
    done
    ```
  - Until:
    ```bash
    until [ condition ]; do
        commands
    done
    ```
- **Examples**:
  ```bash
  # For loop over a list
  for i in 1 2 3; do
      echo "Number: $i"
  done
  # Output: Number: 1, Number: 2, Number: 3

  # For loop over files
  for file in *.txt; do
      echo "Found file: $file"
  done

  # While loop
  count=1
  while [ $count -le 3 ]; do
      echo "Count: $count"
      ((count++))
  done
  # Output: Count: 1, Count: 2, Count: 3

  # Until loop
  count=1
  until [ $count -gt 3 ]; do
      echo "Until count: $count"
      ((count++))
  done
  # Output: Until count: 1, Until count: 2, Until count: 3
  ```

## 4. Functions
- **Description**: Reusable blocks of code defined with a name, allowing parameter passing and modularity.
- **Syntax**:
  ```bash
  function_name() {
      commands
      # Use $1, $2, ... for parameters
  }
  ```
- **Common Practices**:
  - Use `return [n]` for exit status (0-255).
  - Access parameters with `$1`, `$2`, etc., or `$@` for all.
- **Examples**:
  ```bash
  # Define a function
  greet() {
      echo "Hello, $1!"
  }

  # Call function
  greet Alice
  # Output: Hello, Alice!

  # Function with multiple parameters
  add() {
      sum=$(( $1 + $2 ))
      echo "Sum: $sum"
  }
  add 5 3
  # Output: Sum: 8

  # Function with return status
  check_file() {
      if [ -f "$1" ]; then
          echo "File exists"
          return 0
      else
          echo "File not found"
          return 1
      fi
  }
  check_file myfile.txt
  echo "Exit status: $?"
  ```

## Practical Tips
- **Shebang**: Start scripts with `#!/bin/bash` to specify Bash.
- **Make executable**: Use `chmod +x script.sh` to run scripts (`./script.sh`).
- **Quote variables**: Always use `"$var"` to handle spaces or empty values.
- **Debug scripts**: Run with `bash -x script.sh` to trace execution.
- **Test conditions carefully**: Use double brackets `[[ ]]` for safer string comparisons.
- **Use functions for modularity**: Break complex scripts into reusable functions.
- **Check exit status**: Use `$?` to verify command or function success (0 = success).

## Practice Tasks
1. Create a script that sets a variable `username` and prints a greeting.
2. Write a script with an `if` statement to check if a file exists.
3. Create a script with a `for` loop to list all `.txt` files in the current directory.
4. Write a `while` loop to count from 1 to 5.
5. Define a function to calculate the square of a number passed as a parameter.
6. Create a script combining a function and conditional to check if a number is even or odd.

**Solution** (save as `script.sh` and run with `chmod +x script.sh && ./script.sh`):
```bash
#!/bin/bash

# Task 1: Variable
username="Alice"
echo "Hello, $username!"

# Task 2: Conditional
if [ -f "test.txt" ]; then
    echo "test.txt exists"
else
    echo "test.txt does not exist"
fi

# Task 3: For loop
for file in *.txt; do
    echo "Text file: $file"
done

# Task 4: While loop
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Task 5: Function for square
square() {
    result=$(( $1 * $1 ))
    echo "Square of $1 is $result"
}
square 4

# Task 6: Function with conditional
is_even() {
    if [ $(( $1 % 2 )) -eq 0 ]; then
        echo "$1 is even"
    else
        echo "$1 is odd"
    fi
}
is_even 6
```