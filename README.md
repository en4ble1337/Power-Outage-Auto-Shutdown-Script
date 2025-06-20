# Power Outage Auto-Shutdown Script

A lightweight bash script that monitors internet connectivity and gracefully shuts down your system during power outages to prevent data corruption.

## ⚠️ Disclaimer

**I don't take any responsibility for this script. This is my way of giving back to the community. Always test thoroughly before putting into production and adjust to your specific situation.**

Would like to share a new logic script that I think some may find beneficial to their setups. This will work with any system that can run cronjobs.

---

# 🎯 Purpose

---

During power outages, this script ensures graceful system shutdown instead of abrupt power cut-off by monitoring internet connectivity as a proxy for power status.

# 🧠 Logic

---

When power goes out, your ISP typically goes down too. The script monitors internet connectivity by pinging 1.1.1.1 every minute. After 5 consecutive failures (configurable), it triggers a graceful shutdown, giving you time to work on battery backup.

# ✅ Benefits

---

**Why Graceful Shutdown Matters:**
- Applications close properly instead of crashing
- Prevents data corruption and file system issues
- Databases and services shut down cleanly
- Reduces recovery time when power returns

# 📋 Requirements

---

- Linux/Unix system with bash
- Cron job capability
- Root/sudo access
- Battery backup (UPS) recommended

# 🔧 Installation

---

### Method 1: Using Git

**Step 1:** Install Git (if not already installed)
```
apt update
apt install git -y
```

**Step 2:** Clone the Repository
```
git clone https://github.com/en4ble1337/Power-Outage-Auto-Shutdown-Script.git
cd Power-Outage-Auto-Shutdown-Script
```

**Step 3:** Install the Script
```
sudo cp ping_monitor.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/ping_monitor.sh
```

### Method 2: Direct Download (No Git Required)

**Step 1:** Download the Script
```
wget https://raw.githubusercontent.com/en4ble1337/Power-Outage-Auto-Shutdown-Script/main/ping_monitor.sh
```

**Step 2:** Install the Script
```
sudo mv ping_monitor.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/ping_monitor.sh
```

### Continue with Either Method

### Setup Cron Job
```
sudo crontab -e
```

Add this line:
```
# Run ping monitor every minute
* * * * * /usr/local/bin/ping_monitor.sh
```

### Setup Log Files
```
sudo touch /var/log/ping_monitor.log
sudo touch /var/log/ping_monitor_counter
sudo chmod 644 /var/log/ping_monitor.log
sudo chmod 644 /var/log/ping_monitor_counter
```

# ⚙️ Configuration

---

Edit the script to customize:
- **Timeout**: Change the `5` in the failure check to your desired minutes
- **Target IP**: Change `1.1.1.1` to a different reliable server
- **Ping timeout**: Modify the `-W 5` parameter for different ping timeouts

# 🔍 How It Works

---

1. Script pings 1.1.1.1 once every minute via cron
2. If ping fails, increments counter in `/var/log/ping_monitor_counter`
3. If ping succeeds, resets counter to 0
4. After 5 consecutive failures, issues graceful shutdown command
5. All activities are logged to `/var/log/ping_monitor.log`

# 🧪 Testing

---

**Safe Testing (without actual shutdown):**
1. Comment out the shutdown line in the script:
   ```
   # /sbin/shutdown -h now "Network connectivity lost - automatic shutdown triggered"
   ```
2. Block 1.1.1.1 traffic temporarily:
   ```
   sudo iptables -A OUTPUT -d 1.1.1.1 -j DROP
   ```
3. Monitor the log:
   ```
   tail -f /var/log/ping_monitor.log
   ```
4. Restore connectivity:
   ```
   sudo iptables -D OUTPUT -d 1.1.1.1 -j DROP
   ```

# 📊 Monitoring

---

**Check current failure count:**
```
cat /var/log/ping_monitor_counter
```

**View log file:**
```
tail -f /var/log/ping_monitor.log
```

**Check if cron job is running:**
```
sudo crontab -l | grep ping_monitor
```

# 🏗️ System Assumptions

---

- System runs on battery backup (UPS)
- Default 5-minute window is adjustable based on your battery capacity
- Internet outage indicates power outage in most cases
- System has sufficient UPS runtime for graceful shutdown

# ⚠️ Recommendations for Critical Systems

---

For validators or mission-critical systems:
- Always maintain full system backups (not just keys)
- Consider running standby/failover units
- Test your UPS runtime regularly
- Monitor UPS battery health
- Consider shorter timeout periods for faster response

# 🔧 Troubleshooting

---

**Script not running:**
- Check cron service: `systemctl status cron`
- Verify crontab entry: `sudo crontab -l`
- Check script permissions: `ls -la /usr/local/bin/ping_monitor.sh`

**False shutdowns:**
- Increase failure threshold in script
- Use different target IP addresses
- Check network stability

**Log files not created:**
- Verify write permissions to `/var/log/`
- Check disk space

# 🤝 Contributing

---

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

# 📄 License

---

This project is released under the MIT License. See LICENSE file for details.

# ⭐ Support

---

If you find this script helpful, please star the repository! 

For issues or questions, please open a GitHub issue.
