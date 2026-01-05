# Nginx Reverse Proxy with UI Management

This Docker Compose setup provides an Nginx reverse proxy with a web-based management interface for easy configuration.

## Services

### 1. Nginx Reverse Proxy (`nginx-proxy`)
- **Port**: 80 (HTTP) - *Standard HTTP port (IIS server stopped)*
- **Purpose**: Routes requests to backend services on 172.16.116.82 network
- **Path Mappings**:
  - `/map` → `http://172.16.116.82:3000`
  - `/data` → `http://172.16.116.82:8501`
  - `/pm25` → `http://172.16.116.82:3002`
  - `/pm25infuxd` → `http://172.16.116.82:8086`

### 2. Nginx UI Management (`nginx-ui`)
- **Port**: 8002 (HTTP), 8443 (HTTPS) - *Changed from 8080 to avoid API conflicts*
- **Purpose**: Web-based interface for managing Nginx configurations
- **Access**: http://localhost:8002
- **Default Credentials**: 
  - Username: `admin`
  - Password: `admin` (change on first login)

## Quick Start

### Option 1: Using Management Script (Recommended)
```bash
# Make script executable
chmod +x manage.sh

# Start services
./manage.sh start

# Check status
./manage.sh status

# View logs
./manage.sh logs

# Stop services
./manage.sh stop
```

### Option 2: Using Docker Compose Directly
1. **Start the services**:
   ```bash
   docker-compose up -d
   ```

2. **Access the services**:
   - **Reverse Proxy**: http://localhost
   - **Nginx UI**: http://localhost:8002
   - **Admin Panel**: http://localhost/admin

3. **Check service status**:
   ```bash
   docker-compose ps
   ```

4. **View logs**:
   ```bash
   # All services
   docker-compose logs -f
   
   # Specific service
   docker-compose logs -f nginx-proxy
   docker-compose logs -f nginx-ui
   ```

## Nginx UI Features

The Nginx UI provides a web-based interface to:

- **Configuration Management**: Edit nginx.conf and site configurations through a GUI
- **Site Management**: Create, enable/disable, and manage virtual hosts
- **Real-time Monitoring**: View server statistics and performance metrics
- **Log Viewing**: Access and analyze Nginx access and error logs
- **SSL/TLS Management**: Manage certificates and SSL configurations
- **Auto-reload**: Automatically reload Nginx after configuration changes

## Configuration Management

### Using Nginx UI (Recommended)
1. Access http://localhost:8080
2. Login with admin credentials
3. Navigate to "Sites" to manage configurations
4. Use "Config" section to edit main nginx.conf

### Manual Configuration
- Edit `nginx.conf` directly
- Restart the nginx-proxy service: `docker-compose restart nginx-proxy`

## Path Mappings

The reverse proxy is configured with the following mappings:

| Path | Backend Service | Description |
|------|----------------|-------------|
| `/map` | 172.16.116.82:3000 | Mapping service |
| `/data` | 172.16.116.82:8501 | Data service |
| `/pm25` | 172.16.116.82:3002 | PM2.5 monitoring |
| `/pm25infuxd` | 172.16.116.82:8086 | PM2.5 InfluxDB |
| `/admin` | nginx-ui-manager:80 | Nginx UI Management Interface |

## Access Points

- **Main Proxy**: http://localhost (routes to backend services)
- **Nginx UI Direct**: http://localhost:8002 (direct access to management UI)
- **Nginx UI via Proxy**: http://localhost/admin (access UI through main proxy)

## Health Checks

Both services include health checks:
- **Nginx Proxy**: http://localhost/health
- **Nginx UI**: Automatic container health monitoring

## Volumes and Data Persistence

- `nginx-config`: Nginx configuration files (managed by Nginx UI)
- `nginx-ui-data`: Nginx UI application data and settings
- `./logs`: Nginx access and error logs (shared between services)

## Security Considerations

1. **Change Default Credentials**: Update Nginx UI admin password on first login
2. **Network Access**: Nginx UI is exposed on port 8080 - restrict access in production
3. **SSL/TLS**: Configure HTTPS for production deployments
4. **Firewall**: Ensure proper firewall rules for your environment

## Troubleshooting

### Port Conflicts (Windows)
If you encounter "port already in use" errors:

```bash
# Check what's using the port
netstat -ano | findstr :80
netstat -ano | findstr :8002

# Kill the process using the port (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or change ports in docker-compose.yml
# Example: Change "80:80" to "8000:80"
# Example: Change "8002:80" to "8005:80"
```

### Service Won't Start
```bash
# Check service status
docker-compose ps

# View detailed logs
docker-compose logs nginx-proxy
docker-compose logs nginx-ui
```

### Configuration Issues
1. Use Nginx UI to validate configurations
2. Check syntax: Access Nginx UI → Config → Test Configuration
3. View error logs in the UI or via: `docker-compose logs nginx-proxy`

### Backend Services Unreachable
1. Verify backend services are running on 172.16.116.82
2. Check network connectivity from containers
3. Review proxy logs for connection errors

## Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: This will delete all data)
docker-compose down -v
```

## Advanced Configuration

### Custom Nginx Configuration
The Nginx UI follows Debian standards:
- Site configurations: `/etc/nginx/sites-available/`
- Enabled sites: `/etc/nginx/sites-enabled/`
- Main config: `/etc/nginx/nginx.conf`

### Environment Variables
Customize the Nginx UI container:
- `TZ`: Timezone (default: UTC)
- Additional environment variables available in Nginx UI documentation

## Support

- **Nginx UI Documentation**: https://nginxui.com/
- **Docker Compose Reference**: https://docs.docker.com/compose/
- **Nginx Documentation**: https://nginx.org/en/docs/