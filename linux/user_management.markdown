# Linux User Management

This document covers Linux commands for managing users: `adduser`, `usermod`, `passwd`, and `groups`. Each command includes a description, common options, and practical examples to help you create, modify, and manage user accounts effectively.

## 1. adduser (Add a User)
- **Description**: An interactive, high-level command to create a new user, setting up their home directory, password, and other details.
- **Common Options**:
  - `--home [dir]`: Specify the home directory.
  - `--shell [shell]`: Set the user’s default shell (e.g., `/bin/bash`).
  - `--ingroup [group]`: Set the primary group.
  - `--gecos [info]`: Set user information (e.g., full name).
- **Examples**:
  ```bash
  # Add a new user interactively
  sudo adduser newuser
  # Follow prompts to set password, full name, etc.

  # Add a user with specific options
  sudo adduser --home /home/newuser --shell /bin/zsh --ingroup developers newuser

  # Verify user creation
  id newuser
  # Example output: uid=1001(newuser) gid=1001(developers) groups=1001(developers)
  ```
- **Note**: Requires `sudo`. Creates home directory and adds user to `/etc/passwd` and `/etc/shadow`. Use `useradd` for a lower-level alternative.

## 2. usermod (Modify a User)
- **Description**: Modifies an existing user’s account settings, such as group membership, home directory, or shell.
- **Common Options**:
  - `-aG [group]`: Add user to supplementary groups (use with `-a` to append).
  - `-d [dir]`: Change home directory.
  - `-s [shell]`: Change login shell.
  - `-l [newname]`: Change username.
  - `-L`: Lock the user account (disable login).
  - `-U`: Unlock the user account.
- **Examples**:
  ```bash
  # Add user to a group
  sudo usermod -aG sudo newuser
  # Verify group membership
  groups newuser
  # Output: newuser : developers sudo

  # Change home directory
  sudo usermod -d /newhome/newuser newuser

  # Change shell
  sudo usermod -s /bin/bash newuser

  # Rename user
  sudo usermod -l newname newuser

  # Lock user account
  sudo usermod -L newuser

  # Unlock user account
  sudo usermod -U newuser
  ```
- **Note**: Requires `sudo`. Use `-a` with `-G` to avoid overwriting existing groups.

## 3. passwd (Change User Password)
- **Description**: Changes a user’s password or manages password settings.
- **Common Options**:
  - `[username]`: Specify the user (default is current user).
  - `-l`: Lock the password (disable login).
  - `-u`: Unlock the password.
  - `-d`: Delete the password (allow passwordless login).
- **Examples**:
  ```bash
  # Change current user’s password
  passwd
  # Follow prompts to enter new password

  # Change another user’s password
  sudo passwd newuser
  # Follow prompts

  # Lock a user’s password
  sudo passwd -l newuser

  # Unlock a user’s password
  sudo passwd -u newuser

  # Delete a user’s password
  sudo passwd -d newuser
  ```
- **Note**: Requires `sudo` for other users. Locked accounts show `!` in `/etc/shadow`.

## 4. groups (Display User Groups)
- **Description**: Shows the groups a user belongs to.
- **Common Options**:
  - `[username]`: Specify the user (default is current user).
- **Examples**:
  ```bash
  # Show current user’s groups
  groups
  # Example output: user developers sudo

  # Show another user’s groups
  groups newuser
  # Example output: newuser : developers sudo

  # Verify with id command
  id newuser
  # Example output: uid=1001(newuser) gid=1001(developers) groups=1001(developers),27(sudo)
  ```
- **Note**: Groups are stored in `/etc/group`. Primary group is listed in `/etc/passwd`.

## Practical Tips
- **Use `adduser` over `useradd`**: `adduser` is more user-friendly and handles home directory creation.
- **Be cautious with `sudo` group**: Adding users to `sudo` grants administrative privileges.
- **Verify changes**: Use `id` or `groups` to confirm user settings after modifications.
- **Lock accounts for security**: Use `usermod -L` or `passwd -l` to disable unused accounts.
- **Backup user files**: Copy `/etc/passwd`, `/etc/shadow`, and `/etc/group` before changes (`sudo cp /etc/passwd /etc/passwd.bak`).
- **Check `/etc/passwd` and `/etc/group`**: Use `cat` or `less` to inspect user and group configurations.

## Practice Tasks
1. Create a new user `testuser` with a home directory and Bash shell.
2. Add `testuser` to the `developers` group.
3. Change the password for `testuser`.
4. Change `testuser`’s shell to `/bin/zsh`.
5. Lock the `testuser` account.
6. Verify `testuser`’s groups and account details.

**Solution**:
```bash
sudo adduser --shell /bin/bash testuser
sudo usermod -aG developers testuser
sudo passwd testuser
sudo usermod -s /bin/zsh testuser
sudo passwd -l testuser
id testuser
groups testuser
```