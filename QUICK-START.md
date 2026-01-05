# 🚀 QUICK START GUIDE

## Prerequisites
- Docker installed
- Docker Compose installed

## 1. Start Services (30 seconds)

```bash
# Option A: Using management script (recommended)
chmod +x manage.sh
./manage.sh start

# Option B: Using docker-compose directly
docker-compose up -d
```

## 2. Access Your Services

### 🌐 Reverse Proxy (Main Service)
```
http://localhost
```
**Available paths:**
- `/map` → Your mapping service (172.16.116.82:3000)
- `/data` → Your data service (172.16.116.82:8501)  
- `/pm25` → Your PM2.5 service (172.16.116.82:3002)
- `/pm25infuxd` → Your InfluxDB service (172.16.116.82:8086)

### ⚙️ Nginx Management UI
```
http://localhost:8080
```
**Default Login:**
- Username: `admin`
- Password: `admin`

**🔧 Alternative access via proxy:**
```
http://localhost/admin
```

## 3. Verify Everything Works

```bash
# Check service status
./manage.sh status

# Test health endpoint
curl http://localhost/health

# Test a backend route (example)
curl http://localhost/map
```

## 4. Quick Configuration

### Using Nginx UI (Easy Way)
1. Go to http://localhost:8080
2. Login with admin/admin
3. Navigate to "Sites" → Create new site
4. Configure your routes through the GUI

### Manual Configuration (Advanced)
1. Edit `nginx.conf` file
2. Restart: `./manage.sh restart`

## 5. View Logs

```bash
# All logs
./manage.sh logs

# Just proxy logs
./manage.sh logs-proxy

# Just UI logs  
./manage.sh logs-ui
```

## 6. Stop Services

```bash
./manage.sh stop
```

---

## 🎯 That's It!

Your Nginx reverse proxy with web UI is now running:

- **Main proxy**: Routes traffic to your backend services
- **Web UI**: Manage configurations without touching files
- **Monitoring**: Real-time stats and logs
- **SSL Ready**: Configure HTTPS through the UI

## 🔥 Pro Tips

1. **Change the default password** immediately after first login
2. **Bookmark** http://localhost:8080 for easy access to management
3. **Use the UI** instead of editing files manually
4. **Check logs** if something doesn't work: `./manage.sh logs`

## ❓ Need Help?

- **Full documentation**: See `README.md`
- **Configuration issues**: Run `./manage.sh config`
- **Clean restart**: `./manage.sh clean` then `./manage.sh start`

**Happy proxying! 🎉**