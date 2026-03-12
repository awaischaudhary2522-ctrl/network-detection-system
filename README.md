# Network Detection System

## Overview
A network monitoring tool that scans your ip address and stores results in a PostgreSQL database.

## Tech Stack
- Python
- Flask (API framework)
- psycopg2 (database library)
- PostgreSQL
- nmap

## Project Structure
network-detection-system/
├── backend/
│   ├── scanner.py   # Handles the network scan
│   ├── api.py       # Flask REST API routes
│   ├── database.py  # All CRUD operations
│   └── models.py
├── schema.sql       # Database made here
└── main.py

## API Endpoints
| Endpoint | Description |
|----------|-------------|
| /scan    | Scans it accepts an IP parameter and returns devices + open ports |
| /devices | Returns the devices name, ip address first and last seen |
| /ports   | Returns the portname and which ports are open |
| /alerts  | Returns what threats are there (in progress) |
| /logs    | Returns system logs |

## How to Run
1. Install dependencies: pip install flask psycopg2 python-nmap
2. Create the database and run schema:
   - createdb network_monitor
   - psql -U postgres -d network_monitor -f schema.sql
3. Run: python main.py
