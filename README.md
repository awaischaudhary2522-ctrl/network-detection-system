# Network Detection System

## Overview
A full-stack network monitoring and threat detection tool that scans your local network, detects suspicious activity using rule-based and ML-based detection (Isolation Forest), and displays results in a desktop GUI.

## Tech Stack
**Backend**
- Python, Flask, psycopg2, python-nmap, scikit-learn

**Frontend**
- C#, Avalonia UI, CommunityToolkit.Mvvm

**Database**
- PostgreSQL

## Project Structure
```
network-detection-system/
├── backend/
│   ├── scanner.py    # Network scanning via nmap
│   ├── api.py        # Flask REST API routes
│   ├── database.py   # All CRUD + query operations
│   ├── detector.py   # Rule-based + ML threat detection
│   └── main.py       # Launcher script
├── frontend/
│   └── NetworkDetectionUI/  # C# Avalonia MVVM app
├── schema.sql        # PostgreSQL schema
└── README.md
```

## API Endpoints
| Endpoint | Description |
|----------|-------------|
| /scan    | Triggers nmap scan, saves results, runs threat detection |
| /devices | Returns all devices from database |
| /ports   | Returns all open ports |
| /alerts  | Returns detected threats and anomalies |
| /logs    | Returns system logs |
| /scans   | Returns scan history |

## How to Run
1. Install Python dependencies:
```
   pip3 install flask psycopg2 python-nmap scikit-learn numpy
```
2. Setup database:
```
   createdb network_monitor
   psql -U postgres -d network_monitor -f schema.sql
```
3. Run everything:
```
   sudo python3 main.py
```

## Features
- Local network scanning with nmap
- Device and port discovery
- Rule-based threat detection (FTP, Telnet, SMB, RDP)
- ML anomaly detection using Isolation Forest
- Real-time alerts
- Full desktop GUI with tabbed interface
- Scan history and logs

## Status
✅ Backend complete
✅ Frontend complete  
✅ Threat detection working
