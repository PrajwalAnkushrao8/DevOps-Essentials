# Linux Cron Jobs and Scheduling

This document covers Linux tools for scheduling tasks: `crontab`, `at`, and automating tasks. Each section includes a description, common syntax, and practical examples to help you automate repetitive tasks effectively.

## 1. crontab (Cron Table)
- **Description**: Schedules recurring tasks using cron, a time-based job scheduler. Each user has their own crontab file.
- **File Location**: User crontabs are stored in `/var/spool/cron/crontabs/`, system-wide in `/etc/crontab` or `/etc/cron.*`.
- **Syntax**:
  ```
  * * * * * /path/to/script.sh
  # Fields: minute (0-59), hour (0-23), day (1-31), month (1-12), day-of-week (0-7)
  ```
- **Common Commands**:
  - `crontab -e`: Edit the current user’s crontab.
  - `crontab -l`: List the current user’s crontab.
  - `crontab -r`: Remove the current user’s crontab.
- **Special Strings**:
  - `@reboot`: Run once at system startup.
  - `@daily`, `@weekly`, `@monthly`: Run daily, weekly, or monthly.
- **Examples**:
  ```bash
  # Edit crontab
  crontab -e
  # Add: Run backup.sh every day at 2 AM
  0 2 * * * /home/user/backup.sh

  # Run script every 5 minutes
  */5 * * * * /home/user/check_status.sh

  # Run script at system reboot
  @reboot /home/user/start_app.sh

  # List crontab
  crontab -l
  # Example output:
  # 0 2 * * * /home/user/backup.sh
  # */5 * * * * /home/user/check_status.sh

  # Remove crontab
  crontab -r
  ```
- **Note**: Ensure scripts have executable permissions (`chmod +x script.sh`). Logs are typically in `/var/log/syslog` or `/var/log/cron`.

## 2. at (One-Time Task Scheduling)
- **Description**: Schedules a one-time task to run at a specified time.
- **Common Commands**:
  - `at [time]`: Schedule a task for a specific time.
  - `atq`: List pending `at` jobs.
  - `atrm [job_id]`: Remove a scheduled `at` job.
- **Time Formats**:
  - Absolute: `HH:MM` (e.g., `14:30`), `YYYY-MM-DD HH:MM` (e.g., `2025-06-28 14:30`).
  - Relative: `now + [time]` (e.g., `now + 10 minutes`).
- **Examples**:
  ```bash
  # Schedule a script to run at 3 PM today
  at 15:00
  # Prompt appears, enter command:
  /home/user/script.sh
  # Press Ctrl+D to save

  # Schedule a command for 10 minutes from now
  echo "/home/user/backup.sh" | at now + 10 minutes

  # List pending at jobs
  atq
  # Example output: 1 Fri Jun 27 15:00:00 2025 a user

  # Remove job with ID 1
  atrm 1
  ```
- **Note**: Requires the `at` package (`sudo apt install at`). Jobs are executed in the user’s shell environment.

## 3. Automating Tasks
- **Description**: Combine `crontab` and `at` with scripts to automate repetitive or one-time tasks, such as backups, system monitoring, or cleanup.
- **Key Practices**:
  - Write scripts with absolute paths (e.g., `/usr/bin/echo` instead of `echo`).
  - Redirect output to logs for debugging (e.g., `>> /var/log/myscript.log 2>&1`).
  - Test scripts manually before scheduling.
  - Use environment variables in crontab if needed (e.g., `PATH=/usr/bin:/bin`).
- **Examples**:
  ```bash
  # Create a backup script
  nano backup.sh
  # Content:
  #!/bin/bash
  tar -czf /home/user/backup_$(date +%F).tar.gz /home/user/docs >> /var/log/backup.log 2>&1

  # Make executable
  chmod +x backup.sh

  # Schedule daily at 1 AM via crontab
  crontab -e
  # Add: 0 1 * * * /home/user/backup.sh

  # Schedule a one-time cleanup 2 hours from now
  echo "rm -f /tmp/*.log" | at now + 2 hours
  ```

## Practical Tips
- **Test scripts first**: Run scripts manually to ensure they work before scheduling.
- **Log output**: Redirect script output to a log file for troubleshooting (e.g., `>> /logfile 2>&1`).
- **Use absolute paths**: Avoid errors in cron due to limited environment variables.
- **Check cron logs**: Look in `/var/log/syslog` or `/var/log/cron` for cron job execution details.
- **Limit `at` usage**: Use `at` for one-time tasks and `crontab` for recurring tasks.
- **Secure scripts**: Ensure scripts have proper permissions and avoid sensitive data in plaintext.
- **Cron syntax tools**: Use online tools like `crontab.guru` to verify cron schedules.

## Practice Tasks
1. Create a script `log_date.sh` that logs the current date to `/tmp/date.log`.
2. Schedule `log_date.sh` to run every minute using `crontab`.
3. List the current user’s crontab.
4. Schedule a one-time task to run `echo "Hello" > /tmp/hello.txt` 5 minutes from now using `at`.
5. List all pending `at` jobs and remove one if it exists.
6. Verify the output of the cron job in `/tmp/date.log`.

**Solution**:
```bash
# Task 1: Create script
cat << 'EOF' > log_date.sh
#!/bin/bash
echo "Date: $(date)" >> /tmp/date.log
EOF
chmod +x log_date.sh

# Task 2: Schedule in crontab
crontab -e
# Add: * * * * * /home/user/log_date.sh
# Save and exit

# Task 3: List crontab
crontab -l

# Task 4: Schedule one-time task
echo "echo 'Hello' > /tmp/hello.txt" | at now + 5 minutes

# Task 5: List and remove at jobs
atq
# If job ID is 1:
atrm 1

# Task 6: Verify cron output
cat /tmp/date.log
```