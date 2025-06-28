# Linux SSH and Remote Access

This document provides an in-depth explanation of Linux tools and configurations for secure remote access: `ssh`, `scp`, `sshd_config`, and key-based authentication. Each section includes a detailed description, how the tool or configuration works, common options, practical examples, use cases, and troubleshooting tips to help you manage remote connections securely.

## Overview of SSH and Remote Access
- **Purpose**: Secure Shell (SSH) enables secure remote access to systems, allowing command execution, file transfers, and server management over encrypted connections.
- **Mechanics**: SSH uses client-server architecture with public-key cryptography for authentication and encryption. The SSH daemon (`sshd`) runs on the server, and clients use `ssh` or `scp` to connect.
- **Use Cases**:
  - Managing remote servers (e.g., web or database servers).
  - Securely transferring files between systems.
  - Setting up passwordless authentication for automation.
- **Key Files**:
  - `/etc/ssh/sshd_config`: SSH server configuration.
  - `~/.ssh/`: User directory for SSH keys and configs.
  - `/var/log/auth.log` or `/var/log/secure`: Logs for SSH authentication events.

## 1. ssh (Secure Shell Client)
### Overview
- **Purpose**: Connects to a remote system to execute commands or start an interactive shell securely.
- **Mechanics**: Establishes an encrypted connection to the SSH daemon on the remote host, authenticating via password or key.
- **Use Cases**:
  - Running commands on a remote server.
  - Accessing a remote shell for administration.
  - Tunneling network traffic.

### Common Options
- `-p [port]`: Specify SSH port (default: 22).
- `-i [keyfile]`: Use a specific private key for authentication.
- `-X`: Enable X11 forwarding for GUI applications.
- `-v`: Verbose output for debugging.
- `[user@host]`: Specify remote user and hostname/IP.

### Detailed Examples
1. **Connect to a Remote Server**:
   ```bash
   ssh user1@192.168.1.100
   # Prompts for password, opens remote shell
   ```

2. **Connect with Custom Port**:
   ```bash
   ssh -p 2222 user1@192.168.1.100
   # Connects to SSH server on port 2222
   ```

3. **Run a Single Command**:
   ```bash
   ssh user1@192.168.1.100 "uptime"
   # Output: 22:43:45 up 5 days, 3:12, 2 users, load average: 0.10, 0.15, 0.20
   ```

4. **Enable X11 Forwarding**:
   ```bash
   ssh -X user1@192.168.1.100
   # Allows running GUI apps (e.g., xterm) remotely
   ```

### Troubleshooting
- **Connection refused**: Ensure `sshd` is running (`sudo systemctl status sshd`) and the port is open (`ss -tuln`).
- **Permission denied**: Verify username, password, or key; check `/var/log/auth.log`.
- **Timeout**: Check firewall rules (`ufw status` or `firewall-cmd --list-all`) and network connectivity (`ping`).

## 2. scp (Secure Copy)
### Overview
- **Purpose**: Securely transfers files between local and remote systems or between two remote systems using SSH.
- **Mechanics**: Uses SSH for encryption, copying files over a secure channel.
- **Use Cases**:
  - Uploading configuration files to a server.
  - Downloading logs from a remote system.
  - Transferring files between servers.

### Common Options
- `-P [port]`: Specify SSH port.
- `-r`: Recursively copy directories.
- `-i [keyfile]`: Use a specific private key.
- `-v`: Verbose output for debugging.

### Detailed Examples
1. **Copy a File to a Remote Server**:
   ```bash
   scp localfile.txt user1@192.168.1.100:/home/user1/
   # Copies localfile.txt to remote /home/user1/
   ```

2. **Copy a Directory Recursively**:
   ```bash
   scp -r /local/dir user1@192.168.1.100:/home/user1/
   # Copies entire directory
   ```

3. **Copy from Remote to Local**:
   ```bash
   scp user1@192.168.1.100:/home/user1/remotefile.txt .
   # Copies remotefile.txt to current directory
   ```

4. **Copy with Custom Port**:
   ```bash
   scp -P 2222 localfile.txt user1@192.168.1.100:/home/user1/
   ```

### Troubleshooting
- **Permission denied**: Check file permissions and SSH authentication.
- **Connection issues**: Verify SSH connectivity (`ssh user1@192.168.1.100`) and port.
- **Slow transfers**: Use `-v` to debug or check network bandwidth.

## 3. sshd_config (SSH Daemon Configuration)
### Overview
- **Purpose**: Configures the SSH server (`sshd`) behavior, including port, authentication methods, and access controls.
- **Mechanics**: Located at `/etc/ssh/sshd_config`, defines settings like port, allowed users, and key-based authentication.
- **Use Cases**:
  - Changing the default SSH port for security.
  - Disabling password authentication.
  - Restricting access to specific users or groups.

