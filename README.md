# Network Detection System

A full-stack network monitoring and threat detection tool. Scans local networks via nmap, detects suspicious activity using rule-based rules + Isolation Forest ML, and displays results in a desktop GUI built with Avalonia UI.

## Features

- **Network Scanning** — scan single IP or CIDR subnet (e.g. `192.168.0.1/24`)
- **Device & Port Discovery** — identifies live hosts and open ports (top 21 common ports)
- **Dashboard** — summary cards: Total Devices, Open Alerts, Last Scan, Threats Detected
- **Threat Detection** — rule-based flags for FTP/Telnet/SMB/RDP + Isolation Forest anomaly detection
- **Alert Management** — severity-colored badges (Critical/High/Medium/Info), inline resolve toggle
- **Search** — debounced search with clear button on Devices, Ports, Alerts
- **CSV Export** — download Devices, Ports, Alerts as CSV
- **Connection Health** — 5-second health polling with visual status indicator
- **Pagination** — all list endpoints support `?page=N&per_page=N&search=QUERY`
- **Scan History** — view past scans and their results

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Python 3, Flask, psycopg2, python-nmap, scikit-learn |
| Frontend | C# 12, .NET 8, Avalonia UI, CommunityToolkit.Mvvm |
| Database | PostgreSQL 15+ |
| ML | Isolation Forest (scikit-learn) |

## Project Structure

```
network-detection-system/
├── backend/
│   ├── api.py          # Flask REST API with all routes
│   ├── database.py     # PostgreSQL CRUD + paginated queries
│   ├── scanner.py      # nmap network scanner
│   ├── detector.py     # Rule-based + ML threat detection
│   ├── config.py       # Environment variable configuration
│   └── main.py         # Backend launcher entry point
├── frontend/
│   └── NetworkDetectionUI/
│       ├── Views/
│       │   ├── MainWindow.axaml      # Main UI layout
│       │   └── MainWindow.axaml.cs   # Window code-behind
│       ├── ViewModels/
│       │   ├── MainWindowViewModel.cs  # All app state & logic
│       │   └── ViewModelBase.cs
│       ├── Converters/
│       │   ├── SeverityColorConverter.cs  # Red/Orange/Yellow/Green
│       │   ├── RelativeTimeConverter.cs   # "2h ago", "3d ago"
│       │   ├── BoolToResolvedConverter.cs
│       │   └── BoolToStatusTextConverter.cs
│       ├── Models/          # C# model classes
│       └── ApiService.cs    # HTTP client with paginated responses
├── database/
│   └── network_monitor.sql  # Full database dump with sample data
├── network_monitor.sql      # Database dump (root level)
├── requirements.txt         # Python dependencies
└── README.md
```

## Prerequisites

### Required System Packages

```bash
# Fedora / RHEL
sudo dnf install python3 python3-pip nmap postgresql dotnet-sdk-8.0

# Ubuntu / Debian
sudo apt install python3 python3-pip nmap postgresql dotnet-sdk-8.0

# Arch
sudo pacman -S python python-pip nmap postgresql dotnet-sdk
```

### Required Python Packages

```bash
pip3 install -r requirements.txt
```

This installs: Flask, flask-cors, psycopg2-binary, python-nmap, scikit-learn, numpy, python-dotenv

### Required .NET Workloads

```bash
dotnet workload install avalonia
```

## Setup & Installation

### 1. Database Setup

**Option A: Docker (recommended)**

```bash
docker run -d \
  --name nds-postgres \
  -e POSTGRES_PASSWORD=admin1234 \
  -p 5433:5432 \
  postgres:15

# Wait a few seconds for PostgreSQL to start, then load the data:
psql -h localhost -p 5433 -U postgres -d postgres < network_monitor.sql
```

**Option B: Native PostgreSQL**

```bash
sudo systemctl start postgresql
sudo -u postgres createdb network_monitor
sudo -u postgres psql -d network_monitor < network_monitor.sql
```

If using native PostgreSQL, update the database port in your `.env` file:

```env
DB_PORT=5432
```

### 2. Backend Setup

```bash
# Navigate to the project root
cd network-detection-system

# Install Python dependencies
pip3 install -r requirements.txt

# (Optional) Create .env for custom configuration
cat > .env << EOF
DB_HOST=localhost
DB_PORT=5433
DB_USER=postgres
DB_PASSWORD=admin1234
DB_NAME=postgres
FLASK_DEBUG=1
FLASK_PORT=5000
EOF
```

### 3. Frontend Setup

```bash
cd frontend/NetworkDetectionUI

# Restore NuGet packages
dotnet restore

# Build the project
dotnet build -c Debug
```

