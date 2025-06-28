# Linux Systemd and Services

This document covers tools for managing system services in Linux using `systemd`: `systemctl`, `service`, and `journalctl`. Each section includes a description, common commands, and practical examples to help you manage and troubleshoot system services effectively.

## 1. systemctl (System Control)
- **Description**: Manages `systemd` services, units, and system state. `systemd` is the init system for most modern Linux distributions (e.g., Ubuntu, Fedora).
- **Common Commands**:
  - `start [unit]`: Start a service.
  - `stop [unit]`: Stop a service.
  - `restart [unit]`: Restart a service.
  - `enable [unit]`: Enable a service to start at boot.
  - `disable [unit]`: Disable a service from starting at boot.
  - `status [unit]`: Show service status.
  - `list-units`: List all loaded units.
  - `list-unit-files`: List all unit files and their state.
- **Examples**:
  ```bash
  # Start a service
  sudo systemctl start nginx

  # Stop a service
  sudo systemctl stop nginx

  # Restart a service
  sudo systemctl restart nginx

  # Enable service to start at boot
  sudo systemctl enable nginx

  # Disable service from starting at boot
  sudo systemctl disable nginx

  # Check service status
  systemctl status nginx
  # Example output: Shows active/inactive state, PID, and logs

  # List all active units
  systemctl list-units --type=service

  # List all unit files
  systemctl list-unit-files --type=service
  ```
- **Note**: Requires `sudo` for administrative tasks. Unit types include `service`, `timer`, `socket`, etc.

## 2. service (Service Management)
- **Description**: A legacy wrapper script for managing services, compatible with both `systemd` and older init systems (e.g., SysVinit). Often redirects to `systemctl` on `systemd`-based systems.
- **Common Commands**:
  - `start [service]`: Start a service.
  - `stop [service]`: Stop a service.
  - `restart [service]`: Restart a service.
  - `status [service]`: Show service status.
- **Examples**:
  ```bash
  # Start a service
  sudo service ssh start

  # Stop a service
  sudo service ssh stop

  # Restart a service
  sudo service ssh restart

  # Check service status
  service ssh status
  # Example output: Shows running/stopped state and recent logs
  ```
- **Note**: Requires `sudo` for administrative tasks. Use `systemctl` for more advanced `systemd` features.

## 3. journalctl (Systemd Journal Logs)
- **Description**: Queries and displays logs from the `systemd` journal, which collects logs from services and the system.
- **Common Options**:
  - `-u [unit]`: Show logs for a specific service.
  - `-b`: Show logs from the current boot.
  - `-f`: Follow logs in real-time (like `tail -f`).
  - `-n [lines]`: Show the last `n` lines.
  - `--since [time]`: Show logs since a specific time (e.g., `2025-06-27`).
  - `-r`: Reverse order (newest first).
- **Examples**:
  ```bash
  # View all journal logs
  journalctl

  # View logs for a specific service
  journalctl -u nginx

  # View logs from current boot
  journalctl -b

  # Follow logs in real-time
  journalctl -f

  # Show last 10 lines of logs
  journalctl -n 10

  # Show logs since a specific date
  journalctl --since "2025-06-27"

  # Show logs in reverse order
  journalctl -r
  ```
- **Note**: Requires `sudo` to view all logs. Logs are stored in `/var/log/journal/` (if persistent journaling is enabled).

## Practical Tips
- **Prefer `systemctl` over `service`**: `systemctl` provides more control and is native to `systemd`.
- **Check service status**: Use `systemctl status` or `service status` to troubleshoot service issues.
- **Monitor logs in real-time**: Use `journalctl -f` for debugging running services.
- **Persistent journaling**: Enable with `sudo mkdir -p /var/log/journal` and `sudo systemd-tmpfiles --create --prefix /var/log/journal`.
- **Filter logs**: Combine `journalctl` options (e.g., `journalctl -u nginx -b` for nginx logs from current boot).
- **Restart safely**: Use `restart` instead of `stop` then `start` to minimize downtime.

## Practice Tasks
1. Start the `ssh` service using `systemctl`.
2. Check the status of the `nginx` service using `service`.
3. Enable the `nginx` service to start at boot.
4. View the last 20 lines of logs for the `ssh` service using `journalctl`.
5. Monitor real-time logs for the `nginx` service.
6. List all active services using `systemctl`.

**Solution**:
```bash
sudo systemctl start ssh
service nginx status
sudo systemctl enable nginx
journalctl -u ssh -n 20
journalctl -u nginx -f
systemctl list-units --type=service
```