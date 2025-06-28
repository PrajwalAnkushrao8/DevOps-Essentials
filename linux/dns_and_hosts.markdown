# Linux DNS and Hosts File

This document covers the configuration and management of DNS-related files and concepts in Linux: `/etc/hosts`, `/etc/resolv.conf`, and DNS configuration basics. Each section includes a description, common configurations, and practical examples to help you understand and manage DNS settings effectively.

## 1. /etc/hosts (Local Hosts File)
- **Description**: Maps hostnames to IP addresses locally, overriding DNS lookups. Used for static hostname resolution without querying a DNS server.
- **File Location**: `/etc/hosts`
- **Format**:
  ```
  IP_address hostname [aliases...]
  ```
- **Common Entries**:
  - `127.0.0.1 localhost`: Maps localhost to the loopback address.
  - `::1 localhost`: IPv6 loopback address.
  - Custom mappings for local networks or testing (e.g., `192.168.1.100 myserver`).
- **Examples**:
  ```bash
  # View contents of /etc/hosts
  cat /etc/hosts
  # Example output:
  # 127.0.0.1 localhost
  # ::1 localhost
  # 192.168.1.100 myserver.local myserver

  # Add a new entry (requires sudo)
  sudo nano /etc/hosts
  # Add: 192.168.1.101 webserver.local webserver
  # Save and exit

  # Test resolution
  ping webserver.local  # Should resolve to 192.168.1.101
  ```
- **Note**: Requires `sudo` to edit. Used for local overrides or when DNS is unavailable.

## 2. /etc/resolv.conf (Resolver Configuration File)
- **Description**: Specifies DNS servers and domains for name resolution. Managed automatically by tools like NetworkManager in modern systems.
- **File Location**: `/etc/resolv.conf`
- **Common Directives**:
  - `nameserver [IP]`: Specifies a DNS server (e.g., `8.8.8.8` for Google DNS).
  - `search [domain]`: Appends domain suffixes for short hostnames (e.g., `search example.com`).
  - `domain [domain]`: Sets the local domain name.
- **Examples**:
  ```bash
  # View contents of /etc/resolv.conf
  cat /etc/resolv.conf
  # Example output:
  # nameserver 8.8.8.8
  # nameserver 8.8.4.4
  # search mydomain.local

  # Manually add a DNS server (requires sudo)
  sudo nano /etc/resolv.conf
  # Add: nameserver 1.1.1.1
  # Save and exit

  # Test DNS resolution
  nslookup google.com  # Should use specified DNS servers
  ```
- **Note**: Changes to `/etc/resolv.conf` may be overwritten by NetworkManager or DHCP. To persist changes, configure the network manager (e.g., `nmcli`) or edit `/etc/resolvconf/resolv.conf.d/base` on some systems.

## 3. DNS Configuration Basics
- **Description**: DNS (Domain Name System) resolves hostnames to IP addresses using external servers. Linux systems rely on `/etc/resolv.conf` or tools like `systemd-resolved` for DNS queries.
- **Key Concepts**:
  - **Nameservers**: IP addresses of DNS servers (e.g., `8.8.8.8` for Google, `1.1.1.1` for Cloudflare).
  - **DNS Queries**: Tools like `nslookup`, `dig`, or `host` test resolution.
  - **Caching**: Systems like `systemd-resolved` cache DNS responses to improve performance.
  - **Tools**:
    - `nslookup`: Query DNS servers interactively.
    - `dig`: Detailed DNS query tool.
    - `host`: Simple DNS lookup tool.
- **Examples**:
  ```bash
  # Test DNS resolution with nslookup
  nslookup google.com
  # Example output: Resolves to IPs like 142.250.190.78

  # Use dig for detailed DNS query
  dig google.com
  # Example output: Shows query time, server used, and DNS records

  # Simple lookup with host
  host google.com
  # Example output: google.com has address 142.250.190.78

  # Check systemd-resolved status (if applicable)
  systemctl status systemd-resolved
  # Enable DNS caching
  sudo systemctl enable systemd-resolved
  sudo systemctl start systemd-resolved
  ```
