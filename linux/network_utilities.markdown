# Linux Network Utilities

This document covers Linux commands for network diagnostics and management: `ping`, `netstat`, `ss`, `ip`, `nmcli`, `curl`, and `wget`. Each command includes a description, common options, and practical examples to help you troubleshoot and interact with networks effectively. A comparison between `curl` and `wget` is also included.

## 1. ping (Packet Internet Groper)
- **Description**: Tests network connectivity by sending ICMP echo requests to a host and measuring response time.
- **Common Options**:
  - `-c [count]`: Send a specified number of packets.
  - `-i [interval]`: Set interval between packets (in seconds).
  - `-s [size]`: Set packet size (in bytes).
  - `-t [ttl]`: Set time-to-live for packets.
- **Examples**:
  ```bash
  ping google.com              # Ping google.com continuously
  ping -c 4 google.com         # Send 4 ping requests
  ping -i 0.5 google.com       # Ping every 0.5 seconds
  ping -s 100 192.168.1.1      # Ping with 100-byte packets
  ping -t 64 8.8.8.8           # Ping with TTL of 64
  ```
- **Note**: Use `Ctrl+C` to stop continuous pinging.

## 2. netstat (Network Statistics)
- **Description**: Displays network connections, routing tables, and interface statistics. Often replaced by `ss` in modern systems.
- **Common Options**:
  - `-a`: Show all connections (including listening).
  - `-t`: Show TCP connections.
  - `-u`: Show UDP connections.
  - `-l`: Show listening sockets.
  - `-p`: Show program/PID associated with connections.
  - `-n`: Show numerical addresses (not resolved to hostnames).
- **Examples**:
  ```bash
  netstat -tuln                # Show listening TCP/UDP ports
  netstat -anp                 # Show all connections with programs/PIDs
  netstat -r                   # Show routing table
  netstat -i                   # Show interface statistics
  ```
- **Note**: May require installation (`sudo apt install net-tools`).

## 3. ss (Socket Statistics)
- **Description**: A modern replacement for `netstat`, providing detailed information about network sockets.
- **Common Options**:
  - `-t`: Show TCP sockets.
  - `-u`: Show UDP sockets.
  - `-l`: Show listening sockets.
  - `-a`: Show all sockets (listening and non-listening).
  - `-p`: Show process/PID using the socket.
  - `-n`: Show numerical addresses.
- **Examples**:
  ```bash
  ss -tuln                     # Show listening TCP/UDP ports
  ss -anp                      # Show all sockets with programs/PIDs
  ss -t -a                     # Show all TCP sockets
  ss -s                        # Show socket summary statistics
  ```

## 4. ip (IP Configuration)
- **Description**: Manages network interfaces, routes, and IP addresses. Part of the `iproute2` suite, replacing `ifconfig`.
- **Common Commands**:
  - `ip addr`: Show IP addresses and interfaces.
  - `ip link`: Show network interfaces and their status.
  - `ip route`: Show or manage routing table.
- **Common Options**:
  - `show`: Display information (default).
  - `add`/`del`: Add or delete configurations.
- **Examples**:
  ```bash
  ip addr show                 # Show all network interfaces and IPs
  ip link show                 # Show interface status
  ip route show                # Show routing table
  sudo ip addr add 192.168.1.100/24 dev eth0  # Add IP to interface eth0
  sudo ip link set eth0 up     # Bring interface eth0 up
  ```

## 5. nmcli (NetworkManager Command Line Interface)
- **Description**: Manages network connections on systems using NetworkManager (common in Ubuntu, Fedora).
- **Common Commands**:
  - `nmcli connection show`: List network connections.
  - `nmcli device status`: Show device status.
  - `nmcli con up [name]`: Activate a connection.
  - `nmcli con down [name]`: Deactivate a connection.
- **Examples**:
  ```bash
  nmcli connection show         # List all network connections
  nmcli device status           # Show status of network devices
  nmcli con up my-wifi         # Activate connection named my-wifi
  nmcli con down my-wifi       # Deactivate connection named my-wifi
  nmcli con add type wifi con-name my-wifi ssid MySSID  # Add a Wi-Fi connection
  ```
- **Note**: Requires NetworkManager (`sudo apt install network-manager`).

## 6. curl (Client URL)
- **Description**: Transfers data to/from a server, supporting protocols like HTTP, HTTPS, FTP, and more. Ideal for scripting and API interactions.
- **Common Options**:
  - `-o [file]`: Save output to a file.
  - `-I`: Fetch headers only.
  - `-X [method]`: Specify HTTP method (e.g., GET, POST).
  - `-d [data]`: Send data in a POST request.
  - `-L`: Follow redirects.
