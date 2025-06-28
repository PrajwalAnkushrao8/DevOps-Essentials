# Linux Firewall Management

This document provides an in-depth explanation of Linux commands and tools for managing firewalls: `ufw`, `iptables`, and `firewalld`. Each section includes a detailed description, how the tool works, common options, practical examples, use cases, and troubleshooting tips to help you configure and manage firewall rules effectively.

## Overview of Firewall Management
- **Purpose**: Firewalls control incoming and outgoing network traffic based on predefined rules, enhancing system security by blocking unauthorized access and allowing legitimate traffic.
- **Mechanics**: Firewalls operate at the kernel level using `netfilter`, with tools like `ufw`, `iptables`, and `firewalld` providing user interfaces to configure rules.
- **Use Cases**:
  - Securing a web server by allowing only HTTP/HTTPS traffic.
  - Blocking specific IP addresses or ports.
  - Managing dynamic firewall rules for complex environments.
- **Key Concepts**:
  - **Rules**: Define actions (e.g., accept, drop) based on criteria (e.g., port, IP, protocol).
  - **Chains**: Categories for rules (e.g., INPUT, OUTPUT, FORWARD).
  - **Policies**: Default actions for unmatched traffic (e.g., DROP, ACCEPT).

## 1. ufw (Uncomplicated Firewall)
### Overview
- **Purpose**: A user-friendly frontend for `iptables`, simplifying firewall configuration on Debian-based systems (e.g., Ubuntu).
- **Mechanics**: Translates high-level commands into `iptables` rules, managing the `netfilter` framework.
- **Use Cases**:
  - Quickly enabling/disabling firewall rules.
  - Allowing specific services (e.g., SSH, HTTP).
  - Blocking unwanted traffic for basic server security.

### Common Options
- `enable`: Enable the firewall.
- `disable`: Disable the firewall.
- `status`: Show current rules and status.
- `allow [port/protocol]`: Allow traffic on a port or service.
- `deny [port/protocol]`: Block traffic on a port or service.
- `delete [rule]`: Remove a rule.
- `reset`: Reset to default (disables firewall, clears rules).

### Detailed Examples
1. **Enable ufw and Allow SSH**:
   ```bash
   sudo ufw enable
   sudo ufw allow ssh
   # Allows port 22/tcp
   sudo ufw status
   # Output: Status: active
   #         To                         Action      From
   #         22/tcp                     ALLOW       Anywhere
   ```

2. **Allow HTTP and HTTPS**:
   ```bash
   sudo ufw allow http
   sudo ufw allow https
   # Allows ports 80/tcp and 443/tcp
   ```

3. **Deny Specific Port**:
   ```bash
   sudo ufw deny 23/tcp
   # Blocks telnet
   ```

4. **Allow Specific IP**:
   ```bash
   sudo ufw allow from 192.168.1.100
   # Allows all traffic from 192.168.1.100
   ```

5. **Delete a Rule**:
   ```bash
   sudo ufw status numbered
   # Output: [1] 22/tcp  ALLOW  Anywhere
   sudo ufw delete 1
   ```

### Troubleshooting
- **Locked out (e.g., SSH)**: Ensure `ufw allow ssh` is set before enabling.
- **Rules not applying**: Check status (`sudo ufw status`) and reload (`sudo ufw reload`).
- **Permission denied**: Use `sudo` for all `ufw` commands.
- **Conflicts with iptables**: Avoid mixing `ufw` and direct `iptables` rules.

## 2. iptables (IP Tables)
### Overview
- **Purpose**: A low-level tool to configure `netfilter` firewall rules, offering fine-grained control over network traffic.
- **Mechanics**: Defines rules in chains (INPUT, OUTPUT, FORWARD) to accept, drop, or reject packets based on criteria like port, IP, or protocol.
- **Use Cases**:
  - Creating complex firewall rules.
  - Logging specific traffic.
  - Managing NAT (Network Address Translation).

### Common Options
- `-A [chain]`: Append a rule to a chain.
- `-D [chain] [rule]`: Delete a rule.
- `-L [chain]`: List rules in a chain.
- `-F [chain]`: Flush (clear) rules in a chain.
- `-P [chain] [policy]`: Set default policy (e.g., DROP, ACCEPT).
- `-p [protocol]`: Specify protocol (e.g., tcp, udp).
- `--dport [port]`: Destination port.
- `-s [source]`: Source IP.
- `-j [target]`: Action (e.g., ACCEPT, DROP, REJECT).

### Detailed Examples
1. **List All Rules**:
   ```bash
   sudo iptables -L -v -n
   # Output: Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
   #         pkts bytes target prot opt in out source destination
   ```

