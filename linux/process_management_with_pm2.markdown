# Linux Process Management (Including PM2)

This document covers Linux commands for managing processes: `ps`, `top`, `htop`, `kill`, `nice`, `fg`, `bg`, and `pm2`. Each command includes a description, common options, and practical examples to help you monitor and control processes effectively, with a focus on both native Linux tools and PM2 for Node.js applications.

## 1. ps (Process Status)
- **Description**: Displays information about active processes.
- **Common Options**:
  - `-e`: Show all processes.
  - `-f`: Full format listing (includes UID, PID, PPID, etc.).
  - `-u [user]`: Show processes for a specific user.
  - `--forest`: Display process hierarchy.
- **Examples**:
  ```bash
  ps                   # Show processes for the current shell
  ps -e                # Show all processes
  ps -ef               # Show all processes in full format
  ps -u user1          # Show processes for user1
  ps -ef --forest      # Show process hierarchy
  ps -aux | grep bash  # Find bash-related processes
  ```

## 2. top (Display System Processes)
- **Description**: Provides a real-time, interactive view of system processes, sorted by resource usage (e.g., CPU, memory).
- **Common Options**:
  - `-u [user]`: Show processes for a specific user.
  - `-d [seconds]`: Set refresh interval.
- **Interactive Commands**:
  - `q`: Quit.
  - `k`: Kill a process (prompts for PID).
  - `r`: Renice a process (prompts for PID and nice value).
  - `1`: Toggle CPU core details.
- **Examples**:
  ```bash
  top                  # Start top with default view
  top -u user1         # Show processes for user1
  top -d 2             # Refresh every 2 seconds
  ```

## 3. htop (Interactive Process Viewer)
- **Description**: A user-friendly, colorful alternative to `top` with mouse/keyboard navigation.
- **Common Options**:
  - `-u [user]`: Show processes for a specific user.
  - `-d [tenths]`: Set refresh interval (in tenths of seconds, e.g., `10` = 1 second).
- **Interactive Commands**:
  - `F2`: Setup (customize display).
  - `F3` or `/`: Search for a process.
  - `F9`: Kill a process.
  - `F7`/`F8`: Decrease/increase nice value (priority).
  - `q`: Quit.
- **Examples**:
  ```bash
  htop                 # Start htop
  htop -u user1        # Show processes for user1
  htop -d 20           # Refresh every 2 seconds
  ```
- **Note**: `htop` may need to be installed (`sudo apt install htop` or equivalent).

## 4. kill (Terminate Processes)
- **Description**: Sends a signal to terminate or control a process by its PID.
- **Common Signals**:
  - `SIGTERM` (15): Polite termination (default).
  - `SIGKILL` (9): Forceful termination.
  - `SIGHUP` (1): Hangup (reload configuration for some processes).
- **Common Options**:
  - `-l`: List all signal names.
  - `-[signal]`: Specify the signal (e.g., `-9` for SIGKILL).
- **Examples**:
  ```bash
  kill 1234            # Send SIGTERM to process with PID 1234
  kill -9 1234         # Forcefully kill process with PID 1234
  kill -HUP 1234       # Send SIGHUP to process with PID 1234
  kill -l              # List all available signals
  ```

## 5. nice (Set Process Priority)
- **Description**: Sets the priority (nice value) of a new process. Nice values range from -20 (highest priority) to 19 (lowest priority).
- **Common Options**:
  - `-n [value]`: Set the nice value (e.g., `-n 10`).
- **Examples**:
  ```bash
  nice -n 10 ./script.sh    # Run script.sh with nice value 10
  nice -n -5 ./program      # Run program with higher priority (-5)
  ```

## 6. renice (Change Running Process Priority)
- **Description**: Changes the priority of an already running process.
- **Common Options**:
  - `[value]`: Set the new nice value.
  - `-p [PID]`: Specify the process ID.
  - `-u [user]`: Change priority for all processes of a user.
- **Examples**:
  ```bash
  renice 10 -p 1234         # Set nice value 10 for process with PID 1234
  renice -5 -p 1234         # Increase priority for PID 1234
  renice 0 -u user1         # Reset nice value to 0 for all user1’s processes
  ```

## 7. fg (Foreground a Process)
- **Description**: brings a background process to the foreground.
- **Common Options**: None typically used, but job number can be specified.
- **Examples**:
  ```bash
  sleep 100 &          # Start sleep in background
  fg                   # Bring most recent background job to foreground
  fg %1                # Bring job number 1 to foreground
  ```

