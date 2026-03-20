# Importing Flask and Data from database.py

from flask import Flask, jsonify
from database import read_devices, read_ports, read_alerts, read_scans, read_logs, insert_logs
from flask import request
from scanner import NetworkScanner
from detector import ThreatDetector
from datetime import datetime


app = Flask(__name__)

# Defining Routes now

# Scans Route


@app.route('/scan')
def scan():
    ip = request.args.get('ip')
    if not ip:
        return jsonify({'error': 'Please provide an IP address'})
    network = NetworkScanner(ip)
    insert_logs(f"Scan started for {ip}", datetime.now())
    network.scan()
    network.save_scans()
    network.save_devices()
    network.save_ports()
    detector = ThreatDetector(network.scan_id)
    detector.master_detection()
    insert_logs(f"Scan completed for {ip}", datetime.now())
    return jsonify({
        'devices': network.devices,
        'ports': network.ports

    })

# Devices Route


@app.route('/devices')
def devices():
    results = []
    for row in read_devices():
        results.append({
            'id': row[0],
            'ip_address': row[1],
            'mac_address': row[2],
            'hostname': row[3],
            'first_seen': row[4],
            'last_seen': row[5]

        })

    return jsonify(results)

# Ports Route


@app.route('/ports')
def ports():
    results = []
    for row in read_ports():
        results.append({
            'id': row[0],
            'device_id': row[1],
            'scan_id': row[2],
            'port_number': row[3],
            'service_name': row[4],
            'protocol': row[5]

        })

    return jsonify(results)

# Alerts Route


@app.route('/alerts')
def alerts():
    results = []
    for row in read_alerts():
        results.append({
            'id': row[0],
            'alert_type': row[1],
            'severity': row[2],
            'source_ip': row[3],
            'created_at': row[4],
            'resolved': row[5]

        })

    return jsonify(results)

# Logs Route


@app.route('/logs')
def logs():
    results = []
    for row in read_logs():
        results.append({
            'id': row[0],
            'event': row[1],
            'created_at': row[2],
        })

    return jsonify(results)

# Scans Route


@app.route('/scans')
def scans():
    results = []
    for row in read_scans():
        results.append({
            'id': row[0],
            'subnet_scanned': row[1],
            'scanned_at': row[2]
        })
    return jsonify(results)


if __name__ == '__main__':
    app.run(debug=True)
