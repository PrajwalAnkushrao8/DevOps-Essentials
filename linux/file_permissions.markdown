# Linux File Permissions

This document covers Linux file permission commands: `chmod`, `chown`, `umask`, and `stat`. Each command includes a description, common options, and practical examples to help you understand and manage file permissions effectively.

## 1. chmod (Change File Mode)
- **Description**: Modifies file or directory permissions (read, write, execute) for owner, group, and others.
- **Permission Types**:
  - `r` (read): 4
  - `w` (write): 2
  - `x` (execute): 1
- **Permission Levels**:
  - `u`: User (owner)
  - `g`: Group
  - `o`: Others
  - `a`: All (user, group, others)
- **Common Options**:
  - `-R`: Recursive, apply to directories and their contents.
  - `-v`: Verbose, show changes made.
- **Syntax**:
  - Numeric mode: `chmod [permissions] file` (e.g., `755` = `rwxr-xr-x`).
  - Symbolic mode: `chmod [who][+|-|=][permissions] file` (e.g., `u+x` adds execute for owner).
- **Examples**:
  ```bash
  chmod 644 file.txt            # Set owner: read/write (6), group/others: read (4)
  chmod 755 script.sh           # Set owner: rwx (7), group/others: rx (5)
  chmod -R 700 myfolder         # Set owner: rwx, group/others: none, recursively
  chmod u+x script.sh           # Add execute permission for owner
  chmod go-r file.txt           # Remove read permission for group and others
  chmod -v a+w file.txt         # Add write for all, with verbose output
  ```

## 2. chown (Change Owner)
- **Description**: Changes the owner and/or group of a file or directory.
- **Common Options**:
  - `-R`: Recursive, apply to directories and their contents.
  - `-v`: Verbose, show changes made.
  - `-h`: Modify symbolic link itself, not the target.
- **Syntax**:
  - `chown [user]:[group] file`
  - Omit `:[group]` to change only the owner.
- **Examples**:
  ```bash
  chown user1 file.txt                # Change owner to user1
  chown user1:group1 file.txt         # Change owner to user1 and group to group1
  chown -R user1:group1 myfolder      # Change owner and group recursively
  chown -v user2 file.txt             # Change owner with verbose output
  chown -h user1 symlink              # Change owner of symlink itself
  ```

## 3. umask (User Mask)
- **Description**: Sets the default permissions for newly created files and directories by subtracting from the default permissions (usually `666` for files, `777` for directories).
- **Common Values**:
  - `022`: Files get `644` (rw-r--r--), directories get `755` (rwxr-xr-x).
  - `002`: Files get `664` (rw-rw-r--), directories get `775` (rwxrwxr-x).
- **Syntax**:
  - `umask [value]`: Set the umask.
  - `umask`: Display current umask.
- **Examples**:
  ```bash
  umask 022                  # Set umask to 022 (default for most systems)
  umask                      # Display current umask (e.g., 0022)
  umask 002                  # Set umask to 002 (more permissive for group)
  touch newfile.txt          # Create file with permissions 664 (if umask is 002)
  mkdir newdir               # Create directory with permissions 775 (if umask is 002)
  ```

## 4. stat (Display File Status)
- **Description**: Displays detailed file or directory information, including permissions, ownership, timestamps, and more.
- **Common Options**:
  - `-f`: Display filesystem status instead of file status.
  - `--format`: Customize output format.
- **Examples**:
  ```bash
  stat file.txt              # Display detailed info about file.txt
  stat -f /home              # Display filesystem info for /home
  stat --format="%n %U %G %A" file.txt  # Show name, owner, group, and permissions
  ```

## Practical Tips
- **Understanding Permissions**:
  - Numeric: Sum permissions for owner, group, others (e.g., `755` = `rwx` for owner, `r-x` for group/others).
  - Symbolic: Use `+` to add, `-` to remove, `=` to set exact permissions.
- **Check Permissions**: Use `ls -l` to view permissions before and after using `chmod` or `chown`.
- **Default umask**: Common default is `022`. Adjust in `~/.bashrc` or `/etc/profile` for persistence.
- **stat for Debugging**: Use `stat` to verify permissions, ownership, or timestamps when troubleshooting.
- **Safety**: Use `-i` with `chmod` or `chown -R` to avoid unintended changes.

## Practice Tasks
1. Create a file `test.txt` and set its permissions to `rw-r--r--` (644).
2. Change the owner of `test.txt` to `user1` and group to `group1`.
3. Set umask to `002`, then create a file `newfile.txt` and directory `newdir`. Check their permissions.
4. Use `stat` to display the owner, group, and permissions of `test.txt`.
5. Recursively set permissions of a directory `myfolder` to `700`.

**Solution**:
```bash
touch test.txt
chmod 644 test.txt
chown user1:group1 test.txt
umask 002
touch newfile.txt
mkdir newdir
ls -l newfile.txt newdir    # Should show 664 for file, 775 for directory
stat --format="%n %U %G %A" test.txt
mkdir myfolder
chmod -R 700 myfolder
```