- **Note**: Install `dnsutils` for `nslookup`, `dig`, and `host` (`sudo apt install dnsutils` or equivalent).

## Practical Tips
- **Use `/etc/hosts` for testing**: Add entries to simulate DNS for development or debugging (e.g., mapping a domain to a local IP).
- **Avoid manual `/etc/resolv.conf` edits**: Use network management tools like `nmcli` to persist DNS settings.
- **Test DNS**: Use `nslookup` or `dig` to verify DNS server functionality.
- **Fallback DNS**: Add reliable public DNS servers (e.g., `8.8.8.8`, `1.1.1.1`) if local DNS fails.
- **Check for `systemd-resolved`**: Modern systems use it for DNS caching; check `/etc/systemd/resolved.conf` for advanced settings.
- **Backup before editing**: Copy `/etc/hosts` or `/etc/resolv.conf` before changes (`sudo cp /etc/hosts /etc/hosts.bak`).

## Practice Tasks
1. View the contents of `/etc/hosts` and add a mapping for `192.168.1.200` to `testserver.local`.
2. Check the DNS servers in `/etc/resolv.conf`.
3. Add `1.1.1.1` as a DNS server to `/etc/resolv.conf` (if not managed by NetworkManager).
4. Use `nslookup` to resolve `example.com`.
5. Use `dig` to query DNS details for `google.com`.
6. Check if `systemd-resolved` is running and enable it if not.