- **Examples**:
  ```bash
  curl http://example.com       # Fetch content from example.com
  curl -o output.html http://example.com  # Save content to output.html
  curl -I http://example.com   # Fetch headers only
  curl -X POST -d "name=value" http://example.com/api  # Send POST request
  curl -L http://example.com   # Follow redirects
  ```

## 7. wget (Web Get)
- **Description**: Downloads files from the web, supporting HTTP, HTTPS, and FTP. Designed for robust file downloads, including recursive fetching.
- **Common Options**:
  - `-O [file]`: Save output to a specific file.
  - `-c`: Resume a partially downloaded file.
  - `-r`: Recursive download (e.g., entire website).
  - `-q`: Quiet mode (no output).
  - `--limit-rate=[rate]`: Limit download speed (e.g., `100k`).
- **Examples**:
  ```bash
  wget http://example.com/file.txt  # Download file.txt
  wget -O myfile.txt http://example.com/file.txt  # Save as myfile.txt
  wget -c http://example.com/largefile.zip  # Resume partial download
  wget -r http://example.com        # Recursively download website
  wget --limit-rate=100k http://example.com/file.zip  # Limit speed to 100 KB/s
  ```

## Comparison: curl vs. wget
- **Purpose**:
  - `curl`: Designed for transferring data, including API requests, with support for multiple protocols (HTTP, HTTPS, FTP, SFTP, etc.). Best for scripting and complex requests.
  - `wget`: Focused on downloading files and recursive website fetching. Ideal for simple downloads and mirroring websites.
- **Protocols**:
  - `curl`: Supports a broader range of protocols (e.g., HTTP, HTTPS, FTP, SFTP, LDAP, IMAP).
  - `wget`: Limited to HTTP, HTTPS, and FTP.
- **Output Handling**:
  - `curl`: Outputs to `stdout` by default, requiring `-o` or `>` for file saving.
  - `wget`: Saves to a file by default, with automatic filename detection.
- **Interactivity**:
  - `curl`: Better for scripting, API calls, and non-interactive tasks (e.g., POST requests, authentication).
  - `wget`: Better for recursive downloads and resuming interrupted downloads.
- **Features**:
  - `curl`: Supports advanced HTTP features (e.g., POST, PUT, headers, cookies, authentication).
  - `wget`: Supports recursive downloads (`-r`) and bandwidth limiting (`--limit-rate`).
- **Examples**:
  - Use `curl` for API testing:
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"key":"value"}' http://api.example.com
    ```
  - Use `wget` for recursive website download:
    ```bash
    wget -r http://example.com
    ```
- **When to Use**:
  - Choose `curl` for API interactions, custom HTTP requests, or non-HTTP protocols.
  - Choose `wget` for simple file downloads, resuming large downloads, or mirroring websites.

## Practical Tips
- **Use `ping` for quick checks**: Test connectivity before deeper troubleshooting.
- **Prefer `ss` over `netstat`**: `ss` is faster and more modern, but `netstat` may be used on older systems.
- **Combine `ip` with `nmcli`**: Use `ip` for low-level interface details and `nmcli` for managing NetworkManager connections.
- **Secure `curl` and `wget`**: Use HTTPS URLs and verify certificates (e.g., `curl --cacert [file]` or `wget --no-check-certificate` for testing).
- **Pipe `curl` output**: Combine with `grep` or `jq` for parsing (e.g., `curl api.example.com | jq .`).
- **Monitor with `watch`**: Use `watch ss -tuln` to monitor network sockets in real-time.

## Practice Tasks
1. Ping `google.com` 4 times and check the response time.
2. List all listening TCP/UDP ports using `ss`.
3. Display the routing table using `ip`.
4. Show all network connections with `nmcli`.
5. Download a file from `http://example.com/file.txt` using `wget`.
6. Fetch the headers of `http://example.com` using `curl`.
7. Use `curl` to send a POST request with data `name=test` to `http://example.com/api`.
8. Use `wget` to resume a partial download of a large file.

**Solution**:
```bash
ping -c 4 google.com
ss -tuln
ip route show
nmcli connection show
wget http://example.com/file.txt
curl -I http://example.com
curl -X POST -d "name=test" http://example.com/api
wget -c http://example.com/largefile.zip
```