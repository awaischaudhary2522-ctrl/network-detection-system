import csv
import io
from datetime import datetime
from flask import Flask, jsonify, request, Response
from flask_cors import CORS
from config import FLASK_DEBUG, FLASK_PORT

from database import (
    read_devices, read_devices_paginated,
    read_ports, read_ports_paginated,
    read_alerts, read_alerts_paginated,
    read_scans, read_scans_paginated,
    read_logs, read_logs_paginated,
    insert_logs, update_alerts
)
from scanner import NetworkScanner
from detector import ThreatDetector


app = Flask(__name__)
CORS(app)


@app.errorhandler(400)
def bad_request(e):
    return jsonify({'error': 'Bad request', 'code': 400}), 400


@app.errorhandler(404)
def not_found(e):
    return jsonify({'error': 'Not found', 'code': 404}), 404


@app.errorhandler(500)
def internal_error(e):
    return jsonify({'error': 'Internal server error', 'code': 500}), 500


@app.route('/health')
def health():
    return jsonify({'status': 'ok'})


def row_to_dict(row, columns):
    return dict(zip(columns, row))


DEVICE_COLS = ['id', 'ip_address', 'mac_address', 'hostname', 'first_seen', 'last_seen']
PORT_COLS = ['id', 'device_id', 'scan_id', 'port_number', 'service_name', 'protocol']
ALERT_COLS = ['id', 'alert_type', 'severity', 'source_ip', 'created_at', 'resolved']
LOG_COLS = ['id', 'event', 'created_at']
SCAN_COLS = ['id', 'subnet_scanned', 'scanned_at']


def paginated_response(data, total, page, per_page):
    return jsonify({
        'data': data,
        'total': total,
        'page': page,
        'per_page': per_page
    })


@app.route('/scan')
def scan():
    ip = request.args.get('ip')
    if not ip:
        return jsonify({'error': 'Please provide an IP address', 'code': 400}), 400
    try:
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
    except PermissionError:
        return jsonify({'error': 'Scan requires root privileges. Run with sudo.', 'code': 403}), 403
    except Exception as e:
        insert_logs(f"Scan failed for {ip}: {str(e)}", datetime.now())
        return jsonify({'error': f'Scan failed: {str(e)}', 'code': 500}), 500


@app.route('/devices')
def devices():
    has_page = request.args.get('page') is not None
    if has_page:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 50, type=int)
        search = request.args.get('search', '', type=str)
        rows, total = read_devices_paginated(page, per_page, search)
        data = [row_to_dict(r, DEVICE_COLS) for r in rows]
        return paginated_response(data, total, page, per_page)
    rows = read_devices()
    return jsonify([row_to_dict(r, DEVICE_COLS) for r in rows])


@app.route('/ports')
def ports():
    has_page = request.args.get('page') is not None
    if has_page:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 50, type=int)
        search = request.args.get('search', '', type=str)
        rows, total = read_ports_paginated(page, per_page, search)
        data = [row_to_dict(r, PORT_COLS) for r in rows]
        return paginated_response(data, total, page, per_page)
    rows = read_ports()
    return jsonify([row_to_dict(r, PORT_COLS) for r in rows])


@app.route('/alerts')
def alerts():
    has_page = request.args.get('page') is not None
    if has_page:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 50, type=int)
        search = request.args.get('search', '', type=str)
        rows, total = read_alerts_paginated(page, per_page, search)
        data = [row_to_dict(r, ALERT_COLS) for r in rows]
        return paginated_response(data, total, page, per_page)
    rows = read_alerts()
    return jsonify([row_to_dict(r, ALERT_COLS) for r in rows])


@app.route('/alerts/<int:alert_id>', methods=['PATCH'])
def update_alert(alert_id):
    body = request.get_json(silent=True) or {}
    if 'resolved' not in body:
        return jsonify({'error': 'Missing resolved field', 'code': 400}), 400
    update_alerts(body['resolved'], alert_id)
    return jsonify({'status': 'updated'})


@app.route('/logs')
def logs():
    has_page = request.args.get('page') is not None
    if has_page:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 50, type=int)
        rows, total = read_logs_paginated(page, per_page)
        data = [row_to_dict(r, LOG_COLS) for r in rows]
        return paginated_response(data, total, page, per_page)
    rows = read_logs()
    return jsonify([row_to_dict(r, LOG_COLS) for r in rows])


@app.route('/scans')
def scans():
    has_page = request.args.get('page') is not None
    if has_page:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 50, type=int)
        rows, total = read_scans_paginated(page, per_page)
        data = [row_to_dict(r, SCAN_COLS) for r in rows]
        return paginated_response(data, total, page, per_page)
    rows = read_scans()
    return jsonify([row_to_dict(r, SCAN_COLS) for r in rows])


def generate_csv(columns, rows):
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(columns)
    for row in rows:
        writer.writerow(row)
    return output.getvalue()


@app.route('/export/devices')
def export_devices():
    rows = read_devices()
    csv_data = generate_csv(DEVICE_COLS, rows)
    return Response(csv_data, mimetype='text/csv',
                    headers={'Content-Disposition': 'attachment; filename=devices.csv'})


@app.route('/export/ports')
def export_ports():
    rows = read_ports()
    csv_data = generate_csv(PORT_COLS, rows)
    return Response(csv_data, mimetype='text/csv',
                    headers={'Content-Disposition': 'attachment; filename=ports.csv'})


@app.route('/export/alerts')
def export_alerts():
    rows = read_alerts()
    csv_data = generate_csv(ALERT_COLS, rows)
    return Response(csv_data, mimetype='text/csv',
                    headers={'Content-Disposition': 'attachment; filename=alerts.csv'})


if __name__ == '__main__':
    app.run(debug=FLASK_DEBUG, port=FLASK_PORT)