### Common Directives
- `Port [number]`: Set SSH port (default: 22).
- `PermitRootLogin [yes|no]`: Allow/disallow root login.
- `PasswordAuthentication [yes|no]`: Enable/disable password login.
- `AllowUsers [user1 user2]`: Restrict SSH to specific users.
- `PubkeyAuthentication [yes|no]`: Enable/disable key-based authentication.

### Detailed Examples
1. **Change SSH Port**:
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Change: Port 22
   # To:     Port 2222
   # Save and exit
   sudo systemctl restart sshd
   ```

2. **Disable Root Login**:
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set: PermitRootLogin no
   sudo systemctl restart sshd
   ```

3. **Restrict to Specific Users**:
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Add: AllowUsers user1 user2
   sudo systemctl restart sshd
   ```

4. **Disable Password Authentication**:
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set: PasswordAuthentication no
   sudo systemctl restart sshd
   ```

### Troubleshooting
- **Syntax errors**: Test config with `sudo sshd -t` before restarting.
- **Locked out**: Always test changes with an active session; ensure `AllowUsers` includes your user.
- **Service not restarting**: Check logs (`journalctl -u sshd`) for errors.
- **Firewall issues**: Update firewall rules for new port (`ufw allow 2222` or `firewall-cmd --add-port=2222/tcp`).

## 4. Key-Based Authentication
### Overview
- **Purpose**: Enables passwordless SSH login using public-private key pairs, improving security and automation.
- **Mechanics**: A private key is stored on the client, and the corresponding public key is added to `~/.ssh/authorized_keys` on the server.
- **Use Cases**:
  - Automating scripts requiring SSH access.
  - Enhancing security by disabling passwords.
  - Simplifying logins for frequent access.

### Steps to Set Up
1. **Generate Key Pair on Client**:
   ```bash
   ssh-keygen -t rsa -b 4096
   # Press Enter for defaults (~/.ssh/id_rsa)
   ```

2. **Copy Public Key to Server**:
   ```bash
   ssh-copy-id user1@192.168.1.100
   # Adds public key to ~user1/.ssh/authorized_keys on server
   ```

3. **Test Key-Based Login**:
   ```bash
   ssh user1@192.168.1.100
   # Should log in without password
   ```

4. **Disable Password Authentication** (Optional):
   ```bash
   sudo nano /etc/ssh/sshd_config
   # Set: PasswordAuthentication no
   sudo systemctl restart sshd
   ```

### Detailed Example
- **Full Setup**:
   ```bash
   # Generate key pair
   ssh-keygen -t rsa -b 4096
   # Copy key to server
   ssh-copy-id -i ~/.ssh/id_rsa.pub user1@192.168.1.100
   # Test login
   ssh user1@192.168.1.100
   # Verify authorized_keys
   ssh user1@192.168.1.100 "cat ~/.ssh/authorized_keys"
   ```

### Troubleshooting
- **Permission denied**: Ensure `~/.ssh` is 700 and `authorized_keys` is 600 (`chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys`).
- **Key rejected**: Check server logs (`sudo journalctl -u sshd`) and verify key in `authorized_keys`.
- **SELinux issues**: On Red Hat-based systems, restore context (`sudo restorecon -R -v ~/.ssh`).
- **Firewall blocks**: Ensure SSH port is open (`ufw status` or `firewall-cmd --list-all`).

## Practical Tips
- **Secure SSH**: Change default port, disable root login, and use key-based authentication.
- **Backup keys**: Store `~/.ssh/id_rsa` securely; losing it prevents access.
- **Monitor logs**: Check `/var/log/auth.log` or `/var/log/secure` for SSH issues.
- **Use `scp` for automation**: Combine with key-based authentication for scripts.
- **Test config changes**: Use `sshd -t` and keep an active session to avoid lockouts.
- **Combine with `tmux`**: Use `tmux` for persistent remote sessions.

## Practice Tasks
1. Connect to a remote server (`user1@192.168.1.100`) using `ssh`.
2. Copy a local file (`data.txt`) to the remote server using `scp`.
3. Change the SSH port to 2222 in `sshd_config` and restart `sshd`.
4. Set up key-based authentication for `user1@192.168.1.100`.
5. Disable password authentication on the server.
6. Verify SSH login without a password.

**Solution**:
```bash
ssh user1@192.168.1.100
scp data.txt user1@192.168.1.100:/home/user1/
sudo nano /etc/ssh/sshd_config
# Set: Port 2222
sudo systemctl restart sshd
ssh-keygen -t rsa -b 4096
ssh-copy-id -i ~/.ssh/id_rsa.pub user1@192.168.1.100
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart sshd
ssh -p 2222 user1@192.168.1.100
```