> **Note:** If NuGet.org is unreachable, packages must be downloaded manually from `api.nuget.org/v3-flatcontainer/` and stored in a local NuGet source. See [Offline Build](#offline-build) below.

## How to Run (Manual Start)

Start each component in a separate terminal.

### Terminal 1 — Backend (Flask API)

```bash
cd network-detection-system

# IMPORTANT: nmap requires root privileges for most scan types
sudo python3 backend/main.py
```

The API server starts on `http://localhost:5000`. Verify it's running:

```bash
curl http://localhost:5000/health
# Expected: {"status": "healthy"}
```

If you get a `PermissionError` when scanning, the backend needs `sudo` for nmap.
To run without sudo (limited functionality), set `FLASK_DEBUG=0` first.

### Terminal 2 — Frontend (Avalonia GUI)

```bash
cd network-detection-system/frontend/NetworkDetectionUI
dotnet run -c Debug
```

The GUI window will appear. It automatically connects to `http://localhost:5000`.

### Using the Application

1. **Dashboard**: View summary cards (Total Devices, Open Alerts, Last Scan, Threats)
2. **Scan**: Enter an IP (e.g. `192.168.0.1`) or CIDR (e.g. `192.168.0.1/24`) and click **Scan**
3. **Devices/Ports/Alerts**: Browse discovered data, use search, export as CSV
4. **Logs**: View scan and system log history
5. **Scans**: View past scan records
6. **Alerts**: Click the resolve toggle to mark alerts as handled

### One-Line Start (for testing)

```bash
sudo python3 backend/main.py &  # Start backend
sleep 2
cd frontend/NetworkDetectionUI && dotnet run -c Debug  # Start frontend
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/scan?ip=<target>` | Trigger a network scan |
| GET | `/devices?page=N&per_page=N&search=Q` | Paginated device list |
| GET | `/ports?page=N&per_page=N&search=Q` | Paginated port list |
| GET | `/alerts?page=N&per_page=N&search=Q` | Paginated alert list |
| GET | `/logs?page=N&per_page=N` | Paginated log list |
| GET | `/scans?page=N&per_page=N` | Paginated scan history |
| GET | `/export/devices` | Download devices as CSV |
| GET | `/export/ports` | Download ports as CSV |
| GET | `/export/alerts` | Download alerts as CSV |
| PATCH | `/alerts/<id>` | Resolve/unresolve alert `{"resolved": true}` |
| GET | `/health` | Health check |

### Pagination

When `?page=` is provided, the API returns:
```json
{ "data": [...], "total": 100, "page": 1, "per_page": 50 }
```

Without `?page=`, returns a flat array (backward-compatible).

## Configuration

All backend settings are configured via environment variables or a `.env` file:

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `localhost` | PostgreSQL host |
| `DB_PORT` | `5433` | PostgreSQL port (Docker default) |
| `DB_USER` | `postgres` | Database user |
| `DB_PASSWORD` | `admin1234` | Database password |
| `DB_NAME` | `postgres` | Database name |
| `FLASK_DEBUG` | `1` | Enable Flask debug mode |
| `FLASK_PORT` | `5000` | Flask server port |

Create a `.env` file in the project root to override defaults.

## Database Schema

The `network_monitor.sql` dump creates the following tables:
- `devices` — discovered devices (ip, hostname, timestamps)
- `ports` — open ports (device_id, scan_id, port number, service, protocol)
- `alerts` — detected threats (device_id, scan_id, severity, type, description)
- `logs` — system log entries (message, timestamp)
- `scans` — scan history (target, timestamp)

## Threat Detection

The system uses two detection methods:

1. **Rule-based**: Flags specific high-risk services (FTP on port 21, Telnet on 23, SMB on 445, RDP on 3389)
2. **ML-based**: Uses Isolation Forest to detect anomalous port/service combinations based on:
   - Number of open ports
   - Number of devices discovered
   - Count of suspicious services

## Offline Build

If NuGet.org is unreachable, packages can be restored from a local cache:

```bash
# Download required packages (example for one package)
curl -o /tmp/nupkgs/avalonia.11.0.0.nupkg \
  "https://api.nuget.org/v3-flatcontainer/avalonia/11.0.0/avalonia.11.0.0.nupkg"

# Add local source
dotnet nuget add source /tmp/nupkgs --name local-cache

# Build using local cache
dotnet build -c Debug
```

Required NuGet packages: Avalonia (11.0+), Avalonia.Desktop, CommunityToolkit.Mvvm, System.Text.Json.
