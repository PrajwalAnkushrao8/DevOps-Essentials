# Linux File Permissions

This document provides an in-depth explanation of Linux commands for managing file permissions: `chmod`, `chown`, `setfacl`, and `getfacl`. Each section includes a detailed description, how the command works, common options, practical examples, use cases, and troubleshooting tips to help you manage file and directory access effectively.

## Overview of File Permissions
- **Purpose**: Linux file permissions control who can read, write, or execute files and directories. Permissions are managed for three categories: owner, group, and others.
- **Mechanics**:
  - **Standard Permissions**: Defined by read (`r`), write (`w`), and execute (`x`) for owner, group, and others, represented as `rwxrwxrwx` (9 characters) or octal (e.g., `755`).
  - **Access Control Lists (ACLs)**: Extend standard permissions with fine-grained control using `setfacl` and `getfacl`.
  - **Ownership**: Each file has an owner (user) and a group, managed by `chown`.
- **Use Cases**:
  - Securing sensitive files (e.g., configuration files).
  - Granting specific users access to shared directories.
  - Controlling script execution permissions.
- **Key Files**:
  - Permissions and ownership are stored in the file system’s inode metadata.
  - View with `ls -l` (e.g., `-rw-r--r-- user group`).

## 1. chmod (Change Mode)
### Overview
- **Purpose**: Modifies file or directory permissions for owner, group, and others.
- **Mechanics**: Uses symbolic (e.g., `u+x`) or octal (e.g., `755`) notation to set permissions.
  - **Symbolic**: `u` (user/owner), `g` (group), `o` (others), `a` (all); `+` (add), `-` (remove), `=` (set); `r` (read), `w` (write), `x` (execute).
  - **Octal**: Three digits (0-7) for owner, group, others (e.g., `755` = `rwxr-xr-x`).
    - `4` = read, `2` = write, `1` = execute (sum them: `7 = rwx`, `6 = rw-`, etc.).
- **Use Cases**:
  - Making scripts executable.
  - Restricting access to sensitive files.
  - Setting directory permissions for collaboration.

### Common Options
- `-R`: Apply permissions recursively to directories and their contents.
- `-v`: Verbose output, showing changed files.
- `--reference=[file]`: Copy permissions from another file.

### Detailed Examples
1. **Set Permissions with Octal Notation**:
   - Make a script executable by owner, read-only for group and others:
     ```bash
     chmod 744 script.sh
     ls -l script.sh
     # Output: -rwxr--r-- 1 user group 123 Jun 27 2025 script.sh
     ```

2. **Set Permissions with Symbolic Notation**:
   - Add execute permission for owner:
     ```bash
     chmod u+x script.sh
     ls -l script.sh
     # Output: -rwxr--r-- 1 user group 123 Jun 27 2025 script.sh
     ```

3. **Recursive Permissions for a Directory**:
   - Set a directory to `rwxr-x---` (owner full access, group read/execute, others none):
     ```bash
     chmod -R 750 /home/user/docs
     ls -ld /home/user/docs
     # Output: drwxr-x--- 2 user group 4096 Jun 27 2025 docs
     ```

### Troubleshooting
- **Permission denied**: Ensure you have `sudo` or ownership to change permissions.
- **Recursive errors**: Use `chmod -R` carefully; verify with `ls -lR`.
- **Incorrect mode**: Check octal (`0-7`) or symbolic syntax (`u,g,o`).

## 2. chown (Change Owner)
### Overview
- **Purpose**: Changes the owner and/or group of a file or directory.
- **Mechanics**: Updates the file’s inode metadata to reflect new user and/or group ownership, referencing `/etc/passwd` and `/etc/group`.
- **Use Cases**:
  - Transferring file ownership to another user.
  - Assigning files to a group for shared access.
  - Fixing ownership after copying files.

### Common Options
- `-R`: Apply changes recursively.
- `-v`: Verbose output.
- `--reference=[file]`: Copy ownership from another file.

### Detailed Examples
1. **Change File Owner**:
   - Change owner of a file to `newuser`:
     ```bash
     sudo chown newuser file.txt
     ls -l file.txt
     # Output: -rw-r--r-- 1 newuser group 123 Jun 27 2025 file.txt
     ```

2. **Change Owner and Group**:
   - Change owner to `newuser` and group to `developers`:
     ```bash
     sudo chown newuser:developers file.txt
     ls -l file.txt
     # Output: -rw-r--r-- 1 newuser developers 123 Jun 27 2025 file.txt
     ```

3. **Recursive Ownership Change**:
   - Change ownership of a directory and its contents:
     ```bash
     sudo chown -R user1:users /home/user1/docs
     ls -lR /home/user1/docs
     ```

