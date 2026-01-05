# Traefik Reverse Proxy Setup

Modern reverse proxy with automatic service discovery and built-in web dashboard.

## 🚀 Quick Start

### Start Traefik
```bash
# Make script executable
chmod +x manage-traefik.sh

# Start Traefik
./manage-traefik.sh start
```

### Access Services
- **🌐 Main Proxy**: http://localhost
- **📊 Traefik Dashboard**: http://localhost:8080

## 📍 Route Mappings

| Path | Backend Service | Description |
|------|----------------|-------------|
| `/map` | 172.16.116.82:3000 | Mapping service |
| `/data` | 172.16.116.82:8501 | Data service |
| `/pm25` | 172.16.116.82:3002 | PM2.5 monitoring |
| `/pm25infuxd` | 172.16.116.82:8086 | PM2.5 InfluxDB |
| `/health` | Internal | Health check |

## ✨ Traefik Features

### Built-in Dashboard
- **URL**: http://localhost:8080
- **Real-time routing information**
- **Service health monitoring**
- **Request metrics and statistics**
- **No authentication required** (development setup)

### Automatic Features
- ✅ **Service Discovery**: Automatic backend detection
- ✅ **Health Checks**: Built-in health monitoring
- ✅ **Load Balancing**: Automatic load distribution
- ✅ **Path Stripping**: Removes path prefixes before forwarding
- ✅ **Security Headers**: Automatic security header injection
- ✅ **Metrics**: Prometheus metrics available
- ✅ **Hot Reload**: Configuration updates without restart

## 🔧 Management Commands

```bash
# Service management
./manage-traefik.sh start      # Start Traefik
./manage-traefik.sh stop       # Stop Traefik
./manage-traefik.sh restart    # Restart Traefik
./manage-traefik.sh status     # Check status

# Monitoring
./manage-traefik.sh logs       # View logs
./manage-traefik.sh dashboard  # Open dashboard

# Configuration
./manage-traefik.sh config     # Validate config
./manage-traefik.sh clean      # Clean everything
```

## 📁 Configuration Files

### Docker Compose
- `docker-compose.yml` - Main Traefik service definition

### Traefik Configuration
- `traefik/dynamic.yml` - Route definitions and middleware

### Logs
- `logs/` - Traefik access and error logs

## 🔄 Configuration Updates

Traefik automatically reloads configuration changes:

1. **Edit routes**: Modify `traefik/dynamic.yml`
2. **Save file**: Changes apply automatically
3. **Check dashboard**: Verify routes updated

No container restart required!

## 🏥 Health Monitoring

### Built-in Health Checks
- **Traefik**: http://localhost:8080/ping
- **Services**: Automatic backend health monitoring
- **Dashboard**: Real-time service status

### Service Status
```bash
# Check Traefik health
curl http://localhost:8080/ping

# Check service health
curl http://localhost/health

# Test backend routes
curl http://localhost/map
curl http://localhost/data
```

## 🔒 Security Features

### Automatic Security Headers
- `X-Frame-Options: SAMEORIGIN`
- `X-XSS-Protection: 1; mode=block`
- `X-Content-Type-Options: nosniff`

### Network Security
- Isolated Docker network
- No direct backend exposure
- Configurable SSL/TLS (ready for certificates)

## 🆚 Traefik vs Nginx

### Advantages of Traefik
- ✅ **Built-in Dashboard**: No separate UI needed
- ✅ **Auto-discovery**: Automatic service detection
- ✅ **Hot Reload**: No restart for config changes
- ✅ **Modern**: Cloud-native design
- ✅ **Metrics**: Built-in Prometheus metrics
- ✅ **SSL**: Automatic Let's Encrypt integration

### Migration Benefits
- 🔄 **Same functionality**: All routes work identically
- 📊 **Better monitoring**: Real-time dashboard
- ⚡ **Easier management**: Less configuration needed
- 🔧 **More flexible**: Dynamic configuration updates

## 🛠 Troubleshooting

### Service Not Accessible
1. Check Traefik dashboard: http://localhost:8080
2. Verify service appears in "HTTP Services"
3. Check backend health in dashboard
4. Review logs: `./manage-traefik.sh logs`

### Configuration Issues
```bash
# Validate configuration
./manage-traefik.sh config

# Check dynamic config syntax
docker run --rm -v $(pwd)/traefik:/etc/traefik traefik:v3.0 traefik validate --configfile=/etc/traefik/dynamic.yml
```

### Port Conflicts
```bash
# Check port usage
netstat -ano | findstr :80
netstat -ano | findstr :8080

# Change ports in docker-compose.yml if needed
```

## 🚀 Advanced Features

### SSL/HTTPS Setup
Ready for SSL certificates - just add certificate configuration to `traefik/dynamic.yml`.

### Custom Middleware
Add authentication, rate limiting, or custom headers by extending the middleware section.

### Multiple Environments
Use different dynamic configuration files for dev/staging/production.

## 📈 Monitoring & Metrics

### Prometheus Metrics
- **Endpoint**: http://localhost:8080/metrics
- **Built-in**: Request counts, response times, error rates
- **Integration**: Ready for Grafana dashboards

### Access Logs
- **Location**: `logs/` directory
- **Format**: JSON structured logs
- **Content**: All requests with timing information

---

**🎉 Enjoy your modern reverse proxy with Traefik!**