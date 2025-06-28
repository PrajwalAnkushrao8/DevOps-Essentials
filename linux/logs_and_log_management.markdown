# Linux Logs and Log Management

This document provides an in-depth explanation of Linux tools and configurations for managing system logs: `tail`, `grep`, `/var/log`, and `logrotate`. Each section includes a detailed description, how the tool or configuration works, common options, practical examples, use cases, and troubleshooting tips to help you monitor and manage logs effectively.

## Overview of Logs
- **Purpose**: Logs record system and application events, such as errors, warnings, authentication attempts, and service activities, aiding in debugging, monitoring, and auditing.
- **Mechanics**: Logs are typically stored as text files in `/var/log`, managed by the system logger (e.g., `rsyslog` or `syslog`). Tools like `tail` and `grep` help analyze logs, while `logrotate` manages log file growth.
- **Use Cases**:
  - Troubleshooting service failures (e.g., checking `nginx` logs).
  - Monitoring security events (e.g., failed login attempts).
  - Managing disk space by rotating old logs.
- **Key Directory**: `/var/log` contains most system and service logs (e.g., `/var/log/syslog`, `/var/log/auth.log`).

## 1. tail (View End of File)
### Overview
- **Purpose**: Displays the last few lines of a file, useful for monitoring log files in real-time or checking recent events.
- **Mechanics**: Reads the end of a file (default 10 lines) and can follow changes as they occur.
- **Use Cases**:
  - Monitoring live logs (e.g., web server errors).
  - Checking the most recent entries in a log file.

### Common Options
- `-n [lines]`: Show the last `n` lines.
- `-f`: Follow the file, displaying new lines as they are written.
- `-q`: Quiet mode (suppress headers for multiple files).
- `--pid=[pid]`: Stop following when a specific process ends.

### Detailed Examples
1. **View Last 10 Lines of a Log**:
   ```bash
   tail /var/log/syslog
   # Output: Shows the last 10 lines of system logs
   ```

2. **View Last 20 Lines**:
   ```bash
   tail -n 20 /var/log/auth.log
   # Output: Shows the last 20 lines of authentication logs
   ```

3. **Monitor Logs in Real-Time**:
   ```bash
   tail -f /var/log/nginx/error.log
   # Output: Displays new error log entries as they occur
   # Press Ctrl+C to stop
   ```

4. **Follow Until Process Ends**:
   ```bash
   # Find nginx PID
   pidof nginx
   # Output: e.g., 1234
   tail -f --pid=1234 /var/log/nginx/access.log
   # Stops when nginx process ends
   ```

### Troubleshooting
- **Permission denied**: Use `sudo` for restricted logs (e.g., `sudo tail /var/log/auth.log`).
- **No output**: Verify the log file exists (`ls /var/log`) and has recent entries.
- **Too much output**: Use `-n` to limit lines or combine with `grep`.

## 2. grep (Search Text in Files)
### Overview
- **Purpose**: Searches for patterns in log files or other text, filtering relevant lines for analysis.
- **Mechanics**: Uses regular expressions to match text, outputting matching lines or counts.
- **Use Cases**:
  - Finding error messages in logs.
  - Filtering logs by user or IP address.
  - Counting occurrences of specific events.

### Common Options
- `-i`: Case-insensitive search.
- `-r`: Recursive search in directories.
- `-n`: Show line numbers.
- `-c`: Count matching lines.
- `-v`: Show non-matching lines (inverse search).
- `-w`: Match whole words only.

### Detailed Examples
1. **Search for Errors in a Log**:
   ```bash
   grep "error" /var/log/syslog
   # Output: Lines containing "error" (case-sensitive)
   ```

2. **Case-Insensitive Search with Line Numbers**:
   ```bash
   grep -in "fail" /var/log/auth.log
   # Output: e.g., 123:Failed password for user1
   ```

3. **Count Failed Logins**:
   ```bash
   grep -c "Failed password" /var/log/auth.log
   # Output: e.g., 5
   ```

4. **Recursive Search in Log Directory**:
   ```bash
   grep -r "crash" /var/log
   # Output: Matches in all files under /var/log
   ```

### Troubleshooting
- **No matches**: Check case sensitivity (`-i`) or pattern accuracy.
- **Permission denied**: Use `sudo` for restricted files.
- **Too many matches**: Narrow the search with `-w` or combine with `tail`.

## 3. /var/log (System Log Directory)
### Overview
- **Purpose**: Stores log files for the system and services, managed by the system logger (e.g., `rsyslog` or `systemd-journald`).
- **Mechanics**: Log files are written by services, daemons, and the kernel. Common files include:
  - `/var/log/syslog` or `/var/log/messages`: General system logs.
  - `/var/log/auth.log`: Authentication-related logs.
  - `/var/log/kern.log`: Kernel logs.
  - Service-specific logs (e.g., `/var/log/nginx/access.log`).
- **Use Cases**:
  - Debugging system or application issues.
  - Auditing security events.
  - Monitoring service activity.