### Troubleshooting
- **User/group not found**: Verify users (`id user`) and groups (`getent group groupname`).
- **Permission denied**: Use `sudo` or ensure you have sufficient privileges.
- **Recursive issues**: Confirm the directory path and use `ls -lR` to verify changes.

## 3. setfacl (Set File Access Control Lists)
### Overview
- **Purpose**: Sets Access Control Lists (ACLs) to provide fine-grained permissions beyond standard owner/group/others.
- **Mechanics**: ACLs extend permissions by defining specific access for users or groups, stored in the file system’s extended attributes.
- **Use Cases**:
  - Granting specific users access to a file without changing group ownership.
  - Allowing multiple groups different permissions on a directory.
  - Managing shared directories with complex access rules.

### Common Options
- `-m [acl]`: Modify or add ACL entries (e.g., `u:user:rw`, `g:group:rx`).
- `-x [acl]`: Remove an ACL entry.
- `-R`: Apply recursively.
- `-b`: Remove all ACLs, reverting to standard permissions.
- `--set`: Set new ACLs, replacing existing ones.

### Detailed Examples
1. **Grant a User Specific Permissions**:
   - Allow `user2` read and write access to a file:
     ```bash
     setfacl -m u:user2:rw file.txt
     getfacl file.txt
     # Output: user::rw-
     #       group::r--
     #       other::r--
     #       user:user2:rw-
     ```

2. **Grant a Group Permissions**:
   - Allow `developers` group read and execute access:
     ```bash
     setfacl -m g:developers:rx /home/user/docs
     getfacl /home/user/docs
     # Output: Includes group:developers:r-x
     ```

3. **Recursive ACLs**:
   - Apply ACLs to a directory and its contents:
     ```bash
     setfacl -R -m u:user2:rwx /home/user/docs
     ```

### Troubleshooting
- **ACL not supported**: Ensure the file system supports ACLs (e.g., `ext4`, `xfs`; enable with `mount -o acl`).
- **Command not found**: Install `acl` package (`sudo apt install acl`).
- **Unexpected access**: Verify ACLs with `getfacl` and check standard permissions (`ls -l`).

## 4. getfacl (Get File Access Control Lists)
### Overview
- **Purpose**: Displays the ACLs of a file or directory, including standard permissions and extended ACL entries.
- **Mechanics**: Reads extended attributes to show detailed access rules.
- **Use Cases**:
  - Verifying ACLs after modification.
  - Debugging permission issues.
  - Documenting access rules for shared resources.

### Common Options
- `-R`: Display ACLs recursively for directories.
- `--omit-header`: Skip header information for cleaner output.

### Detailed Examples
1. **View ACLs for a File**:
   ```bash
   getfacl file.txt
   # Output: # file: file.txt
   # owner: user
   # group: group
   user::rw-
   user:user2:rw-
   group::r--
   other::r--
   ```

2. **View ACLs Recursively**:
   ```bash
   getfacl -R /home/user/docs
   # Output: Shows ACLs for all files and subdirectories
   ```

3. **Clean Output**:
   ```bash
   getfacl --omit-header file.txt
   # Output: user::rw-
   #       user:user2:rw-
   #       group::r--
   #       other::r--
   ```

### Troubleshooting
- **No ACLs displayed**: File system may not support ACLs or none are set.
- **Permission denied**: Use `sudo` for restricted files.
- **Complex output**: Use `ls -l` alongside `getfacl` to compare standard permissions.

## Practical Tips
- **Check permissions first**: Use `ls -l` to view standard permissions before modifying.
- **Use octal for `chmod`**: Octal notation (e.g., `755`) is faster for setting all permissions at once.
- **Secure sensitive files**: Use `600` for private files and `700` for directories.
- **Combine `chown` and `chmod`**: Set ownership and permissions together for new files.
- **Use ACLs sparingly**: Reserve ACLs for complex permission scenarios; standard permissions are simpler.
- **Backup before changes**: Copy critical files or directories before modifying permissions.

## Practice Tasks
1. Create a file `test.txt` and set permissions to `rw-r-----` using `chmod`.
2. Change the owner of `test.txt` to `user1` and group to `developers`.
3. Grant `user2` read and execute permissions on `test.txt` using `setfacl`.
4. Verify the ACLs on `test.txt` with `getfacl`.
5. Recursively set permissions on `/home/user/docs` to `rwxr-x---` and add `user2` with full access via ACLs.
6. Check ownership and permissions of `/home/user/docs`.

**Solution**:
```bash
touch test.txt
chmod 640 test.txt
sudo chown user1:developers test.txt
setfacl -m u:user2:rx test.txt
getfacl test.txt
chmod -R 750 /home/user/docs
setfacl -R -m u:user2:rwx /home/user/docs
ls -ld /home/user/docs
getfacl /home/user/docs
```