2. **Allow SSH Traffic**:
   ```bash
   sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
   # Allows incoming SSH
   ```

3. **Block Specific IP**:
   ```bash
   sudo iptables -A INPUT -s 192.168.1.100 -j DROP
   # Drops all traffic from 192.168.1.100
   ```

4. **Set Default Policy to DROP**:
   ```bash
   sudo iptables -P INPUT DROP
   sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
   # Drops all incoming traffic except HTTP
   ```

5. **Save Rules**:
   ```bash
   sudo iptables-save > /etc/iptables/rules.v4
   # Persist rules (Debian-based, requires iptables-persistent package)
   ```

### Troubleshooting
- **Rules not persistent**: Use `iptables-save` and a package like `iptables-persistent`.
- **Locked out**: Ensure critical ports (e.g., SSH) are allowed before setting DROP policy.
- **Complex rules**: Test rules incrementally and use `-L -v -n` to verify.
- **Conflicts with ufw/firewalld**: Use only one firewall tool to avoid conflicts.

## 3. firewalld (Firewall Daemon)
### Overview
- **Purpose**: A dynamic firewall management tool for Red Hat-based systems (e.g., CentOS, Fedora), providing a high-level interface for `netfilter`.
- **Mechanics**: Uses zones (e.g., public, trusted) and services to manage rules, with dynamic updates via D-Bus.
- **Use Cases**:
  - Managing firewall rules on servers with changing network conditions.
  - Supporting NetworkManager integration.
  - Configuring complex firewall policies with zones.

### Common Options
- `--get-zones`: List available zones.
- `--get-active-zones`: Show currently active zones.
- `--add-service=[service]`: Allow a service (e.g., `http`, `ssh`).
- `--add-port=[port/protocol]`: Allow a specific port.
- `--remove-service=[service]`: Remove a service rule.
- `--permanent`: Make changes persistent across reboots.
- `--reload`: Apply changes without interrupting connections.

### Detailed Examples
1. **Check Active Zones**:
   ```bash
   sudo firewall-cmd --get-active-zones
   # Output: public
   #         interfaces: eth0
   ```

2. **Allow HTTP Service**:
   ```bash
   sudo firewall-cmd --add-service=http
   sudo firewall-cmd --permanent --add-service=http
   sudo firewall-cmd --reload
   # Output: success
   ```

3. **Allow Specific Port**:
   ```bash
   sudo firewall-cmd --add-port=8080/tcp --permanent
   sudo firewall-cmd --reload
   ```

4. **List Rules in a Zone**:
   ```bash
   sudo firewall-cmd --list-all
   # Output: public (active)
   #         services: ssh http
   #         ports: 8080/tcp
   ```

5. **Block an IP**:
   ```bash
   sudo firewall-cmd --add-source=192.168.1.100 --zone=drop --permanent
   sudo firewall-cmd --reload
   ```

### Troubleshooting
- **Rules not applied**: Use `--permanent` and `--reload` for persistence.
- **Service not found**: Check available services (`firewall-cmd --get-services`).
- **Locked out**: Ensure `ssh` or management ports are allowed in the active zone.
- **Conflicts with iptables/ufw**: Disable other firewall tools (`systemctl stop ufw`).

## Practical Tips
- **Choose one tool**: Use `ufw` (Ubuntu), `firewalld` (Red Hat), or `iptables` exclusively to avoid conflicts.
- **Test rules**: Apply rules temporarily before making them permanent.
- **Backup rules**: Save `iptables` rules (`iptables-save`) or export `firewalld` configs (`/etc/firewalld/`).
- **Log blocked traffic**: Use `iptables -j LOG` or `firewalld` logging for debugging.
- **Allow critical services**: Always allow `ssh` (port 22) to avoid lockouts.
- **Monitor logs**: Check `/var/log/messages` or `journalctl` for firewall-related events.

## Practice Tasks
1. Enable `ufw` and allow SSH and HTTP.
2. List all `iptables` rules for the INPUT chain.
3. Block traffic from `192.168.1.200` using `iptables`.
4. Allow port 8080/tcp in `firewalld` for the public zone.
5. Check active zones in `firewalld`.
6. Delete the HTTP rule from `ufw`.

**Solution** (Debian-based with `ufw` and `iptables`):
```bash
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow http
sudo iptables -L INPUT -v -n
sudo iptables -A INPUT -s 192.168.1.200 -j DROP
sudo ufw status numbered
sudo ufw delete allow http
```

**Solution** (Red Hat-based with `firewalld`):
```bash
sudo firewall-cmd --add-service=ssh --permanent
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --remove-service=http --permanent
sudo firewall-cmd --reload
```