## 8. bg (Background a Process)
- **Description**: Resumes a suspended process in the background.
- **Common Options**: None typically used, but job number can be specified.
- **Examples**:
  ```bash
  sleep 100            # Start sleep, then press Ctrl+Z to suspend
  bg                   # Resume most recent suspended job in background
  bg %1                # Resume job number 1 in background
  ```

## 9. pm2 (Process Manager for Node.js Applications)
- **Description**: A production-grade process manager for Node.js (and other languages like Python, Ruby) with built-in load balancing, monitoring, and automatic restarts. It daemonizes applications to keep them running in the background.[](https://en.wikipedia.org/wiki/PM2_%28software%29)[](https://go.lightnode.com/tech/what-is-pm2)
- **Common Options/Commands**:
  - `start [app]`: Start an application (e.g., `app.js`).
  - `--name [name]`: Name the process.
  - `-i [n]`: Start in cluster mode with `n` instances (or `max` for CPU core count).
  - `--watch`: Restart on file changes.
  - `list`: List all managed processes.
  - `stop [name|id]`: Stop a process.
  - `restart [name|id]`: Restart a process.
  - `delete [name|id]`: Delete a process from PM2.
  - `logs [name]`: View logs for a process.
  - `monit`: Monitor CPU/memory usage.
  - `startup`: Generate a script to restart PM2 on system boot.
  - `save`: Save current process list for boot persistence.
- **Examples**:
  ```bash
  npm install pm2@latest -g        # Install PM2 globally
  pm2 start app.js --name my-app  # Start app.js with name "my-app"
  pm2 start app.js -i max         # Start in cluster mode using all CPU cores
  pm2 start script.py             # Start a Python script
  pm2 list                        # List all managed processes
  pm2 stop my-app                 # Stop process named my-app
  pm2 restart my-app              # Restart process named my-app
  pm2 delete my-app               # Delete process named my-app
  pm2 logs my-app                 # View logs for my-app
  pm2 monit                       # Monitor all processes
  pm2 startup                     # Generate startup script
  pm2 save                        # Save process list for boot
  ```
- **Note**: PM2 requires Node.js (`sudo apt install nodejs npm` or equivalent). Logs are stored in `~/.pm2/logs/`. Use `pm2 flush` to clear logs.[](https://www.npmjs.com/package/pm2)[](https://pm2.io/blog/2018/09/19/Manage-Python-Processes)

## Practical Tips
- **Find PIDs**: Use `ps -aux | grep [process]` or `pidof [process]` for native processes, or `pm2 list` for PM2-managed processes.
- **Use `htop` for interactivity**: Easier to navigate and kill processes than `top`.
- **Be cautious with `kill -9`**: Use SIGKILL only when SIGTERM fails, as it doesn’t allow cleanup.
- **PM2 for production**: Use PM2 for Node.js apps to ensure automatic restarts and load balancing. Use cluster mode (`-i max`) for better performance.[](https://go.lightnode.com/tech/what-is-pm2)
- **Monitor resources**: Use `top`, `htop`, or `pm2 monit` to identify resource-heavy processes.
- **Background tasks**: Use `&` for native background processes, or PM2’s daemonization for apps.
- **Check jobs**: Use `jobs` for native background/suspended processes, or `pm2 list` for PM2 processes.

## Practice Tasks
1. List all processes for the current user with `ps`.
2. Start `top`, then switch to `htop` to compare interfaces.
3. Start a `sleep 100` process in the background, then bring it to the foreground.
4. Suspend a `sleep 200` process with `Ctrl+Z`, then resume it in the background.
5. Find the PID of a running `bash` process and terminate it with `kill`.
6. Run a script (`script.sh`) with a nice value of 10, then change its priority to 5 using `renice`.
7. Install PM2, start a Node.js app (`app.js`) with name `my-app`, and view its logs.
8. Use PM2 to start a Python script (`script.py`) and monitor it with `pm2 monit`.

**Solution**:
```bash
ps -u $USER
top  # Press 'q' to quit
htop  # Press 'q' to quit
sleep 100 &
fg
sleep 200  # Press Ctrl+Z to suspend
bg
ps -aux | grep bash  # Find PID (e.g., 1234)
kill 1234
nice -n 10 ./script.sh &
renice 5 -p $(pidof script.sh)
npm install pm2@latest -g
pm2 start app.js --name my-app
pm2 logs my-app
pm2 start script.py
pm2 monit
```