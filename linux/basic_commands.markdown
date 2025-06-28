# Linux Basic Commands

This document covers the foundational Linux commands for navigating and managing files and directories: `ls`, `cd`, `mv`, `cp`, `rm`, `touch`, and `mkdir`. Each command includes a description, common options, and practical examples.

## 1. ls (List Directory Contents)
- **Description**: Displays files and directories in the current directory.
- **Common Options**:
  - `-l`: Long format (shows permissions, owner, size, etc.).
  - `-a`: Includes hidden files (those starting with `.`).
  - `-h`: Human-readable file sizes (used with `-l`).
  - `-t`: Sort by modification time (newest first).
  - `-r`: Reverse sort order.
- **Examples**:
  ```bash
  ls                   # List files and directories
  ls -l                # List in long format
  ls -la               # List all files, including hidden, in long format
  ls -lh               # List with human-readable sizes
  ls -ltr              # List in long format, sorted by time, reversed
  ```

## 2. cd (Change Directory)
- **Description**: Navigates to a specified directory.
- **Common Options**: None typically used, but special arguments exist:
  - `..`: Move up one directory.
  - `~`: Go to the user’s home directory.
  - `-`: Return to the previous directory.
- **Examples**:
  ```bash
  cd /home/user/docs   # Navigate to the docs directory
  cd ..                # Move up one directory
  cd ~                 # Go to home directory
  cd -                 # Return to the previous directory
  cd                   # Go to home directory (no argument)
  ```

## 3. mv (Move/Rename Files or Directories)
- **Description**: Moves or renames files and directories.
- **Common Options**:
  - `-i`: Prompt before overwriting.
  - `-f`: Force overwrite without prompting.
  - `-v`: Verbose, show what is being done.
- **Examples**:
  ```bash
  mv file.txt /home/user/docs/       # Move file.txt to docs directory
  mv file.txt newname.txt            # Rename file.txt to newname.txt
  mv -i file.txt /home/user/docs/    # Move with overwrite prompt
  mv -v myfolder /home/user/backup/  # Move directory with verbose output
  ```

## 4. cp (Copy Files or Directories)
- **Description**: Copies files or directories.
- **Common Options**:
  - `-r`: Recursive, copy directories and their contents.
  - `-i`: Prompt before overwriting.
  - `-v`: Verbose, show what is being done.
- **Examples**:
  ```bash
  cp file.txt /home/user/backup/         # Copy file.txt to backup directory
  cp -r myfolder /home/user/backup/      # Copy myfolder and its contents
  cp -i file.txt /home/user/backup/      # Copy with overwrite prompt
  cp -v file.txt file_copy.txt           # Copy with verbose output
  ```

## 5. rm (Remove Files or Directories)
- **Description**: Deletes files or directories.
- **Common Options**:
  - `-r`: Recursive, delete directories and their contents.
  - `-f`: Force deletion without prompting.
  - `-i`: Prompt before each deletion.
  - `-v`: Verbose, show what is being deleted.
- **Examples**:
  ```bash
  rm file.txt                # Delete file.txt
  rm -r myfolder             # Delete myfolder and its contents
  rm -rf myfolder            # Force delete myfolder without prompting
  rm -i file.txt             # Delete with prompt
  rm -v *.txt                # Delete all .txt files with verbose output
  ```
- **Caution**: Use `rm -rf` carefully, as it deletes files permanently without recovery.

## 6. touch (Create Empty Files or Update Timestamps)
- **Description**: Creates empty files or updates the timestamp of existing files.
- **Common Options**:
  - `-m`: Update modification time only.
  - `-a`: Update access time only.
  - `-c`: Do not create the file if it doesn’t exist.
- **Examples**:
  ```bash
  touch newfile.txt          # Create empty file newfile.txt
  touch -m existing.txt      # Update modification time of existing.txt
  touch -c nonexistent.txt   # Do nothing if file doesn’t exist
  touch file1.txt file2.txt  # Create multiple files
  ```

## 7. mkdir (Make Directories)
- **Description**: Creates new directories.
- **Common Options**:
  - `-p`: Create parent directories as needed (no error if they exist).
  - `-v`: Verbose, show each directory created.
- **Examples**:
  ```bash
  mkdir myfolder                   # Create a directory named myfolder
  mkdir -p /home/user/docs/new     # Create nested directories
  mkdir -v folder1 folder2         # Create multiple directories with verbose output
  ```

## Practical Tips
- **Tab Completion**: Press `Tab` to auto-complete file or directory names.
- **Command History**: Use `up` and `down` arrows to navigate previous commands.
- **Combine Commands**: Use `&&` to run commands sequentially (e.g., `mkdir myfolder && cd myfolder`).
- **Safety with `rm`**: Double-check paths with `rm -rf` to avoid accidental deletion.
- **Practice Environment**: Use a virtual machine or non-critical directory for testing.

## Practice Tasks
1. Create a directory `test`, navigate into it, and create an empty file `example.txt`.
2. Copy `example.txt` to `backup.txt` in the same directory.
3. Rename `backup.txt` to `backup_copy.txt`.
4. List all files in long format, including hidden ones.
5. Delete `example.txt` and the `test` directory.

**Solution**:
```bash
mkdir test
cd test
touch example.txt
cp example.txt backup.txt
mv backup.txt backup_copy.txt
ls -la
rm example.txt
cd ..
rm -r test
```