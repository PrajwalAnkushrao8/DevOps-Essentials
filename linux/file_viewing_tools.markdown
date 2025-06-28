# Linux File Viewing Tools

This document covers Linux commands for viewing and searching file contents: `cat`, `less`, `more`, `head`, `tail`, and `grep`. Each command includes a description, common options, and practical examples to help you effectively view and manipulate text files.

## 1. cat (Concatenate and Display Files)
- **Description**: Displays the contents of one or more files, concatenates files, or redirects output to a new file.
- **Common Options**:
  - `-n`: Number all output lines.
  - `-b`: Number non-blank lines.
  - `-s`: Squeeze multiple blank lines into one.
- **Examples**:
  ```bash
  cat file.txt                 # Display contents of file.txt
  cat -n file.txt              # Display file.txt with line numbers
  cat file1.txt file2.txt      # Concatenate and display file1.txt and file2.txt
  cat file1.txt file2.txt > combined.txt  # Concatenate files into combined.txt
  cat -s file.txt              # Display file.txt with squeezed blank lines
  ```

## 2. less (View File Contents Interactively)
- **Description**: Displays file contents one page at a time, allowing navigation (scrolling, searching).
- **Common Options**:
  - `-N`: Show line numbers.
  - `-i`: Ignore case when searching.
  - `-S`: Chop long lines instead of wrapping.
- **Navigation**:
  - `Space`: Next page.
  - `b`: Previous page.
  - `/pattern`: Search for `pattern`.
  - `q`: Quit.
- **Examples**:
  ```bash
  less file.txt                # View file.txt interactively
  less -N file.txt             # View with line numbers
  less -i file.txt             # View with case-insensitive search
  less -S longlines.txt        # View without line wrapping
  ```

## 3. more (View File Contents Page by Page)
- **Description**: Displays file contents one page at a time, with less interactivity than `less`.
- **Common Options**:
  - `+n`: Start at line number `n`.
  - `-n`: Display `n` lines per page.
  - `+ /pattern`: Start at the first occurrence of `pattern`.
- **Navigation**:
  - `Space`: Next page.
  - `Enter`: Next line.
  - `q`: Quit.
- **Examples**:
  ```bash
  more file.txt                # View file.txt page by page
  more +10 file.txt            # Start at line 10
  more -5 file.txt             # Display 5 lines per page
  more +/error log.txt         # Start at first occurrence of "error"
  ```

## 4. head (Display First Lines of a File)
- **Description**: Displays the first 10 lines of a file by default.
- **Common Options**:
  - `-n N`: Display the first `N` lines.
  - `-c N`: Display the first `N` bytes.
- **Examples**:
  ```bash
  head file.txt                # Display first 10 lines of file.txt
  head -n 5 file.txt           # Display first 5 lines
  head -c 100 file.txt         # Display first 100 bytes
  head file1.txt file2.txt     # Display first 10 lines of multiple files
  ```

## 5. tail (Display Last Lines of a File)
- **Description**: Displays the last 10 lines of a file by default.
- **Common Options**:
  - `-n N`: Display the last `N` lines.
  - `-c N`: Display the last `N` bytes.
  - `-f`: Follow the file, showing new lines as they are appended (useful for logs).
- **Examples**:
  ```bash
  tail file.txt                # Display last 10 lines of file.txt
  tail -n 5 file.txt           # Display last 5 lines
  tail -c 100 file.txt         # Display last 100 bytes
  tail -f /var/log/syslog      # Follow syslog for real-time updates
  ```

## 6. grep (Search Text Using Patterns)
- **Description**: Searches for a pattern in files or input and displays matching lines.
- **Common Options**:
  - `-i`: Ignore case.
  - `-r`: Recursive search in directories.
  - `-n`: Show line numbers.
  - `-v`: Show non-matching lines.
  - `-w`: Match whole words only.
  - `-c`: Count matching lines.
- **Examples**:
  ```bash
  grep "error" log.txt         # Find lines containing "error" in log.txt
  grep -i "error" log.txt      # Case-insensitive search
  grep -r "TODO" /home/user    # Recursively search for "TODO" in /home/user
  grep -n "error" log.txt      # Show line numbers with matches
  grep -v "info" log.txt       # Show lines not containing "info"
  grep -c "error" log.txt      # Count lines with "error"
  ```

## Practical Tips
- **Use `cat` for small files**: For quick viewing or concatenation, but avoid for large files.
- **Prefer `less` for large files**: It’s more efficient than `cat` and allows navigation.
- **Combine `grep` with pipes**: Use with other commands (e.g., `cat file.txt | grep error`).
- **Monitor logs with `tail -f`**: Useful for real-time log monitoring (e.g., `/var/log/syslog`).
- **Search efficiently**: Use `grep -r` for directories, and combine with `-i` or `-w` for precision.
- **Escape special characters in `grep`**: Use quotes or `\` for patterns with spaces or special characters (e.g., `grep "my pattern" file.txt`).

## Practice Tasks
1. Create a file `test.txt` with some text and display its contents using `cat`.
2. View `test.txt` with line numbers using `less`.
3. Display the first 3 lines of `test.txt` using `head`.
4. Display the last 5 lines of `test.txt` using `tail`.
5. Search for the word "test" in `test.txt` with line numbers using `grep`.
6. Combine `tail` and `grep` to show the last 10 lines containing "error" in a log file.

**Solution**:
```bash
echo -e "Line 1\ntest line\nLine 3\ntest case\nLine 5" > test.txt
cat test.txt
less -N test.txt              # Press 'q' to quit
head -n 3 test.txt
tail -n 5 test.txt
grep -n "test" test.txt
tail -n 10 /var/log/syslog | grep "error"
```