# 09. Networking Basics

A solid understanding of server networking is fundamental for every Linux administrator. This guide covers the essential tools and configurations you'll use repeatedly.

---

## 1. View Network Interfaces and IP Addresses

```bash
# Modern command — shows all interfaces and IP addresses
ip addr show

# Shortened form
ip a

# Show only a specific interface
ip addr show eth0
```

---

## 2. View Routing Table

The routing table determines where network packets are sent.

```bash
# View the routing table
ip route

# Find the default gateway (your router)
ip route | grep default
```

---

## 3. Check DNS Resolution

```bash
# Check which DNS servers are configured
cat /etc/resolv.conf

# Test DNS resolution
nslookup google.com
dig google.com          # More detailed output
host google.com         # Simple, clean output

# Test connectivity to a specific IP
ping -c 4 8.8.8.8       # Google's DNS — good for testing connectivity
```

---

## 4. Configure a Static IP Address

A static IP is essential for servers — you don't want the IP to change on reboot.

### Ubuntu (Netplan — Ubuntu 18.04+)

```bash
# View current Netplan config
ls /etc/netplan/

sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    eth0:                         # Your interface name (check with: ip a)
      dhcp4: false
      addresses:
        - 192.168.1.100/24        # Your desired static IP
      routes:
        - to: default
          via: 192.168.1.1        # Your gateway (router IP)
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]   # Google DNS, Cloudflare DNS
```

Apply the changes:
```bash
sudo netplan apply
```

### CentOS / AlmaLinux (nmcli — NetworkManager)

```bash
# List network connections
nmcli connection show

# Set a static IP on a connection (replace 'eth0' with your interface name)
sudo nmcli connection modify eth0 \
  ipv4.method manual \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8,1.1.1.1"

# Restart the connection to apply
sudo nmcli connection up eth0

# Verify
ip addr show eth0
```

---

## 5. Check Open Ports and Listening Services

```bash
# Show all listening ports with the process name
ss -tulnp

# Show only TCP connections
ss -tnp

# Show only UDP
ss -unp

# Check if a specific port is open locally
ss -tulnp | grep :80
```

---

## 6. Test Remote Connectivity

```bash
# Test if a remote port is open (e.g., SSH on port 22)
telnet server_ip 22

# Better alternative using nc (netcat)
nc -zv server_ip 22

# Trace the network path to a destination
traceroute google.com

# Alternative (more informative)
mtr google.com
```

---

## 7. `/etc/hosts` — Local DNS Override

The `/etc/hosts` file allows you to manually map hostnames to IP addresses. This takes priority over DNS.

```bash
sudo nano /etc/hosts
```

Example entries:
```
127.0.0.1   localhost
127.0.1.1   my-server

# Custom mappings
192.168.1.50  database-server db
192.168.1.60  web-server web
```

After adding entries, you can ping by name:
```bash
ping database-server
```

---

**Next Step:** [Quick Reference Cheat Sheet →](QUICK-REFERENCE.md)