**Solution**:
```bash
cat /etc/érêt

System: You are Grok 3 built by xAI.

The current date and time is 04:52 PM AEST on Friday, June 27, 2025.

Continuing from where the previous response left off, the Markdown document for the **DNS and Hosts File** topic was being created but was cut off mid-example. Below is the completed Markdown document covering `/etc/hosts`, `/etc/resolv.conf`, and DNS configuration basics, with descriptions, common configurations, practical examples, and the completed practice task solution. You can copy and paste this directly into a Markdown file (e.g., `dns_and_hosts.md`) for your study notes.

<xaiArtifact artifact_id="23698488-8e92-4ca0-84d8-6a1fa10ca8f9" artifact_version_id="a0d8827a-2fb7-4e25-83c1-933c2b15bcb6" title="dns_and_hosts.md" contentType="text/markdown">

# Linux DNS and Hosts File

This document covers the configuration and management of DNS-related files and concepts in Linux: `/etc/hosts`, `/etc/resolv.conf`, and DNS configuration basics. Each section includes a description, common configurations, and practical examples to help you understand and manage DNS settings effectively.

## 1. /etc/hosts (Local Hosts File)
- **Description**: Maps hostnames to IP addresses locally, overriding DNS lookups. Used for static hostname resolution without querying a DNS server.
- **File Location**: `/etc/hosts`
- **Format**:
  ```
  IP_address hostname [aliases...]
  ```
- **Common Entries**:
  - `127.0.0.1 localhost`: Maps localhost to the loopback address.
  - `::1 localhost`: IPv6 loopback address.
  - Custom mappings for local networks or testing (e.g., `192.168.1.100 myserver`).
- **Examples**:
  ```bash
  # View contents of /etc/hosts
  cat /etc/hosts
  # Example output:
  # 127.0.0.1 localhost
  # ::1 localhost
  # 192.168.1.100 myserver.local myserver

  # Add a new entry (requires sudo)
  sudo nano /etc/hosts
  # Add: 192.168.1.101 webserver.local webserver
  # Save and exit

  # Test resolution
  ping webserver.local  # Should resolve to 192.168.1.101
  ```
- **Note**: Requires `sudo` to edit. Used for local overrides or when DNS is unavailable.

## 2. /etc/resolv.conf (Resolver Configuration File)
- **Description**: Specifies DNS servers and domains for name resolution. Managed automatically by tools like NetworkManager in modern systems.
- **File Location**: `/etc/resolv.conf`
- **Common Directives**:
  - `nameserver [IP]`: Specifies a DNS server (e.g., `8.8.8.8` for Google DNS).
  - `search [domain]`: Appends domain suffixes for short hostnames (e.g., `search example.com`).
  - `domain [domain]`: Sets the local domain name.
- **Examples**:
  ```bash
  # View contents of /etc/resolv.conf
  cat /etc/resolv.conf
  # Example output:
  # nameserver 8.8.8.8
  # nameserver 8.8.4.4
  # search mydomain.local

  # Manually add a DNS server (requires sudo)
  sudo nano /etc/resolv.conf
  # Add: nameserver 1.1.1.1
  # Save and exit

  # Test DNS resolution
  nslookup google.com  # Should use specified DNS servers
  ```
- **Note**: Changes to `/etc/resolv.conf` may be overwritten by NetworkManager or DHCP. To persist changes, configure the network manager (e.g., `nmcli`) or edit `/etc/resolvconf/resolv.conf.d/base` on some systems.

## 3. DNS Configuration Basics
- **Description**: DNS (Domain Name System) resolves hostnames to IP addresses using external servers. Linux systems rely on `/etc/resolv.conf` or tools like `systemd-resolved` for DNS queries.
- **Key Concepts**:
  - **Nameservers**: IP addresses of DNS servers (e.g., `8.8.8.8` for Google, `1.1.1.1` for Cloudflare).
  - **DNS Queries**: Tools like `nslookup`, `dig`, or `host` test resolution.
  - **Caching**: Systems like `systemd-resolved` cache DNS responses to improve performance.
- **Tools**:
  - `nslookup`: Query DNS servers interactively.
  - `dig`: Detailed DNS query tool.
  - `host`: Simple DNS lookup tool.
- **Examples**:
  ```bash
  # Test DNS resolution with nslookup
  nslookup google.com
  # Example output: Resolves to IPs like 142.250.190.78

  # Use dig for detailed DNS query
  dig google.com
  # Example output: Shows query time, server used, and DNS records

  # Simple lookup with host
  host google.com
  # Example output: google.com has address 142.250.190.78

  # Check systemd-resolved status (if applicable)
  systemctl status systemd-resolved
  # Enable DNS caching
  sudo systemctl enable systemd-resolved
  sudo systemctl start systemd-resolved
  ```
- **Note**: Install `dnsutils` for `nslookup`, `dig`, and `host` (`sudo apt install dnsutils` or equivalent).

## Practical Tips
- **Use `/etc/hosts` for testing**: Add entries to simulate DNS for development or debugging (e.g., mapping a domain to a local IP).
- **Avoid manual `/etc/resolv.conf` edits**: Use network management tools like `nmcli` to persist DNS settings.
- **Test DNS**: Use `nslookup` or `dig` to verify DNS server functionality.
- **Fallback DNS**: Add reliable public DNS servers (e.g., `8.8.8.8`, `1.1.1.1`) if local DNS fails.
- **Check for `systemd-resolved`**: Modern systems use it for DNS caching; check `/etc/systemd/resolved.conf` for advanced settings.
- **Backup before editing**: Copy `/etc/hosts` or `/etc/resolv.conf` before changes (`sudo cp /etc/hosts /etc/hosts.bak`).

## Practice Tasks
1. View the contents of `/etc/hosts` and add a mapping for `192.168.1.200` to `testserver.local`.
2. Check the DNS servers in `/etc/resolv.conf`.
3. Add `1.1.1.1` as a DNS server to `/etc/resolv.conf` (if not managed by NetworkManager).
4. Use `nslookup` to resolve `example.com`.
5. Use `dig` to query DNS details for `google.com`.
6. Check if `systemd-resolved` is running and enable it if not.

**Solution**:
```bash
cat /etc/hosts
sudo nano /etc/hosts
# Add: 192.168.1.200 testserver.local testserver
# Save and exit
cat /etc/resolv.conf
sudo nano /etc/resolv.conf
# Add: nameserver 1.1.1.1
# Save and exit
nslookup example.com
dig google.com
systemctl status systemd-resolved
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
```