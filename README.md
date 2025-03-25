# Split Tunneling Setup for Amnezia VPN on DigitalOcean

This guide helps you set up server-side split tunneling for Amnezia VPN on a DigitalOcean server.
It allows you to dynamically route only specific IPs through VPN for all clients, and toggle the routing on/off.

## 📦 Files Needed

- `toggle_split_tunneling.sh`: Script to enable/disable split tunneling
- `splitvpn-toggle.service`: systemd unit to toggle routing
- `ip-list.json`: JSON file containing the list of IPs to be routed through VPN

## 🚀 Setup Instructions

### 1. Upload the files to your server
```bash
scp toggle_split_tunneling.sh root@<SERVER_IP>:/root/
scp splitvpn-toggle.service root@<SERVER_IP>:/etc/systemd/system/
scp ip-list.json root@<SERVER_IP>:/root/
```

### 2. Make the script executable
```bash
chmod +x /root/toggle_split_tunneling.sh
```

### 3. Install `jq` (if not installed)
```bash
apt update && apt install -y jq
```

### 4. Reload systemd and enable the service
```bash
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable splitvpn-toggle.service
```

### 5. Toggle split tunneling manually
```bash
systemctl start splitvpn-toggle.service   # toggles on/off based on current state
```

## 🧠 How it works

- Adds custom routes to specific IPs using `ip route add`
- Uses custom routing table `splitvpn` and `ip rule` for client subnet `172.29.172.0/24`
- Tracks state using `/root/.splitvpn_enabled` file

## 🔁 Optional
- To auto-toggle at boot, keep the service enabled with `systemctl enable`

---
**Note:** Update the script if your VPN interface or client subnet differs from `amn0` / `172.29.172.0/24`.