### Common Log Files
- `/var/log/syslog` (Ubuntu) or `/var/log/messages` (CentOS): System-wide logs.
- `/var/log/auth.log` (Ubuntu) or `/var/log/secure` (CentOS): Authentication logs.
- `/var/log/dmesg`: Kernel ring buffer (boot and hardware messages).
- `/var/log/nginx/*.log`: Web server logs (if nginx is installed).

### Detailed Examples
1. **View System Logs**:
   ```bash
   sudo less /var/log/syslog
   # Navigate with arrow keys, q to quit
   ```

2. **Check Recent Authentication Events**:
   ```bash
   sudo tail -n 10 /var/log/auth.log
   # Output: Last 10 authentication events
   ```

3. **Search for Kernel Issues**:
   ```bash
   sudo grep "error" /var/log/kern.log
   ```

4. **Combine with journalctl**:
   ```bash
   journalctl --since "2025-06-27" -u nginx
   # Output: nginx logs from systemd journal
   ```

### Troubleshooting
- **File not found**: Ensure the log file exists (`ls /var/log`) and the service is running.
- **Empty logs**: Check if the service is configured to log or if `rsyslog`/`systemd-journald` is active.
- **Permission issues**: Use `sudo` to access restricted logs.

## 4. logrotate (Rotate Log Files)
### Overview
- **Purpose**: Manages log file growth by rotating, compressing, and deleting old logs to save disk space.
- **Mechanics**: Controlled by configuration files in `/etc/logrotate.conf` and `/etc/logrotate.d/`. Runs periodically via cron (`/etc/cron.daily/logrotate`).
- **Use Cases**:
  - Preventing logs from filling disk space.
  - Archiving old logs for auditing.
  - Compressing logs to save space.

### Configuration File
- **Location**: `/etc/logrotate.conf` (global settings), `/etc/logrotate.d/` (service-specific configs).
- **Format**:
  ```plaintext
  /var/log/example.log {
      daily
      rotate 7
      compress
      missingok
      notifempty
  }
  ```
  - **Options**:
    - `daily`/`weekly`/`monthly`: Rotation frequency.
    - `rotate [n]`: Keep `n` old logs.
    - `compress`: Compress old logs (e.g., `.gz`).
    - `missingok`: Ignore missing log files.
    - `notifempty`: Skip rotation if the log is empty.

### Detailed Examples
1. **View Global Logrotate Config**:
   ```bash
   cat /etc/logrotate.conf
   # Output: Shows default rotation settings
   ```

2. **Check Service-Specific Config**:
   ```bash
   cat /etc/logrotate.d/nginx
   # Example output:
   # /var/log/nginx/*.log {
   #     daily
   #     rotate 14
   #     compress
   #     missingok
   # }
   ```

3. **Manually Run Logrotate**:
   ```bash
   sudo logrotate -f /etc/logrotate.conf
   # Forces rotation of all logs
   ```

4. **Create a Custom Logrotate Config**:
   ```bash
   sudo nano /etc/logrotate.d/myapp
   # Add:
   /var/log/myapp.log {
       weekly
       rotate 4
       compress
       missingok
   }
   # Save and exit
   # Test:
   sudo logrotate -d /etc/logrotate.d/myapp
   # Debug mode, shows what would happen
   ```

### Troubleshooting
- **Logs not rotating**: Check cron job (`/etc/cron.daily/logrotate`) and permissions.
- **Config errors**: Test with `logrotate -d` to debug.
- **Disk space issues**: Verify old logs are compressed or deleted (`ls /var/log`).

## Practical Tips
- **Monitor logs in real-time**: Use `tail -f` for live debugging.
- **Filter efficiently**: Combine `grep` with `tail` (e.g., `tail -f /var/log/syslog | grep error`).
- **Secure log files**: Ensure logs like `/var/log/auth.log` have restricted permissions (`ls -l /var/log`).
- **Check disk usage**: Use `du -sh /var/log/*` to monitor log sizes.
- **Automate log analysis**: Script `grep` searches in cron jobs for alerts.
- **Backup configs**: Copy `/etc/logrotate.conf` and `/etc/logrotate.d/` before editing.

## Practice Tasks
1. View the last 15 lines of `/var/log/syslog`.
2. Search for "error" in `/var/log/nginx/error.log`.
3. Monitor `/var/log/auth.log` in real-time for failed logins.
4. Create a `logrotate` config for `/var/log/myapp.log` to rotate weekly, keeping 5 logs.
5. Test the `logrotate` config in debug mode.
6. Check the size of all logs in `/var/log`.

**Solution**:
```bash
sudo tail -n 15 /var/log/syslog
sudo grep "error" /var/log/nginx/error.log
sudo tail -f /var/log/auth.log | grep "Failed password"
sudo nano /etc/logrotate.d/myapp
# Add:
# /var/log/myapp.log {
#     weekly
#     rotate 5
#     compress
#     missingok
# }
# Save and exit
sudo logrotate -d /etc/logrotate.d/myapp
du -sh /var/log/*
```